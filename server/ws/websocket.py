#!/usr/bin/env python3
import asyncio
import websockets
import json
from http.server import HTTPServer, BaseHTTPRequestHandler
import threading
import subprocess
import time
import os

HTML = """<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>WebSocket Чат</title></head>
<body>
    <h2>🧪 WebSocket Чат</h2>
    <div id="status" style="font-size:18px;">⏳ Подключение...</div>
    <br>
    <input id="msg" placeholder="Сообщение" style="width:300px;">
    <button onclick="sendMsg()">Отправить</button>
    <br><br>
    <div id="log" style="border:1px solid #ccc;padding:10px;min-height:200px;background:#f0f0f0;font-family:monospace;"></div>
    <script>
        const log = document.getElementById('log');
        const status = document.getElementById('status');
        
        // Автоматически определяем хост
        const ws = new WebSocket('ws://' + location.hostname + ':8765');
        
        ws.onopen = () => {
            status.innerHTML = '✅ <span style="color:green;">ПОДКЛЮЧЕНО!</span>';
            ws.send('Привет, сервер!');
        };
        
        ws.onmessage = (e) => {
            log.innerHTML += '📩 ' + e.data + '<br>';
        };
        
        ws.onclose = () => {
            status.innerHTML = '❌ <span style="color:red;">ОТКЛЮЧЕНО</span>';
        };
        
        ws.onerror = () => {
            status.innerHTML = '⚠️ <span style="color:orange;">ОШИБКА</span>';
        };
        
        function sendMsg() {
            const msg = document.getElementById('msg').value;
            if (msg && ws.readyState === WebSocket.OPEN) {
                ws.send(msg);
                log.innerHTML += '📤 ' + msg + '<br>';
                document.getElementById('msg').value = '';
            }
        }
        
        document.getElementById('msg').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') sendMsg();
        });
        
        // Отправка даты и времени каждые 5 секунд
        setInterval(() => {
            const now = new Date();
            const datetime = now.toLocaleString('ru-RU', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            });
            ws.send('📅 ' + datetime);
        }, 5000);
    </script>
</body>
</html>"""

class HTTPHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html; charset=utf-8')
        self.end_headers()
        self.wfile.write(HTML.encode('utf-8'))
    
    def log_message(self, format, *args):
        pass  # Отключаем лог HTTP

CLIENTS = set()

async def ws_handler(websocket):
    CLIENTS.add(websocket)
    try:
        async for message in websocket:
            # Отправляем echo отправителю
            await websocket.send(f"echo: {message}")
            # Рассылаем всем остальным
            others = CLIENTS - {websocket}
            data = json.dumps({"msg": message})
            websockets.broadcast(others, data)
    except websockets.ConnectionClosed:
        pass
    finally:
        CLIENTS.discard(websocket)

def open_browser():
    """Открывает браузер с задержкой (ждём пока сервер запустится)"""
    time.sleep(1.5)
    url = "http://localhost:8000"
    print(f"🌐 Открываю: {url}")
    
    # Определяем команду для открытия браузера
    if os.name == 'posix':  # Linux/Mac
        subprocess.Popen(['xdg-open', url])
    elif os.name == 'nt':   # Windows
        subprocess.Popen(['start', url], shell=True)
    else:
        print(f"Откройте вручную: {url}")

async def start_websocket():
    async with websockets.serve(ws_handler, "0.0.0.0", 8765):
        print("✅ WebSocket сервер на ws://0.0.0.0:8765")
        await asyncio.Future()

if __name__ == "__main__":
    # Запускаем HTTP сервер в отдельном потоке
    httpd = HTTPServer(("0.0.0.0", 8000), HTTPHandler)
    thread = threading.Thread(target=httpd.serve_forever, daemon=True)
    thread.start()
    print("✅ HTTP сервер на http://0.0.0.0:8000")
    
    # Открываем браузер в отдельном потоке
    browser_thread = threading.Thread(target=open_browser, daemon=True)
    browser_thread.start()
    
    # Запускаем WebSocket сервер
    try:
        asyncio.run(start_websocket())
    except KeyboardInterrupt:
        print("\n👋 Сервер остановлен")
