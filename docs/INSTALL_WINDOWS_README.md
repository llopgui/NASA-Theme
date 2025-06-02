# 🚀 NASA Theme - Instalador para Windows (PowerShell)

## 📋 Descripción

Este script de PowerShell instala los temas NASA (claro y oscuro) en Windows de manera automatizada, optimizando los wallpapers para tu resolución de pantalla y configurando el sistema correctamente.

## ✨ Características

- 🔒 **Verificación de privilegios**: Requiere ejecutarse como administrador
- 🖥️ **Detección automática de resolución**: Selecciona wallpapers optimizados
- 🎨 **Instalación flexible**: Instala uno o ambos temas
- 📊 **Logging completo**: Registro detallado de la instalación
- 🎯 **Interfaz colorida**: Mensajes con emojis y colores
- ⚡ **Configuración de registro**: Integración completa con Windows

## 🛠️ Requisitos del Sistema

- Windows 10/11
- PowerShell 5.1 o superior
- Privilegios de administrador
- .NET Framework (para detección de resolución)

## 📥 Instalación

### Método 1: Instalación Básica (Recomendado)

1. **Abrir PowerShell como administrador**:
   - Presiona `Win + X`
   - Selecciona "Windows PowerShell (Administrador)" o "Terminal (Administrador)"

2. **Navegar al directorio del proyecto**:

   ```powershell
   cd "C:\ruta\al\proyecto\NASA_THEME"
   ```

3. **Ejecutar el script**:

   ```powershell
   .\install_windows.ps1
   ```

### Método 2: Ejecución Directa

```powershell
# Permitir ejecución de scripts (solo la primera vez)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Ejecutar instalador
.\install_windows.ps1
```

## 🎛️ Opciones Avanzadas

### Parámetros Disponibles

```powershell
# Instalar solo el tema oscuro
.\install_windows.ps1 -ThemeType Dark

# Instalar solo el tema claro
.\install_windows.ps1 -ThemeType Light

# Instalar ambos temas (por defecto)
.\install_windows.ps1 -ThemeType Both

# Especificar resolución manualmente
.\install_windows.ps1 -Resolution "2560x1440"

# Forzar reinstalación
.\install_windows.ps1 -Force

# Modo verbose para más detalles
.\install_windows.ps1 -Verbose
```

### Ejemplos de Uso

```powershell
# Instalación básica con detección automática
.\install_windows.ps1

# Solo tema oscuro para monitor 4K
.\install_windows.ps1 -ThemeType Dark -Resolution "3840x2160"

# Reinstalar ambos temas con logging detallado
.\install_windows.ps1 -Force -Verbose

# Instalar tema claro para resolución específica
.\install_windows.ps1 -ThemeType Light -Resolution "1920x1080"
```

## 📂 Estructura de Instalación

El script instalará los archivos en:

```
C:\Windows\Resources\Themes\
├── NASA_Light\
│   ├── NASA_Light.theme
│   └── wallpapers\
│       └── nasa_light_wallpaper.jpg
└── NASA_Dark\
    ├── NASA_Dark.theme
    └── wallpapers\
        └── nasa_dark_wallpaper.jpg
```

## 🎨 Aplicar los Temas

### Método 1: A través de Configuración

1. Clic derecho en el escritorio → **"Personalizar"**
2. Ir a **"Temas"** en el panel izquierdo
3. Buscar **"NASA Light Theme"** o **"NASA Dark Theme"**

### Método 2: Ejecución Directa

- Tema Claro: `C:\Windows\Resources\Themes\NASA_Light\NASA_Light.theme`
- Tema Oscuro: `C:\Windows\Resources\Themes\NASA_Dark\NASA_Dark.theme`

## 🔧 Resolución de Problemas

### Error: "No se puede ejecutar scripts"

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Error: "Se requieren privilegios de administrador"

- Cerrar PowerShell
- Abrir PowerShell como administrador
- Ejecutar el script nuevamente

### Wallpapers no se muestran correctamente

- Verificar que la resolución detectada sea correcta
- Usar parámetro `-Resolution` para especificar manualmente
- Verificar que existen wallpapers para tu resolución en `resources/wallpapers/`

### Los temas no aparecen en Configuración

- Reiniciar Windows Explorer: `taskkill /f /im explorer.exe && start explorer`
- Ejecutar el script con parámetro `-Force`

## 📋 Logs y Diagnóstico

El script genera un log detallado en:

```
%TEMP%\nasa_theme_install.log
```

Para ver el log:

```powershell
Get-Content "$env:TEMP\nasa_theme_install.log"
```

## 🔄 Actualización

Para actualizar los temas:

1. Descargar la nueva versión del proyecto
2. Ejecutar el script con parámetro `-Force`

```powershell
.\install_windows.ps1 -Force
```

## ❌ Desinstalación

Para remover los temas:

```powershell
# Eliminar directorios de temas
Remove-Item -Path "$env:SystemRoot\Resources\Themes\NASA_Light" -Recurse -Force
Remove-Item -Path "$env:SystemRoot\Resources\Themes\NASA_Dark" -Recurse -Force

# Limpiar entradas del registro (opcional)
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\NASA_Light" -Force
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\NASA_Dark" -Force
```

## 🌟 Características del Script

### Funciones Principales

- **`Test-AdminPrivileges`**: Verifica privilegios de administrador
- **`Get-ScreenResolution`**: Detecta automáticamente la resolución de pantalla
- **`Get-OptimalWallpaper`**: Encuentra el wallpaper más adecuado para la resolución
- **`Install-NASATheme`**: Instala un tema específico (claro u oscuro)
- **`Set-ThemeRegistry`**: Configura las entradas del registro de Windows
- **`Complete-Installation`**: Finaliza la instalación y muestra estadísticas

### Validaciones Incluidas

- ✅ Verificación de privilegios de administrador
- ✅ Validación de existencia de archivos fuente
- ✅ Verificación de estructura de directorios
- ✅ Manejo de errores robusto
- ✅ Logging completo de operaciones

## 🆘 Soporte

Si encuentras problemas:

1. **Revisa el archivo de log**: `%TEMP%\nasa_theme_install.log`
2. **Ejecuta con modo verbose**: `.\install_windows.ps1 -Verbose`
3. **Verifica los requisitos del sistema**
4. **Contacta al equipo de desarrollo** con el log completo

## 📜 Licencia

Este script está licenciado bajo **CC BY-NC-SA 4.0** (Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International).

## 👥 Contribuir

Para contribuir al proyecto:

1. Fork del repositorio
2. Crear rama de feature
3. Realizar cambios y pruebas
4. Enviar Pull Request

---

**¡Disfruta de tu nuevo tema NASA! 🚀🌌**
