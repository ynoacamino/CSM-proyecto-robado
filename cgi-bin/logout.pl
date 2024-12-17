#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;

# Crear objeto CGI
my $cgi = CGI->new;

# Redirigir al usuario a la página de inicio de sesión
print $cgi->redirect('/CSM/login.html');
