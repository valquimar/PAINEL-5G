#!/bin/bash
# Script de instalação do Painel 5G

# Atualizar pacotes
apt update && apt upgrade -y

# Instalar Apache, PHP e MySQL
apt install apache2 php php-mysql mysql-server unzip git curl -y

# Configurar banco de dados
mysql -u root <<EOF
CREATE DATABASE painel5g CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'painel5guser'@'localhost' IDENTIFIED BY 'senhaSeguraAqui';
GRANT ALL PRIVILEGES ON painel5g.* TO 'painel5guser'@'localhost';
FLUSH PRIVILEGES;
EOF

# Copiar arquivos do painel
mkdir -p /var/www/html/painel5g
cp -r painel5g-main/* /var/www/html/painel5g/

# Importar banco de dados
mysql -u root painel5g < /var/www/html/painel5g/painel5g.sql

# Reiniciar serviços
systemctl restart apache2

echo "Instalação concluída! Acesse http://IP_DO_SERVIDOR/painel5g"