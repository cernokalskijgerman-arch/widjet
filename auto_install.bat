@echo off
chcp 65001 >nul
title Nothing Phone (3a) Pro — Автоматическая установка виджета
color 0C

echo ======================================================================
echo    NOTHING PHONE (3A) PRO — WIDGET AUTO-INSTALLER (LIQUID GLASS)
echo ======================================================================
echo.

set ADB=adb.exe
if exist ".\platform-tools\adb.exe" set ADB=".\platform-tools\adb.exe"
if exist "..\platform-tools\adb.exe" set ADB="..\platform-tools\adb.exe"

echo [*] Проверка наличия ADB...
%ADB% version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [!] ADB не найден в системе. Загрузка ADB platform-tools...
    powershell -Command "Invoke-WebRequest -Uri 'https://dl.google.com/android/repository/platform-tools-latest-windows.zip' -OutFile 'platform-tools.zip'; Expand-Archive -Path 'platform-tools.zip' -DestinationPath . -Force"
    set ADB=".\platform-tools\adb.exe"
)

echo.
echo [1/4] Ожидание подключения Nothing Phone по USB...
echo ----------------------------------------------------------------------
echo  Инструкция:
echo   1. Подключи Nothing Phone (3a) Pro кабелем к этому ПК.
echo   2. В Настройках телефона: «О телефоне» -> нажми 7 раз на «Номер сборки».
echo   3. В меню «Система» -> «Для разработчиков» -> включи «Отладка по USB».
echo   4. На экране телефона появится всплывающее окно:
echo      Поставь галочку «Всегда разрешать с этого компьютера» и нажми «РАЗРЕШИТЬ».
echo ----------------------------------------------------------------------
echo.
echo Ожидаю устройство...

%ADB% wait-for-device

echo.
echo [OK] Устройство подключено!
for /f "tokens=*" %%i in ('%ADB% shell getprop ro.product.model') do set MODEL=%%i
for /f "tokens=*" %%v in ('%ADB% shell getprop ro.build.version.release') do set ANDROID_VER=%%v
echo Устройство: %MODEL% (Android %ANDROID_VER%)
echo.

echo [2/4] Создание каталогов на телефоне...
%ADB% shell mkdir -p /sdcard/NothingWidget
%ADB% shell mkdir -p /sdcard/Kustom/widgets

echo [3/4] Копирование файлов Liquid Glass виджета и расписания...
%ADB% push widget.html /sdcard/NothingWidget/widget.html
%ADB% push schedule.json /sdcard/NothingWidget/schedule.json
%ADB% push KWGT_GUIDE.md /sdcard/NothingWidget/KWGT_GUIDE.md

echo.
echo [4/4] Открытие приложения виджета на экране телефона...
%ADB% shell am start -a android.intent.action.VIEW -d "market://details?id=anwave.webwidget" >nul 2>&1

echo.
echo ======================================================================
echo    ВСЁ УСПЕШНО ЗАГРУЖЕНО НА ТВОЙ NOTHING PHONE!
echo ======================================================================
echo.
echo  Файлы находятся на телефоне в папке: /sdcard/NothingWidget/
echo.
echo  Осталось сделать одно действие на телефоне:
echo   1. Нажми «Установить» в открывшемся на телефоне Google Play (Web Widget).
echo   2. Выйди на рабочий стол, зажми экран -> Виджеты -> Web Widget 2×1.
echo   3. Выбери файл: /sdcard/NothingWidget/widget.html (фон: Transparent).
echo.
echo Виджет сразу появится на экране со всеми уроками и переменами!
echo ======================================================================
pause
