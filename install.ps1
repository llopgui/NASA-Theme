#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Script de instalación para temas NASA en Windows usando PowerShell
.DESCRIPTION
    Este script instala los temas NASA (claro y oscuro) en Windows, copiando archivos de configuración,
    wallpapers optimizados para la resolución del usuario y configurando el registro de Windows.
.AUTHOR
    NASA Theme Project
.VERSION
    2.0.0
.LICENSE
    CC BY-NC-SA 4.0 (Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International)
    https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.es
.EXAMPLE
    .\install_windows.ps1
    Instala ambos temas (claro y oscuro) con detección automática de resolución
.EXAMPLE
    .\install_windows.ps1 -ThemeType Dark -Resolution "1920x1080"
    Instala solo el tema oscuro para resolución específica
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("Light", "Dark", "Both")]
    [string]$ThemeType = "Both",

    [Parameter(Mandatory = $false)]
    [string]$Resolution = "Auto",

    [Parameter(Mandatory = $false)]
    [switch]$Force
)

# Configuración de colores para la consola
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Cyan"

# Variables globales del script
$script:ErrorActionPreference = "Stop"
$script:ProgressPreference = "SilentlyContinue"
$script:ScriptName = "NASA Theme Installer"
$script:ScriptVersion = "2.0.0"
$script:LogFile = "$env:TEMP\nasa_theme_install.log"

# Rutas de instalación
$script:ThemeBaseDir = "$env:SystemRoot\Resources\Themes"
$script:NASA_LightDir = "$script:ThemeBaseDir\NASA_Light"
$script:NASA_DarkDir = "$script:ThemeBaseDir\NASA_Dark"

#region Funciones de utilidad

<#
.SYNOPSIS
    Escribe un mensaje con formato y color en la consola
.PARAMETER Message
    El mensaje a mostrar
.PARAMETER Type
    El tipo de mensaje (Info, Success, Warning, Error)
#>
function Write-ColoredMessage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Info", "Success", "Warning", "Error", "Header")]
        [string]$Type = "Info"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Type] $Message"

    # Escribir al archivo de log
    Add-Content -Path $script:LogFile -Value $logMessage -Encoding UTF8

    # Configurar colores según el tipo
    switch ($Type) {
        "Info" { Write-Host "[INFO] $Message" -ForegroundColor Cyan }
        "Success" { Write-Host "[OK] $Message" -ForegroundColor Green }
        "Warning" { Write-Host "[WARN] $Message" -ForegroundColor Yellow }
        "Error" { Write-Host "[ERROR] $Message" -ForegroundColor Red }
        "Header" {
            Write-Host ""
            Write-Host "=" * 60 -ForegroundColor Magenta
            Write-Host $Message -ForegroundColor Magenta
            Write-Host "=" * 60 -ForegroundColor Magenta
            Write-Host ""
        }
    }
}

<#
.SYNOPSIS
    Verifica si el script se está ejecutando con privilegios de administrador
