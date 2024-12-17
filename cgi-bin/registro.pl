#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use DBI;
use utf8;

# Crear una instancia de CGI
my $cgi = CGI->new;

# Obtener datos del formulario
my $email = $cgi->param('email');
my $username = $cgi->param('username');
my $password = $cgi->param('password');

# Conectar a la base de datos
my $dsn = "DBI:mysql:database=EncomiendasCSM;host=mysql";
my $db_username = 'csm_user';        # Usuario definido en docker-compose.yml
my $db_password = 'csm_password';   # Contraseña definida en docker-compose.yml

my $dbh = DBI->connect($dsn, $db_username, $db_password)
    or die "No se pudo conectar ";

# Verificar si el usuario o el correo ya existen
my $sth_check = $dbh->prepare('SELECT * FROM usuarios WHERE usuario_nombre = ? OR usuario_email = ?');
$sth_check->execute($username, $email);
if ($sth_check->fetchrow_array) {
	print $cgi->redirect('/CSM/registro.html?error=1');
    $sth_check->finish;
    $dbh->disconnect;
    exit;
}
$sth_check->finish;

# Insertar datos en la base de datos
my $sql = 'INSERT INTO usuarios (usuario_nombre, usuario_email, usuario_password) VALUES (?, ?, ?)';
my $sth = $dbh->prepare($sql);
$sth->execute($username, $email, $password);
    

# Desconectar de la base de datos
$sth->finish;
$dbh->disconnect;

# Redirigir al usuario a la página de inicio de sesión
print $cgi->redirect('/CSM/login.html');

