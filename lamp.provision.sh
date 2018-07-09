# mysql-server prompts
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
# phpmyadmin prompts
debconf-set-selections <<< "phpmyadmin phpmyadmin/internal/skip-preseed boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean false"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password root"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password root"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password root"
# update package lists and upgrade existing packages
apt-get update
apt-get upgrade
# install LAMP stack dependencies
apt-get install -y apache2 mysql-server php libapache2-mod-php php-mcrypt php-mysql phpmyadmin php-mbstring php-gettext php-cli php-cgi
phpenmod mcrypt
phpenmod mbstring
# install composer
cd ~
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
# restart apache
sudo su
a2enmod rewrite
sed -i.bak '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
sed -i.bak 's/display_errors = .*/display_errors = On/' /etc/php/7.0/apache2/php.ini
echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
systemctl restart apache2
exit
# report status
php --version
composer --version
