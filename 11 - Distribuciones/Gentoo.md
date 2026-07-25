---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: Portage (emerge)
base: Independiente
---

# Gentoo

## Qué es

**Gentoo** es una distribución **source-based**: todo el software se **compila desde código fuente** optimizado para tu hardware específico. Ofrece el máximo control sobre el sistema mediante **USE flags**, que activan o desactivan características de cada paquete.

Fundada por **Daniel Robbins** en 2000 (basada inicialmente en Enoch Linux), Gentoo sigue el modelo **rolling release**: no hay versiones discretas, el sistema se actualiza continuamente.

## Filosofía

- **Máximo control**: tú decides qué características tiene cada paquete (USE flags), qué está instalado y cómo se compila
- **Optimización nativa**: CFLAGS específicas para tu CPU (march=native, -O2, -pipe)
- **Aprendizaje profundo**: instalar Gentoo te obliga a entender cada componente del sistema
- **Rolling release**: un `emerge --sync && emerge -uDN @world` y estás al día

## Gestor de paquetes: Portage

```bash
# Sincronizar repositorio
emerge --sync

# Instalar paquetes
emerge --ask www-client/firefox        # Firefox (compila desde fuente)
emerge --ask --oneshot sys-devel/gcc   # actualizar GCC

# Actualizar sistema
emerge --update --deep --newuse @world

# Buscar paquetes
emerge --search firefox

# Eliminar
emerge --ask --depclean www-client/firefox

# Ver dependencias
emerge --pretend --verbose www-client/firefox
```

### USE flags

Las USE flags son el corazón de Gentoo. Definen qué características incluir al compilar:

```bash
# /etc/portage/make.conf
USE="-kde -gnome alsa pulseaudio wifi X wayland pipewire vulkan"

# Flags por paquete (en /etc/portage/package.use/)
www-client/firefox wayland gecko-audio
media-video/ffmpeg x264 x265 vpx fdk
```

### Keywords

```bash
# ~amd64 = testing (últimas versiones)
# amd64  = estable

# Marcar paquete como testing
echo "www-client/firefox ~amd64" >> /etc/portage/package.accept_keywords
```

## Instalación

Gentoo se instala siguiendo el **Handbook**, paso a paso manualmente:

```bash
# 1. Descargar stage3 (tarball base)
# 2. Particionar y formatear
# 3. Descomprimir stage3
# 4. Configurar make.conf (CHOST, CFLAGS, MAKEOPTS, USE)
# 5. Chroot al nuevo sistema
# 6. emerge --sync
# 7. Configurar kernel (manual o con genkernel)
# 8. Configurar fstab, hostname, red
# 9. Configurar bootloader (GRUB)
# 10. Establecer contraseña root
# 11. emerge @world (actualizar todo)
```

## Ciclo de lanzamiento

**Rolling release** con dos ramas:
- **Stable** (`amd64`): paquetes probados, más estables pero ligeramente desactualizados
- **Testing** (`~amd64`): últimas versiones, puede tener problemas de dependencias

## Tabla comparativa

| Aspecto | Gentoo | Arch Linux | Void Linux |
|---|---|---|---|
| **Tipo** | Source-based | Binario | Binario |
| **Gestor** | Portage (emerge) | pacman | xbps |
| **Init** | OpenRC (default) / systemd | systemd | runit |
| **Instalación** | Manual (Handbook) | Manual (archinstall) | Manual |
| **Control** | Máximo (USE flags) | Alto | Alto |
| **Tiempo instalar** | Horas-días (compilaciones) | 30-60 min | 30-60 min |

## Portage en profundidad

Portage (el comando `emerge`) es el corazón de Gentoo, inspirado en los **ports de FreeBSD**. Escrito en Python y Bash.

### Características avanzadas

| Característica | Descripción |
|---|---|
| **USE flags** | Activar/desactivar características de cada paquete al compilar |
| **SLOTs** | Múltiples versiones del mismo paquete pueden coexistir |
| **Sandbox** | Compilación aislada para evitar contaminar el sistema |
| **Paquetes virtuales** | Dependencias abstractas (ej: `virtual/ffmpeg`) |
| **Perfiles** | Configuración global del sistema (13.0, 17.0, 17.1) |
| **Binarios** | Desde 2023: repositorios binarios oficiales (opcional) |
| **Gestión de config** | Protege archivos de configuración modificados |

### Perfiles de sistema

| Perfil | Lanzamiento | Novedades |
|---|---|---|
| 13.0 | Febrero 2013 | Establecimiento de perfiles modernos |
| 17.0 | Noviembre 2017 | C++14 y PIE por defecto |
| 17.1 | Diciembre 2017 | Layout multilib alterado para amd64 |

### Hardened Gentoo

Proyecto para instilaciones orientadas a seguridad:
- **SELinux** integrado
- Hardening de espacio de usuario (compilación con flags de seguridad)
- Anteriormente incluía parches del kernel, descontinuados

### Uso de binarios

Desde diciembre 2023, Gentoo ofrece **paquetes binarios oficiales** para quienes no quieran compilar todo desde fuente:

```bash
# Configurar repositorio binario
# en /etc/portage/make.conf:
FEATURES="getbinpkg"
EMERGE_DEFAULT_OPTS="--usepkg"
```

## Incidentes de seguridad

En junio de 2018, el espejo GitHub del repositorio de Gentoo fue comprometido por un atacante que obtuvo acceso a la cuenta de un administrador. La respuesta fue rápida: no se comprometieron claves criptográficas ni paquetes firmados. El repositorio se restauró en 5 días.

## Distribuciones basadas en Gentoo

- **Funtoo Linux** — fork liderado por Daniel Robbins tras conflictos
- **Calculate Linux** — orientada a entornos corporativos
- **Pentoo** — distribución de pentesting basada en Gentoo
- **SystemRescue** — CD de rescate, usa Portage
- **Sabayon Linux** — fork con binarios precompilados (hoy descontinuada)

## Ver también

- [[Arch Linux]] — alternativa rolling binaria
- [[Compilacion desde Codigo Fuente]] — relevante para Gentoo
- [[CachyOS]] — Arch optimizado con CFLAGS
- [[Distros adicionales (Gentoo Slackware Void Solus MX Linux Zorin elementary Kali Parrot Tails)]]
- [[Genkernel]] — configuración automática del kernel para Gentoo

## Enlaces externos

- [Gentoo — Página oficial](https://www.gentoo.org/)
- [Gentoo Wiki](https://wiki.gentoo.org/)
- [Gentoo Handbook](https://wiki.gentoo.org/wiki/Handbook:AMD64)
- [Portage — Documentación](https://wiki.gentoo.org/wiki/Portage)
- [Gentoo binario — Anuncio 2023](https://www.gentoo.org/news/2023/12/29/Gentoo-binary.html)

#distro
