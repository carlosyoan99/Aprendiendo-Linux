---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: apt (dpkg)
base: independiente (base de Ubuntu)
modelo_lanzamiento: Fixed
init: systemd
arquitecturas:
  - x86_64
  - ARM
  - RISC-V
  - MIPS
  - s390x
  - ppc64el
---

# Debian

> La **Universal Operating System**: una de las distros más antiguas (1993) y respetadas. Conocida por su estabilidad extrema, su compromiso con el software libre, y por ser la base de Ubuntu, Linux Mint y muchas otras.

## Filosofía / público objetivo

Estabilidad y **software libre** por encima de todo. Debian es mantenida por la comunidad (Debian Social Contract, Debian Free Software Guidelines) sin una empresa detrás.

Ideal para:
- **Servidores**: estabilidad extrema, actualizaciones conservadoras.
- **Usuarios que priorizan "que funcione"** sobre tener la última versión de cada paquete.
- **Base para aprender Linux** con mucha documentación comunitaria.

## Postura sobre software no-libre

Debian, por defecto, solo incluye software libre en sus repos. Desde Debian 12 (Bookworm, 2023) se incluye **non-free-firmware** para firmware de hardware:

```bash
# En /etc/apt/sources.list:
deb http://deb.debian.org/debian bookworm main contrib non-free-firmware
```

Las ISOs oficiales "non-free" ya vienen con firmware incluido — recomendadas para hardware moderno.

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 1 GHz | 2 GHz+ |
| **RAM** | 512 MB (sin DE) / 2 GB (con DE) | 4 GB+ |
| **Disco** | 10 GB (sin DE) / 20 GB (con DE) | 30 GB+ (SSD) |
| **GPU** | Cualquier compatible | Cualquier con soporte Mesa |

## Ramas de desarrollo

| Rama | Nombre en clave | Estabilidad | Uso recomendado |
|---|---|---|---|
| **stable** | Bookworm (12), Trixie (13) | Máxima | Servidores, escritorio que no se toca |
| **testing** | Forge (futura stable) | Media | Escritorio hogareño |
| **unstable** (sid) | Sid (nombre permanente) | Baja | Developers, entusiastas |

```bash
lsb_release -a
cat /etc/debian_version
```

## Instalación (resumen)

> Para una guía detallada paso a paso, ver [[Proceso de Instalacion General]] y [[Creacion de USB Booteable]].

Debian tiene **dos caminos de instalación**: el clásico instalador de texto (Debian Installer) y el nuevo Calamares (desde Debian 12 en las ISOs con DE).

### Instalador clásico (Debian Installer)

```bash
# 1. Descargar ISO desde debian.org (recomendado: ISO non-free con firmware)
# 2. Crear USB booteable
#    sudo dd if=debian-12-bookworm-amd64-netinst.iso of=/dev/sdX bs=4M status=progress

# 3. Bootear y seguir el instalador:
#    - Elegir idioma, teclado, configuración de red
#    - Nombre de máquina y dominio
#    - Particionado (guiado o manual) — con o sin LVM
#    - Crear usuario root y/o usuario regular
#    - Elegir mirrors (recomendado: mirror propio del país)
#    - Elegir software (DE + utilities)
#    - Instalar GRUB
```

### Instalación con Calamares (ISOs con DE)

Desde Debian 12, las ISOs con escritorio (`debian-live-*-desktop.iso`) usan Calamares, un instalador gráfico más amigable:

```bash
# Similar al instalador de Ubuntu — asistente paso a paso con interfaz gráfica
# Más fácil para newcomers que el Debian Installer tradicional
```

### Instalación mínima (servidor)

```bash
# Para servidores, elegir "ningún escritorio" en el instalador
# O instalar desde cero:
sudo apt install --no-install-recommends 
    openssh-server curl wget ufw fail2ban
```

### Post-instalación esencial

```bash
# Si instalaste sin sudo:
su -
apt install sudo
usermod -aG sudo $USER

# Firmware adicional (si usaste ISO libre)
sudo apt install firmware-linux firmware-iwlwifi

# Firewall
sudo apt install ufw
sudo ufw enable
```

## Gestor de paquetes

```bash
# Comandos básicos
sudo apt update                        # actualizar lista
sudo apt upgrade                       # actualizar paquetes
sudo apt full-upgrade                  # con cambios de dependencias
sudo apt install --no-install-recommends <paquete>  # servidores minimalistas
sudo apt autoremove                    # limpiar huérfanos
sudo apt autoclean                     # limpiar .deb cacheados viejos

# apt vs apt-get: apt es más amigable (barra de progreso)
# apt-get es más estable para scripting
```

### Repositorios adicionales

Debian no tiene PPAs al estilo Ubuntu. Las opciones son:
- **Backports**: paquetes más nuevos de testing compilados para stable
- **Debian Multimedia**: códecs y software multimedia no incluidos en main
- **Repositorios de terceros**: Docker, VirtualBox, etc. (añadir con cuidado)

## Ciclo de lanzamiento

