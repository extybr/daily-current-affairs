#!/usr/bin/env python3
# для локальной папки
from http.server import HTTPServer, SimpleHTTPRequestHandler
import os

PORT = 8080
FOLDER = "./Videos"

os.chdir(FOLDER)
print(f"Сервер запущен на порту {PORT}")
print(f"Отдаёт папку: {os.getcwd()}")
print(f"URL: http://localhost:{PORT}/")
HTTPServer(('0.0.0.0', PORT), SimpleHTTPRequestHandler).serve_forever()
