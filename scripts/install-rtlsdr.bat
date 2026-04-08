@echo off
setlocal enabledelayedexpansion

:: Определяем версию Windows
ver | findstr /l "5.1." > NUL
if %errorlevel% equ 0 (
    set IS_XP=1
    echo Windows XP detected
) else (
    set IS_XP=0
)

:: Создаём временную папку
if not exist tmp mkdir tmp

:: Функция скачивания с fallback
set release_url=http://github.com/rtlsdrblog/rtl-sdr-blog/releases/latest/download/Release.zip
set release_zip=tmp\Release.zip

echo Downloading RTLSDR Driver
call :DownloadFile "%release_url%" "%release_zip%"
if errorlevel 1 (
    echo ERROR: Failed to download RTLSDR driver
    pause
    exit /b 1
)

echo Downloading Zadig
set zadig_url=b721/zadig-2.4.exe
if %IS_XP% equ 1 set zadig_url=v1.2.5/zadig_xp-2.2.exe
set zadig_exe=zadig.exe
call :DownloadFile "http://github.com/pbatard/libwdi/releases/download/%zadig_url%" "%zadig_exe%"
if errorlevel 1 (
    echo ERROR: Failed to download Zadig
    pause
    exit /b 1
)

:: Распаковка
echo Extracting...
if %IS_XP% equ 1 (
    if exist "C:\Program Files\7-Zip\7z.exe" (
        "C:\Program Files\7-Zip\7z.exe" x "%release_zip%" -otmp\ -y >nul
    ) else if exist "C:\Program Files (x86)\7-Zip\7z.exe" (
        "C:\Program Files (x86)\7-Zip\7z.exe" x "%release_zip%" -otmp\ -y >nul
    ) else (
        echo ERROR: 7-Zip not found. Please install 7-Zip first.
        pause
        exit /b 1
    )
) else (
    :: Для Windows 7+ пробуем PowerShell с правильными путями
    powershell -command "& { $ProgressPreference='SilentlyContinue'; Expand-Archive -Path '%release_zip%' -DestinationPath 'tmp' -Force }" 2>nul
    if errorlevel 1 (
        :: Fallback: старый метод .NET
        powershell -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; $zip = [System.IO.Compression.ZipFile]::OpenRead((Resolve-Path '%release_zip%').Path); $zip.Entries | %% { $dest = Join-Path 'tmp' $_.FullName; if ($_.FullName.EndsWith('/') -or $_.FullName.EndsWith('\')) { mkdir $dest -Force } else { mkdir (Split-Path $dest) -Force; [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $dest, $true) } }; $zip.Dispose() }" 2>nul
        if errorlevel 1 (
            echo ERROR: Failed to extract ZIP. Trying built-in tar...
            tar -xf "%release_zip%" -C tmp 2>nul
            if errorlevel 1 (
                echo ERROR: Cannot extract archive. Please install 7-Zip or WinRAR.
                pause
                exit /b 1
            )
        )
    )
)

:: Копирование DLL
if exist "tmp\x64\rtlsdr.dll" (
    move "tmp\x64\rtlsdr.dll" . >nul
    echo rtlsdr.dll installed successfully (x64)
) else if exist "tmp\x86\rtlsdr.dll" (
    move "tmp\x86\rtlsdr.dll" . >nul
    echo rtlsdr.dll installed successfully (x86)
) else if exist "tmp\rtlsdr.dll" (
    move "tmp\rtlsdr.dll" . >nul
    echo rtlsdr.dll installed successfully (root)
) else (
    echo ERROR: rtlsdr.dll not found in any expected location
    echo Searching in tmp folder...
    dir /s /b tmp\*.dll
    pause
    exit /b 1
)

:: Очистка
rmdir /S /Q tmp 2>nul

echo.
echo ========================================
echo Done! All files downloaded and extracted.
echo ========================================
pause
exit /b 0

:DownloadFile
setlocal
set "url=%~1"
set "output=%~2"
echo Downloading from %url% to %output%

:: Пробуем curl (Win10+)
curl -L -o "%output%" "%url%" --silent --fail --connect-timeout 30
if %errorlevel% equ 0 if exist "%output%" if %~z2 gtr 1000 goto :success

:: Пробуем bitsadmin (XP SP2+)
bitsadmin /transfer "download_%random%" /download /priority normal /dynamic "%url%" "%output%" >nul 2>&1
if %errorlevel% equ 0 if exist "%output%" if %~z2 gtr 1000 goto :success

:: Пробуем PowerShell
powershell -command "& { $wc = New-Object System.Net.WebClient; $wc.DownloadFile('%url%', '%output%') }" 2>nul
if %errorlevel% equ 0 if exist "%output%" if %~z2 gtr 1000 goto :success

echo ERROR: All download methods failed for %url%
exit /b 1

:success
exit /b 0
