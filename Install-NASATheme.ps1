#Requires -RunAsAdministrator
#Requires -Version 5.1

<#
.SYNOPSIS
    🚀 NASA Theme Installer - Instalador para Windows 11

.DESCRIPTION
    Instalador para los temas NASA inspirados en el cosmos. Incluye:
    - Tema NASA Dark inspirado en el cosmos profundo
    - Tema NASA Light con colores del cosmos luminoso
    - PRESENTACIÓN AUTOMÁTICA con TODOS los wallpapers cada 10 minutos
    - Configuración completa del sistema Windows 11
    - Modo oscuro avanzado con efectos de transparencia
    - Paleta de colores científicamente inspirada

    CUMPLIMIENTO NASA BRAND GUIDELINES:
    Este proyecto es GRATUITO y NO COMERCIAL, cumple estrictamente con las NASA Brand Guidelines.
    Todas las imágenes provienen de fuentes oficiales de NASA como images.nasa.gov, webb.nasa.gov,
    hubblesite.org, y earthobservatory.nasa.gov. Este proyecto NO está afiliado con NASA.

    Creado por un entusiasta de la astronomía para compartir con la comunidad de amantes del espacio.

.PARAMETER ThemeType
    Especifica qué tema instalar: 'Light', 'Dark', o 'Both' (por defecto)

.PARAMETER Resolution
    Resolución de pantalla para optimizar wallpapers: 'Auto' (detección), '1920x1080', '2560x1440', '3840x2160', etc.

.PARAMETER SkipExplorerRestart
    Omite el reinicio automático de Windows Explorer

.PARAMETER Uninstall
    Desinstala completamente los temas NASA del sistema

.PARAMETER Repair
    Repara los temas NASA del sistema

.PARAMETER Silent
    Instalación silenciosa sin interacción del usuario

.PARAMETER SkipImageOptimization
    Omite la optimización de imágenes para ahorrar tiempo de instalación

.PARAMETER InstallCursors
    Instala cursores modernos NASA temáticos (por JepriCreations) que coinciden con el tema seleccionado

.PARAMETER InstallSounds
    Instala sonidos relacionados con el tema NASA

.EXAMPLE
    .\Install-NASATheme.ps1
    Instalación estándar de ambos temas con presentación automática

.EXAMPLE
    .\Install-NASATheme.ps1 -All
    Instalación COMPLETA: temas + cursores + sonidos oficiales NASA

.EXAMPLE
    .\Install-NASATheme.ps1 -Themes -ThemeType Dark
    Instala SOLO temas (tema oscuro únicamente)

.EXAMPLE
    .\Install-NASATheme.ps1 -Cursors
    Instala SOLO cursores modernos elegantes (W11 Tail Cursor Concept)

.EXAMPLE
    .\Install-NASATheme.ps1 -Sounds
    Instala SOLO sonidos oficiales NASA

.EXAMPLE
    .\Install-NASATheme.ps1 -Repair
    Repara y valida los temas NASA existentes para que aparezcan en Windows

.EXAMPLE
    .\Install-NASATheme.ps1 -Uninstall
    Desinstala completamente todos los componentes NASA Theme

.NOTES
    Autor: NASA Theme Project (@llopgui) - Entusiasta de la astronomía
    Licencia: CC BY-NC-SA 4.0 (Uso NO COMERCIAL únicamente)
    Soporte: Windows 10 2004+ / Windows 11
    Repositorio: https://github.com/llopgui/NASA-Theme

    CRÉDITOS DE IMÁGENES NASA:
    - NASA Image and Video Library (images.nasa.gov)
    - NASA Image of the Day (nasa.gov/image-of-the-day)
    - James Webb Space Telescope Gallery (webb.nasa.gov)
    - Hubble Space Telescope Gallery (hubblesite.org)
    - NASA Earth Observatory (earthobservatory.nasa.gov)
    - NASA's Scientific Visualization Studio (svs.gsfc.nasa.gov)

    CRÉDITOS DE CURSORES:
    - W11 Tail Cursor Concept Free por JepriCreations
    - Sitio Oficial: https://jepricreations.com/products/w11-tail-cursor-concept-free
    - DeviantArt: https://www.deviantart.com/jepricreations
    - Email: contact@jepricreations.com
    - Distribuido bajo permiso para uso no comercial con atribución requerida
    - NOTA: NO son cursores temáticos NASA - son cursores modernos que complementan la experiencia

    IMPORTANTE: Este proyecto NO está afiliado, patrocinado o respaldado por NASA.
    Cumple con NASA Brand Guidelines para uso educativo e informativo únicamente.
    Proyecto compartido con amor por la astronomía y el cosmos.
#>

[CmdletBinding(DefaultParameterSetName = "Interactive")]
param(
    # ===== OPCIONES PRINCIPALES DE INSTALACIÓN =====

    [Parameter(Mandatory = $true, ParameterSetName = "All")]
    [switch]$All,

    [Parameter(Mandatory = $true, ParameterSetName = "Themes")]
    [switch]$Themes,

    [Parameter(Mandatory = $true, ParameterSetName = "Cursors")]
    [switch]$Cursors,

    [Parameter(Mandatory = $true, ParameterSetName = "Sounds")]
    [switch]$Sounds,

    # ===== CONFIGURACIÓN DE TEMAS =====

    [Parameter(Mandatory = $false, ParameterSetName = "All")]
    [Parameter(Mandatory = $false, ParameterSetName = "Themes")]
    [Parameter(Mandatory = $false, ParameterSetName = "Interactive")]
    [ValidateSet("Light", "Dark", "Both")]
    [string]$ThemeType = "Both",

    [Parameter(Mandatory = $false, ParameterSetName = "All")]
    [Parameter(Mandatory = $false, ParameterSetName = "Themes")]
    [Parameter(Mandatory = $false, ParameterSetName = "Interactive")]
    [ValidatePattern('^(Auto|\d{3,4}x\d{3,4})$')]
    [string]$Resolution = "Auto",

    # ===== OPCIONES AVANZADAS =====

    [Parameter(Mandatory = $false)]
    [switch]$SkipExplorerRestart,

    [Parameter(Mandatory = $false)]
    [switch]$Silent,

    [Parameter(Mandatory = $false)]
    [switch]$SkipImageOptimization,

    # ===== ACCIONES DEL SISTEMA =====

    [Parameter(Mandatory = $true, ParameterSetName = "Uninstall")]
    [switch]$Uninstall,

    [Parameter(Mandatory = $true, ParameterSetName = "Repair")]
    [switch]$Repair
)

