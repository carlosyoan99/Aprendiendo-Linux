---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: distribucion
prioridad: alta
gestor_paquetes: apt (dpkg) + snap
base: Debian
modelo_lanzamiento: Fixed
init: systemd
arquitecturas:
  - x86_64
  - ARM
  - RISC-V
---

# Ubuntu

> La distro Linux más popular del mundo. Enfocada en facilidad de uso "out of the box", con el mayor volumen de documentación, foros y tutoriales. Mantenida por **Canonical**.

## Filosofía / público objetivo

Ubuntu busca ser Linux para **todos los públicos**: desde el usuario que migra de Windows hasta el desarrollador y el servidor. Prioriza la experiencia de usuario y el soporte de hardware sobre la pureza del software libre (incluye drivers privativos, Snap, etc.).

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 2 GHz dual-core | 4 GHz quad-core |
| **RAM** | 4 GB | 8 GB+ |
| **Disco** | 25 GB | 50 GB+ (SSD recomendado) |
| **GPU** | Cualquier compatible con Mesa | NVIDIA/AMD para juegos |

## Instalación (resumen)

> Para una guía detallada paso a paso, ver [[Proceso de Instalacion General]] y [[Creacion de USB Booteable]].

Ubuntu es una de las distros más fáciles de instalar gracias a su instalador gráfico **Subiquity** (desde 20.04) / **Ubiquity** (versiones anteriores):

```bash
# 1. Descargar ISO desde ubuntu.com
# 2. Crear USB booteable
#    sudo dd if=ubuntu-24.04-desktop-amd64.iso of=/dev/sdX bs=4M status=progress

# 3. Bootear desde USB y seguir el asistente gráfico:
#    - Idioma y teclado
#    - Tipo de instalación (normal/mínima)
#    - Particionado (automático o manual)
#    - Crear usuario y contraseña
#    - Instalar (10-20 minutos)

# 4. Tras reiniciar, ejecutar:
sudo apt update && sudo apt upgrade -y
```

### Instalación automatizada (Autoinstall / cloud-init)

Para desplegar Ubuntu en servidores o VMs de forma reproducible:

```yaml
# autoinstall.yaml — instalación desatendida
version: 1
identity:
  hostname: ubuntu-server
  username: admin
  password: $6$...  # generar con: mkpasswd -m sha-512
storage:
  layout:
    name: lvm
```

```bash
# Iniciar ISO con autoinstall
dd autoinstall.yaml en USB + arrancar con:
# linux /casper/vmlinuz autoinstall ds=nocloud-net;s=https://example.com/seed/
```

### Ubuntu Server

```bash
# La ISO Server usa Subiquity (interfaz TUI basada en ncurses)
# Incluye opciones avanzadas:
# - ZFS como root filesystem
# - LVM cifrado
# - RAID por software
# - Instalación mínima (sin DE)
```

## Gestor de paquetes

### apt (alto nivel)

```bash
# Comandos básicos
sudo apt update                       # actualizar lista de paquetes disponibles
sudo apt upgrade                      # actualizar paquetes instalados
sudo apt full-upgrade                 # igual que upgrade pero resuelve cambios de dependencias
sudo apt install <paquete>            # instalar
sudo apt remove <paquete>             # eliminar (deja archivos de config)
sudo apt purge <paquete>              # eliminar incluyendo archivos de config
sudo apt autoremove                   # limpiar dependencias que ya no se usan
apt search <termino>                  # buscar paquetes
apt show <paquete>                    # mostrar información detallada de un paquete
apt list --installed                  # listar todos los paquetes instalados
```

### dpkg (bajo nivel)

```bash
sudo dpkg -i paquete.deb              # instalar .deb (no resuelve dependencias)
sudo dpkg -r <paquete>                # eliminar paquete
dpkg -l                               # listar paquetes instalados
dpkg -L <paquete>                     # qué archivos instaló
```

### Snap (impulsado por Canonical)

```bash
snap install <app>                    # instalación automática
snap list                             # snaps instalados
snap remove <app>                     # eliminar snap
snap refresh                          # actualizar todos los snaps
```

Snap empaqueta la app con sus dependencias en sandbox. Es controvertido por:
- Rendimiento de arranque más lento (especialmente en HDD).
- Actualizaciones forzadas sin control granular.
- Ecosistema cerrado (tienda Snap privativa de Canonical).

### PPAs (Personal Package Archives)

Repositorios de terceros en Launchpad:

```bash
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.12
```

⚠️ Los PPAs son mantenidos por la comunidad, no por Canonical. Preferir Flatpak antes que PPAs dudosos.

## Ciclo de lanzamiento

| Tipo | Cada | Soporte | Ejemplo |
|---|---|---|---|
| **LTS** (Long Term Support) | 2 años (abril de años pares) | 5 años (10 con Ubuntu Pro) | 24.04 Noble, 22.04 Jammy |
| **Intermedio** | 6 meses (abril y octubre) | 9 meses | 24.10 Oracular, 25.04 |

