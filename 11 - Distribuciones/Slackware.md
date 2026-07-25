---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: distribucion
prioridad: alta
gestor_paquetes: pkgtools / slackpkg / slackpkg+
base: Independiente
---

# Slackware

## Qué es

**Slackware** es la distribución Linux activa más antigua (1993), creada por **Patrick Volkerding**. Su filosofía es la **simplicidad y fidelidad a Unix**: no oculta la complejidad del sistema bajo capas de abstracción. Sigue el principio **KISS** (Keep It Simple, Stupid).

A diferencia de la mayoría de distros modernas, Slackware **no usa systemd** — emplea scripts de inicio estilo BSD (`/etc/rc.d/`). Tampoco realiza resolución automática de dependencias en sus herramientas oficiales.

```bash
┌─────────────────────────────────────────────────┐
│                Slackware Linux                    │
├─────────────────────────────────────────────────┤
│  1993 — Patrick Volkerding lanza la primera      │
│         versión (basada en SLS Linux)            │
│  2005 — Slackware 10.2                            │
│  2009 — Slackware 13.0 (primera x86_64 oficial)  │
│  2016 — Slackware 14.2                            │
│  2022 — Slackware 15.0 (versión estable actual)  │
│  2026 — Slackware-current en desarrollo activo   │
└─────────────────────────────────────────────────┘
```

## Filosofía

| Principio | Significado |
|---|---|
| **Simplicidad Unix** | Sin systemd, sin asistentes gráficos, sin capas de abstracción |
| **Estabilidad** | Las versiones estables no cambian durante años |
| **Control total** | El administrador sabe exactamente qué pasa en el sistema |
| **Upstream puro** | Mínimos parches al software original |
| **Sin dependencias automáticas** | pkgtools no resuelve dependencias — tú decides |

## Gestor de paquetes

```bash
# pkgtools — herramientas nativas (sin resolución de dependencias)
installpkg paquete.txz                # instalar paquete
removepkg paquete                     # desinstalar
upgradepkg paquete.txz                # actualizar
makepkg paquete.txz directorio/      # crear paquete desde directorio

# slackpkg — gestor oficial con acceso a repos
slackpkg update                       # actualizar lista de paquetes
slackpkg install paquete              # instalar
slackpkg upgrade-all                  # actualizar todo el sistema
slackpkg clean-system                 # eliminar paquetes no oficiales
slackpkg info paquete                 # información del paquete

# slackpkg+ — extensión para repos de terceros (no oficial)
slackpkg update                        # actualiza repos oficiales + terceros
```

| Aspecto | Detalle |
|---|---|
| **Gestor** | pkgtools / slackpkg / slackpkg+ |
| **Formato** | `.txz` (tar + xz) |
| **Dependencias** | Manuales (no resuelve automáticamente) |
| **Repos oficiales** | slackpkg |
| **Repos terceros** | slackpkg+, SlackBuilds.org |
| **Base** | Independiente |
| **Init** | rc (BSD-style, scripts en `/etc/rc.d/`) |

### SlackBuilds.org