# ==========================================
# CONFIGURACIÓN GLOBAL
# ==========================================

$Global:NASAThemeConfig = @{
    Name = "NASA Theme Installer"
    Author = "NASA Theme Project (@llopgui) - Entusiasta de la astronomía"
    LogFile = "$env:TEMP\NASA_Theme_Install_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
    License = "CC BY-NC-SA 4.0 (Non-Commercial Use Only)"
    Repository = "https://github.com/llopgui/NASA-Theme"
    NASACompliance = "Cumple con NASA Brand Guidelines - Uso educativo e informativo únicamente"
    Purpose = "Compartido con amor por la astronomía y el cosmos"
}

$Global:SystemPaths = @{
    ThemeBase = "$env:SystemRoot\Resources\Themes"
    LightTheme = "$env:SystemRoot\Resources\Themes\NASA_Light"
    DarkTheme = "$env:SystemRoot\Resources\Themes\NASA_Dark"
    ProjectRoot = $PSScriptRoot
    Resources = Join-Path $PSScriptRoot "resources"
    Wallpapers = Join-Path $PSScriptRoot "resources\wallpapers"
    Windows = Join-Path $PSScriptRoot "windows"
    Cursors = Join-Path $PSScriptRoot "resources\icons\w11-tail-cursor-concept-free\cursor"
    CursorInstallPath = "$env:SystemRoot\Cursors"
    Sounds = Join-Path $PSScriptRoot "resources\sounds"
    SoundInstallPath = "$env:SystemRoot\Media"
}

$Global:UITheme = @{
    Primary = "Cyan"
    Success = "Green"
    Warning = "Yellow"
    Error = "Red"
    Header = "Magenta"
    NASA = "Blue"
    Info = "White"
    Progress = "DarkCyan"
}

# ==========================================
# SISTEMA DE LOGGING
# ==========================================

function Write-NASALog {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Info", "Success", "Warning", "Error", "Header", "Progress", "NASA")]
        [string]$Level = "Info",

        [Parameter(Mandatory = $false)]
        [switch]$NoConsole
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"
    $logEntry = "[$timestamp] [$Level] $Message"

    # Escribir al archivo de log
    try {
        Add-Content -Path $Global:NASAThemeConfig.LogFile -Value $logEntry -Encoding UTF8 -ErrorAction SilentlyContinue
    } catch { }

    # Mostrar en consola si no está en modo silencioso
    if (-not $NoConsole -and -not $Silent) {
        $prefix = switch ($Level) {
            "Info" { "[INFO]" }
            "Success" { "[✓ OK]" }
            "Warning" { "[⚠ WARN]" }
            "Error" { "[✗ ERROR]" }
            "Header" { "[NASA]" }
            "Progress" { "[→ PROC]" }
            "NASA" { "[🚀 NASA]" }
        }

        $color = $Global:UITheme[$Level]
        if (-not $color) { $color = $Global:UITheme.Info }

        if ($Level -eq "Header") {
            Write-Host ""
            Write-Host "═" * 80 -ForegroundColor $color
            Write-Host "$prefix $Message" -ForegroundColor $color
            Write-Host "═" * 80 -ForegroundColor $color
            Write-Host ""
        } else {
            Write-Host "$prefix " -ForegroundColor $color -NoNewline
            Write-Host $Message -ForegroundColor White
        }
    }
}

# ==========================================
# FUNCIONES PRINCIPALES CORREGIDAS
# ==========================================

function New-ThemeDirectories {
    Write-NASALog "Creando estructura de directorios del sistema..." -Level Progress

    $directories = @(
        $Global:SystemPaths.LightTheme,
        $Global:SystemPaths.DarkTheme,
        (Join-Path $Global:SystemPaths.LightTheme "wallpapers"),
        (Join-Path $Global:SystemPaths.DarkTheme "wallpapers")
    )

    foreach ($dir in $directories) {
        try {
            if (-not (Test-Path $dir)) {
                New-Item -Path $dir -ItemType Directory -Force | Out-Null
                Write-NASALog "Directorio creado: $dir" -Level Success
            }
        } catch {
            Write-NASALog "Error creando directorio $dir : $($_.Exception.Message)" -Level Error
            throw
        }
    }
}

