#!/bin/bash
# Painel 5G - Script de Instalação

# Verificações iniciais
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, execute como root"
  exit
fi

echo "Atualizando pacotes..."
apt update -y && apt upgrade -y

echo "Instalando Apache, MySQL, PHP..."
apt install apache2 mysql-server php php-mysql unzip curl git -y

echo "Configurando firewall..."
ufw allow 'Apache Full'

echo "Baixando arquivos do Painel 5G..."
mkdir -p /var/www/painel5g
cd /var/www/painel5g

# Simulando conteúdo do painel
echo "<?php phpinfo(); ?>" > index.php

# Permissões
chown -R www-data:www-data /var/www/painel5g
chmod -R 755 /var/www/painel5g

echo "Configurando Apache..."
cat <<EOF > /etc/apache2/sites-available/painel5g.conf
<VirtualHost *:80>
    DocumentRoot /var/www/painel5g
    <Directory /var/www/painel5g>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

a2ensite painel5g.conf
a2dissite 000-default.conf
systemctl reload apache2

echo "Instalação concluída! Acesse pelo IP do seu servidor."
