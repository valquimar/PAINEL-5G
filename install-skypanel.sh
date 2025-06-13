#!/bin/bash

clear
echo "🔧 Instalando SkyPanel - Aguarde..."

# Atualiza o sistema
apt update -y && apt upgrade -y

# Instala pacotes necessários
apt install apache2 php php-mysql mysql-server unzip curl git -y

# Configura MySQL (senha padrão: skypanel)
MYSQL_ROOT_PASSWORD="skypanel"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"

# Clona os arquivos do SkyPanel (backend e frontend)
mkdir -p /var/www/html/skypanel
cd /var/www/html/skypanel
git clone https://github.com/valquimar/PAINEL-5G.git .

# Dá permissão aos arquivos
chown -R www-data:www-data /var/www/html/skypanel
chmod -R 755 /var/www/html/skypanel

# Cria banco de dados
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE skypanel;"
mysql -uroot -p$MYSQL_ROOT_PASSWORD skypanel < /var/www/html/skypanel/database/skypanel.sql

# Ativa Apache e PHP
systemctl restart apache2
systemctl enable apache2

# Mostra dados de acesso
IP=$(curl -s ipv4.icanhazip.com)
echo ""
echo "✅ SkyPanel instalado com sucesso!"
echo "🌐 Acesse: http://$IP/skypanel"
echo "📂 Diretório: /var/www/html/skypanel"
echo "🗄️ Banco de dados: skypanel"
echo "🔐 Usuário MySQL root, senha: $MYSQL_ROOT_PASSWORD"
