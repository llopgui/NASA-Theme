#Requires -RunAsAdministrator
#Requires -Version 5.1

<#
.SYNOPSIS
    🚀 NASA Theme Installer - Instalador Oficial para Windows 11

.DESCRIPTION
    Instalador profesional para los temas NASA inspirados en el cosmos. Incluye:
    - Tema NASA Dark (JWST Edition) con paleta James Webb Space Telescope
    - Tema NASA Light con colores del cosmos luminoso
    - Wallpapers optimizados y presentación automática
    - Configuración completa del sistema Windows 11
    - Modo oscuro avanzado con efectos de transparencia
    - Paleta de colores científicamente inspirada

.PARAMETER ThemeType
    Especifica qué tema instalar: 'Light', 'Dark', o 'Both' (por defecto)

.PARAMETER Resolution
    Resolución de pantalla para optimizar wallpapers: 'Auto' (detección), '1920x1080', '2560x1440', '3840x2160', etc.

.PARAMETER WallpaperPath
    Ruta a una imagen personalizada para usar como wallpaper

.PARAMETER EnableSlideshow
    Habilita la presentación automática de wallpapers (30 minutos por defecto)

.PARAMETER SlideshowInterval
    Intervalo en minutos para cambio de wallpapers (5-120 minutos)

.PARAMETER SkipExplorerRestart
    Omite el reinicio automático de Windows Explorer

.PARAMETER Uninstall
    Desinstala completamente los temas NASA del sistema

.PARAMETER Silent
    Instalación silenciosa sin interacción del usuario

.PARAMETER BackupCurrentTheme
    Crea respaldo del tema actual antes de instalar

.EXAMPLE
    .\Install-NASATheme.ps1
    Instalación estándar de ambos temas con detección automática

.EXAMPLE
    .\Install-NASATheme.ps1 -ThemeType Dark -Resolution "2560x1440" -EnableSlideshow
    Instala solo tema oscuro para QHD con presentación de wallpapers

.EXAMPLE
    .\Install-NASATheme.ps1 -WallpaperPath "C:\Pictures\cosmos.jpg" -SlideshowInterval 15
    Instala temas con wallpaper personalizado y cambio cada 15 minutos

.EXAMPLE
    .\Install-NASATheme.ps1 -Uninstall
    Desinstala completamente los temas NASA

.NOTES
    Autor: NASA Theme Project (@llopgui)
    Versión: 4.0.0 - Professional Edition
    Licencia: CC BY-NC-SA 4.0
    Repositorio: https://github.com/llopgui/NASA-Theme
    Soporte: Windows 10 2004+ / Windows 11

.LINK
    https://github.com/llopgui/NASA-Theme
#>

[CmdletBinding(DefaultParameterSetName = "Install")]
param(
    [Parameter(Mandatory = $false, ParameterSetName = "Install")]
    [ValidateSet("Light", "Dark", "Both")]
    [string]$ThemeType = "Both",

    [Parameter(Mandatory = $false, ParameterSetName = "Install")]
    [ValidatePattern('^(Auto|\d{3,4}x\d{3,4})$')]
    [string]$Resolution = "Auto",

    [Parameter(Mandatory = $false, ParameterSetName = "Install")]
    [ValidateScript({
        if ($_ -and -not (Test-Path $_ -PathType Leaf)) {
            throw "El archivo de wallpaper '$_' no existe o no es un archivo válido."
        }
        if ($_ -and $_ -notmatch '\.(jpg|jpeg|png|bmp|webp)$') {
            throw "El archivo debe ser una imagen válida (jpg, jpeg, png, bmp, webp)."
        }
        return $true
    })]
    [string]$WallpaperPath,

    [Parameter(Mandatory = $false, ParameterSetName = "Install")]
    [switch]$EnableSlideshow,

    [Parameter(Mandatory = $false, ParameterSetName = "Install")]
    [ValidateRange(5, 120)]
    [int]$SlideshowInterval = 30,

    [Parameter(Mandatory = $false)]
    [switch]$SkipExplorerRestart,

    [Parameter(Mandatory = $true, ParameterSetName = "Uninstall")]
    [switch]$Uninstall,

    [Parameter(Mandatory = $false)]
    [switch]$Silent,

    [Parameter(Mandatory = $false, ParameterSetName = "Install")]
    [switch]$BackupCurrentTheme
)

# ==========================================
# CONFIGURACIÓN GLOBAL AVANZADA
# ==========================================

$Global:NASAThemeConfig = @{
    # Información del proyecto
    Name = "NASA Theme Installer Professional"
    Version = "4.0.0"
    Edition = "Professional Edition"
    Author = "NASA Theme Project (@llopgui)"
    Repository = "https://github.com/llopgui/NASA-Theme"
    License = "CC BY-NC-SA 4.0"
    SupportedOS = @("Windows 10 2004+", "Windows 11")

    # Configuración del sistema
    RequiredPSVersion = "5.1"
    RequiredOSBuild = 19041  # Windows 10 2004
    MinDiskSpace = 200MB

    # Archivos y rutas
    LogFile = "$env:TEMP\NASA_Theme_Install_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
    BackupDir = "$env:TEMP\NASA_Theme_Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    TempDir = "$env:TEMP\NASA_Theme_Temp"

    # Configuración de colores JWST
    JWSTColors = @{
        Mystical = @{ RGB = @(45, 35, 75); Hex = "#2D234B"; Pantone = "18-3620 TCX" }
        LavenderGray = @{ RGB = @(150, 145, 165); Hex = "#9691A5"; Pantone = "17-3910 TCX" }
        GingerBread = @{ RGB = @(165, 85, 65); Hex = "#A55541"; Pantone = "18-1244 TCX" }
        SteelGray = @{ RGB = @(105, 115, 125); Hex = "#69737D"; Pantone = "18-4005 TCX" }
        Beech = @{ RGB = @(85, 95, 75); Hex = "#555F4B"; Pantone = "19-0618 TCX" }
        Foxtrot = @{ RGB = @(185, 165, 145); Hex = "#B9A591"; Pantone = "18-1025 TCX" }
    }
}

