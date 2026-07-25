---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
---

# AppImage

## Qué es

**AppImage** es un formato de paquete **portable y autónomo** para Linux que permite ejecutar aplicaciones **sin instalación, sin demonios y sin permisos de root**. Un solo archivo `.AppImage` contiene la aplicación y todas sus dependencias, listo para descargar, hacer ejecutable y usar.

```
┌──────────────────────────────────────────────────────┐
│              app.AppImage (~50-500 MB)                │
├──────────────────────────────────────────────────────┤
│  ┌────────────┐  ┌────────────┐  ┌────────────────┐  │
│  │ Aplicación  │  │ Librerías  │  │ Runtimes       │  │
│  │ (binarios)  │  │ (.so, .dll)│  │ (Qt, GTK, SDL) │  │
│  └────────────┘  └────────────┘  └────────────────┘  │
├──────────────────────────────────────────────────────┤
│  SquashFS — sistema de archivos comprimido (RO)      │
│  + AppImage Runtime — punto de entrada                │
├──────────────────────────────────────────────────────┤
│  Se monta en /tmp/.mount_XXXXX al ejecutarse          │
│  Se desmonta al cerrar la app                         │
└──────────────────────────────────────────────────────┘
```

AppImage fue creado por **Simon Peter** como un proyecto comunitario. No pertenece a ninguna empresa — es completamente abierto y descentralizado.

## Filosofía

| Principio | Significado |
|---|---|
| **Una app = un archivo** | No hay instalación, no hay dependencias que gestionar |
| **Sin instalación** | Descargas el archivo y lo ejecutas |
| **Sin daemon** | No necesita snapd, flatpakd ni ningún servicio en segundo plano |
| **Sin root** | Cualquier usuario puede ejecutar AppImages |
| **Portable** | Funciona en cualquier distro Linux moderna (2006+) |
| **Inmutable** | La app se ejecuta desde un sistema de archivos de solo lectura (SquashFS) |

## Cómo funciona

Internamente, un AppImage es:

1. **Un sistema de archivos SquashFS** comprimido con la app y sus dependencias
2. **Un runtime** (archivo ELF) que monta el SquashFS en `/tmp/.mount_XXXXX` y ejecuta el punto de entrada

Cuando ejecutas `./app.AppImage`:

```
1. El runtime ELF se ejecuta
2. Extrae el offset donde comienza el SquashFS
3. Monta el SquashFS en /tmp/.mount_app.XXXXX
4. Configura LD_LIBRARY_PATH, PATH, etc.
5. Ejecuta el binario principal de la app
6. Al cerrar, desmonta y limpia /tmp/
```

```bash
# Detalle: el archivo AppImage tiene un offset entre el ELF y el SquashFS
# Puedes ver dónde empieza el squashfs:
./app.AppImage --appimage-offset
```

## Ventajas y desventajas

### ✅ Ventajas

| Ventaja | Detalle |
|---|---|
| **Portabilidad total** | Un AppImage funciona en cualquier distro desde 2006 |
| **Sin instalación** | `chmod +x` y ejecutar — no hay `apt install`, `flatpak install`, etc. |
| **Sin root** | Perfecto para entornos restringidos, servidores compartidos, laboratorios |
| **No deja rastro** | La app no toca `/usr`, `/etc` ni otros directorios del sistema |
| **Aislamiento básico** | La app no puede modificar el sistema (el AppImage es de solo lectura) |
| **Múltiples versiones** | Puedes tener v1, v2, v3 del mismo programa en paralelo sin conflictos |
| **Distribución directa** | Los desarrolladores suben un solo archivo para toda la plataforma Linux |
| **Sin dependencias** | La app lleva todo lo que necesita (aunque no comparte nada) |

### ❌ Desventajas

