#!/bin/bash

#git clone https://github.com/Ddkotl/bash_scripsts.git
#cd bash_scripsts
#chmod +x settings_for_new_prod_server.sh
#./settings_for_new_prod_server.sh
#adduser user
#usermod -aG sudo user
#sudo deluser user sudo


KEY_PATH="${HOME}/.ssh/id_rsa"
DEPLOY_KEY_PATH="${HOME}/.ssh/deploy.id_rsa"
APP_DOMEN=tech24view.ru
GIT_NAME="dd"
GIT_EMAIL="dd5892631@gmail.com"
GIT_CLON_DIR="https://github.com/Ddkotl/tech.git"
GIT_DIR_NAME="tech"
WORK_DIR="www"

# Обновление системы
sudo apt update && sudo apt upgrade -y

# Настройка Git
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# Установка NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# Применение NVM в текущем скрипте 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Установка последней версии LTS Node.js через NVM
nvm install --lts

# Установка глобальных пакетов через NPM
npm install -g pnpm@latest
npm install -g bun
npm install pm2 -g

# Генерация SSH ключей без пароля
ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N ""
ssh-keygen -t rsa -b 4096 -f "$DEPLOY_KEY_PATH" -N ""

# Установка Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo apt-get install docker-compose-plugin -y

# Скачивание и распаковка проекта
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"
git clone "$GIT_CLON_DIR"
cd "$GIT_DIR_NAME"
cp .env.example .env
bun i

# Запуск фоновых процессов
sudo docker compose up -d
npx prisma migrate deploy
bun run build
pm2 start "bun run start"
npx pm2 startup

# Настройка Firewall (UFW)
sudo apt-get install ufw -y
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw --force enable

# Установка и настройка NGINX
sudo apt install nginx -y
sudo systemctl enable nginx

# Конфигурация NGINX
sudo tee /etc/nginx/sites-available/"$APP_DOMEN".conf > /dev/null <<EOL
server {
  server_name $APP_DOMEN;

  location / {
    client_max_body_size 10M;
    include proxy_params;
    proxy_pass http://127.0.0.1:3000;
  }

  listen 80;
}
EOL

# Активация конфигурации NGINX
sudo ln -s /etc/nginx/sites-available/"$APP_DOMEN".conf /etc/nginx/sites-enabled/
sudo systemctl reload nginx

# Настройка SSL с помощью Certbot
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d "$APP_DOMEN" --non-interactive --agree-tos --email "$GIT_EMAIL"
sudo certbot renew --dry-run

#Перезагрузка
shutdown -r now

