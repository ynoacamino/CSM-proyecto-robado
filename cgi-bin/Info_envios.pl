#!/usr/bin/perl -w

use strict;
use warnings;
use CGI;
use DBI;
use JSON;

# Crear el objeto CGI
my $cgi = CGI->new;

# Obtener datos de los parámetros de la URL
my $envio_id = $cgi->param('envio_id');
my $usuario_id = $cgi->param('usuario_id');


# Configuración de la base de datos
my $dsn = "DBI:mysql:database=EncomiendasCSM;host=mysql";
my $db_username = 'csm_user';        # Usuario definido en docker-compose.yml
my $db_password = 'csm_password';   # Contraseña definida en docker-compose.yml

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $db_username, $db_password)
    or die "No se pudo conectar";

# Consulta SQL
my $sql = '
    SELECT e.envio_id, c.cliente_nombres, c.cliente_apellidos, c.direccion_origen, c.direccion_destino, e.descripcion, e.costo, e.hora_salida, e.numero_seguimiento, e.estado
    FROM envios e
    JOIN clientes c ON e.cliente_id = c.cliente_id
    WHERE e.envio_id = ? AND e.usuario_id = ?
';

# Preparar y ejecutar la consulta
my $sth = $dbh->prepare($sql);
$sth->execute($envio_id, $usuario_id);

# Recuperar los resultados
my $data = $sth->fetchrow_hashref();

# Imprimir la cabecera JSON
print $cgi->header('application/json; charset=UTF-8');

# Imprimir los datos en formato JSON
if ($data) {
    print to_json($data, { utf8 => 1, pretty => 1 });
} else {
    print to_json({ error => 'No se encontraron datos para el envío.' }, { utf8 => 1, pretty => 1 });
}

# Limpiar y desconectar
$sth->finish;
$dbh->disconnect;