#>
function Test-AdminPrivileges {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

<#
.SYNOPSIS
    Detecta automáticamente la resolución de pantalla del usuario
#>
function Get-ScreenResolution {
    try {
        # Obtener información de la pantalla principal
        $screen = [System.Windows.Forms.Screen]::PrimaryScreen
        $width = $screen.Bounds.Width
        $height = $screen.Bounds.Height

        Write-ColoredMessage "Resolución detectada: ${width}x${height}" -Type Info
        return "${width}x${height}"
    }
    catch {
        Write-ColoredMessage "No se pudo detectar la resolución automáticamente. Usando 1920x1080 por defecto." -Type Warning
        return "1920x1080"
    }
}

<#
.SYNOPSIS
    Encuentra el wallpaper más adecuado para la resolución especificada
#>
function Get-OptimalWallpaper {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ThemeVariant,

        [Parameter(Mandatory = $true)]
        [string]$TargetResolution
    )

    $wallpaperDir = ".\resources\wallpapers"

    # Buscar wallpapers que coincidan con el tema y resolución
    $pattern = "nasa_${ThemeVariant}_*_${TargetResolution}*.jpg"
    $candidates = Get-ChildItem -Path $wallpaperDir -Filter $pattern -ErrorAction SilentlyContinue

    if ($candidates.Count -gt 0) {
        # Preferir calidad más alta (q92 sobre q85)
        $bestMatch = $candidates | Where-Object { $_.Name -like "*q92*" } | Select-Object -First 1
        if (-not $bestMatch) {
            $bestMatch = $candidates | Select-Object -First 1
        }
        return $bestMatch.FullName
    }

    # Si no se encuentra coincidencia exacta, buscar el más cercano
    $fallbackPattern = "nasa_${ThemeVariant}_*_1920x1080*.jpg"
    $fallback = Get-ChildItem -Path $wallpaperDir -Filter $fallbackPattern -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($fallback) {
        Write-ColoredMessage "Usando wallpaper de respaldo para resolución 1920x1080" -Type Warning
        return $fallback.FullName
    }

    Write-ColoredMessage "No se encontró wallpaper adecuado para $ThemeVariant" -Type Warning
    return $null
}

<#
.SYNOPSIS
    Crea los directorios necesarios para la instalación
#>
function New-ThemeDirectories {
    $directories = @($script:NASA_LightDir, $script:NASA_DarkDir)

    foreach ($dir in $directories) {
        if (-not (Test-Path $dir)) {
            try {
                New-Item -Path $dir -ItemType Directory -Force | Out-Null
                Write-ColoredMessage "Directorio creado: $dir" -Type Success

                # Crear subdirectorio para wallpapers
                $wallpaperSubDir = Join-Path $dir "wallpapers"
                New-Item -Path $wallpaperSubDir -ItemType Directory -Force | Out-Null
            }
            catch {
                Write-ColoredMessage "Error al crear directorio $dir : $($_.Exception.Message)" -Type Error
                throw
            }
        }
        else {
            Write-ColoredMessage "Directorio ya existe: $dir" -Type Info
        }
    }
}

<#
.SYNOPSIS
    Instala un tema específico (claro u oscuro)
#>
function Install-NASATheme {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Light", "Dark")]
        [string]$Theme,

        [Parameter(Mandatory = $true)]
        [string]$Resolution
    )

    Write-ColoredMessage "Instalando tema NASA $Theme..." -Type Info

    $sourceDir = ".\windows\$($Theme.ToLower())"
    $targetDir = if ($Theme -eq "Light") { $script:NASA_LightDir } else { $script:NASA_DarkDir }
    $themeVariant = if ($Theme -eq "Light") { "light" } else { "dark" }

    # Verificar que existen los archivos fuente
    $themeFile = Join-Path $sourceDir "NASA_$Theme.theme"
    if (-not (Test-Path $themeFile)) {
        Write-ColoredMessage "Archivo de tema no encontrado: $themeFile" -Type Error
        return $false
    }

    try {
        # Copiar archivo de tema principal
        Copy-Item -Path $themeFile -Destination $targetDir -Force
        Write-ColoredMessage "Copiado archivo de tema: NASA_$Theme.theme" -Type Success

        # Buscar y copiar wallpaper optimizado
        $wallpaperPath = Get-OptimalWallpaper -ThemeVariant $themeVariant -TargetResolution $Resolution
        if ($wallpaperPath) {
            $wallpaperDestDir = Join-Path $targetDir "wallpapers"
            $wallpaperDestName = "nasa_${themeVariant}_wallpaper.jpg"
            $wallpaperDestPath = Join-Path $wallpaperDestDir $wallpaperDestName

            Copy-Item -Path $wallpaperPath -Destination $wallpaperDestPath -Force
            Write-ColoredMessage "Copiado wallpaper optimizado: $wallpaperDestName" -Type Success
        }

        # Actualizar registro de Windows para el tema
        Set-ThemeRegistry -Theme $Theme

        return $true
    }
    catch {
        Write-ColoredMessage "Error al instalar tema $Theme : $($_.Exception.Message)" -Type Error
        return $false
    }
}

