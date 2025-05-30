@echo off
REM Script de instalación para temas NASA en Windows
REM Autor: NASA Theme Project
REM Versión: 1.0.0

echo.
echo ==========================================
echo  Instalador de Temas NASA para Windows
echo ==========================================
echo.

REM Verificar si se ejecuta como administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Este script debe ejecutarse como administrador.
    echo Por favor, haga clic derecho en el archivo y seleccione "Ejecutar como administrador"
    pause
    exit /b 1
)

echo Creando directorios de temas...

REM Crear directorios para los temas
if not exist "%SystemRoot%\Resources\Themes\NASA_Light" (
    mkdir "%SystemRoot%\Resources\Themes\NASA_Light"
)

if not exist "%SystemRoot%\Resources\Themes\NASA_Dark" (
    mkdir "%SystemRoot%\Resources\Themes\NASA_Dark"
)

echo Copiando archivos del tema claro...
copy "windows\light\NASA_Light.theme" "%SystemRoot%\Resources\Themes\NASA_Light\"

echo Copiando archivos del tema oscuro...
copy "windows\dark\NASA_Dark.theme" "%SystemRoot%\Resources\Themes\NASA_Dark\"

REM Copiar fondos de pantalla si existen
if exist "resources\wallpapers\nasa_light_wallpaper.jpg" (
    copy "resources\wallpapers\nasa_light_wallpaper.jpg" "%SystemRoot%\Resources\Themes\NASA_Light\"
)

if exist "resources\wallpapers\nasa_dark_wallpaper.jpg" (
    copy "resources\wallpapers\nasa_dark_wallpaper.jpg" "%SystemRoot%\Resources\Themes\NASA_Dark\"
)

echo.
echo ==========================================
echo  Instalación completada exitosamente
echo ==========================================
echo.
echo Para aplicar los temas:
echo 1. Haga clic derecho en el escritorio
echo 2. Seleccione "Personalizar"
echo 3. Vaya a "Temas"
echo 4. Seleccione "NASA Light" o "NASA Dark"
echo.
echo O navegue a:
echo %SystemRoot%\Resources\Themes\NASA_Light\NASA_Light.theme
echo %SystemRoot%\Resources\Themes\NASA_Dark\NASA_Dark.theme
echo.

pause