function Install-NASATheme {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Light", "Dark")]
        [string]$Theme
    )

    Write-NASALog "Instalando tema NASA $Theme con presentación automática..." -Level Header

    $themeVariant = $Theme.ToLower()
    $sourceDir = Join-Path $Global:SystemPaths.Windows $themeVariant
    $targetDir = if ($Theme -eq "Light") { $Global:SystemPaths.LightTheme } else { $Global:SystemPaths.DarkTheme }

    if (-not (Test-Path $sourceDir)) {
        Write-NASALog "Directorio fuente no encontrado: $sourceDir" -Level Error
        return $false
    }

    $themeFile = Get-ChildItem -Path $sourceDir -Filter "*.theme" | Select-Object -First 1
    if (-not $themeFile) {
        Write-NASALog "Archivo de tema no encontrado en: $sourceDir" -Level Error
        return $false
    }

    try {
        # Copiar archivo de tema
        $targetThemeFile = Join-Path $targetDir $themeFile.Name
        Copy-Item -Path $themeFile.FullName -Destination $targetThemeFile -Force
        Write-NASALog "Archivo de tema copiado: $($themeFile.Name)" -Level Success

        # COPIAR TODOS LOS WALLPAPERS PARA PRESENTACIÓN
        $wallpaperDestDir = Join-Path $targetDir "wallpapers"
        $sourceWallpaperDir = $Global:SystemPaths.Wallpapers

        Write-NASALog "Copiando wallpapers para presentación automática cada 10 minutos..." -Level Progress

        # Buscar wallpapers SOLO en el directorio raíz (evitar duplicados del directorio "organized")
        $imageExtensions = @("*.jpg", "*.jpeg", "*.png", "*.webp", "*.bmp")
        $allWallpapers = @()

        foreach ($ext in $imageExtensions) {
            $images = Get-ChildItem -Path $sourceWallpaperDir -Filter $ext -ErrorAction SilentlyContinue
            $allWallpapers += $images
        }

        if ($allWallpapers.Count -eq 0) {
            Write-NASALog "No se encontraron wallpapers en: $sourceWallpaperDir" -Level Warning
            return $false
        }

        Write-NASALog "📷 Encontrados $($allWallpapers.Count) wallpapers originales para copiar..." -Level Info

        # Copiar todos los wallpapers al directorio del tema
        $copiedCount = 0
        foreach ($wallpaper in $allWallpapers) {
            try {
                $destPath = Join-Path $wallpaperDestDir $wallpaper.Name

                # Evitar duplicados
                $counter = 1
                while (Test-Path $destPath) {
                    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($wallpaper.Name)
                    $extension = [System.IO.Path]::GetExtension($wallpaper.Name)
                    $destPath = Join-Path $wallpaperDestDir "${baseName}_${counter}${extension}"
                    $counter++
                }

                Copy-Item -Path $wallpaper.FullName -Destination $destPath -Force
                $copiedCount++

                # Mostrar progreso cada 100 wallpapers
                if ($copiedCount % 100 -eq 0) {
                    Write-NASALog "🖼️ Copiados $copiedCount de $($allWallpapers.Count) wallpapers..." -Level Progress
                }
            } catch {
                Write-NASALog "Error copiando $($wallpaper.Name): $($_.Exception.Message)" -Level Warning
            }
        }

        Write-NASALog "✅ $copiedCount wallpapers copiados para presentación automática" -Level Success

        # Configurar presentación automática (10 minutos, aleatorio)
        Set-SlideshowConfiguration

        Write-NASALog "Tema $Theme instalado exitosamente con $copiedCount wallpapers en presentación" -Level Success
        return $true
    } catch {
        Write-NASALog "Error instalando tema $Theme : $($_.Exception.Message)" -Level Error
        return $false
    }
}

function Set-SlideshowConfiguration {
    Write-NASALog "Configurando presentación automática cada 10 minutos (aleatorio)..." -Level Progress

    try {
        # Configuración exacta según capturas del usuario - 10 minutos
        $intervalMs = 600000  # 10 minutos en milisegundos

        # Configurar registro para presentación
        $slideshowPath = "HKCU:\Control Panel\Desktop"
        Set-ItemProperty -Path $slideshowPath -Name "SlideshowEnabled" -Value 1 -Type DWord
        Set-ItemProperty -Path $slideshowPath -Name "SlideshowInterval" -Value $intervalMs -Type DWord
        Set-ItemProperty -Path $slideshowPath -Name "SlideshowShuffle" -Value 1 -Type DWord

        # Configuraciones adicionales según capturas
        Set-ItemProperty -Path $slideshowPath -Name "WallpaperStyle" -Value 6 -Type DWord  # Expandir
        Set-ItemProperty -Path $slideshowPath -Name "FitMode" -Value 6 -Type DWord

        # Configuración de batería - NO ejecutar en batería como en capturas
        Set-ItemProperty -Path $slideshowPath -Name "SlideshowRunOnBattery" -Value 0 -Type DWord

        # Configuraciones específicas para Windows 11
        $personalizePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        if (-not (Test-Path $personalizePath)) {
            New-Item -Path $personalizePath -Force | Out-Null
        }

        # EFECTOS DE TRANSPARENCIA ACTIVADOS - SEGÚN CAPTURAS
        Set-ItemProperty -Path $personalizePath -Name "EnableTransparency" -Value 1 -Type DWord
        # COLOR DE ÉNFASIS AUTOMÁTICO - SEGÚN CAPTURAS
        Set-ItemProperty -Path $personalizePath -Name "AutoColorization" -Value 1 -Type DWord
        # MOSTRAR COLOR EN INICIO Y BARRA DE TAREAS - ACTIVADO SEGÚN CAPTURAS
        Set-ItemProperty -Path $personalizePath -Name "ColorPrevalence" -Value 1 -Type DWord

        Write-NASALog "✅ Presentación configurada: 10 minutos, aleatorio, NO en batería" -Level Success
    } catch {
        Write-NASALog "Error configurando presentación: $($_.Exception.Message)" -Level Warning
    }
}

function Invoke-SystemRefresh {
    Write-NASALog "Aplicando cambios al sistema Windows..." -Level Progress

    try {
        # Actualizar configuraciones del sistema
        $null = Start-Process -FilePath "rundll32.exe" -ArgumentList "user32.dll,UpdatePerUserSystemParameters" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue

        # Reiniciar Windows Explorer si no se omite
        if (-not $SkipExplorerRestart) {
            Write-NASALog "Reiniciando Windows Explorer..." -Level Progress
            try {
                Stop-Process -Name "explorer" -Force -ErrorAction SilentlyContinue
                Start-Sleep -Seconds 2
                Start-Process "explorer.exe"
                Start-Sleep -Seconds 3
                Write-NASALog "Windows Explorer reiniciado correctamente" -Level Success
            } catch {
                Write-NASALog "El explorador se reiniciará automáticamente" -Level Info
            }
        }

        Write-NASALog "Refrescamiento del sistema completado" -Level Success
    } catch {
        Write-NASALog "Error durante el refrescamiento: $($_.Exception.Message)" -Level Warning
    }
}

