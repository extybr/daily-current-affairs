#!/bin/bash -
# $> ./creating-script-nautilus.sh
# Создание скриптов-сценариев для nautilus

path="$HOME/.local/share/nautilus/scripts"

# Функция с переменными для скриптов
setup_nautilus_scripts() {
    gedit='gedit "$1"'
    nvim_gnome_terminal='gnome-terminal --tab -- zsh -c "nvim $1"'
    nvim_terminator='terminator -g /home/tux/.config/terminator/config --new-tab -e "nvim $1"'
    zip='zip archive_$(date "+%y-%m-%d_%H-%M-%S").zip "$@"'
    zed='zed "$1"'
}

# Получаем переменные из функции
get_script_vars() {
    # Извлекаем только нужные строки с объявлениями переменных
    declare -f setup_nautilus_scripts | grep -E '^\s*[a-zA-Z_][a-zA-Z0-9_]*=' | grep -v 'path=' | awk -F '=' '{print $1}'
}

# Проверяем существование директории
if ! [ -d "$path" ]; then
    echo '*** Путь к папке со скриптами отсутствует ***' >&2
    exit 1
fi

variables=$(get_script_vars)

# Создаем скрипты
for var_name in $variables; do
    var_value=$(setup_nautilus_scripts; echo "${!var_name}")
    echo -e "#!/bin/bash\n$var_value" > "$path/$var_name"
    chmod +x "$path/$var_name"
    echo "Создан скрипт: $var_name"
done

echo "Готово! Скрипты созданы в $path"

