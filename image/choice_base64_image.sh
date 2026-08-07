#!/bin/bash
# $> ./choice_base64_image.sh
# Choice: base64 -> image or image -> base64

FULL_PATH=""

full_path() {
  echo -n "Введите полный путь к файлу: "
  read FULL_PATH
}

while [[ -z "$FULL_PATH" ]] || ! [[ -f "$FULL_PATH" ]]; do
  full_path
done

INPUT_FILE=$(basename "$FULL_PATH")
FILE_NAME="${INPUT_FILE%.*}"
EXT="${INPUT_FILE#*.}"
OUTPUT_FILE="$(dirname $FULL_PATH)/${FILE_NAME}"

if [[ "$EXT" == "txt" ]]; then
  echo -n "Выполнить команду конвертации из base64 в изображение ? [y/n]: "
  read -r CHOICE
  case "$CHOICE" in
    y) OUTPUT_FILE="${OUTPUT_FILE}.png" && base64 -d "$FULL_PATH" > "${OUTPUT_FILE}"
      ;;
    n) exit 0
      ;;
    *) echo "Неверная команда" && exit
      ;;
  esac
elif [[ "$EXT" =~ ^(png|jpg|jpeg|bmp|ico|webp) ]]; then
  echo -n "Выполнить команду конвертации из изображения в base64 ? [y/n]: "
  read -r CHOICE
  case "$CHOICE" in
    y) OUTPUT_FILE="${OUTPUT_FILE}.txt" && base64 -w 0 "$FULL_PATH" > "${OUTPUT_FILE}"
      ;;
    n) exit 0
      ;;
    *) echo "Неверная команда" && exit
      ;;
  esac
fi

SIZE=$(du -b "$FULL_PATH" | cut -f1)
echo "Исходный файл: ${SIZE} байт"
BASE64_SIZE=$(wc -c < "$OUTPUT_FILE")
echo "Результат: ${BASE64_SIZE} байт (~$((BASE64_SIZE - SIZE)) байт накладных расходов)"
echo "Результат сохранен в $(dirname $OUTPUT_FILE)"

# Дополнительные команды для изменения и проверки
additions() {
  # base64_with_tag
  echo "data:image/png;base64,$(base64 -w 0 input.png)" > base64_with_tag.txt
  # python
  python3 -c "import base64; print(base64.b64encode(open('input.png','rb').read()).decode())" > base64.txt
  # clipboard
  base64 -w 0 input.png | xclip -selection clipboard
  # HTML
  echo '<img src="data:image/png;base64,'$(base64 -w 0 input.png)'">' > image.html
  # image->base64->image
  base64 -w 0 input.png | tee base64.txt | base64 -d > output.png
  # проверка
  diff input.png output.png  # не должно выдать ничего
  cmp input.png output.png   # не должно выдать ничего
}