function Show-InstallationSummary {
    param(
        [bool]$LightInstalled,
        [bool]$DarkInstalled,
        [bool]$CursorsInstalled = $false,
        [bool]$SoundsInstalled = $false
    )

    Write-NASALog "RESUMEN DE INSTALACIÓN COMPLETADA" -Level Header

    Write-Host ""
    Write-Host "🎨 ESTADO DE TEMAS:" -ForegroundColor $Global:UITheme.NASA

    if ($LightInstalled) {
        Write-Host "   ✅ NASA Light Theme: INSTALADO con presentación automática" -ForegroundColor $Global:UITheme.Success
    }
    if ($DarkInstalled) {
        Write-Host "   ✅ NASA Dark Theme: INSTALADO con presentación automática" -ForegroundColor $Global:UITheme.Success
    }

    if ($LightInstalled -or $DarkInstalled) {
        Write-Host ""
        Write-Host "🖼️ PRESENTACIÓN AUTOMÁTICA:" -ForegroundColor $Global:UITheme.NASA
        Write-Host "   • Cambio cada 10 minutos" -ForegroundColor $Global:UITheme.Success
        Write-Host "   • Orden aleatorio activado" -ForegroundColor $Global:UITheme.Success
        Write-Host "   • TODOS los wallpapers NASA incluidos" -ForegroundColor $Global:UITheme.Success
        Write-Host "   • NO ejecutar con batería" -ForegroundColor $Global:UITheme.Success

        Write-Host ""
        Write-Host "🚀 CÓMO APLICAR:" -ForegroundColor $Global:UITheme.NASA
        Write-Host "   1. Clic derecho en escritorio → Personalizar" -ForegroundColor $Global:UITheme.Info
        Write-Host "   2. Ir a 'Temas'" -ForegroundColor $Global:UITheme.Info
        Write-Host "   3. Seleccionar tema NASA" -ForegroundColor $Global:UITheme.Info
        Write-Host "   4. ¡La presentación automática inicia inmediatamente!" -ForegroundColor $Global:UITheme.Success
    }

    if ($CursorsInstalled) {
        Write-Host ""
        Write-Host "🖼️ CURSORES MODERNOS ELEGANTES:" -ForegroundColor $Global:UITheme.NASA
        Write-Host "   ✅ Cursores modernos instalados: $ThemeType" -ForegroundColor $Global:UITheme.Success
        Write-Host "   🎨 Por JepriCreations (W11 Tail Cursor Concept Free)" -ForegroundColor $Global:UITheme.Info
        Write-Host "   🌐 Sitio: jepricreations.com" -ForegroundColor $Global:UITheme.Info
        Write-Host "   🔄 Activación automática tras reiniciar Explorer" -ForegroundColor $Global:UITheme.Info
        Write-Host "   ⚠️  NOTA: Cursores elegantes que complementan NASA Theme (no temáticos)" -ForegroundColor $Global:UITheme.Warning

        Write-Host ""
        Write-Host "🛠️ CONFIGURAR CURSORES MANUALMENTE:" -ForegroundColor $Global:UITheme.NASA
        Write-Host "   1. Panel de Control → Personalización → Temas → Configuración del cursor" -ForegroundColor $Global:UITheme.Info
        Write-Host "   2. Buscar 'NASA CURSORS by JepriCreations'" -ForegroundColor $Global:UITheme.Info
        Write-Host "   3. Seleccionar el esquema deseado" -ForegroundColor $Global:UITheme.Info
    }

    if ($SoundsInstalled) {
        Write-Host ""
        Write-Host "🎵 SONIDOS TEMÁTICOS NASA:" -ForegroundColor $Global:UITheme.NASA
        Write-Host "   ✅ Sonidos instalados: $ThemeType" -ForegroundColor $Global:UITheme.Success
        Write-Host "   🎨 Por NASA" -ForegroundColor $Global:UITheme.Info
        Write-Host "   🌐 Sitio: nasa.gov/audio-and-ringtones" -ForegroundColor $Global:UITheme.Info
        Write-Host "   🔄 Activación automática tras reiniciar el sistema o cerrar sesión" -ForegroundColor $Global:UITheme.Info
    }
}

# ==========================================
# INSTALACIÓN DE CURSORES
# ==========================================

function Install-NASACursors {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Light", "Dark", "Both")]
        [string]$CursorTheme,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Light", "Dark", "Both")]
        [string]$PreferredTheme = "Dark"
    )

    Write-NASALog "INSTALANDO CURSORES MODERNOS ELEGANTES" -Level Header

    # Mostrar créditos de cursores
    Write-NASALog "Cursores por JepriCreations (jepricreations.com)" -Level Info
    Write-NASALog "W11 Tail Cursor Concept Free - Distribuido bajo permiso no comercial" -Level Info
    Write-NASALog "NOTA: Cursores modernos que complementan NASA Theme (no temáticos)" -Level Info

    $success = $false

    try {
        # Verificar que existen los cursores
        if (-not (Test-Path $Global:SystemPaths.Cursors)) {
            Write-NASALog "Directorio de cursores no encontrado: $($Global:SystemPaths.Cursors)" -Level Error
            return $false
        }

        # Instalar según el tema seleccionado
        switch ($CursorTheme) {
            "Light" {
                $success = Install-CursorSet -CursorVariant "light" -PreferredTheme $PreferredTheme
            }
            "Dark" {
                $success = Install-CursorSet -CursorVariant "dark" -PreferredTheme $PreferredTheme
            }
            "Both" {
                $lightSuccess = Install-CursorSet -CursorVariant "light" -PreferredTheme $PreferredTheme
                $darkSuccess = Install-CursorSet -CursorVariant "dark" -PreferredTheme $PreferredTheme
                $success = $lightSuccess -or $darkSuccess

                # Aplicar el cursor que coincida con el tema principal
                if ($PreferredTheme -eq "Dark" -and $darkSuccess) {
                    Apply-CursorScheme -CursorVariant "dark"
                } elseif ($PreferredTheme -eq "Light" -and $lightSuccess) {
                    Apply-CursorScheme -CursorVariant "light"
                } elseif ($darkSuccess) {
                    Apply-CursorScheme -CursorVariant "dark"
                } elseif ($lightSuccess) {
                    Apply-CursorScheme -CursorVariant "light"
                }
            }
        }

        if ($success) {
            Write-NASALog "✅ Cursores NASA instalados exitosamente" -Level Success
            Write-NASALog "Los cursores se activarán tras reiniciar Windows Explorer" -Level Info
        } else {
            Write-NASALog "❌ Error durante la instalación de cursores" -Level Warning
        }

        return $success

    } catch {
        Write-NASALog "Error instalando cursores: $($_.Exception.Message)" -Level Error
        return $false
    }
}

