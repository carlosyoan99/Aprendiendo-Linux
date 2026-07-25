---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: xbps
base: Independiente
---

# Void Linux

## Qué es

**Void Linux** es una distribución **rolling** independiente, conocida por su velocidad y simplicidad. Usa **runit** como sistema de init (no systemd) y **xbps** (X Binary Package System) como gestor de paquetes. Es la alternativa moderna preferida por quienes quieren evitar systemd sin sacrificar un sistema actualizado.

Creada por **Juan Romero Pardines** (ex-desarrollador de NetBSD) en 2008. Void comenzó como un proyecto personal para probar xbps y creció hasta convertirse en una distribución popular dentro del nicho "no systemd".

## Filosofía

- **Sin systemd**: usa runit, que sigue el principio Unix de hacer una cosa y hacerla bien
- **Rolling pero estable**: las actualizaciones son continuas pero se prueban antes de liberarse
- **Simplicidad BSD**: la filosofía de diseño se acerca más a BSD que a Linux tradicional
- **Rápido por diseño**: xbps es significativamente más rápido que apt/pacman en operaciones grandes
- **Independiente**: no deriva de ninguna otra distribución

## Gestor de paquetes: xbps

```bash
# Sincronizar repositorios
sudo xbps-install -S

# Instalar paquetes
sudo xbps-install firefox
sudo xbps-install -S firefox          # sincronizar + instalar

# Actualizar sistema
sudo xbps-install -Su

# Buscar paquetes
xbps-query -Rs firefox

# Información de paquete
xbps-query -i firefox                 # versión, dependencias, tamaño
xbps-query -p pkgver firefox          # campo específico

# Eliminar paquete
sudo xbps-remove firefox
sudo xbps-remove -O                    # limpiar caché de paquetes
sudo xbps-remove -o                    # eliminar paquetes huérfanos

# Listar paquetes instalados
xbps-query -l | wc -l
```

### Repositorios

Void tiene repos oficiales y un **template system** para compilar desde fuente (similar a los PKGBUILD de Arch):

```bash
# Repos disponibles:
# https://repo-default.voidlinux.org/current/
# https://repo-default.voidlinux.org/current/multilib/
# https://repo-default.voidlinux.org/current/nonfree/

# Habilitar nonfree (drivers NVIDIA, firmware)
sudo xbps-install -S void-repo-nonfree
sudo xbps-install -S nvidia
```

## Init: runit

runit gestiona servicios con un enfoque minimalista:

```bash
# Estado de un servicio
sudo sv status dhcpcd

# Iniciar/detener/reiniciar
sudo sv start dhcpcd
sudo sv stop dhcpcd
sudo sv restart dhcpcd

# Habilitar servicio (crear symlink en /var/service/)
sudo ln -s /etc/sv/dhcpcd /var/service/

# Deshabilitar servicio
sudo rm /var/service/dhcpcd

# Ver todos los servicios activos
ls /var/service/
```

## Instalación

```bash
# 1. Descargar ISO desde https://voidlinux.org/download/
#    - void-live-x86_64-*.iso (con GUI: XFCE, GNOME, Cinnamon, MATE, Qt)
#    - void-live-x86_64-musl-*.iso (musl libc, no glibc)

# 2. Grabar en USB
sudo dd if=void-live-x86_64-*.iso of=/dev/sdX bs=4M status=progress

# 3. Arrancar e instalar usando el instalador gráfico (calamares)
#    o manualmente con el script `void-installer` desde terminal

# 4. Post-instalación
sudo xbps-install -Su                 # actualizar todo
sudo xbps-install void-repo-nonfree   # repos nonfree
sudo xbps-install void-repo-multilib  # soporte 32-bit

# 5. Configurar servicios
sudo ln -s /etc/sv/dhcpcd /var/service/
sudo ln -s /etc/sv/sshd /var/service/
```

## Características únicas

### musl vs glibc

Void es una de las pocas distribuciones que ofrece ISOs con **musl libc** (alternativa a glibc, más pequeña y enfocada en cumplir estándares POSIX). Ideal para sistemas embebidos o contenedores.

```bash
# Verificar libc
ldd --version
# glibc: "ldd (GNU libc) 2.39"
# musl:  "musl libc (x86_64)"
```

### Binary bootstrap

Void tiene uno de los sistemas de compilación de paquetes más avanzados: **xbps-src**, que permite construir paquetes desde fuente con gestión de dependencias y entornos chroot.

```bash
git clone https://github.com/void-linux/void-packages.git
cd void-packages
./xbps-src binary-bootstrap
./xbps-src pkg firefox
```

## Tabla comparativa

| Aspecto | Void Linux | Arch Linux | Gentoo |
|---|---|---|---|
| **Gestor** | xbps | pacman | Portage (emerge) |
| **Init** | **runit** | systemd | OpenRC / systemd |
| **Tipo** | Binario (rolling) | Binario (rolling) | Source (rolling) |
| **Instalación** | Manual o Calamares | archinstall o manual | Manual (Handbook) |
| **libc** | glibc o **musl** | glibc | glibc |
| **Tamaño base** | ~400 MB | ~1 GB | ~300 MB |
| **Curva** | Media | Baja-media | Alta |
| **Velocidad paquetes** | Muy rápida | Rápida | Lenta (compila) |

## Ver también

- [[Arch Linux]] — alternativa rolling binaria con systemd
- [[Gentoo]] — alternativa rolling source-based
- [[Alpine Linux]] — distro con musl y apk
- [[Distros adicionales (Gentoo Slackware Void Solus MX Linux Zorin elementary Kali Parrot Tails)]]

## Enlaces externos

- [Void Linux — Página oficial](https://voidlinux.org/)
- [Void Handbook](https://docs.voidlinux.org/)
- [xbps — Documentación](https://github.com/void-linux/xbps)
- [runit — Página oficial](http://smarden.org/runit/)
- [Void Packages — GitHub](https://github.com/void-linux/void-packages)
- [Wikipedia — Void Linux](https://en.wikipedia.org/wiki/Void_Linux)

#distro