$Global:SystemPaths = @{
    ThemeBase = "$env:SystemRoot\Resources\Themes"
    LightTheme = "$env:SystemRoot\Resources\Themes\NASA_Light"
    DarkTheme = "$env:SystemRoot\Resources\Themes\NASA_Dark"
    ProjectRoot = $PSScriptRoot
    Resources = Join-Path $PSScriptRoot "resources"
    Wallpapers = Join-Path $PSScriptRoot "resources\wallpapers"
    Windows = Join-Path $PSScriptRoot "windows"
    WindowsApps = "$env:LOCALAPPDATA\Microsoft\WindowsApps"
}

$Global:UITheme = @{
    Primary = "Cyan"
    Success = "Green"
    Warning = "Yellow"
    Error = "Red"
    Header = "Magenta"
    Accent = "Blue"
    Info = "White"
    Progress = "DarkCyan"
    Debug = "DarkGray"
    NASA = "Blue"
}

# ==========================================
# SISTEMA DE LOGGING Y INTERFAZ AVANZADA
# ==========================================

function Write-NASALog {
    <#
    .SYNOPSIS
        Sistema avanzado de logging con múltiples niveles y formato profesional
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Info", "Success", "Warning", "Error", "Header", "Progress", "Debug", "NASA", "System")]
        [string]$Level = "Info",

        [Parameter(Mandatory = $false)]
        [switch]$NoConsole,

        [Parameter(Mandatory = $false)]
        [switch]$NoLog,

        [Parameter(Mandatory = $false)]
        [switch]$Critical
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"
    $logEntry = "[$timestamp] [$Level] $Message"

    # Escribir al archivo de log
    if (-not $NoLog) {
        try {
            if (-not (Test-Path (Split-Path $Global:NASAThemeConfig.LogFile))) {
                New-Item -Path (Split-Path $Global:NASAThemeConfig.LogFile) -ItemType Directory -Force | Out-Null
            }
            Add-Content -Path $Global:NASAThemeConfig.LogFile -Value $logEntry -Encoding UTF8 -ErrorAction SilentlyContinue
        } catch {
            # Silenciar errores de logging
        }
    }

    # Mostrar en consola si no está en modo silencioso
    if (-not $NoConsole -and -not $Silent) {
        $prefix = switch ($Level) {
            "Info" { "[INFO]" }
            "Success" { "[✓ OK]" }
            "Warning" { "[⚠ WARN]" }
            "Error" { "[✗ ERROR]" }
            "Header" { "[NASA]" }
            "Progress" { "[→ PROC]" }
            "Debug" { "[DEBUG]" }
            "NASA" { "[🚀 NASA]" }
            "System" { "[⚙ SYS]" }
            default { "[INFO]" }
        }

        $color = $Global:UITheme[$Level]
        if (-not $color) { $color = $Global:UITheme.Info }

        if ($Level -eq "Header") {
            Write-Host ""
            Write-Host "═" * 100 -ForegroundColor $color
            Write-Host "$prefix $Message" -ForegroundColor $color
            Write-Host "═" * 100 -ForegroundColor $color
            Write-Host ""
        } else {
            Write-Host "$prefix " -ForegroundColor $color -NoNewline

            # Colorear mensaje crítico
            if ($Critical) {
                Write-Host $Message -ForegroundColor Red -BackgroundColor Yellow
            } else {
                Write-Host $Message -ForegroundColor White
            }
        }
    }

    # Log crítico adicional
    if ($Critical) {
        $criticalEntry = "[$timestamp] [CRITICAL] $Message"
        Add-Content -Path "$env:TEMP\NASA_Theme_Critical.log" -Value $criticalEntry -Encoding UTF8 -ErrorAction SilentlyContinue
    }
}

function Show-NASAWelcome {
    <#
    .SYNOPSIS
        Muestra la pantalla de bienvenida profesional con arte ASCII
    #>
    if (-not $Silent) {
        Clear-Host

        # Arte ASCII personalizado NASA
        $nasaArt = @"
    ████████╗███████╗███╗   ███╗ █████╗     ███╗   ██╗ █████╗ ███████╗ █████╗
    ╚══██╔══╝██╔════╝████╗ ████║██╔══██╗    ████╗  ██║██╔══██╗██╔════╝██╔══██╗
       ██║   █████╗  ██╔████╔██║███████║    ██╔██╗ ██║███████║███████╗███████║
       ██║   ██╔══╝  ██║╚██╔╝██║██╔══██║    ██║╚██╗██║██╔══██║╚════██║██╔══██║
       ██║   ███████╗██║ ╚═╝ ██║██║  ██║    ██║ ╚████║██║  ██║███████║██║  ██║
       ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝    ╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
"@

        Write-Host $nasaArt -ForegroundColor $Global:UITheme.NASA
        Write-Host ""
        Write-Host "🌌 " -ForegroundColor $Global:UITheme.NASA -NoNewline
        Write-Host "INSTALADOR PROFESIONAL PARA WINDOWS 11" -ForegroundColor $Global:UITheme.Header
        Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray

        # Información del proyecto
        Write-Host "📦 Versión: " -ForegroundColor $Global:UITheme.Info -NoNewline
        Write-Host "$($Global:NASAThemeConfig.Version) - $($Global:NASAThemeConfig.Edition)" -ForegroundColor $Global:UITheme.Success

        Write-Host "👨‍💻 Desarrollado por: " -ForegroundColor $Global:UITheme.Info -NoNewline
        Write-Host $Global:NASAThemeConfig.Author -ForegroundColor $Global:UITheme.Accent

        Write-Host "🔗 Repositorio: " -ForegroundColor $Global:UITheme.Info -NoNewline
        Write-Host $Global:NASAThemeConfig.Repository -ForegroundColor $Global:UITheme.NASA

        Write-Host "📜 Licencia: " -ForegroundColor $Global:UITheme.Info -NoNewline
        Write-Host $Global:NASAThemeConfig.License -ForegroundColor $Global:UITheme.Warning

        Write-Host ""
        Write-Host "🎨 Características:" -ForegroundColor $Global:UITheme.Header
        Write-Host "   • Tema NASA Dark - Edición James Webb Space Telescope" -ForegroundColor $Global:UITheme.Success
        Write-Host "   • Tema NASA Light - Cosmos Luminoso" -ForegroundColor $Global:UITheme.Success
        Write-Host "   • Wallpapers optimizados para múltiples resoluciones" -ForegroundColor $Global:UITheme.Success
        Write-Host "   • Configuración automática de Windows 11" -ForegroundColor $Global:UITheme.Success
        Write-Host "   • Paleta científica inspirada en misiones espaciales" -ForegroundColor $Global:UITheme.Success
        Write-Host ""
    }
}