| Desventaja | Detalle |
|---|---|
| **Sin sandboxing real** | La app corre con los permisos del usuario — no hay aislamiento estilo Flatpak/Snap |
| **Sin actualizaciones automáticas** | Tienes que descargar la nueva versión manualmente (o usar AppImageUpdate) |
| **Mayor tamaño** | Cada AppImage incluye sus dependencias (no comparte nada con otras apps) |
| **Sin integración automática** | No aparece en el menú de aplicaciones a menos que uses `appimaged` o lo integres manualmente |
| **Arranque más lento** | Descomprime y monta el SquashFS al iniciar (1-3 segundos extras) |
| **Sin gestión centralizada** | No hay un "Flathub" oficial — cada app se descarga de su propio sitio |
| **Sin control de permisos** | No puedes negar acceso a red, webcam, etc. (como sí puedes en Flatpak) |

## Uso básico

```bash
# 1. Descargar un AppImage (ejemplo: Krita)
wget https://download.kde.org/stable/krita/5.2/krita-5.2.0-x86_64.appimage

# 2. Hacer ejecutable
chmod +x krita-5.2.0-x86_64.appimage

# 3. Ejecutar
./krita-5.2.0-x86_64.appimage

# Opciones de línea de comandos del runtime:
./app.AppImage --appimage-help     # ayuda del runtime AppImage
./app.AppImage --appimage-version  # versión del runtime
./app.AppImage --help              # ayuda de la APP (no del runtime)
./app.AppImage --appimage-offset   # muestra offset del squashfs
./app.AppImage --appimage-extract  # extraer el contenido a un directorio
./app.AppImage --appimage-mount    # montar y mostrar el punto de montaje
```

## Integración al escritorio

```bash
# Forma manual: crear entrada .desktop
./app.AppImage --appimage-extract  # extrae a squashfs-root/
# Copiar el .desktop y el icono a $HOME/.local/share/applications/ y icons/

# Forma automática: appimaged (demonio de integración)
# Descargar de: https://github.com/AppImage/appimaged
./appimaged-x86_64.AppImage &
# Escanea ~/Applications/ e integra automáticamente los AppImages
```

## AppImageUpdate — actualizaciones

AppImage soporta actualizaciones delta a través de **AppImageUpdate**, una herramienta que descarga solo las diferencias entre versiones:

```bash
# Instalar AppImageUpdate
wget https://github.com/AppImage/AppImageUpdate/releases/.../appimageupdate.AppImage
chmod +x appimageupdate.AppImage

# Actualizar un AppImage específico
./appimageupdate.AppImage ./krita-5.2.0-x86_64.appimage
```

Los desarrolladores deben configurar la URL de actualización en el AppImage usando `appstreamcli` o herramientas de AppImageKit. No todos los AppImages lo soportan.

## Crear un AppImage

### Opción 1: linuxdeploy (recomendado)

```bash
# Descargar linuxdeploy
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
chmod +x linuxdeploy-x86_64.AppImage

# Crear AppImage a partir de un directorio con la app empaquetada
./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage

# O desde un .AppDir ya preparado:
# 1. Crear AppDir con la estructura:
#    AppDir/
#    ├── usr/
#    │   ├── bin/   → binario principal
#    │   ├── lib/   → librerías
#    │   └── share/ → iconos, .desktop
#    └── AppRun    → punto de entrada (script o binario)
# 2. Ejecutar linuxdeploy:
./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage
```

### Opción 2: appimagetool (AppImageKit)

```bash
# Descargar appimagetool
wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage

# Crear AppImage desde AppDir
./appimagetool-x86_64.AppImage AppDir

# Con compresión gzip (por defecto es xz, más lento pero más pequeño)
./appimagetool-x86_64.AppImage --comp gzip AppDir
```

### Estructura de un AppDir