**SlackBuilds.org (SBo)** es el equivalente al [[Arch Linux#AUR|AUR]] para Slackware: scripts que compilan e instalan software desde fuente de forma limpia y mantenible. No hay resolución automática de dependencias — debes instalarlas manualmente.

```bash
# Flujo típico con SlackBuild:
# 1. Descargar el SlackBuild y el fuente
wget https://slackbuilds.org/slackbuilds/15.0/network/firefox.tar.gz
tar -xzf firefox.tar.gz
cd firefox

# 2. Colocar el fuente en el directorio
#    (o usar el script para descargarlo automáticamente)

# 3. Ejecutar el SlackBuild como root
chmod +x firefox.SlackBuild
su -c ./firefox.SlackBuild

# 4. Instalar el paquete generado
sudo installpkg /tmp/firefox-*.txz
```

## Ciclo de lanzamiento

| Rama | Tipo | Ideal para |
|---|---|---|
| **Stable** (15.0) | Release fija | Servidores, producción, máximo control |
| **-current** | Rolling | Usuarios que quieren lo último, desarrolladores |

Slackware no tiene fechas de lanzamiento fijas. Una versión estable sale **cuando está lista**. La 14.2 duró de 2016 a 2022 (6 años). Cada versión estable recibe parches de seguridad durante todo su ciclo de vida.

```bash
# Slackware-current (rolling)
# Actualizar a -current desde stable:
# Editar /etc/slackpkg/mirrors y seleccionar un mirror -current
slackpkg update
slackpkg upgrade-all
```

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | x86_64 (Pentium 4+) | Cualquier CPU moderna |
| **RAM** | 512 MB | 2 GB+ |
| **Disco** | 5 GB | 20 GB+ |
| **Arranque** | BIOS o UEFI | UEFI |

## Instalación

```bash
# 1. Descargar ISO desde https://www.slackware.com/getslack/
# 2. Grabar en USB
sudo dd if=slackware-15.0-install.iso of=/dev/sdX bs=4M status=progress

# 3. Arrancar desde USB
#    Instalador basado en menús ncurses (sin GUI)
#    Pasos principales:
#    - Particionar con fdisk/cgdisk
#    - Formatear particiones
#    - Seleccionar series de paquetes (A, AP, D, E, F, K, KDE, L, N, T, X, XAP, Y)
#    - Instalar paquetes
#    - Configurar red, kernel, lilo/elilo
#    - Crear root password

# 4. Series de paquetes principales
#    A     → Sistema base (kernel, glibc, bash, coreutils)
#    AP    → Aplicaciones (emacs, man, texinfo)
#    D     → Desarrollo (gcc, g++, make, autoconf, git)
#    E     → Emacs
#    F     → FAQs, documentación
#    K     → Kernel source
#    KDE   → KDE Plasma
#    L     → Librerías
#    N     → Red (networking, ssh, mail)
#    T     → TeX/LaTeX
#    X     → X11
#    XAP   → Aplicaciones X11
#    Y     → Juegos

# 5. Post-instalación
#    - Configurar red: /etc/rc.d/rc.inet1.conf
#    - Añadir mirrors en /etc/slackpkg/mirrors
#    - slackpkg update
#    - slackpkg install-new   # instalar nuevos paquetes añadidos post-release
```

## Post-instalación checklist

```bash
# 1. Configurar mirrors
echo "https://mirrors.slackware.com/slackware/slackware64-15.0/" >> /etc/slackpkg/mirrors
slackpkg update

# 2. Aplicar actualizaciones de seguridad
slackpkg upgrade-all

# 3. Instalar paquetes esenciales
slackpkg install git curl wget vim htop

# 4. Instalar SlackBuilds.org (opcional)
#    Cada SlackBuild se instala manualmente

# 5. Configurar SBo (herramienta sbopkg)
#    Descargar e instalar sbopkg desde https://sbopkg.org/

# 6. Configurar red WiFi si aplica
#    /etc/rc.d/rc.wireless.conf
```

## Problemas conocidos

| Problema | Causa | Solución |
|---|---|---|
| **Paquete no encontrado** | No está en los repos oficiales | Buscar en SlackBuilds.org o compilar desde fuente |
| **Dependencia faltante** | Slackware no resuelve dependencias automáticamente | Instalar la dependencia manualmente con slackpkg |
| **Kernel desactualizado** | Las versiones estables usan kernel antiguo | Usar -current o instalar kernel desde SlackBuilds |
| **Slackpkg no encuentra mirror** | Mirror desactualizado o mal configurado | Cambiar mirror en /etc/slackpkg/mirrors |

## Ver también

- [[Solus]] — otra rolling independiente pero con escritorio moderno
- [[Arch Linux]] — enfoque minimalista pero con systemd y resol. de dependencias
- [[Gentoo]] — source-based, máximo control (otro extremo)
- [[Void Linux]] — otra distro sin systemd (runit)
- [[Compilacion desde Codigo Fuente]] — común en Slackware y Gentoo
- [[Gestores de Paquetes]] — comparativa de gestores
- [[Gestores de Archivos]] — organización del sistema

## Enlaces externos

- [Slackware — Página oficial](https://www.slackware.com/)
- [Slackware — Documentación](https://docs.slackware.com/)
- [SlackBuilds.org](https://slackbuilds.org/) — scripts de compilación comunitarios
- [sbopkg.org](https://sbopkg.org/) — herramienta para gestionar SlackBuilds
- [Slackware — ArchWiki](https://wiki.archlinux.org/title/Slackware)
- [Slackware — Wikipedia](https://en.wikipedia.org/wiki/Slackware)
- [LinuxQuestions.org — Foro Slackware](https://www.linuxquestions.org/questions/slackware-14/)

#distro
