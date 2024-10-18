#!/bin/bash

# Обновление системы
sudo apt update && sudo apt upgrade -y

# Настройка Git
git config --global user.name "dd"
git config --global user.email "dd5892631@gmail.com"

# Создание и настройка файла подкачки
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Установка NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
source ~/.bashrc

# Установка последней версии LTS Node.js через NVM
nvm install --lts

# Установка глобальных пакетов через NPM
npm install -g pnpm@latest
npm install -g bun



echo "Server settings completed!"
