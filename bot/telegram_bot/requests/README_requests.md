## Отправка сообщений телеграм ботов в чат пользователям с помощью requests

`TG_TOKEN_BOT` = "my-telegram-bot-token"

`CHAT_ID` = -123456789

<details><summary>только текст</summary>

requests.post(f"https://api.telegram.org/bot{TG_TOKEN_BOT}/sendMessage", params={'chat_id': f"{CHAT_ID}", 'text': message})

</details>

---