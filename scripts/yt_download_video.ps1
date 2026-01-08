# Переход в папку
cd "$env:USERPROFILE\Desktop\yt-dlp"

# Получение ссылки из буфера обмена
$url = Get-Clipboard

# Проверка, есть ли ссылка в буфере
if ([string]::IsNullOrEmpty($url)) {
    Write-Host "В буфере обмена нет ссылки!" -ForegroundColor Red
    pause
    exit
}

# Запуск yt-dlp с параметрами
.\yt-dlp.exe --proxy http://127.0.0.1:1080 -f "best[height=720]" $url

# Пауза чтобы увидеть результат
pause