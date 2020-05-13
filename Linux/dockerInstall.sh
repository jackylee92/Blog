#!/bin/bash

yum update -y

yum install -y gcc gcc-c++ bison flex ncurses-devel perl zlib-devel curl-devel autoconf sysstat wget ctags python2 python2-devel python3 python3-devel openssl-devel libjpeg-devel libpng-devel freetype-devel pcre-devel bzip2 libXpm-devel libxml2-devel sqlite-devel automake libzip-devel libtool git cmake lsof net-tools expect which passwd openssl openssh-server sudo

ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key -N ''

useradd dev
echo "dev" | passwd dev --stdin > /dev/null 2>&1
echo "root" | passwd root --stdin > /dev/null 2>&1
sed -i "s/account    required     pam_nologin.so.*/#account    required     pam_nologin.so no/g" /etc/pam.d/sshd
sed -i "s/#Port 22.*/Port 222/g" /etc/ssh/sshd_config
echo "dev          ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

mkdir /local
chmod 777 /local
chwon dev /local
chgrp dev /local

cd /opt/
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py

# nginx
cd /opt/
yum install nginx -y

# oniguruma
cd /opt/oniguruma-6.9.4/
./autogen.sh && ./configure --prefix=/usr
make && make install

# php
cd /opt/php-7.2.8/
./configure --prefix=/usr/local/php --enable-fpm --enable-opcache --with-config-file-path=/usr/local/php/etc --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-static --enable-sockets --enable-wddx --enable-zip --enable-calendar --enable-bcmath --enable-soap --with-zlib --with-iconv --with-freetype-dir --with-gd --with-jpeg-dir --with-xmlrpc --enable-mbstring --with-sqlite3 --with-curl --enable-ftp --with-openssl --with-gettext
make && make install
cp php.ini-development /usr/local/php/etc/php.ini
cd sapi/fpm/
cp init.d.php-fpm /etc/init.d/php-fpm
cd /usr/local/php/etc/
cp php-fpm.conf.default php-fpm.conf
cd /usr/local/php/etc/php-fpm.d
cp www.conf.default www.conf
echo "" >> /etc/profile
echo "# PHP" >> /etc/profile
echo "export PATH=$PATH:/usr/local/php/bin/:/usr/local/php/sbin/" >> /etc/profile
source /etc/profile
echo "date.timezone = PRC" >> /usr/local/php/etc/php.ini
ln -s /usr/local/php/bin/php /usr/bin/php
ln -s /usr/local/php/sbin/php-fpm /usr/bin/php-fpm

# swoole
cd /opt/swoole-4.1.1/
phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
echo "extension=swoole" >> /usr/local/php/etc/php.ini

# phptars
cd /opt/
git clone https://github.com/TarsPHP/tars-extension.git
cd tars-extension/
phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
echo "extension=phptars" >> /usr/local/php/etc/php.ini

# blitz
cd /opt/blitz-php7/
phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
echo "extension=blitz" >> /usr/local/php/etc/php.ini

# yaf
cd /opt/yaf-3.0.8/
phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
echo "extension=yaf" >> /usr/local/php/etc/php.ini

#rdkafka
cd /opt/librdkafka/
./configure
make && make install
cd /opt/php-rdkafka/
phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
echo "extension=rdkafka" >> /usr/local/php/etc/php.ini

# phpredis
cd /opt/phpredis-4.3.0/
phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
echo "extension=redis" >> /usr/local/php/etc/php.ini

# redis
yum install redis -y

# PHPUnit
cd /opt/
cp phpunit /usr/local/bin/

# Composer
cd /opt/
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/bin/composer

# Nodejs
cd /opt/
yum install -y nodejs

# supervisor
cd /opt/
pip install supervisor

# yarn
cd /opt/
npm install yarn -g

# rust
# cd /opt/
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# golang
cd /opt/
cp -rf go /usr/local/
echo "" >> /etc/profile
echo "# Golang" >> /etc/profile
echo "export GOROOT=/usr/local/go"  >> /etc/profile
echo "export PATH=\$PATH:\$GOROOT/bin"  >> /etc/profile
source /etc/profile

# vim
cd /opt/vim/
./configure --with-features=huge --enable-multibyte --enable-rubyinterp=yes --enable-python3interp=yes --prefix=/usr/local/vim --disable-selinux --enable-cscope --with-python3-command=python3.6
make && make install
ln -s /usr/local/vim/bin/vim /usr/local/bin/vim

# vim-plug
cd /opt/
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cp /usr/local/vim/share/vim/vim82/vimrc_example.vim ~/.vim/vimrc

# neo
pip3 install --user pynvim
pip3 install --user neovim

# powerline
pip install powerline-status
echo "" >> /etc/profile
echo "# PowerLine" >> /etc/profile
echo "export POWERLINE_COMMAND=powerline" >> /etc/profile
echo "export POWERLINE_CONFIG_COMMAND=powerline-config" >> /etc/profile
echo "powerline-daemon -q" >> /etc/profile
echo "POWERLINE_BASH_CONTINUATION=1" >> /etc/profile
echo "POWERLINE_BASH_SELECT=1" >> /etc/profile
echo ". /usr/local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh" >> /etc/profile
source /etc/profile

cd /opt/
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh

mkdir -p /root/local
cd /opt/
\cp -rf nginx.conf /etc/nginx/nginx.conf
\cp -rf dockerInit /usr/local/bin/
\cp -rf tarsgo /usr/local/bin/
\cp -rf tarsp /usr/local/bin/
\cp -rf tarsphp /usr/local/bin/
\cp -rf vimrc ~/.vim/
chmod 777 /usr/local/bin/dockerInit
rm -rf /opt/*