# ==========================================
# VALIDACIÓN Y DIAGNÓSTICO DEL SISTEMA
# ==========================================

function Test-SystemCompatibility {
    <#
    .SYNOPSIS
        Realiza verificación completa de compatibilidad del sistema
    #>
    Write-NASALog "Iniciando diagnóstico completo del sistema..." -Level Progress

    $compatibility = @{
        OSVersion = $false
        PSVersion = $false
        AdminRights = $false
        DiskSpace = $false
        Architecture = $false
        WindowsFeatures = $false
        Score = 0
    }

    try {
        # Verificar versión del OS
        $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
        $buildNumber = [int]$osInfo.BuildNumber

        if ($buildNumber -ge $Global:NASAThemeConfig.RequiredOSBuild) {
            $compatibility.OSVersion = $true
            Write-NASALog "Sistema Operativo: $($osInfo.Caption) Build $buildNumber ✓" -Level Success
        } else {
            Write-NASALog "Sistema no compatible. Requiere Windows 10 Build $($Global:NASAThemeConfig.RequiredOSBuild)+ o Windows 11" -Level Error
        }

        # Verificar PowerShell
        $psVersion = $PSVersionTable.PSVersion
        if ($psVersion.Major -ge 5 -and $psVersion.Minor -ge 1) {
            $compatibility.PSVersion = $true
            Write-NASALog "PowerShell: $($psVersion.ToString()) ✓" -Level Success
        } else {
            Write-NASALog "PowerShell $($Global:NASAThemeConfig.RequiredPSVersion)+ requerido. Actual: $($psVersion.ToString())" -Level Error
        }

        # Verificar privilegios
        $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
        if ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            $compatibility.AdminRights = $true
            Write-NASALog "Privilegios de administrador: Confirmados ✓" -Level Success
        } else {
            Write-NASALog "Se requieren privilegios de administrador" -Level Error -Critical
        }

        # Verificar espacio en disco
        $systemDrive = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DeviceID -eq ($env:SystemRoot.Substring(0,2)) }
        $freeSpace = $systemDrive.FreeSpace
        if ($freeSpace -gt $Global:NASAThemeConfig.MinDiskSpace) {
            $compatibility.DiskSpace = $true
            $freeSpaceMB = [math]::Round($freeSpace / 1MB, 2)
            Write-NASALog "Espacio libre: ${freeSpaceMB} MB ✓" -Level Success
        } else {
            Write-NASALog "Espacio insuficiente. Requerido: $($Global:NASAThemeConfig.MinDiskSpace / 1MB) MB" -Level Error
        }

        # Verificar arquitectura
        $arch = $env:PROCESSOR_ARCHITECTURE
        if ($arch -eq "AMD64" -or $arch -eq "x86") {
            $compatibility.Architecture = $true
            Write-NASALog "Arquitectura: $arch ✓" -Level Success
        } else {
            Write-NASALog "Arquitectura no soportada: $arch" -Level Warning
        }

        # Verificar características de Windows
        try {
            $dwm = Get-Service -Name "Dwm" -ErrorAction SilentlyContinue
            $themes = Get-Service -Name "Themes" -ErrorAction SilentlyContinue

            if ($dwm -and $themes) {
                $compatibility.WindowsFeatures = $true
                Write-NASALog "Servicios de temas: Disponibles ✓" -Level Success
            } else {
                Write-NASALog "Servicios de temas no disponibles" -Level Warning
            }
        } catch {
            Write-NASALog "No se pudieron verificar los servicios de Windows" -Level Warning
        }

        # Calcular puntuación
        $trueCount = ($compatibility.GetEnumerator() | Where-Object { $_.Key -ne "Score" -and $_.Value -eq $true }).Count
        $totalChecks = ($compatibility.GetEnumerator() | Where-Object { $_.Key -ne "Score" }).Count
        $compatibility.Score = [math]::Round(($trueCount / $totalChecks) * 100, 1)

        Write-NASALog "Puntuación de compatibilidad: $($compatibility.Score)%" -Level NASA

        if ($compatibility.Score -ge 80) {
            Write-NASALog "Sistema apto para instalación de NASA Theme ✓" -Level Success
            return $true
        } elseif ($compatibility.Score -ge 60) {
            Write-NASALog "Sistema parcialmente compatible. Algunos problemas menores detectados" -Level Warning
            return $true
        } else {
            Write-NASALog "Sistema no compatible. Resuelva los problemas críticos antes de continuar" -Level Error -Critical
            return $false
        }

    } catch {
        Write-NASALog "Error durante el diagnóstico: $($_.Exception.Message)" -Level Error -Critical
        return $false
    }
}

