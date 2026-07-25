---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
---

# Wine

## Qué es

**Wine** (acrónimo recursivo de *Wine Is Not an Emulator*) es una **capa de compatibilidad** que permite ejecutar aplicaciones de Microsoft Windows en sistemas Linux, macOS y BSD. **No es un emulador** — no simula hardware ni ejecuta el kernel de Windows. En su lugar, **traduce las llamadas al sistema de Windows a sus equivalentes nativos de POSIX/Linux** en tiempo real.

Wine fue iniciado en 1993 por **Bob Amstadt** y **Eric Youngdale**, y desde 1994 es mantenido por **Alexandre Julliard**. Es software libre bajo licencia **LGPL**.

```
┌───────────────────────────────────────────────────┐
│            Aplicación Windows (.exe)              │
│         (cree que está en Windows)                │
├───────────────────────────────────────────────────┤
│                     Wine                           │
│  ┌──────────┬──────────┬──────────┬──────────┐   │
│  │ win32api │ directx  │ registry │   shell  │   │
│  │ (kernel32│ (wined3d)│ (regedit)│(explorer) │   │
│  │  user32) │          │          │           │   │
│  └──────────┴──────────┴──────────┴──────────┘   │
│  ┌──────────────────────────────────────────┐     │
│  │ Traducción → syscalls Linux/BSD          │     │
│  └──────────────────────────────────────────┘     │
├───────────────────────────────────────────────────┤
│           Sistema Operativo (Linux)                │
│           X11/Wayland + PulseAudio/PipeWire        │
└───────────────────────────────────────────────────┘
```

## Instalación

```bash
# Debian/Ubuntu
sudo dpkg --add-architecture i386   # habilitar 32 bits
sudo apt update
sudo apt install wine wine32 wine64

# Arch Linux
sudo pacman -S wine

# Fedora
sudo dnf install wine

# openSUSE
sudo zypper install wine

# Flatpak (repositorio WineHQ oficial)
flatpak install flathub org.winehq.Wine

# Desde WineHQ (última versión estable)
# https://dl.winehq.org/wine-builds/
```

## Configuración inicial

```bash
# Primera ejecución — crea ~/.wine/ (equivalente a C:\)
winecfg

# Lo que crea:
# ~/.wine/drive_c/   → C:\  (archivos de programa, Windows, users)
# ~/.wine/dosdevices/ → enlaces a unidades (c: → ../drive_c, d: → /mnt/cdrom)

# winetricks — instalador de componentes Windows
sudo apt install winetricks     # o desde winehq
winetricks                      # menú interactivo
winetricks vcrun2022 corefonts directx9  # desde CLI
```

Componentes que puedes instalar con `winetricks`:

| Componente | Para qué |
|---|---|
| `vcrun2022` | Visual C++ Redistributable (muchos juegos lo requieren) |
| `corefonts` | Fuentes Arial, Times New Roman, etc. |
| `dotnet48` | .NET Framework 4.8 (aplicaciones .NET) |
| `directx9` | DirectX 9 (juegos antiguos) |
| `d3dx9` / `d3dx11_43` | Librerías DirectX adicionales |
| `physx` | PhysX SDK |
| `riched20` | Control RichEdit (editores de texto) |
| `ie8` | Internet Explorer 8 (para apps que lo requieren) |

## Uso básico

```bash
# Ejecutar un programa
wine programa.exe
wine ~/.wine/drive_c/Archivos\ de\ Programa/MiApp/app.exe

# Ejecutar programa con argumentos
wine programa.exe /S /D=C:\MiApp

# Ejecutar desde el menú de inicio virtual
wine start "Mi Programa"

# Instalar MSI
wine msiexec /i instalador.msi

# Programas instalados (aparecen en ~/.wine/drive_c/Program Files/)
wine explorer           # abrir explorador de archivos virtual
wine uninstaller        # desinstalar programas Windows
wine regedit            # editor del registro de Windows
wine control            # panel de control virtual
wine taskmgr            # administrador de tareas
```

## Arquitectura interna de Wine

### Capas principales

| Componente | Función |
|---|---|
| **NTDLL** | Traducción de syscalls NT → Linux |
| **KERNEL32** | Gestión de procesos, memoria, archivos |
| **USER32** | Ventanas, mensajes, controles (traducido a X11/Wayland) |
| **GDI32** | Gráficos 2D (traducido a Cairo/XRender) |
| **WINED3D** | Direct3D → OpenGL (y experimental Vulkan) |
| **WINMM** | Multimedia (audio → ALSA/PulseAudio/PipeWire) |
| **WINSOCK** | Sockets Windows → Berkeley sockets |
| **MSHTML** | Motor de renderizado HTML (Gecko embebido) |
| **OLE32** | COM/OLE (Object Linking and Embedding) |

### Cómo se traduce

```bash
# Una app Windows llama a CreateFileW("C:\datos.txt", ...)
# Wine intercepta la llamada en KERNEL32
# La traduce a open("~/.wine/drive_c/datos.txt", ...)
# La syscall Linux ocurre sin que la app lo sepa
```

## Variantes de Wine