```bash
AppDir/
├── AppRun                    # ← punto de entrada (ejecutable)
├── usr/
│   ├── bin/
│   │   └── miapp            # binario principal
│   └── lib/
│       ├── libfoo.so.1      # librerías necesarias
│       └── libbar.so.2
├── miapp.desktop            # archivo .desktop para integración
├── miapp.png                # icono (256x256 recomendado)
└── miapp.appdata.xml        # metadatos (opcional, para AppStream)
```

## Ecosistema AppImage

| Herramienta | Propósito |
|---|---|
| **AppImageKit** | Conjunto de herramientas oficial (appimagetool, AppImage, etc.) |
| **linuxdeploy** | Herramienta moderna para crear AppImages (reemplazo de appimagetool) |
| **appimaged** | Demonio opcional que integra AppImages al escritorio automáticamente |
| **AppImageUpdate** | Actualizaciones delta para AppImages |
| **AppImageLauncher** | Integración + actualización con GUI (alternativa a appimaged) |
| **appimapatch** | Parchea AppImages existentes para añadir funciones |

### appimaged vs AppImageLauncher

| Aspecto | appimaged | AppImageLauncher |
|---|---|---|
| **Tipo** | Demonio en segundo plano | Aplicación con GUI |
| **Integración** | Automática (escanea ~/Applications/) | Al ejecutar un AppImage |
| **Instalación** | Ejecutar el binario | `sudo apt install appimagelauncher` |
| **Actualizaciones** | No | Sí (conecta con AppImageUpdate) |
| **Estado** | Mantenimiento mínimo | Activo |

```bash
# AppImageLauncher
sudo apt install appimagelauncher    # Debian/Ubuntu (requiere PPA)
yay -S appimagelauncher-bin          # Arch (AUR)
# O descargar .deb desde GitHub Releases
# Al ejecutar un AppImage, pregunta si quieres integrarlo al sistema
```

## AppImages notables

Muchos proyectos populares distribuyen AppImages oficiales:

