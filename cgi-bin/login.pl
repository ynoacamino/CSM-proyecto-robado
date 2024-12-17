#!/usr/bin/perl -w

use strict;
use warnings;
use CGI;
use DBI;
use utf8;

# Crear el objeto CGI
my $cgi = CGI->new;

# Obtener parámetros de la solicitud
my $user_email = $cgi->param('user_email');
my $password = $cgi->param('pass');

# Configuración de la base de datos
my $dsn = "DBI:mysql:database=EncomiendasCSM;host=mysql";
my $db_username = 'csm_user';        # Usuario definido en docker-compose.yml
my $db_password = 'csm_password';   # Contraseña definida en docker-compose.yml

# Conectar a la base de datos
my $dbh = DBI->connect($dsn, $db_username, $db_password)
    or die "No se pudo conectar";

# Preparar la consulta SQL
my $sth_check = $dbh->prepare('SELECT usuario_id FROM usuarios WHERE (usuario_nombre = ? OR usuario_email = ?) AND usuario_password = ?');
$sth_check->execute($user_email, $user_email, $password);

# Obtener el usuario_id de la consulta
my ($usuario_id) = $sth_check->fetchrow_array();

if ($usuario_id) {
    # Redirigir al usuario a la página de envíos con usuario_id en la URL
    print $cgi->redirect("/CSM/Envios.html?usuario_id=$usuario_id");
} else {
    # Si las credenciales no son válidas, redirigir al login con un mensaje de error
    print $cgi->redirect('/CSM/login.html?error=1');
}
# Limpiar y desconectar
$sth_check->finish;
$dbh->disconnect;

