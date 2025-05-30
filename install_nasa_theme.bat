@echo off
REM NASA Theme Installer para Windows
REM Autor: llopgui (NASA Theme Project)
REM Repositorio: https://github.com/llopgui/NASA-Theme
REM Versión: 2.0.0
REM Licencia: CC BY-NC-SA 4.0

echo.
echo ============================================
echo  NASA THEME INSTALLER - Windows 10/11
echo ============================================
echo  Instalando temas inspirados en la NASA
echo  Repositorio: https://github.com/llopgui/NASA-Theme
echo ============================================
echo.

REM Verificar privilegios de administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Este script requiere privilegios de administrador.
    echo        Haz clic derecho y selecciona "Ejecutar como administrador"
    pause
    exit /b 1
)

echo [INFO] Verificando sistema...
REM Verificar Windows 10/11
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%VERSION%" lss "10.0" (
    echo [ERROR] Este tema requiere Windows 10 o superior.
    echo         Version actual: %VERSION%
    pause
    exit /b 1
)

echo [INFO] Sistema compatible: Windows %VERSION%

REM Crear directorios de destino
echo [INFO] Creando directorios de temas...
set THEMES_DIR=%SystemRoot%\Resources\Themes
set NASA_DARK_DIR=%THEMES_DIR%\NASA_Dark
set NASA_LIGHT_DIR=%THEMES_DIR%\NASA_Light

if not exist "%NASA_DARK_DIR%" mkdir "%NASA_DARK_DIR%"
if not exist "%NASA_DARK_DIR%\wallpapers" mkdir "%NASA_DARK_DIR%\wallpapers"

if not exist "%NASA_LIGHT_DIR%" mkdir "%NASA_LIGHT_DIR%"
if not exist "%NASA_LIGHT_DIR%\wallpapers" mkdir "%NASA_LIGHT_DIR%\wallpapers"

echo [INFO] Directorios creados exitosamente.

REM Copiar archivos de tema
echo [INFO] Instalando archivos de tema...
copy /Y "windows\dark\NASA_Dark.theme" "%THEMES_DIR%\" >nul
copy /Y "windows\light\NASA_Light.theme" "%THEMES_DIR%\" >nul

if %errorLevel% neq 0 (
    echo [ERROR] No se pudieron copiar los archivos de tema.
    echo         Verifica que el directorio actual contenga la carpeta 'windows'
    pause
    exit /b 1
)

echo [INFO] Archivos de tema instalados.

REM Verificar si existen wallpapers procesados
set WALLPAPERS_SOURCE=""
if exist "tools\nasa_theme_complete\wallpapers\" set WALLPAPERS_SOURCE=tools\nasa_theme_complete\wallpapers\
if exist "processed_images\wallpapers\" set WALLPAPERS_SOURCE=processed_images\wallpapers\
if exist "resources\wallpapers\" set WALLPAPERS_SOURCE=resources\wallpapers\

if "%WALLPAPERS_SOURCE%"=="" (
    echo [WARNING] No se encontraron wallpapers procesados.
    echo           Ejecuta primero el procesador de imagenes:
    echo           cd tools
    echo           python image_processor.py ../resources/RAW_IMAGES/ --recursive --presentation
    echo.
    echo [INFO] Usando wallpapers de ejemplo...

    REM Crear wallpapers de ejemplo con colores del tema
    echo [INFO] Generando wallpapers de muestra...

    REM Copiar wallpaper por defecto de Windows y renombrarlo
    if exist "%SystemRoot%\Web\Wallpaper\Theme1\img1.jpg" (
        copy "%SystemRoot%\Web\Wallpaper\Theme1\img1.jpg" "%NASA_DARK_DIR%\wallpapers\nasa_dark_wallpaper.jpg" >nul
        copy "%SystemRoot%\Web\Wallpaper\Theme1\img1.jpg" "%NASA_LIGHT_DIR%\wallpapers\nasa_light_wallpaper.jpg" >nul
    )
) else (
    echo [INFO] Copiando wallpapers procesados desde %WALLPAPERS_SOURCE%...

    REM Copiar wallpapers oscuros
    for %%f in ("%WALLPAPERS_SOURCE%nasa_dark_*.jpg") do (
        copy /Y "%%f" "%NASA_DARK_DIR%\wallpapers\" >nul
    )

    REM Copiar wallpapers claros
    for %%f in ("%WALLPAPERS_SOURCE%nasa_light_*.jpg") do (
        copy /Y "%%f" "%NASA_LIGHT_DIR%\wallpapers\" >nul
    )

    REM Establecer wallpaper principal
    if exist "%WALLPAPERS_SOURCE%nasa_dark_*_1920x1080.jpg" (
        for %%f in ("%WALLPAPERS_SOURCE%nasa_dark_*_1920x1080.jpg") do (
            copy /Y "%%f" "%NASA_DARK_DIR%\wallpapers\nasa_dark_wallpaper.jpg" >nul
            goto :dark_wallpaper_set
        )
    )
    :dark_wallpaper_set

    if exist "%WALLPAPERS_SOURCE%nasa_light_*_1920x1080.jpg" (
        for %%f in ("%WALLPAPERS_SOURCE%nasa_light_*_1920x1080.jpg") do (
            copy /Y "%%f" "%NASA_LIGHT_DIR%\wallpapers\nasa_light_wallpaper.jpg" >nul
            goto :light_wallpaper_set
        )
    )
    :light_wallpaper_set

    echo [INFO] Wallpapers copiados exitosamente.
)

REM Registrar el tema en el registro (opcional)
echo [INFO] Configurando registro de Windows...

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes" /v "NASA_Dark" /t REG_SZ /d "%THEMES_DIR%\NASA_Dark.theme" /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes" /v "NASA_Light" /t REG_SZ /d "%THEMES_DIR%\NASA_Light.theme" /f >nul 2>&1

REM Configurar personalización para modo oscuro
echo [INFO] Configurando modo oscuro del sistema...
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d 0 /f >nul 2>&1

echo.
echo ============================================
echo  INSTALACION COMPLETADA
echo ============================================
echo.
echo [SUCCESS] Los temas NASA han sido instalados exitosamente!
echo.
echo COMO USAR:
echo 1. Haz clic derecho en el escritorio
echo 2. Selecciona "Personalizar"
echo 3. Ve a "Temas"
echo 4. Busca "NASA Dark Theme" o "NASA Light Theme"
echo 5. Haz clic para aplicar
echo.
echo UBICACION DE ARCHIVOS:
echo - Temas: %THEMES_DIR%\
echo - Wallpapers: %NASA_DARK_DIR%\wallpapers\
echo.
echo REPOSITORIO: https://github.com/llopgui/NASA-Theme
echo LICENCIA: CC BY-NC-SA 4.0
echo.
echo ============================================

REM Preguntar si aplicar tema automáticamente
set /p APPLY_THEME="¿Aplicar tema NASA Dark automáticamente? (s/n): "
if /i "%APPLY_THEME%"=="s" (
    echo [INFO] Aplicando tema NASA Dark...
    rundll32.exe %SystemRoot%\system32\shell32.dll,Control_RunDLL %SystemRoot%\system32\desk.cpl desk,@Themes /Action:OpenTheme /file:"%THEMES_DIR%\NASA_Dark.theme"
)

echo.
echo Presiona cualquier tecla para finalizar...
pause >nul

exit /b 0
