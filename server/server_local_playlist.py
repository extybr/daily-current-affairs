#!/usr/bin/env python3
# для плейлиста
from http.server import HTTPServer, BaseHTTPRequestHandler
import os

PORT = 8080
PLAYLIST_FILE = "playlist.m3u8" 

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/playlist.m3u8':
            if os.path.exists(PLAYLIST_FILE):
                with open(PLAYLIST_FILE, 'r') as f:
                    content = f.read().strip()
                self.send_response(200)
                self.send_header('Content-Type', 'application/vnd.apple.mpegurl')
                self.end_headers()
                self.wfile.write(content.encode())
                print(f"✅ Отдан плейлист ({len(content)} символов)")
            else:
                self.send_error(404, f"Файл {PLAYLIST_FILE} не найден")
        else:
            self.send_error(404, "Используйте /playlist.m3u8")

print(f"Сервер запущен на порту {PORT}")
print(f"Отдаёт файл: {PLAYLIST_FILE}")
print(f"URL: http://localhost:{PORT}/playlist.m3u8")
HTTPServer(('0.0.0.0', PORT), Handler).serve_forever()
