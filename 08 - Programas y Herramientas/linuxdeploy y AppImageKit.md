---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: alta
---

# linuxdeploy y AppImageKit

## Qué son

**linuxdeploy** y **AppImageKit** son las herramientas fundamentales para **crear AppImages**. Mientras que los usuarios solo descargan y ejecutan AppImages (ver [[AppImage]]), los desarrolladores usan estas herramientas para empaquetar sus aplicaciones en formato portable.

La relación entre ambas es **complementaria**:

```
┌─────────────────────────────────────────────────────────────────┐
│                  Flujo de creación de un AppImage                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Código fuente → Compilar → AppDir → linuxdeploy → appimagetool → AppImage │
│                              (crea y      (empaqueta               │
│                               completa el   el AppDir              │
│                               AppDir)       en SquashFS)           │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

| Herramienta | Rollo | Mantenedor |
|---|---|---|
| **linuxdeploy** | Creación y mantenimiento automático de AppDirs | Comunidad (linuxdeploy) |
| **appimagetool** (AppImageKit) | Empaquetado final AppDir → `.AppImage` | AppImage (Simon Peter + colaboradores) |

---

## linuxdeploy

### Qué es

**linuxdeploy** es una herramienta moderna que **automatiza la creación de AppDirs**. A diferencia de hacerlo manualmente (copiar binarios, librerías, iconos una por una), linuxdeploy:

1. Analiza tus binarios con `ldd` para descubrir dependencias
2. Copia automáticamente las librerías `.so` necesarias al AppDir
3. Busca e integra los archivos `.desktop` e iconos
4. Crea el `AppRun` como symlink al binario principal
5. Ofrece plugins para frameworks específicos (Qt, GTK, Python, etc.)

```bash
# Flujo básico: compilar + empaquetar
mkdir -p AppDir/usr/bin
cp ./mi-app AppDir/usr/bin/           # copiar binario compilado
cp ./mi-app.desktop AppDir/           # archivo .desktop
cp ./mi-app.png AppDir/               # icono

# linuxdeploy completa el AppDir automáticamente
./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage
# Resultado: Mi-App-x86_64.AppImage
```

### Instalación

```bash
# Descargar el AppImage de linuxdeploy (único archivo, sin dependencias)
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
chmod +x linuxdeploy-x86_64.AppImage

# Opcional: mover a ~/Applications/ o /usr/local/bin
mv linuxdeploy-x86_64.AppImage ~/Applications/
export PATH="$HOME/Applications:$PATH"
```

### Uso básico

```bash
# 1. Crear AppDir desde un binario ya compilado
./linuxdeploy-x86_64.AppImage \
  --appdir AppDir \
  --executable ./mi-app \
  --desktop-file ./mi-app.desktop \
  --icon-file ./mi-app.png \
  --output appimage

# 2. Si ya tienes un AppDir preparado (con make install DESTDIR=AppDir)
./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage

# 3. Solo completar dependencias (sin empaquetar aún)
./linuxdeploy-x86_64.AppImage --appdir AppDir

# 4. Especificar arquitectura
ARCH=x86_64 ./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage
```

### Plugins

El sistema de plugins es lo que hace potente a linuxdeploy. Se activan con `--plugin <nombre>`:

```bash
# Plugin Qt — empaqueta runtimes Qt5/Qt6, QML, plugins, estilos
./linuxdeploy-x86_64.AppImage --appdir AppDir --plugin qt --output appimage

# Plugin GTK — empaqueta runtimes GTK
./linuxdeploy-x86_64.AppImage --appdir AppDir --plugin gtk --output appimage

# Plugin Python — empaqueta intérprete Python + dependencias pip
./linuxdeploy-x86_64.AppImage --appdir AppDir --plugin python --output appimage

# Múltiples plugins a la vez
./linuxdeploy-x86_64.AppImage \
  --appdir AppDir \
  --plugin qt \
  --plugin python \
  --output appimage
