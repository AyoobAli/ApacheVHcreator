#!/bin/bash

scrUSAGE="Usage: sudo $0 Username DomainName [reload]\n
\t reload \t will reload Apache server after creating the VirtualHost (Optional)"

scrUsername=${1,,}
scrDomain=${2,,}
scrHTMLdir="/public_html"
scrUserHome="/var/www/$scrUsername"
scrConfigFile="/etc/apache2/sites-available/$scrUsername.conf"

scrConfTxt="
<VirtualHost *:80>
	ServerName $scrDomain
	ServerAlias www.$scrDomain

	ServerAdmin webmaster@$scrDomain
	DocumentRoot $scrUserHome$scrHTMLdir

	ErrorLog $scrUserHome/error.log
	CustomLog $scrUserHome/access.log combined
</VirtualHost>

<Directory $scrUserHome$scrHTMLdir>
	Options FollowSymLinks
	AllowOverride None
	Require all granted
</Directory>
"
scrIndexFile="
<html lang=\"en\">
    <head>
        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />
        <title>Under Construction</title>
    </head>
    <style>
        * {
            -webkit-font-smoothing: antialiased !important;
            text-shadow: 1px 1px 1px rgba(0,0,0,0.004);
        }
        html, body {
            font-family: monospace;
            font-size: 14px;
            background-color: #f3f3f3;
            margin: 0px;
            padding: 0px;
            color: #191919;
            width: 100%;
            height: 100%;
            display: table;
        }
        a:link {color: #496283; text-decoration: none;}
        a:visited {color: #496283; text-decoration: none;}
        a:hover {color: #758da8; text-decoration: none;}
        a:active {color: #758da8; text-decoration: none;}
        div.container {
            height: 98%;
            display: table-cell;
            vertical-align: middle;
            text-align: center;
        }
        div.section {
            width: 988px;
            background-color: #FFFFFF;
            border: 1px solid #e3e3e3;
            display: inline-block;
            text-align: left;
        }
        div.sectitle {
            background-color: #EDEDED;
            font-family: \"Open Sans\";
            font-size: 36px;
            border-color: #e3e3e3;
            padding: 0 20px;
        }
        div.secfooter {
            color: #808080;
            text-align: center;
            background-color: #EDEDED;
            font-size: 12px;
            border-color: #e3e3e3;
            padding: 0 20px;
            height: 40px;
            line-height: 40px;
            vertical-align: middle;
        }
        div.seccontent { margin: 50px 5px; }
        .btl { border-top-left-radius: 5px; }
        .btr { border-top-right-radius: 5px; }
        .bbl { border-bottom-left-radius: 5px; }
        .bbr { border-bottom-right-radius: 5px; }
        .bl { border-left-width: 1px; border-left-style: solid; }
        .br { border-right-width: 1px; border-right-style: solid; }
        .bt { border-top-width: 1px; border-top-style: solid; }
        .bb { border-bottom-width: 1px; border-bottom-style: solid; }
        .ba { border-width: 1px; border-style: solid; }
        .tal { text-align: left; }
        .tar { text-align: right; }
        .tac { text-align: center; }
        .taj { text-align: justify; }
    </style>
    <body>
    <div class=\"container\">
        <div class=\"section btl btr bbl bbr\">
            <div class=\"sectitle btl btr bb\">Under Construction</div>
            <div class=\"seccontent tac\">
                We apologize for any inconvenience and should be back up with a newly updated website soon.
            </div>
            <div class=\"secfooter bbl bbr bt\">Powered By $scrDomain</div>
        </div>
    </div>
    </body>
</html>
"

if [ "$scrUsername" == "" ] || [ "$scrDomain" == "" ]; then
    echo -e $scrUSAGE
    exit 1
fi

if [ "$(id -u)" != "0" ]; then
    echo "You need root access to run this script."
    echo -e $scrUSAGE
    exit 1
fi

if [ -e "$scrUserHome" ]; then
	echo "Username '$scrUsername' already exists, Please select another Username."
	exit 1
fi

#
if [ -e "$scrConfigFile" ]; then
	echo "Configration file for the username '$scrUsername' already exists, Please select another Username."
	exit 1
fi


echo "are you sure you want to create an Apache VirtualHost with the username '$scrUsername' and Domain '$scrDomain' ? (y/n): "
read scrConfirm

if [ "${scrConfirm,,}" != "y" ] && [ "${scrConfirm,,}" != "yes" ]; then
	echo "Exiting Script..."
	exit 1
fi

echo "Creating User home dir at '$scrUserHome$scrHTMLdir'..."
echo $(mkdir -p $scrUserHome$scrHTMLdir) > /dev/null
echo -e "$scrIndexFile" > "$scrUserHome$scrHTMLdir/index.html"

echo "Setting User Permission..."
echo $(chown -R $SUDO_USER:$SUDO_USER $scrUserHome$scrHTMLdir) > /dev/null

echo "Creating Configration file..."
echo -e "$scrConfTxt" > $scrConfigFile

echo -e "Enabling VirtualHost..."
echo $(a2ensite "$scrUsername.conf") > /dev/null

if [ ${3,,} == "reload" ]; then
	echo "Reloading Apache Server..."
	echo $(service apache2 reload) > /dev/null
else
	echo "Apache server must be reloaded: sudo service apache2 reload"
fi

echo "All done, you can visit your website at http://$scrDomain . Remember to forward your domain to this server or add the domain to your hosts file for local use:"
echo "Edit '/etc/hosts' (ex.: sudo nano /etc/hosts)"
echo "Then add the below line:-"
echo -e "127.0.0.1 \t $scrDomain www.$scrDomain"