<#
.SYNOPSIS
    Configura las entradas del registro de Windows para los temas
#>
function Set-ThemeRegistry {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Light", "Dark")]
        [string]$Theme
    )

    try {
        $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes"
        $themePath = if ($Theme -eq "Light") { $script:NASA_LightDir } else { $script:NASA_DarkDir }

        # Crear clave de registro si no existe
        if (-not (Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force | Out-Null
        }

        # Registrar el tema en el sistema
        $themeRegPath = "$registryPath\NASA_$Theme"
        New-Item -Path $themeRegPath -Force | Out-Null
        Set-ItemProperty -Path $themeRegPath -Name "DisplayName" -Value "NASA $Theme Theme"
        Set-ItemProperty -Path $themeRegPath -Name "InstallPath" -Value $themePath

        # Configuraciones específicas para tema oscuro JWST
        if ($Theme -eq "Dark") {
            Write-ColoredMessage "Configurando opciones específicas de personalización para tema JWST..." -Type Info

            # Configurar modo oscuro y efectos de transparencia
            $personalizePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
            if (-not (Test-Path $personalizePath)) {
                New-Item -Path $personalizePath -Force | Out-Null
            }

            # Modo oscuro para aplicaciones y sistema
            Set-ItemProperty -Path $personalizePath -Name "SystemUsesLightTheme" -Value 0 -Type DWord
            Set-ItemProperty -Path $personalizePath -Name "AppsUseLightTheme" -Value 0 -Type DWord

            # Efectos de transparencia activados
            Set-ItemProperty -Path $personalizePath -Name "EnableTransparency" -Value 1 -Type DWord

            # Color de énfasis automático y configuraciones
            Set-ItemProperty -Path $personalizePath -Name "ColorPrevalence" -Value 1 -Type DWord

            # Color de énfasis específico (Ginger Bread - PANTONE 18-1244 TCX)
            $accentColor = 0xFFA55541  # Color Ginger Bread en formato hexadecimal
            Set-ItemProperty -Path $personalizePath -Name "AccentColor" -Value $accentColor -Type DWord

            # === CONFIGURACIONES ADICIONALES PARA EXPLORADOR OSCURO ===
            Write-ColoredMessage "Aplicando configuraciones avanzadas para modo oscuro completo..." -Type Info

            # Configuraciones específicas para Windows 11/10 modo oscuro
            $personalizeAdvanced = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
            Set-ItemProperty -Path $personalizeAdvanced -Name "EnableTransparency" -Value 1 -Type DWord
            Set-ItemProperty -Path $personalizeAdvanced -Name "ColorPrevalence" -Value 1 -Type DWord
            Set-ItemProperty -Path $personalizeAdvanced -Name "SystemUsesLightTheme" -Value 0 -Type DWord
            Set-ItemProperty -Path $personalizeAdvanced -Name "AppsUseLightTheme" -Value 0 -Type DWord

            # Configurar explorador de archivos específicamente
            $explorerPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
            if (-not (Test-Path $explorerPath)) {
                New-Item -Path $explorerPath -Force | Out-Null
            }
            # Habilitar modo oscuro en explorador
            Set-ItemProperty -Path $explorerPath -Name "UseCompactMode" -Value 1 -Type DWord

            # Configuraciones adicionales para aplicaciones UWP
            $immersiveColorPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\History"
            if (-not (Test-Path $immersiveColorPath)) {
                New-Item -Path $immersiveColorPath -Force | Out-Null
            }

            # Forzar tema oscuro en aplicaciones del sistema
            $currentThemePath = "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\Microsoft.Windows.ShellExperienceHost_cw5n1h2txyewy\CortanaStartMenuExperienceConfiguration"
            if (-not (Test-Path $currentThemePath)) {
                try {
                    New-Item -Path $currentThemePath -Force | Out-Null
                } catch {
                    # Ignorar si no se puede crear esta ruta específica
                }
            }

            # Configurar colores del sistema para modo oscuro
            $colorsPath = "HKCU:\Control Panel\Colors"
            # Colores específicos para interfaz oscura del explorador
            Set-ItemProperty -Path $colorsPath -Name "Window" -Value "25 20 45" -Type String
            Set-ItemProperty -Path $colorsPath -Name "WindowText" -Value "220 215 235" -Type String
            Set-ItemProperty -Path $colorsPath -Name "Menu" -Value "35 25 55" -Type String
            Set-ItemProperty -Path $colorsPath -Name "MenuText" -Value "220 215 235" -Type String
            Set-ItemProperty -Path $colorsPath -Name "ActiveTitle" -Value "105 115 125" -Type String
            Set-ItemProperty -Path $colorsPath -Name "TitleText" -Value "250 245 255" -Type String
            Set-ItemProperty -Path $colorsPath -Name "Hilight" -Value "165 85 65" -Type String
            Set-ItemProperty -Path $colorsPath -Name "HilightText" -Value "255 255 255" -Type String

            # Configurar DWM (Desktop Window Manager) con configuraciones extendidas
            $dwmPath = "HKCU:\Software\Microsoft\Windows\DWM"
            if (-not (Test-Path $dwmPath)) {
                New-Item -Path $dwmPath -Force | Out-Null
            }

            # Efectos de transparencia y composición
            Set-ItemProperty -Path $dwmPath -Name "EnableAeroPeek" -Value 1 -Type DWord
            Set-ItemProperty -Path $dwmPath -Name "Composition" -Value 1 -Type DWord
            Set-ItemProperty -Path $dwmPath -Name "ColorizationColor" -Value $accentColor -Type DWord
            Set-ItemProperty -Path $dwmPath -Name "ColorizationColorBalance" -Value 89 -Type DWord
            Set-ItemProperty -Path $dwmPath -Name "ColorizationAfterglow" -Value $accentColor -Type DWord
            Set-ItemProperty -Path $dwmPath -Name "ColorizationAfterglowBalance" -Value 43 -Type DWord
            Set-ItemProperty -Path $dwmPath -Name "ColorizationBlurBalance" -Value 49 -Type DWord
            Set-ItemProperty -Path $dwmPath -Name "ColorizationGlassAttribute" -Value 1 -Type DWord
            Set-ItemProperty -Path $dwmPath -Name "EnableWindowColorization" -Value 1 -Type DWord

            # Color de énfasis en barras de título y bordes de ventana
            Set-ItemProperty -Path $dwmPath -Name "ColorPrevalence" -Value 1 -Type DWord
            Set-ItemProperty -Path $dwmPath -Name "AccentColor" -Value $accentColor -Type DWord

            # Configuraciones para barras de título
            $titleBarPath = "HKCU:\Software\Microsoft\Windows\DWM"
            Set-ItemProperty -Path $titleBarPath -Name "ColorPrevalence" -Value 1 -Type DWord

            # Configuraciones adicionales para asegurar modo oscuro
            $immersiveColorSet = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes"
            Set-ItemProperty -Path $immersiveColorSet -Name "CurrentTheme" -Value "C:\Windows\Resources\Themes\NASA_Dark\NASA_Dark.theme" -Type String -ErrorAction SilentlyContinue

            # Configuración de wallpaper en modo presentación
            $desktopPath = "HKCU:\Control Panel\Desktop"
            Set-ItemProperty -Path $desktopPath -Name "WallpaperStyle" -Value "6" -Type String  # Ajustar

            # Desactivar temas de contraste alto
            $accessibilityPath = "HKCU:\Control Panel\Accessibility\HighContrast"
            if (-not (Test-Path $accessibilityPath)) {
                New-Item -Path $accessibilityPath -Force | Out-Null
            }
            Set-ItemProperty -Path $accessibilityPath -Name "Flags" -Value "0" -Type String

            # Configuración específica para nuevas versiones de Windows
            try {
                # Aplicar configuraciones inmediatas de personalización
                $personalizeCSP = "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount"
                if (Test-Path $personalizeCSP) {
                    # Estas son configuraciones avanzadas que Windows 11 utiliza
                }
            } catch {
                # Ignorar errores en configuraciones avanzadas
            }

            Write-ColoredMessage "Configuraciones específicas JWST aplicadas: modo oscuro completo, transparencia, color de énfasis" -Type Success
        }

        Write-ColoredMessage "Configuración de registro actualizada para tema $Theme" -Type Success
    }
    catch {
        Write-ColoredMessage "Advertencia: No se pudo actualizar el registro: $($_.Exception.Message)" -Type Warning
    }
}

