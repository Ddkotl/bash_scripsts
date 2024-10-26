#!/bin/bash

#git clone https://github.com/Ddkotl/bash_scripsts.git
#cd bash_scripsts
#chmod +x settings_for_new_dev_server.sh
#./settings_for_new_dev_server.sh

# Путь для сохранения SSH ключей (по умолчанию в ~/.ssh/id_rsa)
KEY_PATH="${HOME}/.ssh/id_rsa"
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

# Применение NVM в текущем скрипте (без необходимости source ~/.bashrc)
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

shutdown -r now
