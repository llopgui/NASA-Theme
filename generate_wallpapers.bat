@echo off
REM NASA Theme Wallpaper Generator
REM Autor: llopgui (NASA Theme Project)
REM Repositorio: https://github.com/llopgui/NASA-Theme
REM Versión: 2.0.0

echo.
echo ============================================
echo  NASA WALLPAPER GENERATOR
echo ============================================
echo  Generando wallpapers de alta calidad
echo  Repositorio: https://github.com/llopgui/NASA-Theme
echo ============================================
echo.

REM Verificar Python
python --version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Python no está instalado o no está en el PATH.
    echo         Instala Python desde https://python.org
    pause
    exit /b 1
)

echo [INFO] Python encontrado.

REM Verificar si existe el directorio de imágenes
if not exist "resources\RAW_IMAGES" (
    echo [ERROR] No se encontró el directorio de imágenes fuente.
    echo         Asegúrate de tener imágenes en resources\RAW_IMAGES\
    pause
    exit /b 1
)

REM Cambiar al directorio tools
if not exist "tools\image_processor.py" (
    echo [ERROR] No se encontró el procesador de imágenes.
    echo         Archivo faltante: tools\image_processor.py
    pause
    exit /b 1
)

cd tools

echo [INFO] Instalando dependencias de Python...
pip install -r requirements.txt >nul 2>&1

echo [INFO] Procesando imágenes para generar wallpapers...
echo       Esto puede tardar varios minutos dependiendo del número de imágenes.
echo.

REM Ejecutar procesador con configuración optimizada
python image_processor.py ../resources/RAW_IMAGES/ --recursive --output ../nasa_wallpapers --presentation

if %errorLevel% neq 0 (
    echo [ERROR] Error al procesar las imágenes.
    cd ..
    pause
    exit /b 1
)

cd ..

echo.
echo [SUCCESS] Wallpapers generados exitosamente!
echo.
echo UBICACION: nasa_wallpapers\wallpapers\
echo GALERIA HTML: nasa_wallpapers\nasa_theme_gallery.html
echo.
echo SIGUIENTE PASO:
echo Ejecuta install_nasa_theme.bat como administrador para instalar los temas.
echo.
pause

exit /b 0