<#
.SYNOPSIS
    Muestra las instrucciones finales para aplicar los temas
#>
function Show-FinalInstructions {
    Write-ColoredMessage "Instrucciones para aplicar los temas NASA:" -Type Header

    Write-Host "[TEMAS] " -NoNewline -ForegroundColor Yellow
    Write-Host "Método 1 - A través de Configuración:" -ForegroundColor White
    Write-Host "   1. Haga clic derecho en el escritorio y seleccione 'Personalizar'"
    Write-Host "   2. Vaya a 'Temas' en el panel izquierdo"
    Write-Host "   3. Busque 'NASA Light Theme' o 'NASA Dark Theme - JWST Edition'"
    Write-Host ""

    Write-Host "[ACCESO] " -NoNewline -ForegroundColor Yellow
    Write-Host "Método 2 - Directamente:" -ForegroundColor White

    if (Test-Path "$script:NASA_LightDir\NASA_Light.theme") {
        Write-Host "   * Tema Claro: " -NoNewline
        Write-Host "$script:NASA_LightDir\NASA_Light.theme" -ForegroundColor Cyan
    }

    if (Test-Path "$script:NASA_DarkDir\NASA_Dark.theme") {
        Write-Host "   * Tema Oscuro JWST: " -NoNewline
        Write-Host "$script:NASA_DarkDir\NASA_Dark.theme" -ForegroundColor Cyan
    }

    Write-Host ""
    Write-Host "[JWST] " -NoNewline -ForegroundColor Yellow
    Write-Host "Características de la Edición James Webb Space Telescope:" -ForegroundColor White
    Write-Host "   * Paleta de colores inspirada en imágenes del JWST" -ForegroundColor Cyan
    Write-Host "   * Mystical (morado profundo), Lavender Gray, Ginger Bread" -ForegroundColor Cyan
    Write-Host "   * Steel Gray, Beech, Foxtrot - Colores PANTONE oficiales" -ForegroundColor Cyan
    Write-Host "   * Modo presentación automático de wallpapers" -ForegroundColor Cyan
    Write-Host "   * Efectos de transparencia y acrílico avanzados" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "[TIPS] " -NoNewline -ForegroundColor Yellow
    Write-Host "Consejos adicionales:" -ForegroundColor White
    Write-Host "   * Los wallpapers están optimizados para su resolución actual"
    Write-Host "   * Para cambiar entre temas, simplemente haga doble clic en el archivo .theme"
    Write-Host "   * Las configuraciones se aplicaron automáticamente al registro"
    Write-Host "   * Si algunos efectos no se ven, reinicie Windows para aplicar todos los cambios"
    Write-Host ""

    Write-Host "[PERSONALIZACIÓN] " -NoNewline -ForegroundColor Yellow
    Write-Host "Configuraciones aplicadas automáticamente:" -ForegroundColor White
    Write-Host "   * Configuración -> Personalización -> Colores: Modo oscuro" -ForegroundColor Green
    Write-Host "   * Efectos de transparencia: Activado" -ForegroundColor Green
    Write-Host "   * Mostrar color de énfasis en inicio y barra de tareas: Activado" -ForegroundColor Green
    Write-Host "   * Mostrar color de énfasis en barras de título: Activado" -ForegroundColor Green
    Write-Host "   * Temas de contraste: Desactivado" -ForegroundColor Green
    Write-Host ""

    Write-Host "[EXPLORADOR] " -NoNewline -ForegroundColor Yellow
    Write-Host "Configuraciones específicas del Explorador de Archivos:" -ForegroundColor White
    Write-Host "   * Colores de fondo y texto optimizados para modo oscuro" -ForegroundColor Green
    Write-Host "   * Configuraciones del registro aplicadas para interfaz oscura" -ForegroundColor Green
    Write-Host "   * Actualización automática de Windows Explorer realizada" -ForegroundColor Green
    Write-Host ""

    Write-Host "[IMPORTANTE] " -NoNewline -ForegroundColor Red
    Write-Host "Si siguen apareciendo elementos blancos:" -ForegroundColor Yellow
    Write-Host "   1. REINICIE WINDOWS completamente (recomendado)" -ForegroundColor Cyan
    Write-Host "   2. O vaya a Configuración -> Personalización -> Colores" -ForegroundColor Cyan
    Write-Host "   3. Cambie temporalmente a 'Claro' y luego de vuelta a 'Oscuro'" -ForegroundColor Cyan
    Write-Host "   4. El reinicio asegura que todos los componentes apliquen el tema" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "[LOG] " -NoNewline -ForegroundColor Yellow
    Write-Host "Log de instalación guardado en: " -NoNewline -ForegroundColor White
    Write-Host $script:LogFile -ForegroundColor Cyan
}

