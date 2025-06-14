## Отправка сообщений и файлов телеграм ботов в чат пользователя с помощью curl
	 
`TG_TOKEN` = "my-telegram-bot-token"

`TG_USER` = 123456789

<details><summary>текст только в кодировке utf-8</summary>

Декодер онлайн (decoder online) - https://involta.ru/tools/decoder/ . Вставляем "Привет друг" в окно UTF-8 и берем готовый текст "РџСЂРёРІРµС‚ РґСЂСѓРі" в окне CP-1251 для сообщения.

curl -X POST -H "Content-Type: application/json" -d "{\"chat_id\": \"$TG_USER\", \"text\": \"Hello\", \"disable_notification\": true}" https://api.telegram.org/bot"$TG_TOKEN"/sendMessage

curl -X POST -H "Content-Type: application/json" -d "{\"chat_id\": \"$TG_USER\", \"text\": \"РљР°Рє РґРµР»Р°\"}" https://api.telegram.org/bot"$TG_TOKEN"/sendMessage

curl "https://api.telegram.org/bot'$TG_TOKEN'/sendMessage?chat_id='$TG_USER'" --data-urlencode "text=Hello"

curl "https://api.telegram.org/bot'$TG_TOKEN'/sendMessage?chat_id='$TG_USER'" --data-urlencode "text=РљР°Рє РґРµР»Р°"

curl "https://api.telegram.org/bot'$TG_TOKEN'/sendMessage?chat_id='$TG_USER'&text=Hello"

</details>

<details><summary>текст только в urlencode</summary>

(текст только в urlencode,  https://checkserp.com/encode/urlencode/)

curl "https://api.telegram.org/bot'$TG_TOKEN'/sendMessage?chat_id='$TG_USER'&text=%D0%9A%D0%B0%D0%BA%20%D0%B4%D0%B5%D0%BB%D0%B0"

</details>

<details><summary>docker контейнер отправляет сообщение</summary>

docker run --rm curlimages/curl "https://api.telegram.org/bot'$TG_TOKEN'/sendMessage?chat_id='$TG_USER'&text=%D0%9A%D0%B0%D0%BA%20%D0%B4%D0%B5%D0%BB%D0%B0"

</details>

<details><summary>отправляет одну картинку</summary>

curl -s -X POST -F media="[{\"type\":\"photo\",\"media\":\"attach://photo\"}]" -F photo=@"000.jpg" -H "Content-Type:multipart/form-data" https://api.telegram.org/bot'$TG_TOKEN'/sendMediaGroup?chat_id='$TG_USER'

</details>

<details><summary>отправляет две картинки</summary>

curl -s -X POST -F media="[{\"type\":\"photo\",\"media\":\"attach://photo1\"}, {\"type\":\"photo\",\"media\":\"attach://photo2\"}]" -F photo1="@000.jpg" -F photo2="@001.jpg" -H "Content-Type:multipart/form-data" https://api.telegram.org/bot'$TG_TOKEN'/sendMediaGroup?chat_id='$TG_USER'

</details>

<details><summary>отправляет документ</summary>

curl -s -X POST -F media="[{\"type\":\"document\",\"media\":\"attach://document\"}]" -F document=@"systemd.pdf" -H "Content-Type:multipart/form-data" https://api.telegram.org/bot'$TG_TOKEN'/sendMediaGroup?chat_id='$TG_USER'

curl -F chat_id='$TG_USER' -F document=@"text.txt" -F caption="Document" 'https://api.telegram.org/bot'$TG_TOKEN'/sendDocument'

</details>

---
