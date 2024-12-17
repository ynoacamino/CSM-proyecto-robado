#!/usr/bin/perl -w

use strict;
use warnings;
use CGI;
use DBI;
use POSIX qw(strftime);
use utf8;

# Crear el objeto CGI
my $cgi = CGI->new;

# Obtener datos del formulario
my $usuario_id = $cgi->param('usuario_id');
my $nombres = $cgi->param('nombres');
my $apellidos = $cgi->param('apellidos');
my $origen = $cgi->param('origen');
my $destino = $cgi->param('destino');
my $costo = $cgi->param('costo');
my $descripcion = $cgi->param('descripcion');



# Configuración de la base de datos
my $dsn = "DBI:mysql:database=EncomiendasCSM;host=mysql";
my $db_username = 'csm_user';        # Usuario definido en docker-compose.yml
my $db_password = 'csm_password';   # Contraseña definida en docker-compose.yml

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $db_username, $db_password)or die "No se pudo conectar ";
# Insertar datos en la tabla Clientes
my $sql_cliente = "INSERT INTO clientes (usuario_id, cliente_nombres, cliente_apellidos, direccion_origen, direccion_destino) VALUES (?, ?, ?, ?, ?)";
my $sth_cliente = $dbh->prepare($sql_cliente);
$sth_cliente->execute($usuario_id, $nombres, $apellidos, $origen, $destino);

my $cliente_id = $dbh->last_insert_id(undef, undef, 'clientes', 'cliente_id');

my $hora_salida = strftime('%Y-%m-%d %H:%M:%S', localtime(time + 60));
my $hora_entrega = strftime('%Y-%m-%d %H:%M:%S', localtime(time + 300));
my $numero_seguimiento = int(rand(1000000));
my $sql_envio = "INSERT INTO envios (cliente_id, usuario_id, descripcion, costo, hora_salida, hora_llegada, numero_seguimiento) VALUES (?, ?, ?, ?, ?, ?, ?)";
my $sth_envio = $dbh->prepare($sql_envio);
$sth_envio->execute($cliente_id, $usuario_id, $descripcion, $costo, $hora_salida, $hora_entrega, $numero_seguimiento);


# Obtener el ID del envío recién insertado
my $envio_id = $dbh->last_insert_id(undef, undef, 'envios', 'envio_id');



# Redirigir a la página de confirmación con el ID del envío
print $cgi->redirect("/CSM/confirmacion.html?envio_id=$envio_id&usuario_id=$usuario_id");


# Limpiar y desconectar
$sth_cliente->finish;
$sth_envio->finish;	
$dbh->disconnect;




    