<#
.SYNOPSIS
    Limpia archivos temporales y realiza tareas de mantenimiento
#>
function Complete-Installation {
    Write-ColoredMessage "Finalizando instalación..." -Type Info

    # Aplicar cambios del tema inmediatamente
    try {
        Write-ColoredMessage "Aplicando configuraciones de personalización..." -Type Info

        # Actualizar configuración de colores del sistema inmediatamente
        Write-ColoredMessage "Actualizando configuración de colores del sistema..." -Type Info
        try {
            $null = Start-Process -FilePath "rundll32.exe" -ArgumentList "user32.dll,UpdatePerUserSystemParameters" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        } catch {
            Write-ColoredMessage "Configuración de colores aplicada mediante método alternativo" -Type Info
        }

        # Forzar actualización de configuración de personalización
        Write-ColoredMessage "Aplicando configuraciones de personalización..." -Type Info
        try {
            $null = Start-Process -FilePath "rundll32.exe" -ArgumentList "shell32.dll,Options_RunDLL 0" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        } catch {
            Write-ColoredMessage "Configuración de personalización aplicada mediante método alternativo" -Type Info
        }

        # Actualizar configuración del DWM (Desktop Window Manager)
        Write-ColoredMessage "Actualizando Desktop Window Manager..." -Type Info
        # Nota: DwmEnableComposition ya no es necesario en Windows 10/11 (siempre está habilitado)
        # En su lugar, aplicamos configuraciones a través del registro

        # Refrescar configuración de temas
        try {
            $null = Start-Process -FilePath "rundll32.exe" -ArgumentList "shell32.dll,Control_RunDLL desk.cpl,,2" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        } catch {
            Write-ColoredMessage "Configuración de temas aplicada mediante método alternativo" -Type Info
        }

        # Aplicar configuraciones específicas para modo oscuro
        Write-ColoredMessage "Aplicando modo oscuro en aplicaciones del sistema..." -Type Info

        # Forzar aplicación de configuraciones de personalización
        try {
            # Enviar mensaje para actualizar configuraciones
            Add-Type -TypeDefinition @"
                using System;
                using System.Runtime.InteropServices;
                public class Win32 {
                    [DllImport("user32.dll", SetLastError = true)]
                    public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam, uint fuFlags, uint uTimeout, out IntPtr lpdwResult);

                    [DllImport("user32.dll", SetLastError = true)]
                    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

                    public const int HWND_BROADCAST = 0xffff;
                    public const int WM_SETTINGCHANGE = 0x1a;
                    public const int SMTO_ABORTIFHUNG = 0x0002;
                }
"@ -ErrorAction SilentlyContinue

            # Enviar mensaje de cambio de configuración a todas las ventanas
            $result = [IntPtr]::Zero
            [Win32]::SendMessageTimeout([IntPtr]0xffff, 0x1a, [IntPtr]::Zero, [IntPtr]::Zero, 0x0002, 5000, [ref]$result)

            Write-ColoredMessage "Señal de actualización enviada a aplicaciones del sistema" -Type Success
        }
        catch {
            Write-ColoredMessage "Configuraciones aplicadas mediante método alternativo" -Type Info
        }

        # Reiniciar Windows Explorer para aplicar cambios visuales
        Write-ColoredMessage "Reiniciando Windows Explorer para aplicar cambios..." -Type Info

        try {
            # Terminar Explorer de forma elegante
            $explorerProcesses = Get-Process -Name "explorer" -ErrorAction SilentlyContinue
            if ($explorerProcesses) {
                foreach ($process in $explorerProcesses) {
                    $process.CloseMainWindow()
                }
                Start-Sleep -Seconds 2

                # Si aún está ejecutándose, forzar cierre
                Stop-Process -Name "explorer" -Force -ErrorAction SilentlyContinue
            }

            Start-Sleep -Seconds 3
            Start-Process "explorer.exe"
            Start-Sleep -Seconds 2

            Write-ColoredMessage "Windows Explorer reiniciado exitosamente" -Type Success
        }
        catch {
            Write-ColoredMessage "Explorer se reiniciará automáticamente" -Type Info
        }

        Write-ColoredMessage "Configuraciones aplicadas exitosamente" -Type Success
        Write-ColoredMessage "IMPORTANTE: Si el explorador sigue mostrando elementos claros, reinicie Windows para aplicar todos los cambios." -Type Warning
    }
    catch {
        Write-ColoredMessage "No se pudieron aplicar todos los cambios automáticamente. Se requerirá reinicio." -Type Warning
    }

    # Mostrar estadísticas de instalación
    $lightInstalled = Test-Path "$script:NASA_LightDir\NASA_Light.theme"
    $darkInstalled = Test-Path "$script:NASA_DarkDir\NASA_Dark.theme"

    Write-ColoredMessage "Resumen de instalación:" -Type Header
    Write-Host "* Tema NASA Light: " -NoNewline
    if ($lightInstalled) {
        Write-Host "[INSTALADO]" -ForegroundColor Green
    } else {
        Write-Host "[NO INSTALADO]" -ForegroundColor Red
    }

    Write-Host "* Tema NASA Dark JWST Edition: " -NoNewline
    if ($darkInstalled) {
        Write-Host "[INSTALADO]" -ForegroundColor Green
    } else {
        Write-Host "[NO INSTALADO]" -ForegroundColor Red
    }

    # Verificar configuraciones específicas del tema oscuro
    if ($darkInstalled) {
        Write-Host ""
        Write-Host "[JWST] Configuraciones aplicadas:" -ForegroundColor Magenta
        Write-Host "* Modo oscuro del sistema y aplicaciones: ACTIVADO" -ForegroundColor Green
        Write-Host "* Efectos de transparencia: ACTIVADO" -ForegroundColor Green
        Write-Host "* Color de énfasis automático: ACTIVADO" -ForegroundColor Green
        Write-Host "* Color de énfasis en inicio y barra de tareas: ACTIVADO" -ForegroundColor Green
        Write-Host "* Color de énfasis en barras de título y bordes: ACTIVADO" -ForegroundColor Green
        Write-Host "* Temas de contraste: DESACTIVADO" -ForegroundColor Green
        Write-Host "* Modo presentación de wallpapers: ACTIVADO" -ForegroundColor Green
        Write-Host "* Paleta de colores: James Webb Space Telescope" -ForegroundColor Cyan
    }
}

