#!/bin/bash
#=====================================================================
# Internatioinal SQL-Ledger-Network Association
# 
#  Author: Maik Wagner (based on a script by Sebastian Weitmann)
#     Web: http://www.linuxandlanguages.com
#   Email: info@linuxandlanguages.com
#
#======================================================================
#
# Installation Script for SQL-Ledger Run my Accounts Community Version
# 
# for Ubuntu 16.04 (Xenial Xerus) 
#
#======================================================================
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details:
# <http://www.gnu.org/licenses/>.
#======================================================================
#
#This script calls the installation function
#
#

# Main installation routine

installation ()
{

clear
echo "Installing Run my Accounts Community Version..."

sleep 4
cd ~/  
apt-get install debian-archive-keyring
apt-key update
apt-get update
apt-get upgrade
apt-get -y install acpid apache2 openssl ssl-cert postgresql libdbix-simple-perl libcgi-simple-perl libtext-markdown-perl
apt-get -y install libdbi-perl libdbd-pg-perl libobject-signature-perl git-core gitweb postfix mailutils 
apt-get -y install texlive nano libhtml-template-perl make cpan libtemplate-perl libnumber-format-perl
apt-get -y install lynx libcgi-formbuilder-perl libmime-lite-perl libtext-markdown-perl libdate-calc-perl libtemplate-plugin-number-format-perl
apt-get -y install libgd-gd2-perl libdatetime-perl libhtml-format-perl libmime-tools-perl apg libgd2-xpm-dev build-essential
apt-get -y install libuser-simple-perl libxml-simple-perl
cpan CGI::FormBuilder DBIx::XHTML_Table
cpan GD
cpan GD::Thumbnail
cpan cpan MIME::Lite::TT::HTML
a2ensite default-ssl
service apache2 reload
a2enmod ssl
a2enmod cgi
service apache2 restart
cd /var/www/html
git clone https://github.com/sweitmann/rma-community-version.git ledger123
cd /var/www/html/ledger123
git clone git://github.com/ledger123/ledgercart.git ledgercart
mkdir spool
cd /
wget http://www.sql-ledger-network.com/debian/demousers.tar.gz --retr-symlinks=no
tar -xvf demousers.tar.gz
cd /var/www/html/ledger123
wget http://www.sql-ledger-network.com/debian/demo_templates.tar.gz --retr-symlinks=no
tar -xvf demo_templates.tar.gz
chown -hR www-data.www-data users templates css spool
cp sql-ledger.conf.default sql-ledger.conf
git checkout -b rel3 origin/rel3
git checkout rel3
cd ~/
wget http://www.sql-ledger-network.com/debian/sl_index.html --retr-symlinks=no
mv sl_index.html /var/www/html/index.html
wget http://www.sql-ledger-network.com/debian/sql-ledger --retr-symlinks=no
cp sql-ledger /etc/apache2/sites-available/sql-ledger.conf
cd /etc/apache2/sites-enabled/
ln -s ../sites-available/sql-ledger.conf 001-sql-ledger

echo "AddHandler cgi-script .pl" >> /etc/apache2/apache2.conf
echo "Alias /ledger123/ /var/www/html/ledger123/" >> /etc/apache2/apache2.conf
echo "<Directory /var/www/html/ledger123>" >> /etc/apache2/apache2.conf
echo "Options ExecCGI Includes FollowSymlinks" >> /etc/apache2/apache2.conf
echo "</Directory>" >> /etc/apache2/apache2.conf
echo "<Directory /var/www/html/ledger123/users>" >> /etc/apache2/apache2.conf
echo "Order Deny,Allow" >> /etc/apache2/apache2.conf
echo "Deny from All" >> /etc/apache2/apache2.conf
echo "</Directory>" >> /etc/apache2/apache2.conf

service apache2 restart
cd ~/

wget http://www.sql-ledger-network.com/debian/pg_hba.conf --retr-symlinks=no
cp pg_hba.conf /etc/postgresql/9.5/main/
service postgresql restart
su postgres -c "createuser -d -S -R sql-ledger"
su postgres -c "createdb ledgercart"
su postgres -c "psql ledgercart < /var/www/html/ledger123/ledgercart/sql/ledgercart.sql"
su postgres -c "psql ledgercart < /var/www/html/ledger123/ledgercart/sql/schema.sql"
su postgres -c "psql -U postgres ledgercart < /var/www/html/ledger123/sql/Pg-custom_tables.sql"
cp /var/www/html/ledger123/ledgercart/config-default.pl /var/www/html/ledger123/ledgercart/config.pl

}

# Main program

clear
echo "International SQL-Ledger Network Association"
echo "This is free software, and you are welcome to redistribute it under"
echo "certain conditions; See <http://www.gnu.org/licenses/> for more details"
echo "This script will install SQL-Ledger and LedgerCart on Linux Debian Jessie." 
echo "This program comes with ABSOLUTELY NO WARRANTY"
echo ""
echo ""
echo "If you want to install Run my Accounts Community Version"
echo "please type 'runmyaccounts' and press <Enter>"
echo ""
read input

if [ "$input" = "runmyaccounts" ]; then
installation
clear
echo
echo "The installation has now been completed."
echo
echo "Login to Run my Accounts Community Version with user 'admin' on"
echo "http://yourserver_ip"
echo ""
echo "Visit http://forum.sql-ledger-network.com for support"
echo ""
echo ""
echo "IMPORTANT NOTE: This simple installation was only designed to run on your"
echo "local network."
fi
exit 0