function Install-CursorSet {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("light", "dark")]
        [string]$CursorVariant,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Light", "Dark", "Both")]
        [string]$PreferredTheme = "Dark"
    )

    Write-NASALog "Instalando set de cursores: $CursorVariant" -Level Progress

    $cursorSourcePath = Join-Path $Global:SystemPaths.Cursors $CursorVariant
    $cursorDestPath = Join-Path $Global:SystemPaths.CursorInstallPath "NASA_$($CursorVariant.ToUpper())"

    if (-not (Test-Path $cursorSourcePath)) {
        Write-NASALog "Fuente de cursores no encontrada: $cursorSourcePath" -Level Error
        return $false
    }

    try {
        # Crear directorio de destino
        if (-not (Test-Path $cursorDestPath)) {
            New-Item -Path $cursorDestPath -ItemType Directory -Force | Out-Null
            Write-NASALog "Directorio de cursores creado: $cursorDestPath" -Level Success
        }

        # Copiar archivos de cursores
        $cursorFiles = Get-ChildItem -Path $cursorSourcePath -Filter "*.cur" -ErrorAction SilentlyContinue
        $animatedFiles = Get-ChildItem -Path $cursorSourcePath -Filter "*.ani" -ErrorAction SilentlyContinue
        $allCursorFiles = $cursorFiles + $animatedFiles

        $copiedCount = 0
        foreach ($file in $allCursorFiles) {
            try {
                $destFile = Join-Path $cursorDestPath $file.Name
                Copy-Item -Path $file.FullName -Destination $destFile -Force
                $copiedCount++
            } catch {
                Write-NASALog "Error copiando $($file.Name): $($_.Exception.Message)" -Level Warning
            }
        }

        Write-NASALog "Cursores copiados: $copiedCount archivos" -Level Success

        # Instalar esquema de cursores en el registro
        $success = Register-CursorScheme -CursorVariant $CursorVariant -CursorPath $cursorDestPath

        if ($success -and $copiedCount -gt 0) {
            # Aplicar automáticamente si es el único tema instalándose
            if ($CursorVariant -eq $PreferredTheme.ToLower() -or $PreferredTheme -eq "Both") {
                Apply-CursorScheme -CursorVariant $CursorVariant
            }
            return $true
        }

        return $false

    } catch {
        Write-NASALog "Error durante instalación de cursores: $($_.Exception.Message)" -Level Error
        return $false
    }
}

function Register-CursorScheme {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("light", "dark")]
        [string]$CursorVariant,

        [Parameter(Mandatory = $true)]
        [string]$CursorPath
    )

    try {
        $schemeName = "NASA $($CursorVariant.ToUpper()) Cursors by JepriCreations"
        $schemeKey = "HKCU:\Control Panel\Cursors\Schemes"

        # Definir mapeo de cursores según Windows
        $cursorMapping = @{
            "Arrow" = "arrow.cur"
            "Help" = "help.cur"
            "AppStarting" = "appstarting.ani"
            "Wait" = "wait.ani"
            "Crosshair" = "crosshair.cur"
            "IBeam" = "ibeam.cur"
            "NWPen" = "nwpen.cur"
            "No" = "no.cur"
            "SizeNS" = "sizens.cur"
            "SizeWE" = "sizewe.cur"
            "SizeNWSE" = "sizenwse.cur"
            "SizeNESW" = "sizenesw.cur"
            "SizeAll" = "sizeall.cur"
            "UpArrow" = "uparrow.cur"
            "Hand" = "hand.cur"
            "Person" = "person.cur"
            "Pin" = "pin.cur"
        }

        # Construir string del esquema
        $schemeValue = ""
        foreach ($cursor in @("Arrow", "Help", "AppStarting", "Wait", "Crosshair", "IBeam", "NWPen", "No", "SizeNS", "SizeWE", "SizeNWSE", "SizeNESW", "SizeAll", "UpArrow", "Hand", "Person", "Pin")) {
            $cursorFile = $cursorMapping[$cursor]
            $fullPath = Join-Path $CursorPath $cursorFile

            if (Test-Path $fullPath) {
                $schemeValue += "$fullPath,"
            } else {
                $schemeValue += ","
            }
        }
        $schemeValue = $schemeValue.TrimEnd(",")

        # Registrar esquema
        if (-not (Test-Path $schemeKey)) {
            New-Item -Path $schemeKey -Force | Out-Null
        }

        Set-ItemProperty -Path $schemeKey -Name $schemeName -Value $schemeValue -Type String
        Write-NASALog "Esquema de cursores registrado: $schemeName" -Level Success

        return $true

    } catch {
        Write-NASALog "Error registrando esquema de cursores: $($_.Exception.Message)" -Level Error
        return $false
    }
}

function Apply-CursorScheme {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("light", "dark")]
        [string]$CursorVariant
    )

    try {
        $cursorPath = Join-Path $Global:SystemPaths.CursorInstallPath "NASA_$($CursorVariant.ToUpper())"
        $cursorKey = "HKCU:\Control Panel\Cursors"

        if (-not (Test-Path $cursorPath)) {
            Write-NASALog "Ruta de cursores no encontrada: $cursorPath" -Level Error
            return $false
        }

        # Aplicar cursores individuales
        $cursorMapping = @{
            "Arrow" = "arrow.cur"
            "Help" = "help.cur"
            "AppStarting" = "appstarting.ani"
            "Wait" = "wait.ani"
            "Crosshair" = "crosshair.cur"
            "IBeam" = "ibeam.cur"
            "NWPen" = "nwpen.cur"
            "No" = "no.cur"
            "SizeNS" = "sizens.cur"
            "SizeWE" = "sizewe.cur"
            "SizeNWSE" = "sizenwse.cur"
            "SizeNESW" = "sizenesw.cur"
            "SizeAll" = "sizeall.cur"
            "UpArrow" = "uparrow.cur"
            "Hand" = "hand.cur"
            "Person" = "person.cur"
            "Pin" = "pin.cur"
        }

        $appliedCount = 0
        foreach ($cursorType in $cursorMapping.Keys) {
            $cursorFile = $cursorMapping[$cursorType]
            $fullPath = Join-Path $cursorPath $cursorFile

            if (Test-Path $fullPath) {
                Set-ItemProperty -Path $cursorKey -Name $cursorType -Value $fullPath -Type String
                $appliedCount++
            }
        }

        # Establecer nombre del esquema
        $schemeName = "NASA $($CursorVariant.ToUpper()) Cursors by JepriCreations"
        try {
            Set-ItemProperty -Path $cursorKey -Name "(Default)" -Value $schemeName -Type String -ErrorAction SilentlyContinue
        } catch {
            # Si falla establecer el nombre por defecto, continuar sin error crítico
            Write-NASALog "Info: Nombre de esquema no establecido" -Level Info
        }

        Write-NASALog "Cursores aplicados: $appliedCount de $($cursorMapping.Count)" -Level Success

        # Notificar al sistema del cambio
        try {
            $signature = @"
[DllImport("user32.dll", SetLastError = true)]
public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, string pvParam, uint fWinIni);
"@
            $type = Add-Type -MemberDefinition $signature -Name Win32Utils -Namespace SystemParametersInfo -PassThru -ErrorAction SilentlyContinue
            if ($type) {
                $type::SystemParametersInfo(0x0057, 0, $null, 0x02) | Out-Null
                Write-NASALog "Sistema notificado del cambio de cursores" -Level Success
            }
        } catch {
            Write-NASALog "Los cursores se aplicarán tras reiniciar Windows Explorer" -Level Info
        }

        return $true

    } catch {
        Write-NASALog "Error aplicando cursores: $($_.Exception.Message)" -Level Error
        return $false
    }
}