| Variante | Descripción |
|---|---|
| **Wine** | El proyecto original (estable, desarrollo) |
| **Wine-Staging** | Versión con parches experimentales (mejor compatibilidad) |
| **Wine-GE** | Mantenida por GloriousEggroll, parches extra para juegos |
| **Proton** | Fork de Valve para Steam (Wine + DXVK + VKD3D + parches) |
| **Proton GE** | Proton con parches adicionales de GloriousEggroll |
| **Lutris Wine** | Compilación optimizada para Lutris (wine-lutris, wine-lutris-ge) |

```bash
# Instalar Wine-Staging
# Debian/Ubuntu: añadir repositorio WineHQ
sudo apt install --install-recommends winehq-staging

# Wine-GE (para juegos fuera de Steam)
# Descargar de: https://github.com/GloriousEggroll/wine-ge-custom
# Extraer a ~/.local/share/lutris/runtime/wine/ o similar según el launcher
```

### Comparativa

| Aspecto | Wine | Wine-Staging | Proton | Wine-GE |
|---|---|---|---|---|
| **Rendimiento juegos** | Aceptable | Bueno | Excelente | Excelente |
| **Apps ofimáticas** | Excelente | Excelente | N/A | N/A |
| **Integración Steam** | Manual | Manual | Automática | Manual |
| **Parches extra** | No | Sí | Sí | Sí (juegos) |
| **Estabilidad** | Alta | Alta-media | Alta | Media |

## Casos de uso principales

### 1. **Aplicaciones ofimáticas y utilidades**
- Microsoft Office 2016/2019 (funciona parcialmente)
- Adobe Photoshop CS6 / Acrobat Reader
- 7-Zip, Notepad++, IrfanView, CDex
- Steam, uPlay, Origin (los launchers)

```bash
# Office 2016 en Wine
winetricks corefonts msxml6 gdiplus riched20
wine setup.exe
```

### 2. **Juegos fuera de Steam**
Para juegos que no están en Steam, Wine puro puede ser suficiente, aunque se recomienda usar **Lutris** o **Heroic** que gestionan Wine automáticamente.

```bash
# Juego antiguo con Wine puro
wine juego.exe

# Con Wine-Staging (reemplaza al binario wine, mejor rendimiento)
# Si instalaste wine-staging, el comando sigue siendo: wine
wine juego.exe

# Configuraciones típicas por juego
winecfg # Pestaña Libraries → añadir overrides para DLLs problemáticas
```

### 3. **Pruebas de software**
Entorno aislado en `~/.wine` para probar software Windows sin riesgo para el sistema.

```bash
# Crear prefix separado (entorno Wine independiente)
export WINEPREFIX=~/wine-pruebas winecfg
export WINEPREFIX=~/wine-pruebas wine programa.exe

# Eliminar el prefix para empezar de cero
rm -rf ~/wine-pruebas
```

### 4. **Ejecutar instaladores**
Muchos instaladores de Linux (como fuentes, controladores) vienen como `.exe` de Windows. Wine permite extraer su contenido.

```bash
wine install.exe /extract
# O usar innoextract para instaladores Inno Setup
```

## Configuración avanzada

### winecfg (por prefix)

```bash
winecfg              # prefix por defecto (~/.wine)
WINEPREFIX=~/proyecto wine winecfg  # prefix personalizado

# Desde winecfg puedes configurar:
# - Versión de Windows (Windows 10, 7, XP, 2000, etc.)
# - Gráficos (resolución, ventana vs pantalla completa)
# - Librerías (DLL overrides)
# - Discos (unidades virtuales)
# - Audio (ALSA, PulseAudio, PipeWire, OSS)
# - Temas y colores de la interfaz
```

### DLL overrides

Algunas aplicaciones requieren que DLLs específicas sean **nativas** (las de Windows) o **integradas** (las de Wine):

```bash
# En winecfg → Libraries → New override
# Ejemplos comunes:
riched20        (native)   → apps que requieren editor de texto
msxml3          (native)   → apps XML
quartz          (disabled) → problemas con codecs
d3dx9_36        (native)   → juegos DirectX 9
```

```bash
# O desde línea de comandos
WINEDLLOVERRIDES="riched20=n;msxml3=n;quartz=d" wine app.exe
# n = native (Windows), b = builtin (Wine), d = disabled
```

### Registry

```bash
wine regedit                    # editor gráfico
wine regedit archivo.reg        # importar archivo .reg

# También se puede editar directamente:
# ~/.wine/user.reg
# ~/.wine/system.reg
# ~/.wine/userdef.reg
```

## Variables de entorno útiles

| Variable | Función |
|---|---|
| `WINEPREFIX` | Ruta al directorio Wine (permite múltiples entornos) |
| `WINEARCH` | Arquitectura: `win32` o `win64` (define si el prefix es 32 o 64 bits) |
| `WINEDLLOVERRIDES` | Prioridad de DLLs (native/builtin/disabled) |
| `WINEDEBUG` | Nivel de logging: `+all`, `-all`, `+relay`, `+seh`, `+d3d` |
| `DISPLAY` | Pantalla donde mostrar la app (útil en SSH) |
| `DXVK_HUD` | Mostrar HUD de rendimiento de DXVK (fps, draw calls) |
| `DXVK_CONFIG_FILE` | Ruta a archivo de configuración DXVK |
| `STAGING_SHARED_MEMORY` | Habilitar/deshabilitar CSMT (Wine-Staging) |

