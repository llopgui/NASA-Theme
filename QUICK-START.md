# 🚀 Guía de Inicio Rápido - NASA Theme

> **Para usuarios que quieren instalar inmediatamente sin leer toda la documentación**

## ⚡ Instalación en 3 Pasos

### 1️⃣ **Descargar**

```powershell
git clone https://github.com/llopgui/NASA-Theme.git
cd NASA-Theme
```

### 2️⃣ **Instalar como Administrador**

```powershell
# Clic derecho en PowerShell → "Ejecutar como administrador"
.\Install-NASATheme.ps1
```

### 3️⃣ **Aplicar Tema**

- Clic derecho en escritorio → **Personalizar**
- **Temas** → Seleccionar **NASA Dark Theme** o **NASA Light Theme**

## 🎯 Comandos Útiles

```powershell
# Solo tema oscuro con presentación
.\Install-NASATheme.ps1 -ThemeType Dark -EnableSlideshow

# Para 4K
.\Install-NASATheme.ps1 -Resolution "3840x2160"

# Desinstalar
.\Install-NASATheme.ps1 -Uninstall
```

## ❓ Problemas

- **Error de permisos**: Ejecutar PowerShell como administrador
- **Política de ejecución**: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
- **No aparece el tema**: Reiniciar Windows Explorer

---

**📖 Documentación completa**: [README.md](README.md)
