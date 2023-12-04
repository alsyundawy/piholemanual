#!/bin/bash

# this script requires your webserver is php enabled, read the manual for details.
# fastcgi-php needs to be enabled, read the manual for details.

file=phpliteadmin-dev.zip
mkdir -p phpLiteAdmin
cd phpLiteAdmin
wget https://www.phpliteadmin.org/$file
unzip $file

file=phpliteadmin.php
sudo mv /home/pi/phpLiteAdmin/$file /var/www/html/$file
source=phpliteadmin.config.sample.php
target=phpliteadmin.config.php
sudo mv /home/pi/phpLiteAdmin/$source /var/www/html/$target

sudo sed -i "/$directory = '.';/c\$directory = '/etc/pihole';" /var/www/html/$target
sudo sed -i '/$subdirectories = false;/c\$subdirectories = true;' /var/www/html/$target

sudo wget https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.24.2/codemirror.min.css -O /var/www/html/codemirror.min.css
sudo wget https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.24.2/addon/hint/show-hint.min.css -O /var/www/html/show-hint.min.css
sudo wget https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.24.2/addon/hint/show-hint.min.css.map -O /var/www/html/show-hint.min.css.map
sudo wget https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.24.2/codemirror.min.js -O /var/www/html/codemirror.min.js
sudo wget https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.24.2/codemirror.min.css.map -O /var/www/html/codemirror.min.css.map
sudo wget https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.24.2/addon/hint/show-hint.min.js -O /var/www/html/show-hint.min.js
sudo sed -i 's$https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.24.2/addon/hint/$http://pi.hole/$g' /var/www/html/$file
sudo sed -i 's$https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.24.2/$http://pi.hole/$g' /var/www/html/$file
sudo wget https://cdn.rawgit.com/codemirror/CodeMirror/c4387d6073b15ccf0f32773eb71a54f3b694f2f0/mode/sql/sql.js -O /var/www/html/sql.js
sudo wget https://cdn.rawgit.com/codemirror/CodeMirror/65c70cf5d18ac3a0c1a3fe717d90a81ff823aa9f/addon/hint/sql-hint.js -O /var/www/html/sql-hint.js
sudo sed -i 's$https://cdn.rawgit.com/codemirror/CodeMirror/c4387d6073b15ccf0f32773eb71a54f3b694f2f0/mode/sql/$http://pi.hole/$g' /var/www/html/$file
sudo sed -i 's$https://cdn.rawgit.com/codemirror/CodeMirror/65c70cf5d18ac3a0c1a3fe717d90a81ff823aa9f/addon/hint/$http://pi.hole/$g' /var/www/html/$file

# check configuration, this should echo Syntax OK
lighttpd -t -f /etc/lighttpd/lighttpd.conf

# restart lighttpd
sudo service lighttpd force-reload
