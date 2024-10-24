#!/bin/bash

#git clone https://github.com/Ddkotl/bash_scripsts.git
#cd bash_scripsts
#chmod +x settings_for_new_dev_server.sh.sh
#./settings_for_new_dev_server.sh.sh

# Путь для сохранения SSH ключей (по умолчанию в ~/.ssh/id_rsa)
KEY_PATH="${HOME}/.ssh/id_rsa"
APP_DOMEN="test123.ru"

# Обновление системы
sudo apt update && sudo apt upgrade -y

# Настройка Git
git config --global user.name "dd"
git config --global user.email "dd5892631@gmail.com"

# Установка NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
source ~/.bashrc

# Перезагрузка текущей оболочки для применения NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Это загружает nvm

# Установка последней версии LTS Node.js через NVM
nvm install --lts

# Установка глобальных пакетов через NPM
npm install -g pnpm@latest
npm install -g bun
npm install pm2 -g

# Генерация SSH ключей без пароля
ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N ""

#Установка докера
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo apt-get install docker-compose-plugin -y

#Скачивание и распаковка проекта
cd ~
mkdir www
cd www
git clone https://github.com/Ddkotl/tech.git
cd tech
cp .env.example .env
bun i
bun run build

#Запускаем фоновые процессы
docker compose up -d
npx pm2 start npm --name next -- bun run start
npx pm2 startup

#Запускаем фаервол
sudo apt-get install ufw
sudo ufw status verbose
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable

#Устанавливаем и настраиваем сервер
sudo apt install nginx
sudo systemctl enable nginx
echo server {
  server_name "$APP_DOMEN";

  location / {
    include proxy_params;
    
    proxy_pass http://127.0.0.1:3000;
  }

  listen 80;
} >> /etc/nginx/sites-available/"$APP_DOMEN".conf
sudo ln -s /etc/nginx/sites-available/"$APP_DOMEN".conf /etc/nginx/sites-enabled/
sudo nginx -s reload

#Настройка ssh
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d tech24view.ru
certbot renew --dry-run 
