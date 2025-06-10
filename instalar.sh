#!/bin/bash

clear
echo 'Instalando SkyPanel...'
apt update && apt upgrade -y
apt install apache2 php php-mysql unzip git -y
cd /var/www/html
git clone https://github.com/seurepositorio/skypanel.git .
echo 'Instalação concluída.'