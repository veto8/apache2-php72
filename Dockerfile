FROM debian:latest
LABEL version="0.1"
MAINTAINER veto<veto@myridia.com>
RUN apt-get update && apt-get install -y \
  apache2 \
  apt-transport-https \ 
  lsb-release \
  ca-certificates \
  curl \
  wget \	      
  apt-utils \
  openssh-server \
  supervisor \
  default-mysql-client \
  libpcre3-dev \
  gcc \
  make \
  emacs-nox \ 
  vim \ 
  git \
  gnupg \
  sqlite3 \
  unzip \
  p7zip-full \
  postgresql-client \
  inetutils-ping  \
  net-tools
  
RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
RUN echo "deb https://packages.sury.org/php/ bookworm main" | tee /etc/apt/sources.list.d/php.list


RUN apt-get update && apt-get install -y \
  php7.2 \
  php7.2-json \
  php7.2-xml \
  php7.2-cgi  \
  php7.2-mysql  \
  php7.2-mbstring \
  php7.2-gd \
  php7.2-curl \
  php7.2-zip \
  php7.2-dev \
  php7.2-sqlite3 \ 
  php7.2-ldap \
  php7.2-sybase \ 
  php7.2-pgsql \
  php7.2-soap \
  libapache2-mod-php7.4 \
  php-pear 


#RUN pear install mail \
#pear upgrade MAIL Net_SMTP 


RUN echo "<?php phpinfo() ?>" > /var/www/html/index.php ; \
mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor ; \
a2enmod rewrite  ;\
sed -i -e '/memory_limit =/ s/= .*/= 2056M/' /etc/php/7.4/apache2/php.ini ; \
sed -i -e '/post_max_size =/ s/= .*/= 800M/' /etc/php/7.4/apache2/php.ini ; \
sed -i -e '/max_file_uploads =/ s/= .*/= 200/' /etc/php/7.4/apache2/php.ini ; \
sed -i -e '/upload_max_filesize =/ s/= .*/= 800M/' /etc/php/7.4/apache2/php.ini ; \
sed -i -e '/display_errors =/ s/= .*/= ON/' /etc/php/7.4/apache2/php.ini ; \
sed -i -e '/short_open_tag =/ s/= .*/= ON/' /etc/php/7.4/apache2/php.ini ; \
sed -i -e '/short_open_tag =/ s/= .*/= ON/' /etc/php/7.4/cli/php.ini ; \
sed -i -e '/AllowOverride / s/ .*/ All/' /etc/apache2/apache2.conf ; \
sed -i -e '/max_execution_time =/ s/= .*/= 1200/' /etc/php/7.4/apache2/php.ini ; \
echo 'open_basedir = "/"' >> /etc/php/7.4/apache2/php.ini ; 


RUN  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin 
RUN ln  -s /usr/bin/composer.phar /usr/bin/composer 

RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 22 80
CMD ["/usr/bin/supervisord"]


