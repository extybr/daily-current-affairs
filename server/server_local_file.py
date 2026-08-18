#!/usr/bin/env python3
# для локального файла
from http.server import HTTPServer, BaseHTTPRequestHandler
import os

PORT = 8080
FILE_NAME = "mylocalfile.mp4"

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/' or self.path == f'/{FILE_NAME}':
            if os.path.exists(FILE_NAME):
                with open(FILE_NAME, 'rb') as f:
                    content = f.read()
                self.send_response(200)
                self.send_header('Content-Type', 'video/mp4')
                self.send_header('Content-Length', str(os.path.getsize(FILE_NAME)))
                self.end_headers()
                self.wfile.write(content)
                print(f"✅ Отдан файл: {FILE_NAME}")
            else:
                self.send_error(404, f"Файл {FILE_NAME} не найден")
        else:
            self.send_error(404, "Файл не найден")

print(f"Сервер запущен на порту {PORT}")
print(f"Отдаёт файл: {FILE_NAME}")
print(f"URL: http://localhost:{PORT}/{FILE_NAME}")
HTTPServer(('0.0.0.0', PORT), Handler).serve_forever()
