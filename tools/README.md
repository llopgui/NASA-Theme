# 🚀 NASA Theme Image Processor

Procesador automático de imágenes para generar todos los formatos y tamaños necesarios para los temas NASA en Windows y Linux.

## 📋 Características

- **🔄 Procesamiento automático** de wallpapers, iconos y texturas
- **📐 Múltiples resoluciones** adaptadas para cada sistema operativo
- **🎨 Optimización inteligente** de calidad y compresión
- **🤖 Detección automática** de tipo de imagen y tema (claro/oscuro)
- **📊 Reportes detallados** de archivos generados
- **⚡ Procesamiento por lotes** de directorios completos

## 🛠️ Instalación

### Requisitos

- Python 3.7 o superior
- pip (gestor de paquetes de Python)

### Pasos de instalación

```bash
# 1. Navegar al directorio de herramientas
cd tools/

# 2. Instalar dependencias
pip install -r requirements.txt

# 3. Hacer el script ejecutable (Linux/macOS)
chmod +x image_processor.py
```

## 📖 Uso

### Sintaxis básica

```bash
python image_processor.py <ruta_imagen_o_directorio> [opciones]
```

### Ejemplos de uso

#### **Procesar una imagen individual**

```bash
# Detección automática
python image_processor.py wallpaper.jpg

# Especificar tipo explícitamente
python image_processor.py space_image.png --type wallpaper --theme dark
```

#### **Procesar un directorio**

```bash
# Procesar todas las imágenes en un directorio
python image_processor.py ./images/

# Procesamiento recursivo con tipo específico
python image_processor.py ./wallpapers/ --type wallpaper --recursive
```

#### **Opciones avanzadas**

```bash
# Procesar iconos con nombre personalizado
python image_processor.py icon.png --type icon --name nasa_logo

# Especificar directorio de salida
python image_processor.py ./images/ --output ./processed_nasa_themes/

# Modo silencioso
python image_processor.py ./batch/ --quiet --recursive
```

### Opciones disponibles

| Opción | Descripción | Valores | Default |
|--------|-------------|---------|---------|
| `--type`, `-t` | Tipo de procesamiento | `auto`, `wallpaper`, `icon`, `texture` | `auto` |
| `--theme` | Tema para wallpapers | `auto`, `light`, `dark` | `auto` |
| `--output`, `-o` | Directorio de salida | Cualquier ruta | `processed_images` |
| `--name`, `-n` | Nombre personalizado | Texto | Nombre del archivo |
| `--recursive`, `-r` | Procesar subdirectorios | Flag | `false` |
| `--quiet`, `-q` | Modo silencioso | Flag | `false` |

## 📁 Estructura de salida

El script genera una estructura organizada:

```
processed_images/
├── wallpapers/
│   ├── nasa_light_1920x1080.jpg      # Wallpaper Full HD claro
│   ├── nasa_light_2560x1440.jpg      # Wallpaper 2K claro
│   ├── nasa_dark_1920x1080.jpg       # Wallpaper Full HD oscuro
│   └── nasa_dark_3840x2160.jpg       # Wallpaper 4K oscuro
├── icons/
│   ├── 16x16/
│   │   └── icon_name.png
│   ├── 32x32/
│   │   └── icon_name.png
│   ├── 256x256/
│   │   └── icon_name.png
│   └── ...
├── textures/
│   ├── texture_256x256.png
│   ├── texture_512x512.png
│   └── texture_1024x1024.png
└── processing_report.json             # Reporte detallado
```

## 🎯 Tipos de procesamiento

### **Wallpapers**

- **Resoluciones**: 1366x768, 1600x900, 1920x1080, 2560x1440, 3840x2160, 2560x1600
- **Formatos**: JPG optimizado (calidad 85-92%)
- **Detección automática**: Tema claro/oscuro basado en brillo promedio
- **Optimización**: Mejora de nitidez y saturación

### **Iconos**

- **Tamaños**: 16x16, 22x22, 24x24, 32x32, 48x48, 64x64, 96x96, 128x128, 256x256
- **Formato**: PNG con transparencia
- **Optimización**: Compresión sin pérdida de calidad
- **Organización**: Carpetas por tamaño

### **Texturas**

- **Tamaños**: 256x256, 512x512, 1024x1024 (potencias de 2)
- **Formato**: PNG de alta calidad
- **Uso**: Patrones, overlays, elementos de UI

## 🔧 Detección automática

### **Tipo de imagen**

```python
# Lógica de detección automática
if width >= 1024 and height >= 768:
    tipo = "wallpaper"
elif width <= 256 and height <= 256:
    tipo = "icon"
else:
    tipo = "texture"
```

### **Tema claro/oscuro**

```python
# Análisis de brillo promedio
brillo_promedio = suma_pixeles_grises / total_pixeles
tema = "light" if brillo_promedio > 128 else "dark"
```

## 📊 Reporte de procesamiento

El script genera un reporte JSON detallado:

```json
{
  "total_original_images": 5,
  "total_generated_files": 42,
  "total_size_mb": 156.7,
  "output_directory": "/ruta/completa/processed_images",
  "results": {
    "imagen1.jpg": ["wallpaper1.jpg", "wallpaper2.jpg", ...],
    "icono.png": ["icon_16x16.png", "icon_32x32.png", ...]
  }
}
```

## ⚡ Optimizaciones aplicadas

### **Wallpapers**

- Conversión a RGB para JPG
- Mejora de nitidez (1.1x)
- Aumento de saturación (1.05x)
- Compresión progresiva
- Múltiples calidades para alta resolución

### **Iconos**

- Preservación de transparencia (RGBA)
- Redimensionado con algoritmo Lanczos
- Centrado automático en canvas
- Compresión PNG optimizada

### **Texturas**

- Redimensionado exacto (sin mantener proporción)
- Formato PNG para máxima calidad
- Tamaños de potencia de 2 para compatibilidad

## 🚨 Manejo de errores

- **Formatos no soportados**: Advertencia y omisión
- **Archivos corruptos**: Error específico con continuación del proceso
- **Permisos insuficientes**: Error claro sobre acceso a directorios
- **Interrupciones**: Manejo graceful de Ctrl+C

## 💡 Consejos de uso

### **Para mejores resultados**

1. **Usa imágenes de alta calidad** como fuente (preferiblemente sin comprimir)
2. **Organiza por tipo** antes del procesamiento
3. **Verifica el espacio libre** (el procesamiento puede generar muchos archivos)
4. **Usa nombres descriptivos** para facilitar la organización

### **Flujo de trabajo recomendado**

```bash
# 1. Organizar imágenes fuente
mkdir source_images
mv *.jpg source_images/

# 2. Procesar con configuración específica
python image_processor.py source_images/ --output nasa_theme_resources/

# 3. Verificar resultados
ls -la nasa_theme_resources/

# 4. Revisar reporte
cat nasa_theme_resources/processing_report.json
```

## 📝 Licencia

Este script está licenciado bajo **CC BY-NC-SA 4.0** (Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International).

## 🤝 Contribuir

Las mejoras al procesador son bienvenidas. Por favor:

1. Mantén la compatibilidad con las especificaciones del tema
2. Documenta nuevas características
3. Incluye ejemplos de uso
4. Respeta la licencia CC BY-NC-SA 4.0

---

¡Feliz procesamiento de imágenes para tus temas NASA! 🚀✨