function Get-OptimalResolution {
    <#
    .SYNOPSIS
        Detecta la resolución óptima y características de pantalla
    #>
    Write-NASALog "Detectando configuración de pantalla..." -Level Progress

    try {
        Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue

        $screens = [System.Windows.Forms.Screen]::AllScreens
        $primary = [System.Windows.Forms.Screen]::PrimaryScreen

        $resolution = "$($primary.Bounds.Width)x$($primary.Bounds.Height)"
        $dpi = $primary.Bounds.Width / $primary.WorkingArea.Width

        # Clasificar resolución
        $category = switch ($resolution) {
            "1366x768" { "HD" }
            "1920x1080" { "Full HD" }
            "2560x1440" { "QHD" }
            "3840x2160" { "4K UHD" }
            "5120x2880" { "5K" }
            "7680x4320" { "8K" }
            default { "Personalizada" }
        }

        Write-NASALog "Pantalla principal: $resolution ($category)" -Level Success
        Write-NASALog "Pantallas detectadas: $($screens.Count)" -Level Info

        if ($screens.Count -gt 1) {
            Write-NASALog "Configuración multi-monitor detectada" -Level Info
            foreach ($screen in $screens) {
                $screenRes = "$($screen.Bounds.Width)x$($screen.Bounds.Height)"
                $isPrimary = if ($screen.Primary) { " (Principal)" } else { "" }
                Write-NASALog "  • Monitor: $screenRes$isPrimary" -Level Debug
            }
        }

        return @{
            Resolution = $resolution
            Category = $category
            Primary = $primary
            AllScreens = $screens
            IsMultiMonitor = ($screens.Count -gt 1)
        }

    } catch {
        Write-NASALog "No se pudo detectar la resolución. Usando 1920x1080 por defecto" -Level Warning
        return @{
            Resolution = "1920x1080"
            Category = "Full HD"
            Primary = $null
            AllScreens = @()
            IsMultiMonitor = $false
        }
    }
}

# ==========================================
# GESTIÓN AVANZADA DE WALLPAPERS
# ==========================================

function Optimize-WallpaperCollection {
    <#
    .SYNOPSIS
        Organiza y optimiza la colección completa de wallpapers
    #>
    Write-NASALog "Optimizando colección de wallpapers NASA..." -Level Header

    $wallpaperDir = $Global:SystemPaths.Wallpapers
    if (-not (Test-Path $wallpaperDir)) {
        Write-NASALog "Directorio de wallpapers no encontrado: $wallpaperDir" -Level Error
        return $false
    }

    # Buscar todas las imágenes
    $imageExtensions = @("*.jpg", "*.jpeg", "*.png", "*.webp", "*.bmp")
    $allImages = @()

    foreach ($ext in $imageExtensions) {
        $images = Get-ChildItem -Path $wallpaperDir -Filter $ext -Recurse -ErrorAction SilentlyContinue
        $allImages += $images
    }

    if ($allImages.Count -eq 0) {
        Write-NASALog "No se encontraron imágenes en la colección" -Level Warning
        return $false
    }

    Write-NASALog "Encontradas $($allImages.Count) imágenes para procesar" -Level Info

    # Crear estructura organizada
    $organizedDir = Join-Path $wallpaperDir "organized"
    $categorizedDirs = @{
        "cosmic" = Join-Path $organizedDir "cosmic"
        "galaxy" = Join-Path $organizedDir "galaxy"
        "planet" = Join-Path $organizedDir "planet"
        "telescope" = Join-Path $organizedDir "telescope"
        "mission" = Join-Path $organizedDir "mission"
        "astronaut" = Join-Path $organizedDir "astronaut"
        "stellar" = Join-Path $organizedDir "stellar"
        "space" = Join-Path $organizedDir "space"
    }

    # Crear directorios
    foreach ($dir in $categorizedDirs.Values) {
        if (-not (Test-Path $dir)) {
            New-Item -Path $dir -ItemType Directory -Force | Out-Null
        }
    }

    # Procesar y categorizar imágenes
    $processed = 0
    $categorized = @{}

    foreach ($image in $allImages) {
        try {
            # Determinar categoría basada en nombre y características
            $category = Get-ImageCategory -ImagePath $image.FullName
            $quality = Get-ImageQuality -ImagePath $image.FullName

            # Generar nombre descriptivo
            $newName = "nasa_$($category)_$($quality)_$(Get-Date -Format 'yyyyMMdd')_$($processed.ToString('000'))"
            $newPath = Join-Path $categorizedDirs[$category] "$newName$($image.Extension)"

            # Evitar duplicados
            $counter = 1
            while (Test-Path $newPath) {
                $baseName = [System.IO.Path]::GetFileNameWithoutExtension($newName)
                $newPath = Join-Path $categorizedDirs[$category] "${baseName}_${counter}$($image.Extension)"
                $counter++
            }

            # Copiar imagen
            Copy-Item -Path $image.FullName -Destination $newPath -Force

            # Estadísticas
            if (-not $categorized.ContainsKey($category)) {
                $categorized[$category] = 0
            }
            $categorized[$category]++
            $processed++

            if ($processed % 10 -eq 0) {
                Write-NASALog "Procesadas $processed de $($allImages.Count) imágenes..." -Level Progress
            }

        } catch {
            Write-NASALog "Error procesando $($image.Name): $($_.Exception.Message)" -Level Warning
        }
    }

    # Mostrar estadísticas
    Write-NASALog "Optimización completada: $processed imágenes procesadas" -Level Success
    foreach ($cat in $categorized.GetEnumerator()) {
        Write-NASALog "  • $($cat.Key): $($cat.Value) imágenes" -Level Info
    }

    return $true
}

function Get-ImageCategory {
    <#
    .SYNOPSIS
        Determina la categoría de una imagen basándose en su nombre y metadatos
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$ImagePath
    )

    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($ImagePath).ToLower()

    # Categorización inteligente basada en palabras clave
    $categoryMap = @{
        "galaxy|galaxia|nebula|nebulosa|milky|via|lactea" = "galaxy"
        "planet|planeta|mars|tierra|earth|jupiter|saturn|venus|mercury" = "planet"
        "star|estrella|solar|sun|sol|stellar" = "stellar"
        "space|espacio|cosmos|cosmic|universe|universo" = "space"
        "telescope|telescopio|hubble|webb|jwst|james|observatory" = "telescope"
        "astronaut|astronauta|spacewalk|eva|crew|tripulacion" = "astronaut"
        "mission|mision|rover|perseverance|curiosity|apollo|artemis" = "mission"
    }

    foreach ($pattern in $categoryMap.GetEnumerator()) {
        if ($fileName -match $pattern.Key) {
            return $pattern.Value
        }
    }

    return "cosmic"  # Categoría por defecto
}

