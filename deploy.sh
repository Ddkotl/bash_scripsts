#!/bin/bash
git pull
bun i
sudo docker compose up -d
bun prisma migrate deploy
bun run build
npx pm2 reload all --update-env
