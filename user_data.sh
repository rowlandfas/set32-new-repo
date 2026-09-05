#!/bin/bash
sudo yum install httpd -y
sudo service httpd start 
sudo systemctl enable httpd
cd /var/www/
sudo chmod -R 777 html
cd html
touch index.html
echo "this is set32 terraform and git server">index.html
