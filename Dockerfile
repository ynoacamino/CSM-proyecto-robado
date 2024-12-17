FROM httpd:2.4.46

# Instala perl y módulos de Apache
RUN apt-get update && apt-get install -y \
    perl \
    libapache2-mod-perl2 \
    libapache2-request-perl \
    libmariadb-dev \
    libmariadb-dev-compat \
    mariadb-client 

# Instala herramientas de compilación y cpanminus
RUN apt-get install -y \
    build-essential \
    libssl-dev \
    cpanminus \
    libmariadbclient-dev \
    default-libmysqlclient-dev

# Instala los módulos Perl
RUN cpanm CGI
RUN cpanm DBI
RUN cpanm -v --force DBD::mysql@4.050
RUN cpanm Time::Piece
RUN cpanm JSON

# Configura el script CGI de ejemplo
COPY ./cgi-bin /usr/local/apache2/cgi-bin
RUN chmod -R 777 /usr/local/apache2/cgi-bin/

COPY ./httpdocs /usr/local/apache2/htdocs

# Inicia Apache con el módulo CGI habilitado
CMD ["httpd-foreground", "-c", "LoadModule cgid_module modules/mod_cgid.so"]