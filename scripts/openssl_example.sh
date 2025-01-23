#!/bin/bash
# Варианты использования openssl

function cryptArchive {
  # Шифруем архив
  openssl enc -aes-256-cbc -pbkdf2 -in files_archive.tar.gz -out archive_file_crypt.env
}

function cryptFile {
  # Шифруем файл
  openssl enc -aes-256-cbc -pbkdf2 -in file.txt -out file_crypt.env
}

function cryptFile {
  # Шифруем и кодируем в base64 файл «file.txt» в файл «file.enc» с паролем «mysecret»
  openssl aes-256-cbc -pbkdf2 -base64 -in file.txt -out file.enc -pass pass:mysecret  # шифруем
  openssl aes-256-cbc -pbkdf2 -base64 -d -in file.enc -out file.txt -pass pass:mysecret  # дешифруем
  cat file.enc | openssl aes-256-cbc -pbkdf2 -base64 -d -pass pass:mysecret  # вывод данных
}

function cryptScript {
  # Пример выполнения зашифрованного «обернутого» скрипта/команды
  echo 'python -m http.server 9090' | openssl aes-256-cbc -pbkdf2 -base64 -pass pass:123
  eval $(echo U2FsdGVkX19OYO6rNmXY2jXh64pfiHD3RLCRdyikjC/9MST+SQTjH+1rZGibTN9h | \
         openssl aes-256-cbc -pbkdf2 -base64 -d -pass pass:123)
}

function makeCert {
  # Создание самоподписаного сертификата
  openssl genrsa -out server.key 4096
  openssl req -new -key server.key -out server.csr
  openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.csr
}

function genCert {
  openssl genrsa -aes256 -out private.pem 2048  # создаем ключ
  openssl req -x509 -sha256 -nodes -days 3650 -newkey rsa:2048 -keyout private.pem -out public.pem  # создаем сертификат
  openssl x509 -outform der -in public.pem -out mydomainlocal.der  # конвертируем сертификат, в понятный для браузера формат
}

function getCertificate {
  # Вывод сертификата сайта
  echo | openssl s_client -connect google.com:443 2> /dev/null | \
  awk '/-----BEGIN/,/END CERTIFICATE-----/'
}

function certAspire {
  # Срок истекания сетификата сайта
  getCertificate | openssl x509 -noout -enddate
}

getCertificate > google.cert
certAspire