```bash
lsb_release -a                         # ver versión instalada
lsb_release -c                         # nombre en clave
```

## Actualización entre versiones mayores

```bash
# LTS → LTS (ej. 22.04 → 24.04)
sudo apt update && sudo apt upgrade -y
sudo apt autoremove --purge
sudo do-release-upgrade                # herramienta oficial de Canonical

# Esperar al primer point release (24.04.1) antes de actualizar producción
# Ver [[Actualizacion entre versiones mayores]] para más detalles
```

## Sabores oficiales (flavours)

> Para una guía detallada de todos los sabores, ver [[Sabores de Ubuntu]].

| Sabor | DE | Para quién |
|---|---|---|
| **Ubuntu** | GNOME (personalizado) | Mayoría de usuarios |
| **Kubuntu** | [[KDE Plasma]] | Personalización máxima |
| **Xubuntu** | [[XFCE]] | Equipos ligeros |
| **Lubuntu** | LXQt | Equipos muy antiguos |
| **Ubuntu MATE** | MATE | Tradición GNOME 2 |
| **Ubuntu Budgie** | Budgie | Escritorio moderno liviano |
| **Ubuntu Cinnamon** | [[Cinnamon]] | Usuarios de Linux Mint |
| **Ubuntu Studio** | KDE + multimedia | Producción AV |

## Post-instalación recomendada

- [ ] `sudo apt update && sudo apt upgrade` — actualizar sistema
- [ ] `sudo apt install ubuntu-restricted-extras` — códecs multimedia, fuentes
- [ ] Instalar drivers NVIDIA si aplica (desde "Software & Updates" → Drivers adicionales)
- [ ] Configurar firewall: `sudo ufw enable`
- [ ] Activar `systemd-timesyncd` para sincronización de hora
- [ ] Instalar Flatpak si prefieres apps en sandbox: `sudo apt install flatpak`

## Comandos asociados

| Comando | Para qué |
|---|---|
| `lsb_release -a` | Ver versión y nombre en clave de Ubuntu |
| `do-release-upgrade` | Actualizar a la siguiente versión LTS |
| `snap list` | Ver aplicaciones Snap instaladas |
| `add-apt-repository` | Añadir PPA |
| `dpkg -l` | Listar paquetes instalados |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| `Could not get lock /var/lib/dpkg/lock` | Otro proceso apt en ejecución | `sudo killall apt` o reiniciar |
| Snap apps no abren | Snap service no corriendo | `sudo systemctl enable --now snapd` |
| Pantalla negra tras actualizar NVIDIA | Driver NVIDIA incompatible con kernel | Arrancar con `nomodeset`, reinstalar driver (ver [[Pantalla en negro tras actualizar drivers]]) |
| WiFi no funciona en portátiles | Faltan drivers de firmware | `sudo apt install linux-firmware` |
| `E: Unable to locate package` | Repositorios no actualizados | `sudo apt update` |

## Comparativa con otras distros

| Aspecto | Ubuntu | Debian | Fedora |
|---|---|---|---|
| **Facilidad** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Rendimiento** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Paquetes** | ⭐⭐⭐⭐⭐ (muchos PPAs) | ⭐⭐⭐⭐ (estables) | ⭐⭐⭐⭐ (actualizados) |
| **Comunidad** | ⭐⭐⭐⭐⭐ (enorme) | ⭐⭐⭐⭐⭐ (veterana) | ⭐⭐⭐⭐ (activa) |
| **Estabilidad** | ⭐⭐⭐⭐ (LTS) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Software reciente** | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ |

## Notas de instalación propias

- La instalación mínima (sin extras) ahorra ~2 GB y muchos paquetes que no usarás. Siempre elegir "Instalación mínima" en el asistente si no necesitas LibreOffice/juegos preinstalados.
- Tras instalar: `sudo apt install ubuntu-restricted-extras` para códecs multimedia y fuentes.
- Ubuntu Pro (token gratuito para uso personal) da 5 años extra de soporte de seguridad para hasta 5 máquinas. Conseguir token en [ubuntu.com/pro](https://ubuntu.com/pro).

## Enlaces externos

- [Sitio oficial](https://ubuntu.com/)
- [Wiki oficial](https://wiki.ubuntu.com/)
- [Wikipedia — Ubuntu](https://en.wikipedia.org/wiki/Ubuntu)
- [Repositorio GitHub](https://github.com/canonical)
- [DistroWatch](https://distrowatch.com/ubuntu)
- [Sabores de Ubuntu](https://ubuntu.com/download/flavours)

## Ver también

- [[Debian]] — la base de Ubuntu
- [[Linux Mint]] — basada en Ubuntu, orientada a Windows migrants
- [[Sabores de Ubuntu]] — lista completa de flavours
- [[Gestores de Paquetes]]
- [[Proceso de Instalacion General]]
- [[Actualizacion entre versiones mayores]]

#distro