```bash
# Ejemplos
WINEPREFIX=~/wine-steam WINEARCH=win32 winecfg
WINEDEBUG=-all wine juego.exe                 # silenciar logs
WINEDEBUG=+relay wine app.exe 2>&1 | less     # debug detallado
```

## Wine y DXVK

**DXVK** es una implementación de **DirectX 9/10/11 sobre Vulkan** que mejora drásticamente el rendimiento de juegos en Wine. Wine por defecto traduce Direct3D a OpenGL (wined3d), que es más lento.

```bash
# Instalar DXVK en un prefix
# Descargar release de: https://github.com/doitsujin/dxvk/releases
# Extraer y copiar DLLs al prefix:
export WINEPREFIX=~/wine-juego
cp dxvk/x32/*.dll "$WINEPREFIX/drive_c/windows/system32/"
cp dxvk/x64/*.dll "$WINEPREFIX/drive_c/windows/syswow64/"
wine juego.exe  # ahora usa DXVK → Vulkan

# O usar winetricks:
winetricks dxvk

# Verificar que DXVK está activo:
WINEDEBUG=-all DXVK_HUD=1 wine juego.exe
# Debería ver: DXVK: x.x — frametime graph en la esquina
```

DXVK se incluye por defecto en **Proton**, **Wine-GE** y **Lutris Wine**. Solo necesitas instalarlo manualmente si usas Wine puro.

## Wine en contenedores y Docker

Wine también se puede ejecutar dentro de contenedores Docker para entornos de CI/CD o pruebas automatizadas:

```dockerfile
FROM ubuntu:22.04
RUN dpkg --add-architecture i386 && apt-get update
RUN apt-get install -y wine wine32 wine64 xvfb winetricks
ENV WINEPREFIX=/opt/wine_prefix
ENV DISPLAY=:99
CMD Xvfb :99 & wine app.exe
```

## Troubleshooting común

```bash
# 1. Verificar versión de Wine
wine --version

# 2. "wine: cannot find L" o error similar → el prefix no existe o está corrupto
winecfg           # crea el prefix de nuevo
rm -rf ~/.wine && winecfg  # empezar de cero

# 3. Pantalla negra / gráficos corruptos
winecfg → Graphics → Emulate a virtual desktop → marcar
# O instalar DXVK si el juego usa DirectX

# 4. Sonido no funciona
winecfg → Audio → elegir PipeWire/PulseAudio/ALSA

# 5. DLL not found / error de carga
winetricks # instalar componente faltante (vcrun, dotnet, etc.)

# 6. Programa no reconoce teclado/mouse
# Probar con:
wine explorer /desktop=name,1366x768 programa.exe

# 7. Obtener log de debug
export WINEDEBUG=+all
wine programa.exe 2>&1 | tee wine-debug.log
# Buscar en WineHQ AppDB el juego/app para soluciones específicas

# 8. Error de permisos en ~/.wine
rm -rf ~/.wine/*.lock   # eliminar archivos de bloqueo
```

## WineHQ AppDB

[WineHQ AppDB](https://appdb.winehq.org/) es la base de datos colaborativa donde se reporta la compatibilidad de cada aplicación:

| Clasificación | Significado |
|---|---|
| **Platinum** | Funciona perfecto sin configuración |
| **Gold** | Funciona con configuración mínima |
| **Silver** | Funciona con algunos problemas |
| **Bronze** | Funciona pero con problemas graves |
| **Garbage** | No funciona / inestable |

Antes de intentar ejecutar una app en Wine, busca su clasificación en AppDB + reseñas recientes.

## Ver también

- [[Videojuegos en Linux]] — gaming en Linux con Proton, Lutris, Heroic
- [[Contenedores]] — concepto de aislamiento (Wine como capa de compatibilidad)
- [[Snap y Flatpak]] — distribución de apps, Wine disponible como Flatpak
- [[PipeWire]] — audio para juegos y apps Wine
- [[Virtualización (KVM QEMU libvirt)]] — alternativa a Wine para apps Windows
- [[Git]] — el proyecto Wine se aloja en Git

## Enlaces externos

- [WineHQ — Página oficial](https://www.winehq.org/)
- [WineHQ AppDB — Base de datos de compatibilidad](https://appdb.winehq.org/)
- [WineHQ Wiki](https://wiki.winehq.org/)
- [Winetricks — Script de componentes](https://github.com/Winetricks/winetricks)
- [DXVK — DirectX sobre Vulkan](https://github.com/doitsujin/dxvk)
- [Proton GE](https://github.com/GloriousEggroll/proton-ge-custom)
- [Wine Staging](https://wine-staging.com/)
- [ArchWiki — Wine](https://wiki.archlinux.org/title/Wine)
- [Wikipedia — Wine](https://en.wikipedia.org/wiki/Wine_(software))

#programa