Releases estables cada ~2 años con soporte de seguridad durante:
- ~3 años para stable regular
- ~5 años con Debian LTS (equipo voluntario)
- +2 años con Debian ELTS (pago)

## Actualización entre versiones mayores

```bash
# Debian 11 (bullseye) → 12 (bookworm)
sudo apt update && sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt autoremove --purge

# Cambiar sources.list
sudo sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list
sudo sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list.d/*.list 2>/dev/null

# Ejecutar upgrade
sudo apt update
sudo apt upgrade --without-new-pkgs -y
sudo apt full-upgrade -y

# Verificar
cat /etc/debian_version

# Ver [[Actualizacion entre versiones mayores]] para guía detallada
```

## Sabores (Desktop environments)

```bash
# Instalar DE completo tras tener Debian base
sudo apt install task-gnome-desktop       # GNOME
sudo apt install task-kde-desktop         # KDE Plasma
sudo apt install task-xfce-desktop        # XFCE (popular por ligera)
sudo apt install task-cinnamon-desktop    # Cinnamon
```

## Post-instalación recomendada

- [ ] `sudo apt update && sudo apt full-upgrade` — actualizar sistema
- [ ] `sudo apt install firmware-linux` — firmware para hardware (si usas ISO libre)
- [ ] `sudo apt install sudo` — instalar sudo (Debian no lo incluye por defecto)
- [ ] Añadir usuario a sudo: `usermod -aG sudo $USER` (tras instalar sudo)
- [ ] Configurar firewall: `sudo apt install ufw && sudo ufw enable`
- [ ] Activar sincronización horaria: `sudo timedatectl set-ntp true`

## Comandos asociados

| Comando | Para qué |
|---|---|
| `lsb_release -a` | Ver versión de Debian instalada |
| `cat /etc/debian_version` | Versión puntual exacta |
| `apt-cache policy <paquete>` | Ver qué versiones están disponibles |
| `apt-get --no-install-recommends` | Instalar sin paquetes recomendados (servidores) |
| `apt-listbugs` | Ver bugs conocidos antes de actualizar |
| `apt-mark hold <paquete>` | Congelar versión de un paquete (evita upgrade) |
| `dpkg --configure -a` | Reconfigurar paquetes a medio instalar (tras fallo) |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| WiFi no funciona en portátiles | Falta firmware no-libre | Usar ISO non-free o `sudo apt install firmware-iwlwifi` |
| `sudo: command not found` | sudo no instalado por defecto | `su -` → `apt install sudo` → `usermod -aG sudo $USER` |
| `E: Repository '...' does not have a Release file` | Repositorio desactualizado en sources.list | Verificar releases con `cat /etc/debian_version` |
| Paquetes muy antiguos | Usando stable sin backports | Añadir backports: `deb http://deb.debian.org/debian bookworm-backports main` |
| `debconf: unable to initialize frontend` | Instalación sin terminal interactiva | `export DEBIAN_FRONTEND=noninteractive` |

## Comparativa con otras distros

| Aspecto | Debian | Ubuntu | Fedora |
|---|---|---|---|
| **Facilidad** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Rendimiento** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Paquetes** | ⭐⭐⭐⭐ (estables) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Comunidad** | ⭐⭐⭐⭐⭐ (veterana) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Estabilidad** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Software libre** | ⭐⭐⭐⭐⭐ | ⭐⭐ (Snap, drivers) | ⭐⭐⭐⭐ |

## Notas de instalación propias

- **Siempre usar la ISO non-free** para hardware moderno (WiFi, NVIDIA, Bluetooth). La ISO libre te hará perder tiempo buscando firmware manualmente.
- Para escritorio, usar **Debian Testing** en lugar de Stable — los paquetes de Stable se quedan muy atrás y algunos programas ni siquiera están disponibles en versiones recientes.
- Para servidor, **Stable sin duda**. La estabilidad de Debian Stable es legendaria: servidores que llevan años sin reiniciarse.
- `--no-install-recommends` es tu mejor amigo para mantener el sistema limpio — evita que apt instale toneladas de dependencias innecesarias.
- Si necesitas un paquete más reciente: primero mirar Backports, luego Testing (pin con `apt pinning`), y solo como último recurso compilar desde fuente.

## Enlaces externos

- [Sitio oficial](https://www.debian.org/)
- [Wiki oficial](https://wiki.debian.org/)
- [Wikipedia — Debian](https://en.wikipedia.org/wiki/Debian)
- [DistroWatch](https://distrowatch.com/debian)
- [Debian Social Contract](https://www.debian.org/social_contract)
- [Debian LTS](https://wiki.debian.org/LTS)

## Ver también

- [[Ubuntu]] — derivada de Debian, más fácil de instalar
- [[Linux Mint]] — basada en Ubuntu (y por tanto en Debian)
- [[Versiones de Debian]] — timeline de releases
- [[Gestores de Paquetes]]
- [[Proceso de Instalacion General]]
- [[Actualizacion entre versiones mayores]]

#distro