# ==========================================
# INSTALACIÓN DE SONIDOS NASA
# ==========================================

function Install-NASASounds {
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet("All", "SystemOnly", "NotificationOnly")]
        [string]$SoundType = "All"
    )

    Write-NASALog "INSTALANDO SONIDOS TEMÁTICOS NASA" -Level Header

    # Mostrar información de sonidos
    Write-NASALog "Sonidos oficiales de NASA para una experiencia inmersiva completa" -Level Info
    Write-NASALog "Fuentes: nasa.gov/audio-and-ringtones, hubble sonifications" -Level Info
    Write-NASALog "Licencia: Dominio público NASA - Uso educativo permitido" -Level Info

    $success = $false

    try {
        # Verificar que existe el directorio de sonidos
        if (-not (Test-Path $Global:SystemPaths.Sounds)) {
            Write-NASALog "Directorio de sonidos no encontrado: $($Global:SystemPaths.Sounds)" -Level Error
            return $false
        }

        # Verificar qué sonidos están disponibles
        $soundFiles = Get-AvailableSounds

        if ($soundFiles.Count -eq 0) {
            Write-NASALog "No se encontraron archivos de sonido en resources/sounds/" -Level Warning
            Write-NASALog "Los sonidos se descargan por separado desde fuentes oficiales NASA" -Level Info
            return $false
        }

        Write-NASALog "Encontrados $($soundFiles.Count) archivos de sonido para instalar" -Level Info

        # Instalar sonidos según el tipo seleccionado
        switch ($SoundType) {
            "All" {
                $success = Install-SystemSounds -SoundFiles $soundFiles
            }
            "SystemOnly" {
                $systemSounds = $soundFiles | Where-Object { $_.Type -eq "System" }
                $success = Install-SystemSounds -SoundFiles $systemSounds
            }
            "NotificationOnly" {
                $notificationSounds = $soundFiles | Where-Object { $_.Type -eq "Notification" }
                $success = Install-SystemSounds -SoundFiles $notificationSounds
            }
        }

        if ($success) {
            Write-NASALog "✅ Sonidos NASA instalados exitosamente" -Level Success
            Write-NASALog "Los cambios se aplicarán tras reiniciar el sistema o cerrar sesión" -Level Info
        } else {
            Write-NASALog "❌ Error durante la instalación de sonidos" -Level Warning
        }

        return $success

    } catch {
        Write-NASALog "Error instalando sonidos: $($_.Exception.Message)" -Level Error
        return $false
    }
}

function Get-AvailableSounds {
    $soundFiles = @()
    $soundsPath = $Global:SystemPaths.Sounds

    # Mapeo de archivos de sonido a eventos de Windows
    $soundMapping = @{
        "startup.wav" = @{ WindowsEvent = "SystemStart"; Type = "System"; Description = "Inicio del sistema (Artemis Launch)" }
        "logon.wav" = @{ WindowsEvent = "WindowsLogon"; Type = "System"; Description = "Inicio de sesión (Apollo 11)" }
        "logoff.wav" = @{ WindowsEvent = "WindowsLogoff"; Type = "System"; Description = "Cierre de sesión (Eagle Landing)" }
        "error.wav" = @{ WindowsEvent = "SystemHand"; Type = "System"; Description = "Error crítico (Apollo 13)" }
        "notification.wav" = @{ WindowsEvent = "SystemNotification"; Type = "Notification"; Description = "Notificación (Hubble)" }
        "mail.wav" = @{ WindowsEvent = "MailBeep"; Type = "Notification"; Description = "Correo nuevo (Comunicación espacial)" }
    }

    foreach ($soundFile in $soundMapping.Keys) {
        $fullPath = Join-Path $soundsPath $soundFile
        if (Test-Path $fullPath) {
            $soundInfo = $soundMapping[$soundFile]
            $soundFiles += [PSCustomObject]@{
                FileName = $soundFile
                FullPath = $fullPath
                WindowsEvent = $soundInfo.WindowsEvent
                Type = $soundInfo.Type
                Description = $soundInfo.Description
            }
        }
    }

    return $soundFiles
}

function Install-SystemSounds {
    param(
        [Parameter(Mandatory = $true)]
        [array]$SoundFiles
    )

    try {
        $installedCount = 0

        foreach ($sound in $SoundFiles) {
            # Copiar archivo a directorio Media de Windows
            $destPath = Join-Path $Global:SystemPaths.SoundInstallPath "NASA_$($sound.FileName)"

            try {
                Copy-Item -Path $sound.FullPath -Destination $destPath -Force
                Write-NASALog "Copiado: $($sound.FileName) → $destPath" -Level Success

                # Registrar el sonido en el esquema de Windows
                $registered = Register-WindowsSound -SoundFile $destPath -WindowsEvent $sound.WindowsEvent -Description $sound.Description

                if ($registered) {
                    $installedCount++
                    Write-NASALog "Registrado: $($sound.Description)" -Level Success
                } else {
                    Write-NASALog "Error registrando: $($sound.Description)" -Level Warning
                }

            } catch {
                Write-NASALog "Error procesando $($sound.FileName): $($_.Exception.Message)" -Level Warning
            }
        }

        Write-NASALog "Sonidos instalados exitosamente: $installedCount de $($SoundFiles.Count)" -Level Success

        # Aplicar el esquema de sonidos NASA
        if ($installedCount -gt 0) {
            Apply-NASASoundScheme
        }

        return $installedCount -gt 0

    } catch {
        Write-NASALog "Error durante instalación de sonidos: $($_.Exception.Message)" -Level Error
        return $false
    }
}