```

| Plugin | Propósito | Ejemplo |
|---|---|---|
| `qt` | Qt5/Qt6 (widgets, QML, Quick, estilos, plataformas) | Apps Qt como Krita, OnlyOffice |
| `gtk` | GTK 2/3/4 + temas | Apps GTK como GIMP, Inkscape |
| `python` | Python3 + site-packages + numpy, etc. | Apps Python como Joplin |
| `ncurses` | Librerías ncurses | Apps TUI |
| `vst` | Plugins VST | Apps de audio |
| `perl` | Perl + módulos | Scripts Perl |
| `java` | JRE + dependencias Java | Apps Java |

```bash
# Listar plugins disponibles
./linuxdeploy-x86_64.AppImage --list-plugins

# Plugins se descargan por separado del repositorio:
# https://github.com/linuxdeploy/linuxdeploy-plugin-<nombre>
# Ejemplo para Qt:
wget https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage
chmod +x linuxdeploy-plugin-qt-x86_64.AppImage
```

### linuxdeploy avanzado

```bash
# Especificar directorio de salida para las librerías
./linuxdeploy-x86_64.AppImage --appdir AppDir --library-path /usr/local/lib

# Excluir librerías específicas (si sabes que sobran)
./linuxdeploy-x86_64.AppImage --appdir AppDir --exclude-library libGL.so.1

# Generar actualizaciones delta (zsync) para AppImageUpdate
./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage --update-info "gh-releases-zsync|usuario|repo|latest|*.AppImage.zsync"

# Modo verbose para depuración
VERBOSE=1 ./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage
```

---

## AppImageKit

### Qué es

**AppImageKit** es el conjunto de herramientas oficial del formato AppImage. Su componente principal es **appimagetool**, que toma un **AppDir** y lo empaqueta en un archivo `.AppImage` ejecutable.

Además de appimagetool, AppImageKit incluye herramientas auxiliares:

| Herramienta | Propósito |
|---|---|
| **appimagetool** | Convierte AppDir → AppImage |
| **AppImage** (binario) | Runtime ELF que monta y ejecuta el AppImage |
| **AppImageUpdate** | Actualizaciones delta de AppImages |
| **appimaged** | Demonio opcional de integración al escritorio |
| **validate** | Valida que un AppImage sea correcto |

### appimagetool

```bash
# Uso básico
./appimagetool-x86_64.AppImage AppDir/

# Especificar nombre de salida
./appimagetool-x86_64.AppImage AppDir/ Mi-App-x86_64.AppImage

# Con información de actualización (para AppImageUpdate)
./appimagetool-x86_64.AppImage \
  -u "gh-releases-zsync|usuario|repo|latest|*.AppImage.zsync" \
  AppDir/
```

### Compresión (gzip, xz, zstd)

El algoritmo de compresión del SquashFS interno es crucial para el balance **tamaño vs velocidad de arranque**:

| Algoritmo | Tamaño | Arranque | Uso recomendado |
|---|---|---|---|
| **gzip** | Mayor (~+15%) | **Más rápido** (<1s) | Apps que se ejecutan frecuentemente |
| **xz** | **Menor** (mejor compresión) | Más lento (~2-3s) | Apps grandes, descarga única |
| **zstd** | Medio (mejor que gzip) | Rápido (~1s) | **Mejor balance general** |

```bash
# Comprimir con gzip (arranque más rápido)
./appimagetool-x86_64.AppImage --comp gzip AppDir/

# Comprimir con xz (tamaño más pequeño, por defecto)
./appimagetool-x86_64.AppImage --comp xz AppDir/

# Comprimir con zstd (mejor balance)
./appimagetool-x86_64.AppImage --comp zstd AppDir/

# Sin compresión (solo para depuración)
./appimagetool-x86_64.AppImage --comp null AppDir/
```

### Opciones avanzadas de appimagetool

```bash
# Firmar el AppImage con GPG (verificación de integridad)
./appimagetool-x86_64.AppImage --sign AppDir/

# No firmar (por defecto no firma)
./appimagetool-x86_64.AppImage --no-sign AppDir/

# Especificar versión de runtime
./appimagetool-x86_64.AppImage --runtime-file /path/to/runtime AppDir/

# Archivo de actualización (zsync) para AppImageUpdate
./appimagetool-x86_64.AppImage --update-information "gh-releases-zsync|user|repo|tag|file.zsync" AppDir/

# Forzar arranque con FUSE (requiere fuse instalado)
./appimagetool-x86_64.AppImage --guess AppDir/  # detecta tipo de app

