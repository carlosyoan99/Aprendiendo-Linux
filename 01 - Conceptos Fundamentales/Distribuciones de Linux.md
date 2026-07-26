---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: concepto
prioridad: alta
---

# Distribuciones de Linux

> Una distribución (distro) es un sistema operativo completo basado en el kernel Linux, empaquetado con un gestor de paquetes, instalador, entorno gráfico y software preconfigurado. No existe "Linux" como producto — solo existen distribuciones.

## Definición

El kernel Linux por sí solo es inutilizable: es solo el núcleo del sistema. Una **distribución** empaqueta el kernel con:

- **GNU userland** (coreutils, bash, gcc, glibc)
- **Gestor de paquetes** (apt, pacman, dnf, zypper...)
- **Instalador** (Calamares, Anaconda, archinstall...)
- **Entorno gráfico** (GNOME, KDE, XFCE...)
- **Software adicional** (navegador, suite ofimática...)

```
┌─────────────────────────────────────────┐
│         Distribución (Ubuntu, Arch...)  │
│  ┌───────────────────────────────────┐  │
│  │  Software de usuario              │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │  GNU userland (coreutils)   │  │  │
│  │  │  ┌───────────────────────┐  │  │  │
│  │  │  │  Kernel Linux         │  │  │  │
│  │  │  └───────────────────────┘  │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

## Familias de distribuciones

Las distros se agrupan por origen y modelo de desarrollo:

| Familia | Base | Ejemplos |
|---|---|---|
| **Debian** | `.deb`, APT | Ubuntu, Linux Mint, Pop!_OS, Kali, Raspberry Pi OS |
| **Red Hat** | `.rpm`, DNF | Fedora, RHEL, CentOS, Rocky, AlmaLinux |
| **Arch** | `.pkg.tar.zst`, Pacman | Arch, Manjaro, EndeavourOS, CachyOS |
| **SUSE** | `.rpm`, Zypper | openSUSE Leap, openSUSE Tumbleweed |
| **Independent** | Propio | Alpine, Void, Gentoo, NixOS, Slackware |
| **Immutable** | Inmutable | Fedora Silverblue, Vanilla OS, Bazzite |

## Modelo de lanzamiento

| Modelo | Descripción | Ejemplos |
|---|---|---|
| **Rolling release** | Actualizaciones continuas, sin "versiones" | Arch, Manjaro, Tumbleweed, Void |
| **Fixed release** | Versiones con soporte definido (LTS o no) | Ubuntu, Fedora, Debian |
| **Semi-rolling** | Rolling con estabilización periódica | openSUSE Leap, Solus |

## Las 5 distribuciones más importantes

| Distro | Familia | Público | Init | Por qué importa |
|---|---|---|---|---|
| **Ubuntu** | Debian | Principiantes → servidores | systemd | La distro más usada del mundo, referencia de Linux |
| **Debian** | — | Servidores, estabilidad | systemd | La "madre" de Ubuntu, puro software libre |
| **Fedora** | Red Hat | Desarrolladores, innovación | systemd | Laboratorio de RHEL, siempreanguardia |
| **Arch Linux** | — | Avanzados, minimalismo | systemd | Rolling, AUR, wiki legendaria |
| **Alpine Linux** | Independent | Contenedores, seguridad | OpenRC | Mínima (5MB), musl libc, ideal para Docker |

## Tabla comparativa amplia

| Aspecto | Ubuntu | Debian | Fedora | Arch | Alpine | openSUSE | Mint | NixOS |
|---|---|---|---|---|---|---|---|---|
| **Base** | Debian | — | — | — | — | — | Ubuntu | Nix |
| **Paquetes** | apt | apt | dnf | pacman | apk | zypper | apt | nix |
| **Modelo** | Fixed | Fixed | Fixed | Rolling | Rolling | Semi-rolling | Fixed | Rolling |
| **Facilidad** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐ |
| **Estabilidad** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Actualizaciones** | Cada 6 meses | Cada 2 años | Cada 6 meses | Continuas | Continuas | Continuas/15mo | Cada 6 meses | Continuas |
| **Paquetes** | 60k+ | 60k+ | 50k+ | 50k+ (AUR: 80k+) | ~15k | 60k+ | 60k+ | ~100k (Nix) |

## Cómo elegir una distribución

```
¿Eres principiante?
├── SÍ → ¿Quieres algo tipo Windows?
│   ├── SÍ → Linux Mint o Zorin OS
│   └── NO → Ubuntu o Fedora
└── NO → ¿Necesitas estabilidad máxima?
    ├── SÍ → Debian Stable o Rocky Linux
    └── NO → ¿Quieres control total?
        ├── SÍ → Arch Linux o Gentoo
        └── NO → ¿Para servidores/contenedores?
            ├── SÍ → Alpine Linux o Debian minimal
            └── NO → Fedora o openSUSE
```

## Casos prácticos

### Probar una distro sin instalar (Live USB)
```bash
# Crear USB booteable con Ubuntu
sudo dd if=ubuntu-24.04-desktop-amd64.iso of=/dev/sdX bs=4M status=progress
# O con Ventoy — copiar ISO directamente al USB
```

Ver [[Creación de USB Booteable]].

### Cambiar de distro sin perder datos
```bash
# 1. Respaldar home
rsync -av --progress /home/ /mnt/backup/

# 2. Respaldar lista de paquetes instalados
# Debian/Ubuntu:
dpkg --get-selections > ~/paquetes.txt
# Arch:
pacman -Qqen > ~/paquetes.txt
# Fedora:
dnf list installed > ~/paquetes.txt

# 3. Instalar la nueva distro (preservando /home si es posible)
```

### Ver qué distro estás usando
```bash
# Métodos para identificar la distro
cat /etc/os-release            # información detallada
lsb_release -a                 # LSB info (si está instalado)
hostnamectl                    # systemd way
```

## Notas personales

- No existe "la mejor distro" — cada una optimiza para un caso de uso diferente.
- Ubuntu es la puerta de entrada más segura para principiantes.
- Arch Linux tiene la mejor wiki de Linux (se usa aunque no uses Arch).
- Para servidores: Debian o Rocky Linux. Para desktop: Ubuntu o Fedora.
- Las distros immutable (Silverblue, Bazzite) son el futuro — el sistema no se rompe.

## Enlaces externos
- [DistroWatch](https://distrowatch.com/) — rankings, comparativas, historial
- [Wikipedia — Linux distribution](https://en.wikipedia.org/wiki/Linux_distribution)
- [Arch Wiki — Distribution comparison](https://wiki.archlinux.org/title/Arch_Linux_based_distributions)
- [Which Linux Distribution Should I Use?](https://wiki.archlinux.org/title/Frequently_asked_questions)

## Ver también
- [[Que es Linux]] — qué es el kernel Linux
- [[GNU y Linux]] — la otra mitad del sistema operativo
- [[Gestores de Paquetes]] — apt, pacman, dnf, zypper comparados
- [[Proceso de Instalación General]] — cómo instalar cualquier distro
- [[De Windows a Linux]] — migración para usuarios de Windows
- [[Ubuntu]], [[Debian]], [[Arch Linux]], [[Fedora]], [[Alpine Linux]] — notas individuales

#concepto
