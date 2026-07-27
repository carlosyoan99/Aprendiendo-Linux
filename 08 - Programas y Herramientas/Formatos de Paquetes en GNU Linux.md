---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: media
---

# Formatos de Paquetes en GNU/Linux

## Definición

Un **formato de paquete** es un tipo de archivo que contiene software empaquetado junto con **metadatos** (nombre, versión, dependencias, scripts de instalación/eliminación) que los gestores de paquetes utilizan para instalarlo, actualizarlo o eliminarlo del sistema.

Cada gran familia de distribuciones tiene su propio formato, aunque los conceptos internos son similares:

- **Paquete binario**: contiene el software ya compilado listo para instalar
- **Paquete fuente**: contiene el código fuente y las instrucciones para compilarlo

> Para los comandos y herramientas que manejan estos paquetes, ver [[Gestores de Paquetes]].

---

## .deb — Debian / Ubuntu y derivados

**`.deb`** es el formato de paquete de Debian y sus derivados (Ubuntu, Linux Mint, Pop!_OS, etc.). Fue creado por Ian Jackson en 1993.

### Anatomía interna

Un `.deb` es en realidad un archivo **ar** (Unix archive) que contiene tres archivos:

```
paquete_1.0-1_amd64.deb
┌──────────────────────────┐
│  debian-binary           │ ← archivo de texto con \"2.0\\n\"
├──────────────────────────┤
│  control.tar.gz (o .zst) │ ← metadatos del paquete
├──────────────────────────┤
│  data.tar.gz (o .zst)    │ ← los archivos reales a instalar
└──────────────────────────┘
```

```bash
# Inspeccionar un .deb
ar t paquete.deb                          # listar contenido del ar archive
ar x paquete.deb                          # extraer los 3 archivos

# Ver metadatos (sin extraer)
dpkg-deb --info paquete.deb               # info del paquete
dpkg-deb --field paquete.deb Version       # campo específico
dpkg-deb --contents paquete.deb            # listar archivos que instalará

# Extraer solo el contenido (data.tar.*)
dpkg-deb --extract paquete.deb ./dir       # extrae los archivos sin scripts
dpkg-deb --vextract paquete.deb ./dir      # extrae con verbose
```

### Estructura de control.tar.gz

```
control.tar.gz
├── control           ← metadatos: Package, Version, Depends, Description...
├── md5sums           ← checksums de cada archivo del paquete
├── postinst          ← script ejecutado después de instalar
├── preinst           ← script ejecutado antes de instalar
├── postrm            ← script ejecutado después de eliminar
├── prerm             ← script ejecutado antes de eliminar
├── conffiles         ← lista de archivos de configuración
└── shlibs            ← dependencias de librerías compartidas
```

### Convención de nombres

```
<nombre>_<versión>_<arquitectura>.deb
     ↓         ↓           ↓
  firefox_126.0_amd64.deb

<mozilla-firefox_1.0.6.package.deb>

<paquete>_<versión>-<revisión>_<arquitectura>.deb
  openssh-client_9.3p1-1_amd64.deb
```

### Scripts de mantenimiento

Los scripts (`preinst`, `postinst`, `prerm`, `postrm`) son **scripts shell** que dpkg ejecuta en momentos específicos:

| Script | Cuándo se ejecuta | Uso típico |
|---|---|---|
| `preinst` | Antes de descomprimir el paquete | Detener servicios, crear usuarios |
| `postinst` | Después de instalar los archivos | Configurar, iniciar servicios, actualizar cache |
| `prerm` | Antes de eliminar el paquete | Detener servicios |
| `postrm` | Después de eliminar los archivos | Limpiar config, eliminar usuarios |

```bash
# Ver scripts de un .deb sin instalarlo
dpkg-deb --info paquete.deb | grep -A 20 '^ Scripts'
# O más directo:
ar p paquete.deb control.tar.gz | tar xz --to-stdout ./postinst
```

---

## .rpm — Red Hat / Fedora / openSUSE / CentOS

