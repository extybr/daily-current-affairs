#!/bin/bash -
# $> ./add_nvim_env_conf.sh
# Создание nvim конфига для virtual environments

echo -n 'Укажите путь к папке: '
read -r path
if ! [ -d "${path}" ]; then
  echo 'Папка не найдена'
  exit
fi

echo " add nim config"

if ! [ -f "${path}/pyrightconfig.json" ]; then
  echo '{
  "venvPath": ".",
  "venv": ".venv"
}' > "${path}/pyrightconfig.json"
fi

# if [ -f "${path}/.gitignore" ]; then
#   echo '
# # nvim config
# pyrightconfig.json
# ' >> "${path}/.gitignore"
# fi