function Get-ImageQuality {
    <#
    .SYNOPSIS
        Determina la calidad de una imagen basándose en su tamaño
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$ImagePath
    )

    $fileInfo = Get-Item $ImagePath
    $sizeMB = $fileInfo.Length / 1MB

    return switch ($sizeMB) {
        { $_ -gt 20 } { "ultra_hq" }
        { $_ -gt 10 } { "high_quality" }
        { $_ -gt 5 } { "medium_quality" }
        { $_ -gt 1 } { "standard" }
        default { "compressed" }
    }
}

function Get-BestWallpaper {
    <#
    .SYNOPSIS
        Selecciona el mejor wallpaper para un tema y resolución específicos
    #>
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("light", "dark")]
        [string]$ThemeVariant,

        [Parameter(Mandatory = $true)]
        [string]$TargetResolution,

        [Parameter(Mandatory = $false)]
        [string]$CustomWallpaperPath
    )

    Write-NASALog "Seleccionando wallpaper óptimo para tema $ThemeVariant ($TargetResolution)..." -Level Progress

    # Si hay wallpaper personalizado, validarlo y usarlo
    if ($CustomWallpaperPath -and (Test-Path $CustomWallpaperPath)) {
        Write-NASALog "Usando wallpaper personalizado: $(Split-Path $CustomWallpaperPath -Leaf)" -Level Success
        return $CustomWallpaperPath
    }

    $wallpaperDir = $Global:SystemPaths.Wallpapers
    $searchDirs = @($wallpaperDir)

    # Buscar en directorio organizado si existe
    $organizedDir = Join-Path $wallpaperDir "organized"
    if (Test-Path $organizedDir) {
        $searchDirs = @($organizedDir) + $searchDirs
    }

    # Patrones de búsqueda específicos por tema
    $themePatterns = switch ($ThemeVariant) {
        "dark" {
            @(
                "*galaxy*", "*nebula*", "*deep*", "*dark*", "*black*", "*night*",
                "*cosmos*", "*stellar*", "*void*", "*mystery*"
            )
        }
        "light" {
            @(
                "*earth*", "*planet*", "*blue*", "*bright*", "*light*", "*day*",
                "*solar*", "*mission*", "*apollo*", "*telescope*"
            )
        }
    }

    $candidates = @()

    # Buscar en cada directorio
    foreach ($searchDir in $searchDirs) {
        foreach ($pattern in $themePatterns) {
            $matches = Get-ChildItem -Path $searchDir -Filter "$pattern.*" -Recurse -ErrorAction SilentlyContinue
            $candidates += $matches | Where-Object { $_.Extension -match '\.(jpg|jpeg|png|webp|bmp)$' }
        }
    }

    if ($candidates.Count -gt 0) {
        # Ordenar por calidad (tamaño) y seleccionar el mejor
        $bestCandidate = $candidates | Sort-Object Length -Descending | Select-Object -First 1
        Write-NASALog "Wallpaper seleccionado: $($bestCandidate.Name) ($([math]::Round($bestCandidate.Length/1MB, 2)) MB)" -Level Success
        return $bestCandidate.FullName
    }

    # Fallback: buscar cualquier imagen de calidad
    Write-NASALog "Aplicando selección de respaldo..." -Level Warning
    $allImages = Get-ChildItem -Path $wallpaperDir -Include @("*.jpg", "*.jpeg", "*.png", "*.webp") -Recurse |
                 Sort-Object Length -Descending |
                 Select-Object -First 5

    if ($allImages.Count -gt 0) {
        $fallback = $allImages | Get-Random
        Write-NASALog "Usando wallpaper de respaldo: $($fallback.Name)" -Level Warning
        return $fallback.FullName
    }

    Write-NASALog "No se encontraron wallpapers adecuados" -Level Error
    return $null
}

# ==========================================
# FUNCIONES DE INSTALACIÓN Y CONFIGURACIÓN
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
            } else {
                Write-NASALog "Directorio existente: $dir" -Level Info
            }
        } catch {
            Write-NASALog "Error creando directorio $dir : $($_.Exception.Message)" -Level Error -Critical
            throw
        }
    }
}

function Install-NASATheme {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Light", "Dark")]
        [string]$Theme,

        [Parameter(Mandatory = $true)]
        [string]$Resolution,

        [Parameter(Mandatory = $false)]
        [string]$CustomWallpaperPath
    )

    Write-NASALog "Instalando tema NASA $Theme..." -Level Header

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

        # Instalar wallpaper
        $wallpaperPath = Get-BestWallpaper -ThemeVariant $themeVariant -TargetResolution $Resolution -CustomWallpaperPath $CustomWallpaperPath

        if ($wallpaperPath) {
            $wallpaperDestDir = Join-Path $targetDir "wallpapers"
            $extension = [System.IO.Path]::GetExtension($wallpaperPath)
            $destWallpaperName = "nasa_${themeVariant}_wallpaper${extension}"
            $destWallpaperPath = Join-Path $wallpaperDestDir $destWallpaperName

            Copy-Item -Path $wallpaperPath -Destination $destWallpaperPath -Force
            Write-NASALog "Wallpaper instalado: $destWallpaperName" -Level Success

            # Actualizar archivo de tema con nueva ruta
            Update-ThemeWallpaperPath -ThemeFile $targetThemeFile -WallpaperPath $destWallpaperPath
        }

        # Configurar presentación si está habilitada
        if ($EnableSlideshow) {
            Set-SlideshowConfiguration -ThemeDirectory $targetDir -IntervalMinutes $SlideshowInterval
        }

        # Configurar registro
        Set-ThemeRegistryConfiguration -Theme $Theme -ThemePath $targetDir

        # Configuraciones específicas del tema oscuro
        if ($Theme -eq "Dark") {
            Set-JWSTDarkConfiguration
        }

        Write-NASALog "Tema $Theme instalado exitosamente" -Level Success
        return $true
    } catch {
        Write-NASALog "Error instalando tema $Theme : $($_.Exception.Message)" -Level Error -Critical
        return $false
    }
}

