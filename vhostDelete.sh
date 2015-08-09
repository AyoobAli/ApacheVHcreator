#!/bin/bash


scrUSAGE="Usage: sudo $0 Username [reload]\n
\t reload \t will reload Apache server after creating the VirtualHost (Optional)"

scrUsername=${1,,}
scrHTMLdir="/public_html"
scrUserHome="/var/www/$scrUsername"
scrConfigFile="/etc/apache2/sites-available/$scrUsername.conf"

if [ "$scrUsername" == "" ]; then
    echo -e $scrUSAGE
    exit 1
fi

if [ "$(id -u)" != "0" ]; then
    echo "You need root access to run this script."
    echo -e $scrUSAGE
    exit 1
fi


echo -e "are you sure you want to DELETE an Apache VirtualHost with the username '$scrUsername' ? \nThis will permanently delete all files/dir's under '$scrUserHome' (yes/no): "
read scrConfirm

if [ "$scrConfirm" != "yes" ]; then
	echo "Exiting Script..."
	exit 1
fi

echo "Deleting Configration file..."
echo $(a2dissite "$scrUsername.conf") > /dev/null
echo $(rm -f "$scrConfigFile") > /dev/null

echo "Deleting User home dir '$scrUserHome'..."
echo $(rm -rf "$scrUserHome") > /dev/null

if [ "${2,,}" == "reload" ]; then
	echo "Reloading Apache Server..."
	echo $(service apache2 reload) > /dev/null
else
	echo "Apache server must be reloaded: sudo service apache2 reload"
fi

echo "All done."