# Generar archivo .zsync además del .AppImage
./appimagetool-x86_64.AppImage --zsync AppDir/  # genera .zsync para actualizaciones delta

# El AppImage ya creado tiene opciones de runtime para inspeccionarse:
./Mi-App-x86_64.AppImage --appimage-list        # listar contenido del AppImage
./Mi-App-x86_64.AppImage --appimage-extract      # extraer contenido a squashfs-root/
```

### Actualizaciones (AppImageUpdate)

AppImageUpdate permite que los usuarios actualicen AppImages descargando solo las diferencias (delta):

```bash
# El desarrollador debe embeber la URL de actualización al crear el AppImage:
./appimagetool-x86_64.AppImage \
  -u "gh-releases-zsync|usuario|repo|latest|*.AppImage.zsync" \
  AppDir/

# El usuario actualiza:
./AppImageUpdate.AppImage ./Mi-App-x86_64.AppImage

# También desde línea de comandos:
./Mi-App-x86_64.AppImage --appimage-update  # si el update-info está embebido
```

Formatos de `update-info`:

| Formato | Descripción |
|---|---|
| `gh-releases-zsync\|user\|repo\|tag\|pattern` | GitHub Releases con zsync |
| `zsync\|https://ejemplo.com/app.AppImage.zsync` | URL directa de zsync |
| `gh-releases\|user\|repo\|tag\|pattern` | GitHub Releases (descarga completa) |

### appimaged

Demonio opcional que integra AppImages al escritorio automáticamente:

```bash
# Descargar appimaged
wget https://github.com/AppImage/appimaged/releases/download/continuous/appimaged-x86_64.AppImage
chmod +x appimaged-x86_64.AppImage

# Ejecutar (escanea ~/Applications/ y ~/Downloads/ por AppImages)
./appimaged-x86_64.AppImage &

# Detener
pkill appimaged
```

### Validar un AppImage

```bash
# Verificar que un AppImage es válido
./appimagetool-x86_64.AppImage --validate Mi-App-x86_64.AppImage

# Ver información del runtime
./Mi-App-x86_64.AppImage --appimage-version
file Mi-App-x86_64.AppImage  # debe decir "ELF 64-bit LSB executable... AppImage"

# Ver tipo de AppImage (Type 1 = ELF runtime, Type 2 = FUSE runtime)
readelf -h Mi-App-x86_64.AppImage | grep Type
```

---

## CI/CD — Automatización de builds

Integrar la creación de AppImages en un pipeline de CI/CD permite generar automáticamente el archivo portable en cada release.

### GitHub Actions

```yaml
# .github/workflows/build-appimage.yml
name: Build AppImage

on:
  push:
    tags:
      - 'v*'              # disparar en tags como v1.0.0
  workflow_dispatch:       # también manualmente

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout código
        uses: actions/checkout@v4
      
      - name: Instalar dependencias de compilación
        run: |
          sudo apt-get update
          sudo apt-get install -y \
            build-essential cmake \
            qtbase5-dev \
            file
      
      - name: Compilar proyecto
        run: |
          mkdir build && cd build
          cmake .. -DCMAKE_INSTALL_PREFIX=/usr
          make -j$(nproc)
          make install DESTDIR=$GITHUB_WORKSPACE/AppDir
      
      - name: Descargar linuxdeploy
        run: |
          wget -c https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
          chmod +x linuxdeploy-x86_64.AppImage
          
          # Si la app usa Qt:
          wget -c https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage
          chmod +x linuxdeploy-plugin-qt-x86_64.AppImage
      
      - name: Crear AppImage
        run: |
          # Copiar archivos necesarios al AppDir si no se hizo con make install
          cp $GITHUB_WORKSPACE/*.desktop $GITHUB_WORKSPACE/AppDir/
          cp $GITHUB_WORKSPACE/*.png $GITHUB_WORKSPACE/AppDir/
          
          # Ejecutar linuxdeploy con plugins
          ARCH=x86_64 ./linuxdeploy-x86_64.AppImage \
            --appdir AppDir \
            --plugin qt \
            --output appimage
      
      - name: Subir AppImage como artefacto
        uses: actions/upload-artifact@v4
        with:
          name: Mi-App-x86_64.AppImage
          path: ./*.AppImage
      
      - name: Publicar en Release
        if: startsWith(github.ref, 'refs/tags/')
        uses: softprops/action-gh-release@v2
        with:
          files: |
            ./*.AppImage
            ./*.zsync              # para actualizaciones delta
          generate_release_notes: true
```

