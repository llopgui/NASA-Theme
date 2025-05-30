# NASA Theme - Temas Claro y Oscuro para Windows y Linux

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)
[![GitHub](https://img.shields.io/badge/GitHub-NASA--Theme-blue)](https://github.com/llopgui/NASA-Theme)
[![Python](https://img.shields.io/badge/Python-3.7%2B-green)](https://python.org)

## Descripción

Colección de temas inspirados en la NASA para Windows y Linux, disponibles en modo claro y oscuro con **colores verdaderamente oscuros** y wallpapers de alta calidad.

## Estructura del Proyecto

```
NASA_THEME/
├── windows/              # Temas para Windows
│   ├── light/           # Tema claro
│   └── dark/            # Tema oscuro
├── linux/               # Temas para Linux
│   ├── gtk/             # Temas GTK
│   └── qt/              # Temas Qt
├── resources/           # Recursos compartidos
│   ├── wallpapers/      # Fondos de pantalla
│   ├── icons/           # Iconos
│   └── colors/          # Paletas de colores
├── tools/               # Herramientas de desarrollo
│   ├── image_processor.py  # Procesador de imágenes
│   └── requirements.txt    # Dependencias Python
└── docs/                # Documentación
```

## 🚀 Instalación Rápida

### **Windows 10/11 - Instalación Automática**

#### **Opción 1: Instalación Completa (Recomendada)**
```cmd
# 1. Generar wallpapers de alta calidad
generate_wallpapers.bat

# 2. Instalar temas (como administrador)
install_nasa_theme.bat
```

#### **Opción 2: Solo instalar temas**
```cmd
# Instalar solo los archivos de tema (como administrador)
install_nasa_theme.bat
```

### **Características de los Temas v2.0**

✅ **NASA Dark Theme**:
- **Colores ultra oscuros** (RGB 5-25 en lugar de 30-60)
- **Modo oscuro real** del sistema Windows
- **Presentación automática** de wallpapers
- **Configuración completa** de colores del sistema

✅ **NASA Light Theme**:
- **Colores espaciales claros** inspirados en el cosmos
- **Interfaz luminosa** con acentos azules
- **Optimizado para productividad** diurna

## Instalación Manual

### Windows

#### **Método Automático (Recomendado)**
1. **Ejecuta como administrador**: `install_nasa_theme.bat`
2. Sigue las instrucciones en pantalla
3. Ve a **Configuración > Personalización > Temas**
4. Selecciona **NASA Dark Theme** o **NASA Light Theme**

#### **Método Manual**
1. Copia los archivos `.theme` a `%SystemRoot%\Resources\Themes\`
2. Crea carpetas: `%SystemRoot%\Resources\Themes\NASA_Dark\wallpapers\`
3. Copia wallpapers a las carpetas correspondientes
4. Aplica el tema desde **Configuración > Personalización**

### Linux (GTK)

1. Copia la carpeta del tema a `~/.themes/`
2. Usa tu gestor de temas favorito para aplicarlo

### Linux (Qt)

1. Copia la carpeta del tema a `~/.local/share/color-schemes/`
2. Configura desde las opciones del sistema

## 🖼️ Procesador de Imágenes

### **Instalación del Procesador**
```bash
# Navegar al directorio de herramientas
cd tools/

# Instalar dependencias
pip install -r requirements.txt
```

### **Uso Básico**
```bash
# Procesar todas las imágenes automáticamente
python image_processor.py ../resources/RAW_IMAGES/ --recursive --presentation

# Procesar imagen específica
python image_processor.py imagen.jpg --type wallpaper --theme dark

# Generar galería HTML de presentación
python image_processor.py ./imagenes/ --presentation
```

### **Funcionalidades v1.1**
- **🔄 Nombres únicos** - Ya no sobrescribe wallpapers
- **📐 Múltiples resoluciones** (1366x768 hasta 4K)
- **🎨 Optimización inteligente** de calidad y compresión
- **🤖 Detección automática** de tipo de imagen y tema
- **📊 Reportes detallados** de archivos generados
- **🌐 Galería HTML** interactiva con previsualización

📖 **Documentación completa**: [`tools/README.md`](tools/README.md)

## Características

- **✨ Modo Claro**: Colores suaves inspirados en el espacio
- **🌃 Modo Oscuro**: Colores ultra oscuros del cosmos profundo
- **🖥️ Compatibilidad multiplataforma** (Windows 10/11, Linux)
- **🎨 Iconos personalizados** del sistema
- **🖼️ Wallpapers de alta calidad** en múltiples resoluciones
- **🔧 Instalación automática** con scripts inteligentes

## 🔧 Solución de Problemas

### **El tema oscuro no es suficientemente oscuro**
- Asegúrate de usar la **versión 2.0** del tema
- Ejecuta `install_nasa_theme.bat` **como administrador**
- Verifica que Windows esté en **modo oscuro** en Configuración

### **Los wallpapers no aparecen**
- Ejecuta `generate_wallpapers.bat` primero
- Verifica que existan imágenes en `resources/RAW_IMAGES/`
- Reinstala con `install_nasa_theme.bat` como administrador

### **Error de permisos en Windows**
- **Ejecuta siempre como administrador** los scripts de instalación
- Verifica que no tengas antivirus bloqueando la escritura

## Requisitos

- **Windows**: 10/11 o superior
- **Linux**: Distribución moderna con GTK 3.20+ o Qt 5+
- **Python**: 3.7+ (para el procesador de imágenes)
- **Permisos**: Administrador para instalación

## Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Haz fork del repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-caracteristica`)
3. Haz commit de tus cambios (`git commit -am 'Añadir nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Abre un Pull Request

📖 **Contribuir**: [`CONTRIBUTORS.md`](CONTRIBUTORS.md)

## Licencia

Este proyecto está licenciado bajo **CC BY-NC-SA 4.0** (Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International).

### Resumen de la Licencia

- **Atribución**: Debes dar crédito adecuado al autor original
- **No Comercial**: No puedes usar el material para fines comerciales
- **Compartir Igual**: Si remezclas, transformas o creas a partir del material, debes distribuir tus contribuciones bajo la misma licencia

📄 **Texto completo de la licencia**: [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.es)

### Cómo Citar

```
NASA Theme por llopgui
Licencia: CC BY-NC-SA 4.0
URL: https://github.com/llopgui/NASA-Theme
```

## Enlaces

- **Repositorio**: [https://github.com/llopgui/NASA-Theme](https://github.com/llopgui/NASA-Theme)
- **Issues**: [https://github.com/llopgui/NASA-Theme/issues](https://github.com/llopgui/NASA-Theme/issues)
- **Documentación**: [docs/](docs/)
- **Herramientas**: [tools/README.md](tools/README.md)