**`.rpm`** (RPM Package Manager, inicialmente Red Hat Package Manager) es el formato usado por Red Hat, Fedora, CentOS, Rocky Linux, openSUSE, Mageia y derivados. Es parte del **Linux Standard Base (LSB)**.

### Anatomía interna

Un `.rpm` tiene cuatro secciones principales:

```
paquete-1.0-1.x86_64.rpm
┌──────────────┐
│  Lead        │ ← Magic number + firma (obsoleto, solo compatibilidad)
├──────────────┤
│  Signature   │ ← Firma GPG/MD5 del encabezado y payload
├──────────────┤
│  Header      │ ← Metadatos (nombre, versión, dependencias, scripts...)
├──────────────┤
│  Payload     │ ← Archivos comprimidos (cpio + gz/bz2/xz/zstd)
└──────────────┘
```

A diferencia de `.deb` (que separa control y datos en archivos distintos), `.rpm` usa un solo **header** binario que contiene todos los metadatos en formato de *tags* indexadas, seguido del payload comprimido.

```bash
# Inspeccionar un .rpm
rpm -qip paquete.rpm                      # información detallada
rpm -qlp paquete.rpm                      # listar archivos que contiene
rpm -qcp paquete.rpm                      # archivos de configuración
rpm -qdp paquete.rpm                      # archivos de documentación

# Ver scripts
rpm -qp --scripts paquete.rpm

# Ver dependencias
rpm -qpR paquete.rpm                      # REQUIRES
rpm -qpP paquete.rpm                      # PROVIDES (si el flag existe)

# Verificar firma
rpm -K paquete.rpm                        # checks GPG + MD5

# Extraer contenido (sin instalar)
rpm2cpio paquete.rpm | cpio -idmv        # extrae todo en el dir actual

# Ver el header en crudo
rpm -qpi --changelog paquete.rpm          # changelog del paquete
```

### Convención de nombres

```
<nombre>-<versión>-<release>.<arquitectura>.rpm
   ↓        ↓          ↓          ↓
firefox-126.0-1.fc40.x86_64.rpm

Partes:
firefox         = nombre del paquete
126.0           = versión del programa
1               = release/revisión del empaquetado
fc40            = distribución destino (Fedora 40)
x86_64          = arquitectura

Otros sufijos de arquitectura:
- noarch → independiente de arquitectura (scripts, docs)
- i686   → 32-bit
- aarch64 → ARM 64-bit
- src    → SRPM (fuentes, no binario)
```

### Tags del header RPM

El header RPM contiene cientos de *tags* indexadas. Las más importantes:

| Tag ID | Nombre | Ejemplo |
|---|---|---|
| 1000 | NAME | firefox |
| 1001 | VERSION | 126.0 |
| 1002 | RELEASE | 1.fc40 |
| 1004 | SUMMARY | Mozilla Firefox Web Browser |
| 1014 | LICENSE | MPL-2.0 |
| 1020 | REQUIRENAME | libc.so.6, libstdc++.so.5 |
| 1042 | OLDFILENAMES | /usr/bin/firefox |

```bash
# Ver las tags del header
rpm -qpi paquete.rpm | head -30          # muestra los tags legibles
```

### SRPM (Source RPM)

Los `.src.rpm` contienen el código fuente, el spec file y los parches para reconstruir el paquete:

```bash
# Instalar un SRPM (pone los fuentes en ~/rpmbuild/)
rpm -i paquete-1.0-1.src.rpm

# Reconstruir el binario
cd ~/rpmbuild/SPECS
rpmbuild -ba paquete.spec                # construye binario + SRPM

# Los SRPMs son verificables: puedes auditar el código fuente
# y reconstruir el binario exacto
```

---

## .pkg.tar.zst — Arch Linux