### GitHub Actions (workflow mínimo sin compilación)

```yaml
# .github/workflows/appimage.yml
# Para apps en lenguajes interpretados (Python, Node.js, etc.)
name: Package AppImage

on:
  release:
    types: [published]

jobs:
  appimage:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      
      - name: Install dependencies
        run: pip install -r requirements.txt
      
      - name: Build AppImage con linuxdeploy-plugin-python
        run: |
          wget -c https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
          wget -c https://github.com/linuxdeploy/linuxdeploy-plugin-python/releases/download/continuous/linuxdeploy-plugin-python-x86_64.AppImage
          chmod +x linuxdeploy*.AppImage
          
          mkdir -p AppDir/usr/bin
          cp -r src/* AppDir/usr/bin/
          cp app.desktop AppDir/
          cp icon.png AppDir/
          
          ARCH=x86_64 ./linuxdeploy-x86_64.AppImage \
            --appdir AppDir \
            --plugin python \
            --output appimage
      
      - name: Upload Release Asset
        uses: softprops/action-gh-release@v2
        with:
          files: ./*.AppImage
```

### GitLab CI

```yaml
# .gitlab-ci.yml
stages:
  - build
  - package

variables:
  LINUXDEPLOY_URL: "https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage"

build:
  stage: build
  image: ubuntu:latest
  script:
    - apt-get update && apt-get install -y build-essential cmake qtbase5-dev
    - mkdir build && cd build
    - cmake .. -DCMAKE_INSTALL_PREFIX=/usr
    - make -j$(nproc)
    - make install DESTDIR=$CI_PROJECT_DIR/AppDir
  artifacts:
    paths:
      - AppDir/
    expire_in: 1 hour

package:
  stage: package
  image: ubuntu:latest
  needs: [build]
  script:
    - apt-get update && apt-get install -y wget file fuse3 libfuse2
    - wget -c "$LINUXDEPLOY_URL" -O linuxdeploy-x86_64.AppImage
    - chmod +x linuxdeploy-x86_64.AppImage
    
    # Si usa Qt, descargar plugin
    - wget -c "https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage"
    - chmod +x linuxdeploy-plugin-qt-x86_64.AppImage
    
    # Crear AppImage
    - cp $CI_PROJECT_DIR/*.desktop AppDir/ || true
    - cp $CI_PROJECT_DIR/*.png AppDir/ || true
    
    - ARCH=x86_64 ./linuxdeploy-x86_64.AppImage --appdir AppDir --plugin qt --output appimage
  
  artifacts:
    paths:
      - ./*.AppImage
    expire_in: 1 week
```

### Docker / Podman (build en contenedor)

```dockerfile
# Dockerfile para build reproducible de AppImage
FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y \
    build-essential cmake qtbase5-dev wget file

WORKDIR /app
COPY . .

RUN mkdir build && cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr && \
    make -j$(nproc) && \
    make install DESTDIR=/app/AppDir

# Etapa de empaquetado
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y wget file fuse libfuse2 && \
    wget -c https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage && \
    chmod +x linuxdeploy-x86_64.AppImage

COPY --from=builder /app/AppDir /app/AppDir
COPY --from=builder /app/*.desktop /app/AppDir/ 2>/dev/null || true
COPY --from=builder /app/*.png /app/AppDir/ 2>/dev/null || true

RUN ARCH=x86_64 /linuxdeploy-x86_64.AppImage --appdir /app/AppDir --output appimage

CMD ["/bin/bash"]
```

### Buenas prácticas de CI/CD

| Práctica | Por qué |
|---|---|
| **Compilar en el CI, no en local** | Reproducibilidad — evitar \"en mi máquina funciona\" |
| **Usar runners ubuntu-latest** | Mayor compatibilidad glibc (ubuntu 22.04+ tiene glibc moderna) |
| **Limpiar dependencias no necesarias** | AppImage más pequeño, arranque más rápido |
| **Probar el AppImage en el CI** | Ejecutar `./app.AppImage --appimage-help` para verificar que no se corrompe |
| **Generar .zsync para releases** | Permite actualizaciones delta con AppImageUpdate |
| **Firmar con GPG** | Los usuarios pueden verificar que el AppImage es tuyo |
| **Compilar con gzip** | Arranque más rápido para apps de escritorio (la velocidad de arranque importa más que el tamaño) |
| **Probar en varias distros** | Un AppImage que funciona en Ubuntu puede fallar en Debian antiguo |

