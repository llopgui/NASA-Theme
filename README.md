# 🚀 NASA Theme - Temas Profesionales Inspirados en el Cosmos

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-blue.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)
[![Windows 11](https://img.shields.io/badge/Windows-10%20%7C%2011-blue.svg)](https://www.microsoft.com/windows)
[![PowerShell 5.1+](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://docs.microsoft.com/powershell/)
[![NASA](https://img.shields.io/badge/Inspired%20by-NASA-orange.svg)](https://www.nasa.gov/)
[![GitHub](https://img.shields.io/badge/GitHub-NASA--Theme-black.svg)](https://github.com/llopgui/NASA-Theme)

> **Transforma tu experiencia de Windows con temas inspirados en las misiones espaciales más icónicas de la NASA**

Colección profesional de temas para Windows 10/11 que lleva la majestuosidad del cosmos directamente a tu escritorio. Inspirados en las misiones espaciales reales de la NASA, incluyendo la paleta de colores científicamente precisa del Telescopio Espacial James Webb.

![NASA Theme Preview](https://via.placeholder.com/1200x600/2D234B/FFFFFF?text=NASA+THEME+-+COSMOS+EN+TU+ESCRITORIO)

## ✨ Características Destacadas

### 🌌 **NASA Dark Theme - JWST Edition**

- **Paleta científica auténtica** basada en el Telescopio Espacial James Webb
- **Colores PANTONE oficiales**: Mystical, Lavender Gray, Ginger Bread, Steel Gray
- **Modo oscuro completo** optimizado para Windows 11
- **Efectos de transparencia avanzados** con composición DWM
- **Presentación automática** de wallpapers del cosmos

### ☀️ **NASA Light Theme - Cosmos Luminoso**

- **Colores inspirados** en la luminosidad del cosmos
- **Interfaz clara y productiva** perfecta para trabajo diurno
- **Tonos azules espaciales** que evocan la vastedad del universo
- **Optimizado para múltiples resoluciones**

### 🖼️ **Colección de Wallpapers Premium**

- **Más de 100 imágenes NASA** de alta resolución
- **Categorización inteligente**: Galaxias, Planetas, Misiones, Telescopios
- **Optimización automática** para tu resolución de pantalla
- **Calidades múltiples**: Ultra HQ, High Quality, Standard
- **Organización automática** por tipo y tema

### ⚙️ **Instalador Profesional**

- **Interfaz moderna** con arte ASCII personalizado
- **Diagnóstico completo** del sistema Windows
- **Instalación inteligente** con detección automática
- **Respaldo automático** del tema actual
- **Logging detallado** para troubleshooting

## 🚀 Instalación Rápida

### **Método Recomendado - PowerShell Avanzado**

1. **Descargar el proyecto**:

   ```powershell
   git clone https://github.com/llopgui/NASA-Theme.git
   cd NASA-Theme
   ```

2. **Ejecutar instalador como administrador**:

   ```powershell
   # Instalación completa (ambos temas)
   .\Install-NASATheme.ps1

   # Solo tema oscuro JWST con presentación
   .\Install-NASATheme.ps1 -ThemeType Dark -EnableSlideshow

   # Instalación personalizada para 4K
   .\Install-NASATheme.ps1 -Resolution "3840x2160" -SlideshowInterval 15
   ```

3. **Aplicar el tema**:
   - Clic derecho en el escritorio → **Personalizar**
   - Ir a **Temas** → Seleccionar **NASA Dark Theme** o **NASA Light Theme**

### **Opciones Avanzadas del Instalador**

```powershell
# Instalación silenciosa para automatización
.\Install-NASATheme.ps1 -Silent -ThemeType Both

# Con wallpaper personalizado
.\Install-NASATheme.ps1 -WallpaperPath "C:\Pictures\mi_cosmos.jpg"

# Con respaldo del tema actual
.\Install-NASATheme.ps1 -BackupCurrentTheme

# Desinstalación completa
.\Install-NASATheme.ps1 -Uninstall
```

## 🎨 Paleta de Colores JWST

El tema oscuro utiliza la paleta oficial del Telescopio Espacial James Webb:

| Color | PANTONE | Hex | RGB | Uso |
|-------|---------|-----|-----|-----|
| **Mystical** | 18-3620 TCX | `#2D234B` | `45, 35, 75` | Fondos principales |
| **Lavender Gray** | 17-3910 TCX | `#9691A5` | `150, 145, 165` | Texto secundario |
| **Ginger Bread** | 18-1244 TCX | `#A55541` | `165, 85, 65` | Acentos y énfasis |
| **Steel Gray** | 18-4005 TCX | `#69737D` | `105, 115, 125` | Elementos UI |
| **Beech** | 19-0618 TCX | `#555F4B` | `85, 95, 75` | Bordes y sombras |
| **Foxtrot** | 18-1025 TCX | `#B9A591` | `185, 165, 145` | Highlights |

## 📁 Estructura del Proyecto

```
NASA-Theme/
├── 🚀 Install-NASATheme.ps1      # Instalador profesional v4.0
├── 📖 README.md                  # Documentación principal
├── 📄 LICENSE                    # Licencia CC BY-NC-SA 4.0
├── 👥 CONTRIBUTORS.md            # Colaboradores del proyecto
├──
├── 🎨 windows/                   # Archivos de temas Windows
│   ├── dark/                     # NASA Dark Theme - JWST Edition
│   │   └── NASA_Dark.theme       # Archivo de tema principal
│   └── light/                    # NASA Light Theme
│       └── NASA_Light.theme      # Archivo de tema principal
│
├── 🖼️ resources/                 # Recursos multimedia
│   ├── wallpapers/              # Colección de wallpapers NASA
│   │   ├── organized/           # Wallpapers categorizados
│   │   │   ├── galaxy/          # Imágenes de galaxias
│   │   │   ├── planet/          # Planetas y sistemas solares
│   │   │   ├── telescope/       # Imágenes de telescopios
│   │   │   ├── mission/         # Misiones espaciales
│   │   │   └── cosmic/          # Cosmos general
│   │   └── [100+ imágenes NASA] # Colección original
│   │
│   ├── icons/                   # Iconos del sistema (futuro)
│   └── colors/                  # Paletas de colores
│
└── 📚 docs/                     # Documentación adicional
    ├── installation-guide.md    # Guía detallada de instalación
    ├── troubleshooting.md       # Solución de problemas
    └── contributing.md          # Guía para contribuidores
```

## 🔧 Requisitos del Sistema

### **Sistemas Operativos Soportados**

- ✅ **Windows 11** (Todas las versiones)
- ✅ **Windows 10** Build 19041+ (Versión 2004 o superior)

### **Requisitos Técnicos**

- 🔐 **Privilegios de administrador** (requerido)
- 💾 **200 MB de espacio libre** en disco
- 🛠️ **PowerShell 5.1+** (incluido en Windows)
- 🎨 **Servicios de temas** habilitados

### **Arquitecturas Soportadas**

- 🖥️ **x64 (AMD64)** - Recomendado
- 🖥️ **x86 (32-bit)** - Soportado

## 🖥️ Resoluciones Optimizadas

| Resolución | Categoría | Soporte | Calidad |
|------------|-----------|---------|---------|
| `1366x768` | HD | ✅ Completo | Standard |
| `1920x1080` | Full HD | ✅ Óptimo | High Quality |
| `2560x1440` | QHD | ✅ Óptimo | Ultra HQ |
| `3840x2160` | 4K UHD | ✅ Óptimo | Ultra HQ |
| `5120x2880` | 5K | ✅ Soportado | Ultra HQ |
| Personalizada | Variable | ✅ Auto-detect | Variable |

## 🛠️ Características Técnicas Avanzadas

### **Instalador Inteligente**

- 🔍 **Diagnóstico completo** del sistema
- 🎯 **Detección automática** de resolución y características
- 📊 **Puntuación de compatibilidad** del sistema
- 🔄 **Organización automática** de wallpapers
- 💾 **Sistema de respaldo** integrado
- 📝 **Logging detallado** con timestamps

### **Configuración del Sistema**

- 🌙 **Modo oscuro completo** en Windows 11
- 🎨 **Color de énfasis personalizado** (Ginger Bread)
- ✨ **Efectos de transparencia** habilitados
- 🖼️ **Presentación automática** de wallpapers
- 🔧 **Configuración avanzada** del registro
- 🎯 **Optimización DWM** (Desktop Window Manager)

### **Gestión de Wallpapers**

- 📁 **Categorización inteligente** por contenido
- 🏷️ **Nomenclatura descriptiva** automática
- 📐 **Optimización por resolución**
- 🎨 **Selección temática** (oscuro/claro)
- 🔄 **Rotación automática** configurable

## 🚀 Ejemplos de Uso Avanzado

### **Para Desarrolladores**

```powershell
# Instalación automatizada en scripts de setup
.\Install-NASATheme.ps1 -Silent -ThemeType Dark -SkipExplorerRestart
```

### **Para Diseñadores**

```powershell
# Máxima calidad visual con presentación personalizada
.\Install-NASATheme.ps1 -ThemeType Both -EnableSlideshow -SlideshowInterval 10 -Resolution "2560x1440"
```

### **Para Administradores de Sistema**

```powershell
# Instalación con respaldo y logging detallado
.\Install-NASATheme.ps1 -BackupCurrentTheme -ThemeType Dark -Verbose
```

### **Para Personalización Extrema**

```powershell
# Con wallpaper personalizado y configuración específica
.\Install-NASATheme.ps1 -WallpaperPath "D:\NASA\mi_nebula_favorita.jpg" -SlideshowInterval 45
```

## 🔧 Solución de Problemas

### **Problemas Comunes**

#### ❌ "El script no puede ejecutarse"

**Solución**: Ejecutar PowerShell como administrador:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\Install-NASATheme.ps1
```

#### ❌ "Tema no aparece suficientemente oscuro"

**Solución**: El instalador configura automáticamente el modo oscuro completo. Si persiste:

1. Ir a **Configuración** → **Personalización** → **Colores**
2. Seleccionar **Modo oscuro**
3. Reiniciar Windows Explorer

#### ❌ "Wallpapers no cambian automáticamente"

**Solución**: Verificar configuración de presentación:

```powershell
# Reinstalar con presentación habilitada
.\Install-NASATheme.ps1 -ThemeType Dark -EnableSlideshow -SlideshowInterval 30
```

#### ❌ "Error de permisos"

**Solución**: Asegurar privilegios de administrador y deshabilitar temporalmente el antivirus durante la instalación.

### **Logs y Diagnóstico**

Los logs detallados se guardan automáticamente en:

- 📄 `%TEMP%\NASA_Theme_Install_[timestamp].log` - Log principal
- 🚨 `%TEMP%\NASA_Theme_Critical.log` - Errores críticos

Para diagnóstico avanzado:

```powershell
# Ejecutar con información de depuración
.\Install-NASATheme.ps1 -Verbose -Debug
```

## 🤝 Contribuir al Proyecto

¡Las contribuciones son bienvenidas! Este proyecto vive gracias a la comunidad.

### **Formas de Contribuir**

- 🖼️ **Wallpapers NASA**: Aporta imágenes de alta calidad
- 🎨 **Nuevos temas**: Diseños inspirados en misiones espaciales
- 🐛 **Reportar bugs**: Issues en GitHub con logs detallados
- 📖 **Documentación**: Mejoras en guías y tutoriales
- 💻 **Código**: Mejoras en el instalador y funcionalidades

### **Proceso de Contribución**

1. **Fork** del repositorio
2. **Crear branch** para tu feature: `git checkout -b feature/nueva-caracteristica`
3. **Commit** tus cambios: `git commit -am 'Añadir nueva característica'`
4. **Push** al branch: `git push origin feature/nueva-caracteristica`
5. **Abrir Pull Request**

📖 **Guía completa**: [CONTRIBUTORS.md](CONTRIBUTORS.md)

## 📜 Licencia y Atribución

### **Licencia del Proyecto**

Este proyecto está licenciado bajo **CC BY-NC-SA 4.0** (Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International).

#### ✅ **Permitido**

- ✅ **Compartir** - Copiar y redistribuir el material
- ✅ **Adaptar** - Remezclar, transformar y crear a partir del material
- ✅ **Uso personal** - Uso en computadoras personales
- ✅ **Uso educativo** - Uso en instituciones educativas

#### ❌ **Restricciones**

- ❌ **Uso comercial** - No se permite uso para fines comerciales
- ⚠️ **Atribución** - Debe dar crédito al autor original
- 🔄 **CompartirIgual** - Derivados bajo la misma licencia

### **Cómo Citar**

```
NASA Theme por llopgui
Licencia: CC BY-NC-SA 4.0
Repositorio: https://github.com/llopgui/NASA-Theme
```

### **Créditos Especiales**

- 🚀 **NASA** - Por inspirar la exploración del cosmos
- 🔭 **James Webb Space Telescope Team** - Por la paleta de colores científica
- 🌌 **Comunidad Astronómica** - Por las imágenes del cosmos
- 💻 **Contribuidores** - Ver [CONTRIBUTORS.md](CONTRIBUTORS.md)

## 🔗 Enlaces y Recursos

### **Proyecto NASA Theme**

- 🏠 **Repositorio Principal**: [github.com/llopgui/NASA-Theme](https://github.com/llopgui/NASA-Theme)
- 🐛 **Reportar Issues**: [github.com/llopgui/NASA-Theme/issues](https://github.com/llopgui/NASA-Theme/issues)
- 💡 **Solicitar Features**: [github.com/llopgui/NASA-Theme/discussions](https://github.com/llopgui/NASA-Theme/discussions)
- 📚 **Wiki del Proyecto**: [github.com/llopgui/NASA-Theme/wiki](https://github.com/llopgui/NASA-Theme/wiki)

### **Recursos NASA**

- 🚀 **NASA Oficial**: [nasa.gov](https://www.nasa.gov/)
- 🖼️ **NASA Image Gallery**: [nasa.gov/multimedia/imagegallery](https://www.nasa.gov/multimedia/imagegallery/)
- 🔭 **James Webb Space Telescope**: [jwst.nasa.gov](https://www.jwst.nasa.gov/)
- 🌌 **Hubble Space Telescope**: [hubblesite.org](https://hubblesite.org/)

### **Tecnología**

- 💻 **PowerShell Docs**: [docs.microsoft.com/powershell](https://docs.microsoft.com/powershell/)
- 🎨 **Windows Themes**: [docs.microsoft.com/windows/themes](https://docs.microsoft.com/windows/themes)
- 📖 **CC BY-NC-SA 4.0**: [creativecommons.org/licenses/by-nc-sa/4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)

---

<div align="center">

**🌌 "Explorando el cosmos desde tu escritorio" 🌌**

Hecho con ❤️ para la comunidad de entusiastas del espacio

**⭐ Si te gusta este proyecto, dale una estrella en GitHub ⭐**

[⬆️ Volver al inicio](#-nasa-theme---temas-profesionales-inspirados-en-el-cosmos)

</div>
