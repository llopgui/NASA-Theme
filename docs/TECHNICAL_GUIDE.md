# Guía Técnica - Temas NASA

## Descripción General
Esta guía técnica explica la estructura interna y el funcionamiento de los temas NASA para Windows y Linux.

## Estructura de Archivos

### Windows
Los temas de Windows utilizan archivos `.theme` que configuran:
- **Colores del sistema**: Definidos en la sección `[Control Panel\Colors]`
- **Fondos de pantalla**: Configurados en `[Control Panel\Desktop]`
- **Estilos visuales**: Referenciados en `[VisualStyles]`

#### Formato de Colores Windows
Los colores se definen en formato RGB (0-255):
```ini
ButtonFace=248 250 252
; Equivale a: #F8FAFC
```

### Linux GTK
Los temas GTK utilizan CSS personalizado con variables de color:

#### Variables de Color
```css
@define-color nasa_blue #0B3D91;
@define-color theme_bg_color @star_silver;
```

#### Selectores Principales
- `window`: Ventanas principales
- `headerbar`: Barras de título
- `button`: Botones del sistema
- `entry`: Campos de entrada
- `menu`: Menús contextuales

### Linux Qt/KDE
Los esquemas de color Qt utilizan archivos `.colors` con secciones específicas:

#### Secciones Principales
- `[Colors:Button]`: Colores de botones
- `[Colors:Window]`: Ventanas y marcos
- `[Colors:View]`: Áreas de contenido
- `[Colors:Selection]`: Elementos seleccionados

## Paleta de Colores

### Tema Claro (NASA Light)
| Elemento | Hex | RGB | Uso |
|----------|-----|-----|-----|
| NASA Blue | `#0B3D91` | 11,61,145 | Acentos principales |
| Cosmic White | `#FFFFFF` | 255,255,255 | Fondos principales |
| Star Silver | `#F8FAFC` | 248,250,252 | Fondos secundarios |
| Space Gray | `#475569` | 71,85,105 | Elementos inactivos |

### Tema Oscuro (NASA Dark)
| Elemento | Hex | RGB | Uso |
|----------|-----|-----|-----|
| NASA Blue | `#1E40AF` | 30,64,175 | Acentos principales |
| Cosmic Black | `#0F172A` | 15,23,42 | Fondos principales |
| Void Black | `#1E293B` | 30,41,59 | Fondos secundarios |
| Star Dust | `#94A3B8` | 148,163,184 | Elementos inactivos |

## Personalización Avanzada

### Modificar Colores
1. **Windows**: Edite la sección `[Control Panel\Colors]` en el archivo `.theme`
2. **GTK**: Modifique las variables `@define-color` en `gtk.css`
3. **Qt**: Actualice los valores RGB en las secciones correspondientes

### Agregar Nuevos Elementos
Para agregar estilos a nuevos elementos:

#### GTK
```css
/* Nuevo selector personalizado */
.custom-widget {
    background: @nasa_blue;
    color: @cosmic_white;
    border-radius: 6px;
}
```

#### Qt
Agregue nuevas secciones de color según sea necesario:
```ini
[Colors:CustomWidget]
BackgroundNormal=11,61,145
ForegroundNormal=255,255,255
```

## Instalación Programática

### Windows (PowerShell)
```powershell
# Aplicar tema mediante registro
$themePath = "$env:SystemRoot\Resources\Themes\NASA_Light\NASA_Light.theme"
Start-Process -FilePath $themePath -Wait
```

### Linux (Bash)
```bash
# Aplicar tema GTK
gsettings set org.gnome.desktop.interface gtk-theme "NASA-Light"

# Aplicar esquema Qt (KDE)
kwriteconfig5 --file kdeglobals --group General --key ColorScheme "NASA Light"
```

## Desarrollo y Testing

### Herramientas Recomendadas
- **Windows**: Microsoft Visual Studio (para .msstyles)
- **GTK**: GTK Inspector (`Ctrl+Shift+I`)
- **Qt**: Qt Designer y qdbusviewer

### Testing
1. **Compatibilidad**: Pruebe en múltiples versiones del SO
2. **Accesibilidad**: Verifique contraste y legibilidad
3. **Rendimiento**: Monitor uso de recursos

### Debugging GTK
```bash
# Habilitar inspector GTK
GTK_DEBUG=interactive aplicacion
```

### Debugging Qt
```bash
# Variables de debug Qt
export QT_LOGGING_RULES="qt.qpa.theme.debug=true"
```

## Contribuir al Proyecto

### Estructura de Commits
```
tipo(ámbito): descripción

- feat(gtk): agregar soporte para GTK 4.0
- fix(windows): corregir colores en modo de alto contraste
- docs(readme): actualizar instrucciones de instalación
```

### Checklist de Pull Request
- [ ] Temas probados en ambos modos (claro/oscuro)
- [ ] Documentación actualizada
- [ ] Scripts de instalación funcionando
- [ ] Colores validados para accesibilidad

## Solución de Problemas

### Windows
**Problema**: El tema no se aplica
**Solución**: Verificar permisos de administrador y rutas de archivos

### Linux GTK
**Problema**: Tema no visible en selector
**Solución**: Verificar estructura de directorios y archivo `index.theme`

### Linux Qt
**Problema**: Colores no se actualizan
**Solución**: Reiniciar aplicaciones Qt o cerrar sesión

## Recursos Adicionales

### Documentación Oficial
- [Windows Theme Format](https://docs.microsoft.com/en-us/windows/win32/controls/themes-overview)
- [GTK CSS Reference](https://docs.gtk.org/gtk3/css-properties.html)
- [KDE Color Schemes](https://develop.kde.org/docs/plasma/theme/colorscheme/)

### Herramientas Útiles
- **Calculadora de contraste**: [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- **Selector de colores**: [Adobe Color](https://color.adobe.com/)
- **Convertidor RGB/Hex**: Múltiples herramientas online disponibles