**`.pkg.tar.zst`** es el formato de paquete de Arch Linux y derivados, manejado por [[Gestores de Paquetes#Comparativa por distro|pacman]]. Es simplemente un tarball comprimido con **zstd**.

### Anatomía interna

```
paquete-1.0-1-x86_64.pkg.tar.zst
┌──────────────────────────┐
│  .PKGINFO                │ ← metadatos (nombre, versión, dependencias...)
├──────────────────────────┤
│  .INSTALL                │ ← scripts opcionales (pre/post install/remove)
├──────────────────────────┤
│  .MTREE                  │ ← árbol de archivos con checksums (opcional)
├──────────────────────────┤
│  (directorios y archivos)│ ← el contenido real a instalar
└──────────────────────────┘
```

```bash
# Inspeccionar un paquete de Arch
tar -tf paquete-1.0-1-x86_64.pkg.tar.zst   # listar contenido
tar -xf paquete-1.0-1-x86_64.pkg.tar.zst   # extraer

# Ver metadatos
tar -xO paquete-1.0-1-x86_64.pkg.tar.zst .PKGINFO

# El .PKGINFO tiene este formato:
# pkgname = firefox
# pkgver = 126.0-1
# pkgdesc = Standalone web browser from mozilla.org
# url = https://www.mozilla.org/firefox
# builddate = 1717858800
# packager = Jan Alexander Steffens (heftig) <heftig@archlinux.org>
# size = 123456789
# license = MPL-2.0
# depend = nss
# depend = alsa-lib
```

### .PKGINFO — metadatos

Es un archivo de texto con pares clave=valor. Contiene:

```bash
# Campos típicos de .PKGINFO
pkgname = firefox
pkgver = 126.0-1
pkgdesc = Mozilla Firefox Web Browser
url = https://www.mozilla.org/
builddate = 1717858800
packager = John Doe <johndoe@archlinux.org>
size = 201234567
arch = x86_64
license = MPL-2.0
depend = gtk3
depend = libx11
depend = libxcb
depend = alsa-lib
depend = nss>=3.79
optdepend = libnotify: desktop notification support
provides = firefox=126.0
conflict = firefox-developer-edition
```

### Compresión

Históricamente Arch usó `.pkg.tar.gz` (gzip), luego `.pkg.tar.xz` (LZMA2) desde mayo de 2010, y desde 2019 migró a **zstd** (`.pkg.tar.zst`) por ser más rápido de comprimir/descomprimir con ratios similares.

```bash
# Comparativa de velocidad de compresión
# gzip: lento al comprimir, rápido al descomprimir
# xz:  muy lento al comprimir, lento al descomprimir, ~30% más pequeño
# zstd: rápido en ambos sentidos, ratio cercano a xz
```

---

## Tabla comparativa de formatos

| Formato | Usado por | Compresión | Metadatos | Scripts | Estructura |
|---|---|---|---|---|---|
| **.deb** | Debian, Ubuntu, Mint | gz/bz2/xz/zst | `control.tar.gz` | pre/post inst/rm | ar archive (3 partes) |
| **.rpm** | Fedora, RHEL, openSUSE | gz/bz2/xz/zst | Header binario (tags) | pre/post inst/uninst | Header + cpio payload |
| **.pkg.tar.zst** | Arch, Manjaro, EndeavourOS | zstd (antes xz/gz) | `.PKGINFO` texto | `.INSTALL` | tarball con metadatos |
| **.apk** | Alpine Linux | gz/xz | `.PKGINFO` | pre/post scripts | tarball + `.SIGN.RSA.xxx` |
| **.txz** | Slackware | xz | `doinst.sh` (incluido en tarball) | `doinst.sh` | tarball simple |
| **.ebuild** | Gentoo | No aplica (fuente) | Script Bash | En el ebuild | Script + dependencias |
| **Flatpak** | Multi-distro | OSTree + gpg | `metadata` + `.flatpak-info` | No (sandbox) | OSTree + bundle |
| **Snap** | Multi-distro | SquashFS | `meta/snap.yaml` | `snapcraft.yaml` | SquashFS + snap mount |
| **AppImage** | Multi-distro | SquashFS | `AppInfo` | No | ELF + SquashFS |

### Otros formatos

| Formato | Distro | Estado |
|---|---|---|
| **.apk** | Alpine Linux | Activo — formato simple basado en tarball con firma GPG |
| **.txz** | Slackware | Activo — el más simple de todos, solo tarball + scripts de instalación en `/var/log/packages/` |
| **.ebuild** | Gentoo | Activo — no es binario, es un script Bash que describe cómo compilar desde fuente |
| **eopkg** | Solus | Activo — fork de PiSi (Pardus), basado en XML + tarball |
| **.pkg.tar.gz** | Arch (histórico) | Obsoleto — reemplazado por .xz en 2010 y .zst en 2019 |
| **PiSi** | Pardus (histórico) | Obsoleto — Pardus migró a Debian |
| **PUP/PET** | Puppy Linux | Activo — PET = Puppy Enhanced Tarball, formato comprimido |
| **.fpm** | Frugalware | Obsoleto — Frugalware descontinuado |

---

## Paquetes fuente vs binarios

| Característica | Binario (.deb, .rpm) | Fuente (PKGBUILD, ebuild, spec) |
|---|---|---|
| **Contiene** | Programa ya compilado | Código fuente + instrucciones |
| **Instalación** | Rápida (descomprimir) | Lenta (compilar) |
| **Optimización** | Genérica (para cualquier CPU) | Específica (para tu CPU exacta) |
| **Verificable** | Firmas GPG | Puedes auditar el código fuente |
| **Dependencias** | Se resuelven automáticamente | Se resuelven automáticamente |
| **Tamaño** | Pequeño | Variable (depende de las fuentes) |
| **Ejemplo** | `firefox_126.0_amd64.deb` | PKGBUILD + parches |

---

## Conversión entre formatos

**Alien** es la herramienta clásica para convertir entre formatos:

```bash
# Instalar alien
sudo apt install alien                     # Debian/Ubuntu
sudo pacman -S alien                       # Arch (AUR)

# Convertir .rpm → .deb
sudo alien --to-deb paquete-1.0-1.x86_64.rpm

# Convertir .deb → .rpm
sudo alien --to-rpm paquete_1.0-1_amd64.deb

# Convertir .deb → .tgz (tarball genérico)
sudo alien --to-tgz paquete_1.0-1_amd64.deb

# Convertir y también instalar
sudo alien -i paquete-1.0-1.x86_64.rpm    # convierte a .deb e instala
```

> ⚠️ **Alien no es recomendado para paquetes críticos del sistema**. Las convenciones de nombres de rutas, dependencias y scripts son distintas entre formatos. Usar Alien puede producir un paquete funcional pero mal integrado. Preferir siempre el formato nativo de tu distro.

Conversión manual (sin Alien):

```bash
# Extraer contenido de cualquier formato e instalarlo manualmente
# .deb
dpkg-deb --extract paquete.deb ./dir
sudo cp -r dir/* /

# .rpm
rpm2cpio paquete.rpm | cpio -idmv
sudo cp -r * /

# .pkg.tar.zst
tar -xf paquete.pkg.tar.zst
sudo cp -r * /
```

---

## Ver también

- [[Gestores de Paquetes]] — herramientas que manejan estos formatos
- [[Debian]] — formato .deb
- [[Arch Linux]] — formato .pkg.tar.zst + PKGBUILDs
- [[Gentoo]] — formato ebuild
- [[Alpine Linux]] — formato .apk
- [[Slackware]] — formato .txz
- [[Snap y Flatpak]] — formatos portables
- [[AppImage]] — formato portable autónomo
- [[Compilación desde Código Fuente]] — cuando no hay paquete

## Enlaces externos

- [Wikipedia: Formatos de paquetes en GNU/Linux](https://es.wikipedia.org/wiki/Formatos_de_paquetes_en_GNU/Linux)
- [Debian Policy Manual — control.tar.gz](https://www.debian.org/doc/debian-pkg-binary-pkg.html)
- [RPM Packaging Guide](https://rpm-packaging-guide.github.io/)
- [Arch PKGBUILD reference](https://wiki.archlinux.org/title/PKGBUILD)
- [Alien — conversión entre formatos](https://wiki.debian.org/Alien)

#programa #paquetes #formatos
