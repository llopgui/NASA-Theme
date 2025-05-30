# NASA Theme - Temas Claro y Oscuro para Windows y Linux

## Descripción

Colección de temas inspirados en la NASA para Windows y Linux, disponibles en modo claro y oscuro.

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

## Instalación

### Windows

1. Navega a la carpeta `windows/light` o `windows/dark`
2. Ejecuta el archivo `.theme` correspondiente
3. Windows aplicará automáticamente el tema

### Linux (GTK)

1. Copia la carpeta del tema a `~/.themes/`
2. Usa tu gestor de temas favorito para aplicarlo

### Linux (Qt)

1. Copia la carpeta del tema a `~/.local/share/color-schemes/`
2. Configura desde las opciones del sistema

## 🖼️ Procesador de Imágenes

### Instalación del Procesador
```bash
# Navegar al directorio de herramientas
cd tools/

# Instalar dependencias
pip install -r requirements.txt
```

### Uso Básico
```bash
# Procesar una imagen individual
python image_processor.py imagen.jpg

# Procesar un directorio completo
python image_processor.py ./imagenes/ --recursive

# Generar wallpapers específicos
python image_processor.py wallpaper.jpg --type wallpaper --theme dark
```

### Funcionalidades
- **🔄 Procesamiento automático** de wallpapers, iconos y texturas
- **📐 Múltiples resoluciones** (1366x768 hasta 4K)
- **🎨 Optimización inteligente** de calidad y compresión
- **🤖 Detección automática** de tipo de imagen y tema
- **📊 Reportes detallados** de archivos generados

📖 **Documentación completa**: [`tools/README.md`](tools/README.md)

## Características

- **Modo Claro**: Colores suaves inspirados en el espacio
- **Modo Oscuro**: Tonos profundos del cosmos
- **Compatibilidad multiplataforma**
- **Iconos personalizados**
- **Fondos de pantalla de alta calidad**

## Requisitos

- Windows 10/11 o distribución Linux moderna
- Permisos de administrador para la instalación
- Python 3.7+ (para el procesador de imágenes)

## Contribuir

Las contribuciones son bienvenidas. Por favor lee la documentación antes de enviar pull requests.

## Licencia

Este proyecto está licenciado bajo **CC BY-NC-SA 4.0** (Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International).

### Resumen de la Licencia

- **Atribución**: Debes dar crédito adecuado al autor original
- **No Comercial**: No puedes usar el material para fines comerciales
- **Compartir Igual**: Si remezclas, transformas o creas a partir del material, debes distribuir tus contribuciones bajo la misma licencia

📄 **Texto completo de la licencia**: [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.es)

### Cómo Citar

```
NASA Theme por [NASA Theme Project]
Licencia: CC BY-NC-SA 4.0
URL: [repositorio del proyecto]
```
