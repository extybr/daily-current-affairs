#!/bin/python3
import subprocess

if not subprocess.getoutput('command -v node 2> /dev/null'):
    print('Node.js не установлен')
    exit(0)

while (value := not input('Введите любое число для продолжения: ').isdigit()):
    print('Это не число')

file = """const http = require('node:http');
const hostname = '127.0.0.1';const port = 3000;
const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/html');
  res.end("<!DOCTYPE html><center><h1>Hello, World</h1></center>");
});
server.listen(port, hostname, () => { 
  console.log(`Server running at http://${hostname}:${port}/`);
  console.log(`Start: ${Date.call()}`)
});"""

with open('/tmp/node-server.js', 'w') as serv:
    serv.write(file)

text = 'Введите <y> для запуска http сервера или <n> для выхода: '
number = input(text)
try:
    while number != 'n':
        match number:
            case 'y':
                subprocess.run('node /tmp/node-server.js', shell=True)
            case number:
                print('Неверный ввод')
        number = input(text)
except KeyboardInterrupt:
    subprocess.run("node -e 'console.log(`Stop: ${Date.call()}`)'", shell=True)
    subprocess.run('rm /tmp/node-server.js', shell=True)