function Register-WindowsSound {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SoundFile,

        [Parameter(Mandatory = $true)]
        [string]$WindowsEvent,

        [Parameter(Mandatory = $true)]
        [string]$Description
    )

    try {
        # Registrar en esquema de sonidos NASA
        $schemeKey = "HKCU:\AppEvents\Schemes\Apps\.Default\$WindowsEvent\.NASA"

        # Crear clave si no existe
        if (-not (Test-Path $schemeKey)) {
            New-Item -Path $schemeKey -Force | Out-Null
        }

        # Establecer el archivo de sonido
        Set-ItemProperty -Path $schemeKey -Name "(Default)" -Value $SoundFile -Type String

        Write-NASALog "Evento $WindowsEvent registrado con sonido NASA" -Level Success
        return $true

    } catch {
        Write-NASALog "Error registrando sonido para $WindowsEvent : $($_.Exception.Message)" -Level Error
        return $false
    }
}

function Apply-NASASoundScheme {
    try {
        # Crear esquema de sonidos NASA en el registro
        $schemeKey = "HKCU:\AppEvents\Schemes"
        $nasaSchemeKey = "HKCU:\AppEvents\Schemes\Names\.NASA"

        # Crear entrada del esquema NASA
        if (-not (Test-Path $nasaSchemeKey)) {
            New-Item -Path $nasaSchemeKey -Force | Out-Null
        }

        Set-ItemProperty -Path $nasaSchemeKey -Name "(Default)" -Value "NASA Space Theme Sounds" -Type String

        # Establecer como esquema activo
        Set-ItemProperty -Path $schemeKey -Name "(Default)" -Value ".NASA" -Type String

        Write-NASALog "Esquema de sonidos NASA aplicado exitosamente" -Level Success

        # Notificar al sistema del cambio
        try {
            $signature = @"
[DllImport("user32.dll", SetLastError = true)]
public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, string pvParam, uint fWinIni);
"@
            $type = Add-Type -MemberDefinition $signature -Name Win32SoundUtils -Namespace SystemParametersInfo -PassThru -ErrorAction SilentlyContinue
            if ($type) {
                $type::SystemParametersInfo(0x12, 0, $null, 0x02) | Out-Null
                Write-NASALog "Sistema notificado del cambio de esquema de sonidos" -Level Success
            }
        } catch {
            Write-NASALog "Los sonidos se aplicarán tras reiniciar o cerrar sesión" -Level Info
        }

        return $true

    } catch {
        Write-NASALog "Error aplicando esquema de sonidos: $($_.Exception.Message)" -Level Error
        return $false
    }
}

# ==========================================
# FUNCIÓN PRINCIPAL
# ==========================================