---

## Comparativa: linuxdeploy vs appimagetool

| Aspecto | linuxdeploy | appimagetool |
|---|---|---|
| **Rollo principal** | Crear y mantener AppDirs | Empaquetar AppDir → AppImage |
| **Dependencias automáticas** | ✅ Sí (analiza con ldd) | ❌ No (solo empaqueta lo que hay) |
| **Plugins** | ✅ Qt, GTK, Python, ncurses, etc. | ❌ No tiene plugins |
| **Sistema de compresión** | Usa appimagetool internamente con `--output appimage` | ✅ Soporte nativo (gzip, xz, zstd, null) |
| **Firma GPG** | No | ✅ `--sign` |
| **Actualizaciones delta** | ✅ `--update-info` | ✅ `-u` / `--update-information` |
| **Validación** | No | ✅ `--validate` |
| **Facilidad de uso** | Alta (automatiza casi todo) | Media (requiere AppDir completo) |
| **Ideal para** | Desarrolladores que quieren automatizar | Empaquetado final, scripts simples |

**Recomendación**: usa **linuxdeploy** para el 90% de los casos (sobre todo si tienes Qt, GTK o Python). Usa **appimagetool** directamente solo si necesitas control total sobre la compresión o firma GPG.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `AppImageRun ... not executable` | El AppImage generado no tiene bit +x | `chmod +x AppName.AppImage` antes de ejecutar |
| `can't open shared object file` al arrancar | Falta alguna librería del toolkit en el AppDir | Añadir el paquete con `--include`/`-d` de linuxdeploy (p.ej. las .so de Qt/GTK) |
| FUSE no disponible (AppImage clásico) | FUSE desactivado (p.ej. en contenedores/chroot) | Extraer: `./App.AppImage --appimage-extract`; o usar `--appimage-extract-and-run` |
| `Wrong architecture`/se rompe en otra distro | Librerías ligadas a glibc de otra versión | Compilar con `--appimage-extract` y tratar de incluir glibc portátil o usar el modo `static` del toolkit |
| Icono/desktop no encontrado | Falta `.desktop` e icono en `usr/share/` | Crear `AppName.desktop` + iconos en sus rutas estándar y re-ejecutar linuxdeploy |
| Firma deshabilitada / no firma | GPG no configurado | Montar certificado con `--sign` y `GNUPGHOME`; o firmar después manualmente |

## Ver también

- [[AppImage]] — el formato de paquete portable: uso, integración, troubleshooting
- [[Snap y Flatpak]] — comparativa con otros formatos universales
- [[Gestores de Paquetes]] — visión general del ecosistema de paquetes en Linux
- [[Desarrollo en Linux (gcc make gdb strace)]] — compilación de software
- [[Git]] — control de versiones, integración con CI/CD
- [[Utilidades Base del Sistema]] — FUSE, squashfs

## Enlaces externos

- [linuxdeploy — GitHub](https://github.com/linuxdeploy/linuxdeploy)
- [linuxdeploy — Plugins](https://github.com/linuxdeploy/awesome-linuxdeploy)
- [linuxdeploy-plugin-qt — GitHub](https://github.com/linuxdeploy/linuxdeploy-plugin-qt)
- [linuxdeploy-plugin-gtk — GitHub](https://github.com/linuxdeploy/linuxdeploy-plugin-gtk)
- [linuxdeploy-plugin-python — GitHub](https://github.com/linuxdeploy/linuxdeploy-plugin-python)
- [AppImageKit — GitHub](https://github.com/AppImage/AppImageKit)
- [appimagetool — GitHub](https://github.com/AppImage/appimagetool)
- [AppImageUpdate — GitHub](https://github.com/AppImage/AppImageUpdate)
- [Documentación AppImage](https://docs.appimage.org/)
- [AppImageHub — Catálogo](https://appimage.github.io/)

#programa #paquetes #desarrollo
