#!/bin/bash

#git clone https://github.com/Ddkotl/bash_scripsts.git
#cd bash_scripsts
#chmod +x settings_for_new_dev_server.sh.sh
#./settings_for_new_dev_server.sh.sh

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

# Путь для сохранения SSH ключей (по умолчанию в ~/.ssh/id_rsa)
KEY_PATH="${HOME}/.ssh/id_rsa"

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
docker compose up -d