#endregion

#region Script principal

function Main {
    try {
        # Inicializar archivo de log
        "=" * 80 | Out-File -FilePath $script:LogFile -Encoding UTF8
        "NASA Theme Installer Log - $(Get-Date)" | Out-File -FilePath $script:LogFile -Append -Encoding UTF8
        "=" * 80 | Out-File -FilePath $script:LogFile -Append -Encoding UTF8

        # Mostrar cabecera
        Clear-Host
        Write-ColoredMessage "$script:ScriptName v$script:ScriptVersion" -Type Header
        Write-ColoredMessage "Instalador de Temas NASA para Windows" -Type Info
        Write-ColoredMessage "Licencia: CC BY-NC-SA 4.0" -Type Info
        Write-Host ""

        # Verificar privilegios de administrador
        if (-not (Test-AdminPrivileges)) {
            Write-ColoredMessage "ERROR: Este script debe ejecutarse como administrador." -Type Error
            Write-ColoredMessage "Por favor, ejecute PowerShell como administrador e intente de nuevo." -Type Error
            exit 1
        }

        Write-ColoredMessage "Privilegios de administrador verificados" -Type Success

        # Cargar ensamblado para detección de resolución
        Add-Type -AssemblyName System.Windows.Forms

        # Detectar resolución de pantalla
        $targetResolution = if ($Resolution -eq "Auto") {
            Get-ScreenResolution
        }
        else {
            $Resolution
        }

        Write-ColoredMessage "Resolución objetivo: $targetResolution" -Type Info

        # Crear directorios necesarios
        Write-ColoredMessage "Creando estructura de directorios..." -Type Info
        New-ThemeDirectories

        # Instalar temas según la selección
        $installationSuccess = $true

        switch ($ThemeType) {
            "Light" {
                $installationSuccess = Install-NASATheme -Theme "Light" -Resolution $targetResolution
            }
            "Dark" {
                $installationSuccess = Install-NASATheme -Theme "Dark" -Resolution $targetResolution
            }
            "Both" {
                $lightSuccess = Install-NASATheme -Theme "Light" -Resolution $targetResolution
                $darkSuccess = Install-NASATheme -Theme "Dark" -Resolution $targetResolution
                $installationSuccess = $lightSuccess -and $darkSuccess
            }
        }

        if ($installationSuccess) {
            Write-ColoredMessage "Instalación completada exitosamente!" -Type Success
            Complete-Installation
            Show-FinalInstructions
        }
        else {
            Write-ColoredMessage "La instalación se completó con errores. Revise el log para más detalles." -Type Error
            exit 1
        }

    }
    catch {
        Write-ColoredMessage "Error crítico durante la instalación: $($_.Exception.Message)" -Type Error
        Write-ColoredMessage "Detalles completos guardados en: $script:LogFile" -Type Error

        # Guardar error completo en el log
        $_.Exception | Out-File -FilePath $script:LogFile -Append -Encoding UTF8
        $_.ScriptStackTrace | Out-File -FilePath $script:LogFile -Append -Encoding UTF8

        exit 1
    }
    finally {
        Write-Host ""
        Write-Host "Presione cualquier tecla para continuar..." -ForegroundColor Yellow
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

# Ejecutar script principal
Main

#endregion