function Update-ThemeWallpaperPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ThemeFile,

        [Parameter(Mandatory = $true)]
        [string]$WallpaperPath
    )

    try {
        $content = Get-Content -Path $ThemeFile -Encoding UTF8
        $updatedContent = $content | ForEach-Object {
            if ($_ -match "^Wallpaper=") {
                "Wallpaper=$WallpaperPath"
            } else {
                $_
            }
        }

        Set-Content -Path $ThemeFile -Value $updatedContent -Encoding UTF8
        Write-NASALog "Ruta de wallpaper actualizada en archivo de tema" -Level Success
    } catch {
        Write-NASALog "Error actualizando ruta de wallpaper: $($_.Exception.Message)" -Level Warning
    }
}

function Set-SlideshowConfiguration {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ThemeDirectory,

        [Parameter(Mandatory = $true)]
        [int]$IntervalMinutes
    )

    try {
        $intervalMs = $IntervalMinutes * 60 * 1000

        # Configurar registro para presentación
        $slideshowPath = "HKCU:\Control Panel\Desktop"
        Set-ItemProperty -Path $slideshowPath -Name "SlideshowEnabled" -Value 1 -Type DWord
        Set-ItemProperty -Path $slideshowPath -Name "SlideshowInterval" -Value $intervalMs -Type DWord
        Set-ItemProperty -Path $slideshowPath -Name "SlideshowShuffle" -Value 1 -Type DWord

        Write-NASALog "Presentación de wallpapers configurada ($IntervalMinutes minutos)" -Level Success
    } catch {
        Write-NASALog "Error configurando presentación: $($_.Exception.Message)" -Level Warning
    }
}

function Set-ThemeRegistryConfiguration {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet("Light", "Dark")]
        [string]$Theme,

        [Parameter(Mandatory = $true)]
        [string]$ThemePath
    )

    Write-NASALog "Configurando registro de Windows para tema $Theme..." -Level Progress

    try {
        $themeRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes"
        if (-not (Test-Path $themeRegistryPath)) {
            New-Item -Path $themeRegistryPath -Force | Out-Null
        }

        $themeEntryPath = "$themeRegistryPath\NASA_$Theme"
        New-Item -Path $themeEntryPath -Force | Out-Null
        Set-ItemProperty -Path $themeEntryPath -Name "DisplayName" -Value "NASA $Theme Theme" -Type String
        Set-ItemProperty -Path $themeEntryPath -Name "InstallPath" -Value $ThemePath -Type String
        Set-ItemProperty -Path $themeEntryPath -Name "Version" -Value $Global:NASAThemeConfig.Version -Type String

        Write-NASALog "Registro de tema configurado correctamente" -Level Success
    } catch {
        Write-NASALog "Advertencia: No se pudo configurar el registro del tema: $($_.Exception.Message)" -Level Warning
    }
}

function Set-JWSTDarkConfiguration {
    Write-NASALog "Aplicando configuración avanzada James Webb Space Telescope..." -Level Progress

    try {
        # Personalización del usuario
        $personalizePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        if (-not (Test-Path $personalizePath)) {
            New-Item -Path $personalizePath -Force | Out-Null
        }

        # Modo oscuro completo
        Set-ItemProperty -Path $personalizePath -Name "SystemUsesLightTheme" -Value 0 -Type DWord
        Set-ItemProperty -Path $personalizePath -Name "AppsUseLightTheme" -Value 0 -Type DWord
        Set-ItemProperty -Path $personalizePath -Name "EnableTransparency" -Value 1 -Type DWord
        Set-ItemProperty -Path $personalizePath -Name "ColorPrevalence" -Value 1 -Type DWord

        # Color de énfasis JWST Ginger Bread
        $accentColor = 0xFFA55541
        Set-ItemProperty -Path $personalizePath -Name "AccentColor" -Value $accentColor -Type DWord

        # Desktop Window Manager
        $dwmPath = "HKCU:\Software\Microsoft\Windows\DWM"
        if (-not (Test-Path $dwmPath)) {
            New-Item -Path $dwmPath -Force | Out-Null
        }

        Set-ItemProperty -Path $dwmPath -Name "ColorPrevalence" -Value 1 -Type DWord
        Set-ItemProperty -Path $dwmPath -Name "AccentColor" -Value $accentColor -Type DWord
        Set-ItemProperty -Path $dwmPath -Name "EnableAeroPeek" -Value 1 -Type DWord
        Set-ItemProperty -Path $dwmPath -Name "Composition" -Value 1 -Type DWord

        # Colores del sistema con paleta JWST
        $colorsPath = "HKCU:\Control Panel\Colors"
        $jwstColors = $Global:NASAThemeConfig.JWSTColors

        Set-ItemProperty -Path $colorsPath -Name "Window" -Value "$($jwstColors.Mystical.RGB[0]) $($jwstColors.Mystical.RGB[1]) $($jwstColors.Mystical.RGB[2])" -Type String
        Set-ItemProperty -Path $colorsPath -Name "WindowText" -Value "220 215 235" -Type String
        Set-ItemProperty -Path $colorsPath -Name "Hilight" -Value "$($jwstColors.GingerBread.RGB[0]) $($jwstColors.GingerBread.RGB[1]) $($jwstColors.GingerBread.RGB[2])" -Type String
        Set-ItemProperty -Path $colorsPath -Name "HilightText" -Value "255 255 255" -Type String

        Write-NASALog "Configuración JWST aplicada correctamente" -Level Success
    } catch {
        Write-NASALog "Advertencia: No se pudieron aplicar todas las configuraciones JWST: $($_.Exception.Message)" -Level Warning
    }
}

