#!/usr/bin/perl -w

use strict;
use warnings;
use CGI;
use DBI;
use Time::Piece;
use JSON;

# Crear el objeto CGI
my $cgi = CGI->new;

# Obtener el número de seguimiento del parámetro de la URL
my $numero_seguimiento = $cgi->param('numero_seguimiento');

# Verificar el parámetro
if (!$numero_seguimiento) {
    print $cgi->header('application/json; charset=UTF-8');
    print to_json({ error => 'Falta el número de seguimiento en la URL.' }, { utf8 => 1, pretty => 1 });
    exit;
}

# Configuración de la base de datos
my $dsn = "DBI:mysql:database=EncomiendasCSM;host=mysql";
my $db_username = 'csm_user';        # Usuario definido en docker-compose.yml
my $db_password = 'csm_password';   # Contraseña definida en docker-compose.yml

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $db_username, $db_password, { RaiseError => 1, PrintError => 0 })
    or die "No se pudo conectar a la base de datos: $DBI::errstr";

# Consulta SQL para obtener los datos del envío
my $sql = '
    SELECT e.envio_id, c.cliente_nombres, c.cliente_apellidos, c.direccion_origen, c.direccion_destino,
           e.descripcion, e.costo, e.hora_salida, e.hora_llegada, e.estado
    FROM envios e
    INNER JOIN clientes c ON e.cliente_id = c.cliente_id
    WHERE e.numero_seguimiento = ?
';

# Preparar y ejecutar la consulta
my $sth = $dbh->prepare($sql);
$sth->execute($numero_seguimiento);

# Recuperar los resultados
my $data = $sth->fetchrow_hashref();

# Verificar y actualizar el estado del envío
if ($data->{estado} eq 'pendiente') {
    my $hora_salida = $data->{hora_salida};
    my $hora_entrega = $data->{hora_llegada};

    # Convertir las marcas de tiempo a objetos Time::Piece
    my $hora_salida_obj = Time::Piece->strptime($hora_salida, '%Y-%m-%d %H:%M:%S');
    my $hora_entrega_obj = Time::Piece->strptime($hora_entrega, '%Y-%m-%d %H:%M:%S');
    my $hora_actual = localtime;

    # Comparar con la hora actual
    if ($hora_actual < $hora_salida_obj) {
        $data->{estado} = 'pendiente';
    } elsif ($hora_actual >= $hora_salida_obj && $hora_actual < $hora_entrega_obj) {
        $data->{estado} = 'en camino';
    } elsif ($hora_actual >= $hora_entrega_obj) {
        $data->{estado} = 'entregado';
    }
}

# Actualizar el estado en la base de datos si ha cambiado
if ($data->{estado} ne $sth->{estado}) {
    my $update_sql = '
        UPDATE envios
        SET estado = ?
        WHERE numero_seguimiento = ?
    ';
    my $update_sth = $dbh->prepare($update_sql);
    $update_sth->execute($data->{estado}, $numero_seguimiento);
    $update_sth->finish;
}
$data->{estado} = 'pendiente';
# Imprimir la cabecera JSON
print $cgi->header('application/json; charset=UTF-8');

# Imprimir los datos en formato JSON
if ($data) {
    print to_json($data, { utf8 => 1, pretty => 1 });
} else {
    print to_json({ error => 'No se encontraron datos para el número de seguimiento.' }, { utf8 => 1, pretty => 1 });
}

# Limpiar y desconectar
$sth->finish;
$dbh->disconnect;