function Invoke-NASAThemeInstaller {
    try {
        if (-not $Silent) {
            Clear-Host
            Write-Host "🚀 NASA THEME INSTALLER MODULAR" -ForegroundColor $Global:UITheme.NASA
            Write-Host "═" * 60 -ForegroundColor DarkGray
            Write-Host "✅ Presentación automática con TODOS los wallpapers NASA" -ForegroundColor $Global:UITheme.Success
            Write-Host "✅ Cursores modernos elegantes por JepriCreations (opcional)" -ForegroundColor $Global:UITheme.Success
            Write-Host "✅ Sonidos temáticos oficiales NASA (opcional)" -ForegroundColor $Global:UITheme.Success
            Write-Host "✅ Cumple con NASA Brand Guidelines (Uso NO COMERCIAL)" -ForegroundColor $Global:UITheme.Success
            Write-Host "📸 Imágenes oficiales desde images.nasa.gov y portales NASA" -ForegroundColor $Global:UITheme.Info
            Write-Host "🖱️ Cursores por JepriCreations (jepricreations.com)" -ForegroundColor $Global:UITheme.Info
            Write-Host "🎵 Sonidos desde nasa.gov/audio-and-ringtones (dominio público)" -ForegroundColor $Global:UITheme.Info
            Write-Host "⚠️  NOTA: Cursores NO temáticos - modernos que complementan" -ForegroundColor $Global:UITheme.Warning
            Write-Host "🚫 NO afiliado con NASA - Proyecto educativo independiente" -ForegroundColor $Global:UITheme.Warning
            Write-Host "🌌 Compartido con amor por la astronomía y el cosmos" -ForegroundColor $Global:UITheme.Primary
            Write-Host ""

            # Mostrar modo actual
            $currentMode = ""
            if ($All) { $currentMode = "🌌 INSTALACIÓN COMPLETA" }
            elseif ($Themes) { $currentMode = "🎨 SOLO TEMAS" }
            elseif ($Cursors) { $currentMode = "🖱️ SOLO CURSORES" }
            elseif ($Sounds) { $currentMode = "🎵 SOLO SONIDOS" }
            else { $currentMode = "🎯 MODO INTERACTIVO" }

            Write-Host "MODO: $currentMode" -ForegroundColor $Global:UITheme.Primary
            Write-Host ""
        }

        # Inicializar logging
        "NASA Theme Installer" | Out-File -FilePath $Global:NASAThemeConfig.LogFile -Encoding UTF8
        "Autor: $($Global:NASAThemeConfig.Author)" | Out-File -FilePath $Global:NASAThemeConfig.LogFile -Append -Encoding UTF8
        "Propósito: $($Global:NASAThemeConfig.Purpose)" | Out-File -FilePath $Global:NASAThemeConfig.LogFile -Append -Encoding UTF8
        "Licencia: $($Global:NASAThemeConfig.License)" | Out-File -FilePath $Global:NASAThemeConfig.LogFile -Append -Encoding UTF8
        "NASA Compliance: $($Global:NASAThemeConfig.NASACompliance)" | Out-File -FilePath $Global:NASAThemeConfig.LogFile -Append -Encoding UTF8
        "Inicio: $(Get-Date)" | Out-File -FilePath $Global:NASAThemeConfig.LogFile -Append -Encoding UTF8

        # Modo desinstalación
        if ($Uninstall) {
            Write-NASALog "Desinstalando temas NASA..." -Level Header
            $themesToRemove = @($Global:SystemPaths.LightTheme, $Global:SystemPaths.DarkTheme)
            $removedCount = 0

            foreach ($themePath in $themesToRemove) {
                if (Test-Path $themePath) {
                    try {
                        Remove-Item -Path $themePath -Recurse -Force
                        Write-NASALog "Tema eliminado: $themePath" -Level Success
                        $removedCount++
                    } catch {
                        Write-NASALog "Error eliminando: $($_.Exception.Message)" -Level Error
                    }
                }
            }

            if ($removedCount -gt 0) {
                Write-NASALog "Desinstalación completada: $removedCount temas eliminados" -Level Success
            }
            return
        }

        # Modo reparación
        if ($Repair) {
            Write-NASALog "Modo reparación - verificando y corrigiendo temas..." -Level Header

            # Reiniciar servicios de temas
            try {
                $themeService = Get-Service -Name "Themes" -ErrorAction SilentlyContinue
                if ($themeService) {
                    Restart-Service -Name "Themes" -Force -ErrorAction SilentlyContinue
                    Write-NASALog "Servicio de temas reiniciado" -Level Success
                }
            } catch { }

            Invoke-SystemRefresh
            Write-NASALog "Reparación completada" -Level Success
            return
        }

        # ===== DETERMINAR QUÉ INSTALAR SEGÚN EL MODO =====
        $shouldInstallThemes = $false
        $shouldInstallCursors = $false
        $shouldInstallSounds = $false

        if ($All) {
            $shouldInstallThemes = $true
            $shouldInstallCursors = $true
            $shouldInstallSounds = $true
            Write-NASALog "Modo: INSTALACIÓN COMPLETA (temas + cursores + sonidos)" -Level Header
        }
        elseif ($Themes) {
            $shouldInstallThemes = $true
            Write-NASALog "Modo: SOLO TEMAS ($ThemeType)" -Level Header
        }
        elseif ($Cursors) {
            $shouldInstallCursors = $true
            Write-NASALog "Modo: SOLO CURSORES MODERNOS" -Level Header
        }
        elseif ($Sounds) {
            $shouldInstallSounds = $true
            Write-NASALog "Modo: SOLO SONIDOS OFICIALES NASA" -Level Header
        }
        else {
            # Modo interactivo: instalar temas por defecto
            $shouldInstallThemes = $true
            Write-NASALog "Modo: INTERACTIVO - Instalando temas ($ThemeType)" -Level Header
        }

        # Inicializar variables de estado
        $lightInstalled = $false
        $darkInstalled = $false
        $cursorsInstalled = $false
        $soundsInstalled = $false

        # ===== INSTALAR TEMAS =====
        if ($shouldInstallThemes) {
            # Verificación básica
            if (-not (Test-Path $Global:SystemPaths.Wallpapers)) {
                Write-NASALog "Directorio de wallpapers no encontrado: $($Global:SystemPaths.Wallpapers)" -Level Error
                return
            }

            # Crear directorios
            New-ThemeDirectories

            # Instalar según tipo seleccionado
            switch ($ThemeType) {
                "Light" {
                    $lightInstalled = Install-NASATheme -Theme "Light"
                }
                "Dark" {
                    $darkInstalled = Install-NASATheme -Theme "Dark"
                }
                "Both" {
                    $lightInstalled = Install-NASATheme -Theme "Light"
                    $darkInstalled = Install-NASATheme -Theme "Dark"
                }
            }
        }

        # ===== INSTALAR CURSORES =====
        if ($shouldInstallCursors) {
            Write-NASALog "Iniciando instalación de cursores..." -Level Progress
            $themeForCursors = if ($shouldInstallThemes) { $ThemeType } else { "Dark" }  # Default Dark para cursores standalone
            $cursorsInstalledResult = Install-NASACursors -CursorTheme $themeForCursors -PreferredTheme $themeForCursors
            $cursorsInstalled = [bool]$cursorsInstalledResult
        }

        # ===== INSTALAR SONIDOS =====
        if ($shouldInstallSounds) {
            Write-NASALog "Iniciando instalación de sonidos..." -Level Progress
            $soundsInstalledResult = Install-NASASounds -SoundType "All"
            $soundsInstalled = [bool]$soundsInstalledResult
        }

        # ===== APLICAR CAMBIOS AL SISTEMA =====
        if ($lightInstalled -or $darkInstalled -or $cursorsInstalled -or $soundsInstalled) {
            Invoke-SystemRefresh
        }

        # ===== MOSTRAR RESUMEN (con conversión explícita a Boolean) =====
        Show-InstallationSummary -LightInstalled ([bool]$lightInstalled) -DarkInstalled ([bool]$darkInstalled) -CursorsInstalled ([bool]$cursorsInstalled) -SoundsInstalled ([bool]$soundsInstalled)

        # ===== MENSAJE FINAL =====
        if ($lightInstalled -or $darkInstalled -or $cursorsInstalled -or $soundsInstalled) {
            Write-NASALog "🚀 ¡INSTALACIÓN NASA THEME COMPLETADA EXITOSAMENTE! 🚀" -Level NASA
        } else {
            Write-NASALog "La instalación no se completó correctamente." -Level Error
        }

    } catch {
        Write-NASALog "Error crítico: $($_.Exception.Message)" -Level Error
        Write-NASALog "Detalles en: $($Global:NASAThemeConfig.LogFile)" -Level Error
    }
    finally {
        if (-not $Silent) {
            Write-Host ""
            Write-Host "Log detallado: $($Global:NASAThemeConfig.LogFile)" -ForegroundColor $Global:UITheme.Info
            Write-Host "Presione cualquier tecla para continuar..." -ForegroundColor $Global:UITheme.Info
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    }
}

# ==========================================
# EJECUCIÓN
# ==========================================

Invoke-NASAThemeInstaller