function Invoke-SystemRefresh {
    param(
        [Parameter(Mandatory = $false)]
        [switch]$SkipExplorerRestart
    )

    Write-NASALog "Aplicando cambios al sistema Windows..." -Level Progress

    try {
        # Actualizar configuraciones del sistema
        try {
            $null = Start-Process -FilePath "rundll32.exe" -ArgumentList "user32.dll,UpdatePerUserSystemParameters" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
            Write-NASALog "Configuraciones del usuario actualizadas" -Level Success
        } catch {
            Write-NASALog "Método alternativo para actualización del sistema" -Level Info
        }

        # Reiniciar Windows Explorer si no se omite
        if (-not $SkipExplorerRestart) {
            Write-NASALog "Reiniciando Windows Explorer..." -Level Progress

            try {
                # Finalizar procesos del explorador
                $explorerProcesses = Get-Process -Name "explorer" -ErrorAction SilentlyContinue
                if ($explorerProcesses) {
                    Stop-Process -Name "explorer" -Force -ErrorAction SilentlyContinue
                    Start-Sleep -Seconds 3
                }

                # Reiniciar el explorador
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

function Backup-CurrentTheme {
    if (-not $BackupCurrentTheme) { return $true }

    Write-NASALog "Creando respaldo del tema actual..." -Level Progress

    try {
        $backupDir = $Global:NASAThemeConfig.BackupDir
        if (-not (Test-Path $backupDir)) {
            New-Item -Path $backupDir -ItemType Directory -Force | Out-Null
        }

        # Respaldar configuraciones del registro
        $regBackupPath = Join-Path $backupDir "theme_registry_backup.reg"
        $exportPaths = @(
            "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize",
            "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM",
            "HKEY_CURRENT_USER\Control Panel\Colors"
        )

        foreach ($regPath in $exportPaths) {
            $null = Start-Process -FilePath "reg.exe" -ArgumentList "export", "`"$regPath`"", "`"$regBackupPath`"", "/y" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }

        Write-NASALog "Respaldo creado en: $backupDir" -Level Success
        return $true
    } catch {
        Write-NASALog "Error creando respaldo: $($_.Exception.Message)" -Level Warning
        return $false
    }
}

function Uninstall-NASAThemes {
    Write-NASALog "Desinstalando temas NASA del sistema..." -Level Header

    $themesToRemove = @(
        $Global:SystemPaths.LightTheme,
        $Global:SystemPaths.DarkTheme
    )

    $removedCount = 0

    foreach ($themePath in $themesToRemove) {
        if (Test-Path $themePath) {
            try {
                Remove-Item -Path $themePath -Recurse -Force
                Write-NASALog "Tema eliminado: $themePath" -Level Success
                $removedCount++
            } catch {
                Write-NASALog "Error eliminando tema $themePath : $($_.Exception.Message)" -Level Error
            }
        }
    }

    # Limpiar registro
    try {
        $registryPaths = @(
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\NASA_Light",
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\NASA_Dark"
        )

        foreach ($regPath in $registryPaths) {
            if (Test-Path $regPath) {
                Remove-Item -Path $regPath -Force -ErrorAction SilentlyContinue
            }
        }

        Write-NASALog "Entradas del registro limpiadas" -Level Success
    } catch {
        Write-NASALog "Advertencia: No se pudieron limpiar todas las entradas del registro" -Level Warning
    }

    if ($removedCount -gt 0) {
        Write-NASALog "Desinstalación completada: $removedCount temas eliminados" -Level Success
        return $true
    } else {
        Write-NASALog "No se encontraron temas NASA para desinstalar" -Level Warning
        return $false
    }
}

function Show-InstallationSummary {
    param(
        [Parameter(Mandatory = $true)]
        [bool]$LightInstalled,

        [Parameter(Mandatory = $true)]
        [bool]$DarkInstalled,

        [Parameter(Mandatory = $true)]
        [string]$Resolution
    )

    Write-NASALog "RESUMEN DE INSTALACIÓN COMPLETADA" -Level Header

    # Estado de instalación
    Write-Host ""
    Write-Host "🎨 ESTADO DE TEMAS:" -ForegroundColor $Global:UITheme.NASA
    Write-Host "   • NASA Light Theme: " -NoNewline -ForegroundColor $Global:UITheme.Info
    if ($LightInstalled) {
        Write-Host "✅ INSTALADO" -ForegroundColor $Global:UITheme.Success
    } else {
        Write-Host "❌ NO INSTALADO" -ForegroundColor $Global:UITheme.Error
    }

    Write-Host "   • NASA Dark Theme (JWST Edition): " -NoNewline -ForegroundColor $Global:UITheme.Info
    if ($DarkInstalled) {
        Write-Host "✅ INSTALADO" -ForegroundColor $Global:UITheme.Success
    } else {
        Write-Host "❌ NO INSTALADO" -ForegroundColor $Global:UITheme.Error
    }

    if ($DarkInstalled) {
        Write-Host ""
        Write-Host "🌌 CARACTERÍSTICAS JWST DARK THEME:" -ForegroundColor $Global:UITheme.NASA
        Write-Host "   • Paleta científica James Webb Space Telescope" -ForegroundColor $Global:UITheme.Success
        Write-Host "   • Modo oscuro completo del sistema Windows 11" -ForegroundColor $Global:UITheme.Success
        Write-Host "   • Efectos de transparencia y composición DWM" -ForegroundColor $Global:UITheme.Success
        Write-Host "   • Color de énfasis: Ginger Bread (PANTONE 18-1244 TCX)" -ForegroundColor $Global:UITheme.Success
        if ($EnableSlideshow) {
            Write-Host "   • Presentación automática: $SlideshowInterval minutos" -ForegroundColor $Global:UITheme.Success
        }
    }

    Write-Host ""
    Write-Host "💻 CONFIGURACIÓN APLICADA:" -ForegroundColor $Global:UITheme.NASA
    Write-Host "   • Resolución optimizada: $Resolution" -ForegroundColor $Global:UITheme.Accent
    Write-Host "   • Wallpapers categorizados y optimizados" -ForegroundColor $Global:UITheme.Success
    Write-Host "   • Registro de Windows actualizado" -ForegroundColor $Global:UITheme.Success

    Write-Host ""
    Write-Host "🚀 CÓMO APLICAR LOS TEMAS:" -ForegroundColor $Global:UITheme.NASA
    Write-Host "   1. Clic derecho en el escritorio → Personalizar" -ForegroundColor $Global:UITheme.Accent
    Write-Host "   2. Navegar a 'Temas' en el panel izquierdo" -ForegroundColor $Global:UITheme.Accent
    Write-Host "   3. Seleccionar el tema NASA deseado" -ForegroundColor $Global:UITheme.Accent
    Write-Host "   4. ¡Disfrutar del cosmos en su escritorio!" -ForegroundColor $Global:UITheme.Success

    Write-Host ""
    Write-Host "📁 RUTAS DE INSTALACIÓN:" -ForegroundColor $Global:UITheme.Info
    if ($LightInstalled) {
        Write-Host "   • Light Theme: $($Global:SystemPaths.LightTheme)" -ForegroundColor $Global:UITheme.Accent
    }
    if ($DarkInstalled) {
        Write-Host "   • Dark Theme: $($Global:SystemPaths.DarkTheme)" -ForegroundColor $Global:UITheme.Accent
    }

    Write-Host ""
    Write-Host "📋 Log detallado: $($Global:NASAThemeConfig.LogFile)" -ForegroundColor $Global:UITheme.Info

    if ($BackupCurrentTheme) {
        Write-Host "💾 Respaldo creado: $($Global:NASAThemeConfig.BackupDir)" -ForegroundColor $Global:UITheme.Warning
    }

    Write-Host ""
    Write-Host "⚠️  NOTA: Si algunos efectos no se ven inmediatamente, reinicie Windows." -ForegroundColor $Global:UITheme.Warning
}

# ==========================================
# FUNCIÓN PRINCIPAL DEL INSTALADOR
# ==========================================

function Invoke-NASAThemeInstaller {
    try {
        # Inicializar logging
        "=" * 100 | Out-File -FilePath $Global:NASAThemeConfig.LogFile -Encoding UTF8
        "NASA Theme Installer Professional v$($Global:NASAThemeConfig.Version)" | Out-File -FilePath $Global:NASAThemeConfig.LogFile -Append -Encoding UTF8
        "Inicio: $(Get-Date)" | Out-File -FilePath $Global:NASAThemeConfig.LogFile -Append -Encoding UTF8
        "=" * 100 | Out-File -FilePath $Global:NASAThemeConfig.LogFile -Append -Encoding UTF8

        # Mostrar bienvenida
        Show-NASAWelcome

        # Modo desinstalación
        if ($Uninstall) {
            $uninstallResult = Uninstall-NASAThemes
            if ($uninstallResult) {
                Write-NASALog "¡Desinstalación de NASA Theme completada exitosamente!" -Level Success
            }
            return
        }

        # Diagnóstico del sistema
        if (-not (Test-SystemCompatibility)) {
            Write-NASALog "Sistema no compatible. Instalación cancelada." -Level Error -Critical
            return
        }

        # Detectar resolución de pantalla
        $screenInfo = Get-OptimalResolution
        $targetResolution = if ($Resolution -eq "Auto") {
            $screenInfo.Resolution
        } else {
            $Resolution
        }

        Write-NASALog "Resolución objetivo: $targetResolution ($($screenInfo.Category))" -Level NASA

        # Crear respaldo si se solicita
        Backup-CurrentTheme

        # Optimizar wallpapers
        Optimize-WallpaperCollection

        # Crear estructura de directorios
        New-ThemeDirectories

        # Instalar temas
        $lightInstalled = $false
        $darkInstalled = $false

        switch ($ThemeType) {
            "Light" {
                $lightInstalled = Install-NASATheme -Theme "Light" -Resolution $targetResolution -CustomWallpaperPath $WallpaperPath
            }
            "Dark" {
                $darkInstalled = Install-NASATheme -Theme "Dark" -Resolution $targetResolution -CustomWallpaperPath $WallpaperPath
            }
            "Both" {
                $lightInstalled = Install-NASATheme -Theme "Light" -Resolution $targetResolution -CustomWallpaperPath $WallpaperPath
                $darkInstalled = Install-NASATheme -Theme "Dark" -Resolution $targetResolution -CustomWallpaperPath $WallpaperPath
            }
        }

        # Aplicar cambios al sistema
        if ($lightInstalled -or $darkInstalled) {
            Invoke-SystemRefresh -SkipExplorerRestart:$SkipExplorerRestart
        }

        # Mostrar resumen
        Show-InstallationSummary -LightInstalled $lightInstalled -DarkInstalled $darkInstalled -Resolution $targetResolution

        if ($lightInstalled -or $darkInstalled) {
            Write-NASALog "🚀 ¡INSTALACIÓN NASA THEME COMPLETADA EXITOSAMENTE! 🚀" -Level NASA
        } else {
            Write-NASALog "La instalación no se completó correctamente. Revise el log para detalles." -Level Error -Critical
        }

    } catch {
        Write-NASALog "Error crítico durante la instalación: $($_.Exception.Message)" -Level Error -Critical
        Write-NASALog "Detalles completos en: $($Global:NASAThemeConfig.LogFile)" -Level Error

        # Log de error detallado
        $_.Exception | Out-File -FilePath $Global:NASAThemeConfig.LogFile -Append -Encoding UTF8
        $_.ScriptStackTrace | Out-File -FilePath $Global:NASAThemeConfig.LogFile -Append -Encoding UTF8
    }
    finally {
        if (-not $Silent) {
            Write-Host ""
            Write-Host "🌌 Gracias por usar NASA Theme - Explorando el cosmos desde su escritorio" -ForegroundColor $Global:UITheme.NASA
            Write-Host "Presione cualquier tecla para continuar..." -ForegroundColor $Global:UITheme.Accent
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    }
}

# ==========================================
# EJECUCIÓN DEL INSTALADOR
# ==========================================

# Ejecutar instalador principal
Invoke-NASAThemeInstaller
