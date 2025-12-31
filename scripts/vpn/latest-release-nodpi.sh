#!/bin/bash
# $> ./latest-release-nodpi.sh
# https://github.com/GVCoder09/nodpi
# Скачиваем последний релиз nodpi

set -e

# Сохраняем текущую директорию с гарантией возврата
current_dir=$(pwd)
trap 'cd "${current_dir}"' EXIT

# путь до папки
nodpi_dir="$HOME/my_programs/nodpi"

# Переходим в рабочую директорию
mkdir -p "$nodpi_dir"
cd "$nodpi_dir" || ( echo "❌ Ошибка перехода в $nodpi_dir" && exit 1 )

user='GVCoder09'
repo='NoDPI'

echo "🔍 Проверяем последний релиз nodpi..."

LATEST_RELEASE=$(curl -s "https://github.com/${user}/${repo}/releases" | \
                 grep -oP "/${user}/${repo}/releases/tag/\K[^\"]+" | head -n 1)

if [ -z "$LATEST_RELEASE" ]; then
    echo "❌ Ошибка: не удалось найти последний релиз\!"
    exit 1
fi

echo -e "✅ Найден релиз: \e[36m${LATEST_RELEASE}\e[0m"

link="https://github.com/${user}/${repo}/releases/download/${LATEST_RELEASE}/nodpi_${LATEST_RELEASE}_linux_x64.zip"

cd "$nodpi_dir" && ( for file in $(ls ./); do rm -rf "${file}"; done ) || ( echo "нет папки: $nodpi_dir" && exit 1 )

archive="${link##*/}"

echo -e "⬇️ Скачиваем \e[36m${archive}\e[0m ..."
wget --show-progress -q "$link" || ( echo "❌ Ошибка загрузки!" && exit 1 )

# повторная проверка наличия скаченного архива
if ! [ -f "$archive" ]; then echo "ошибка с файлом архива" && exit 1; fi

echo "📦 Распаковываем..."
unzip "$archive" || ( echo "❌ Ошибка распаковки!" && exit 1 )

cd "nodpi_${LATEST_RELEASE}_linux_x64"

mv * ../
cd ..

# повторная проверка наличия файла nodpi
if ! [ -f "nodpi" ]; then echo -e "ошибка, не найден файл \e[36mnodpi\e[0m" && exit 1; fi

echo "🔄 Делаем исполняемым бинарник..."
chmod u+x nodpi

echo -e "🧹 Удаляем архив \e[36m${archive}\e[0m ..."
rm -rf "$archive"

rm -rf "nodpi_${LATEST_RELEASE}_linux_x64"

echo -e "\n✔️ Успешно! Исполняемый файл: \e[36m$PWD/nodpi\e[0m\n"