| Aplicación | Web |
|---|---|
| **Krita** (pintura digital) | [download.kde.org/krita/](https://download.kde.org/krita/) |
| **Inkscape** (vectorial) | [inkscape.org/release/](https://inkscape.org/release/) |
| **GIMP** (edición de imágenes) | [flathub.org](https://flathub.org) (también AppImage) |
| **OBS Studio** (streaming) | [obsproject.com](https://obsproject.com/) |
| **Audacity** (audio) | [audacityteam.org](https://www.audacityteam.org/) |
| **FreeCAD** (CAD 3D) | [freecad.org](https://www.freecad.org/) |
| **Godot Engine** (videojuegos) | [godotengine.org](https://godotengine.org/) |
| **Blender** (3D) | [blender.org](https://www.blender.org/) |
| **Musescore** (partituras) | [musescore.org](https://musescore.org/) |
| **OnlyOffice** (ofimática) | [onlyoffice.com](https://www.onlyoffice.com/) |
| **RStudio** (estadísticas) | [posit.co](https://posit.co/download/rstudio/) |
| **Joplin** (notas) | [joplinapp.org](https://joplinapp.org/) |

## Dónde encontrar AppImages

| Sitio | Descripción |
|---|---|
| **[AppImageHub](https://appimage.github.io/)** | Catálogo curado de AppImages con metadatos |
| **[AppImagePool](https://appimagepool.github.io/)** | Catálogo visual moderno |
| **[PortableLinux](https://portable-linux-apps.github.io/)** | Colección de apps portables AppImage |
| **Página oficial de cada proyecto** | Muchos proyectos ofrecen AppImage directo en GitHub Releases |

```bash
# Buscar AppImages desde terminal con appimagehub-cli
# (no oficial, pero útil)
pip install appimagehub-cli
appimagehub search krita
```

## AppImage vs Snap vs Flatpak

| Aspecto | AppImage | Flatpak | Snap |
|---|---|---|---|
| **Daemon** | ❌ No | ❌ No (flatpak --user) | ✅ Sí (snapd) |
| **Root requerido** | ❌ No | ❌ No (--user) | ✅ Sí (snapd) |
| **Sandboxing** | ❌ No | ✅ Sí | ✅ Sí |
| **Actualizaciones automáticas** | ❌ No | ⚠️ Manual | ✅ Forzadas |
| **Integración escritorio** | ⚠️ Manual | ✅ Automática | ✅ Automática |
| **Repositorio central** | ❌ No (descentralizado) | ✅ Flathub | ✅ Snap Store |
| **Tamaño disco** | Mayor (cada app todo incluido) | Menor (runtimes compartidos) | Menor (snapd + core) |
| **Tiempo arranque** | ~1-3s (montar squashfs) | <1s | 1-5s |
| **Múltiples versiones** | ✅ Sí (archivos separados) | ⚠️ Parcial | ❌ Una sola |
| **Ideal para** | Probar apps, portabilidad, USB live | Apps de escritorio diarias | Ubuntu, IoT, servidores |

## Buenas prácticas

1. **Organiza tus AppImages**: crea un directorio `~/Applications/` y ponlos ahí
2. **Añade al PATH**: `export PATH="$HOME/Applications:$PATH"` en tu `.bashrc`
3. **Usa AppImageLauncher** si integras muchas AppImages al escritorio
4. **Verifica la procedencia**: los AppImages son archivos ejecutables — solo descarga de sitios oficiales o de confianza
5. **Comprime con gzip** si creas AppImages: arranque más rápido que xz (aunque pesa un poco más)
6. **No uses AppImage para servicios del sistema**: no están diseñados para servidores o servicios que requieran arranque automático

## Troubleshooting

```bash
# 1. "FUSE required" — el sistema no soporta FUSE
./app.AppImage --appimage-extract  # extrae a squashfs-root/
cd squashfs-root/
./AppRun                           # ejecutar directamente

# 2. Error de librería faltante (GLIBC too old)
# El sistema es demasiado antiguo para las dependencias del AppImage
# Solución: buscar una versión más antigua del AppImage

# 3. El AppImage no se abre (no aparece nada)
# Ejecutar desde terminal para ver el error:
./app.AppImage 2>&1 | head -50

# 4. El AppImage falla con "cannot mount"
# El kernel no tiene soporte FUSE o squashfs
sudo apt install fuse               # Debian/Ubuntu
sudo pacman -S fuse                 # Arch
sudo dnf install fuse               # Fedora

# 5. Forzar el uso de X11 (si la app no funciona en Wayland)
QT_QPA_PLATFORM=xcb ./app.AppImage  # apps Qt
GDK_BACKEND=x11 ./app.AppImage      # apps GTK

# 6. Verificar información del AppImage
./app.AppImage --appimage-help
file app.AppImage                    # debe decir "ELF 64-bit ... AppImage"
```

## Ver también

- [[Snap y Flatpak]] — comparativa completa con AppImage y otros formatos
- [[Gestores de Paquetes]] — visión general de formatos de paquetes en Linux
- [[Gestores de Archivos]] — organización de archivos descargados
- [[Contenedores]] — conceptos de empaquetado y aislamiento
- [[Utilidades Base del Sistema]] — FUSE y squashfs como utilidades base

## Enlaces externos

- [AppImage — Página oficial](https://appimage.org/)
- [AppImageHub — Catálogo curado](https://appimage.github.io/)
- [AppImageKit — GitHub](https://github.com/AppImage/AppImageKit)
- [linuxdeploy — GitHub](https://github.com/linuxdeploy/linuxdeploy)
- [AppImageLauncher — GitHub](https://github.com/TheAssassin/AppImageLauncher)
- [AppImageUpdate — GitHub](https://github.com/AppImage/AppImageUpdate)
- [PortableLinux — Apps portables](https://portable-linux-apps.github.io/)
- [Wikipedia — AppImage](https://en.wikipedia.org/wiki/AppImage)

#programa #paquetes
