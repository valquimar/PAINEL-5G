# PAINEL-5G
Painel de conexão ssh
#!/bin/bash

# Painel 5G – Install Script
echo "🔧 Iniciando instalação do Painel 5G..."

# 1) Verificação de autorização de IP
AUTHORIZED_IPS=(
    "123.456.789.000"
    "111.222.333.444"
)
SERVER_IP=$(curl -s ipv4.icanhazip.com)
AUTHORIZED=false
for ip in "${AUTHORIZED_IPS[@]}"; do
    if [[ "$ip" == "$SERVER_IP" ]]; then
        AUTHORIZED=true
        break
    fi
done
if [ "$AUTHORIZED" != true ]; then
    echo "⛔ Este servidor ($SERVER_IP) não está autorizado a instalar o Painel."
    exit 1
fi
echo "✅ IP autorizado: $SERVER_IP"

# 2) Atualizar e instalar pacotes
apt update && apt upgrade -y
apt install -y php php-cli php-mbstring php-xml php-bcmath php-curl php-mysql \
    php-zip unzip curl git mysql-server apache2 composer nodejs npm

# 3) Instalar dependências do Laravel
APP_DIR=$(pwd)
echo "📁 Instalando dependências Laravel em $APP_DIR..."
composer install
npm install
npm run build

# 4) Configuração do Laravel
cp .env.example .env
php artisan key:generate

# 5) Permissões
chown -R www-data:www-data "$APP_DIR"
chmod -R 775 "$APP_DIR/storage" "$APP_DIR/bootstrap/cache"

# 6) Migrations e Seeders
php artisan migrate --seed

# 7) Configurar Apache
cat <<EOF > /etc/apache2/sites-available/painel5g.conf
<VirtualHost *:80>
    ServerAdmin admin@localhost
    DocumentRoot $APP_DIR/public
    <Directory $APP_DIR/public>
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/painel5g_error.log
    CustomLog \${APACHE_LOG_DIR}/painel5g_access.log combined
</VirtualHost>
EOF

a2ensite painel5g.conf
a2enmod rewrite
systemctl restart apache2

echo "🎉 Painel 5G instalado com sucesso!"
echo "Acesse: http://$SERVER_IP"
echo "Login: admin@painel5g.com / Senha: admin123"
