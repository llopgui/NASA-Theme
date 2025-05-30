#!/bin/bash

# Script de instalación para temas NASA en Linux
# Autor: NASA Theme Project
# Versión: 1.0.0

echo ""
echo "=========================================="
echo "  Instalador de Temas NASA para Linux"
echo "=========================================="
echo ""

# Función para mostrar mensajes de progreso
show_progress() {
    echo "✓ $1"
}

# Función para mostrar errores
show_error() {
    echo "✗ ERROR: $1"
}

# Verificar si el directorio .themes existe, si no lo crea
if [ ! -d "$HOME/.themes" ]; then
    mkdir -p "$HOME/.themes"
    show_progress "Directorio ~/.themes creado"
fi

# Verificar si el directorio .local/share/color-schemes existe, si no lo crea
if [ ! -d "$HOME/.local/share/color-schemes" ]; then
    mkdir -p "$HOME/.local/share/color-schemes"
    show_progress "Directorio ~/.local/share/color-schemes creado"
fi

echo ""
echo "Instalando temas GTK..."

# Copiar temas GTK
if [ -d "linux/gtk/NASA-Light" ]; then
    cp -r "linux/gtk/NASA-Light" "$HOME/.themes/"
    show_progress "Tema GTK NASA Light instalado"
else
    show_error "No se encontró el tema NASA Light GTK"
fi

if [ -d "linux/gtk/NASA-Dark" ]; then
    cp -r "linux/gtk/NASA-Dark" "$HOME/.themes/"
    show_progress "Tema GTK NASA Dark instalado"
else
    show_error "No se encontró el tema NASA Dark GTK"
fi

echo ""
echo "Instalando esquemas de color Qt..."

# Copiar esquemas de color Qt
if [ -f "linux/qt/NASA_Light.colors" ]; then
    cp "linux/qt/NASA_Light.colors" "$HOME/.local/share/color-schemes/"
    show_progress "Esquema de color Qt NASA Light instalado"
else
    show_error "No se encontró el esquema de color NASA Light Qt"
fi

if [ -f "linux/qt/NASA_Dark.colors" ]; then
    cp "linux/qt/NASA_Dark.colors" "$HOME/.local/share/color-schemes/"
    show_progress "Esquema de color Qt NASA Dark instalado"
else
    show_error "No se encontró el esquema de color NASA Dark Qt"
fi

echo ""
echo "=========================================="
echo "  Instalación completada exitosamente"
echo "=========================================="
echo ""
echo "Para aplicar los temas:"
echo ""
echo "GTK (GNOME/Ubuntu):"
echo "1. Instale GNOME Tweaks: sudo apt install gnome-tweaks"
echo "2. Abra GNOME Tweaks"
echo "3. Vaya a 'Apariencia' > 'Aplicaciones'"
echo "4. Seleccione 'NASA-Light' o 'NASA-Dark'"
echo ""
echo "Qt/KDE:"
echo "1. Abra 'Configuración del sistema'"
echo "2. Vaya a 'Apariencia' > 'Colores'"
echo "3. Seleccione 'NASA Light' o 'NASA Dark'"
echo ""
echo "También puede usar herramientas como:"
echo "- lxappearance (LXDE/OpenBox)"
echo "- qt5ct (para aplicaciones Qt)"
echo ""

# Hacer el script ejecutable a sí mismo
chmod +x "$0"

echo "¡Disfrute de sus nuevos temas NASA!"
echo ""
