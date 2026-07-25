---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: dnf (rpm)
base: independiente (upstream de RHEL)
---

# Fedora

## Filosofía / público objetivo

Software libre "de primera línea" y adopción temprana de tecnologías nuevas del ecosistema Linux: fue de las primeras en adoptar systemd, Wayland (por defecto desde Fedora 25), PipeWire (desde Fedora 34), y Btrfs como FS por defecto. Patrocinada por **Red Hat** (IBM). Es el **upstream** de RHEL (Red Hat Enterprise Linux), lo que significa que las tecnologías que llegan a Fedora después llegan a RHEL.

Ideal para: desarrolladores y entusiastas que quieren software reciente pero más estable que Arch, sin la capa extra de personalización de Ubuntu.

## Ediciones oficiales (spins)

| Edición | DE / Propósito | Descarga |
|---|---|---|
| **Fedora Workstation** | GNOME | La principal, para escritorio |
| **Fedora Server** | Sin DE | Para servidores, incluye Cockpit (GUI web admin) |
| **Fedora IoT** | Minimalista | Para dispositivos IoT / edge |
| **Fedora Silverblue** | GNOME (inmutable) | Sistema base de solo lectura, apps en contenedores (rpm-ostree) |
| **Fedora KDE** / XFCE / etc. | Varios | Spins con DEs alternativos oficiales |

## Gestor de paquetes

## Gestor de paquetes: dnf

### dnf (gestor principal)

```bash
# ── dnf: gestionar paquetes ──
sudo dnf install <paquete>               # instalar
sudo dnf upgrade                         # actualizar TODO (dnf upgrade = dnf update)
sudo dnf search <termino>                # buscar
sudo dnf remove <paquete>                # eliminar
sudo dnf autoremove                      # limpiar dependencias huérfanas
sudo dnf info <paquete>                  # información del paquete
sudo dnf provides </ruta/al/binario>     # ¿qué paquete provee este archivo?
sudo dnf groupinstall "Development Tools" # instalar grupo de paquetes

# ── rpm: bajo nivel (cuando dnf no basta) ──
sudo rpm -ivh paquete.rpm                # instalar un .rpm
rpm -ql <paquete>                        # listar archivos de un paquete instalado
rpm -q --changelog <paquete>            # ver changelog de un paquete

# ── RPM Fusion: repositorios extra (codecs, NVIDIA, Steam) ──
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install steam                  # ahora sí disponible
sudo dnf install rpmfusion-free-release-tainted  # códecs con patentes

# ── COPR: repositorios de terceros (como PPAs) ──
sudo dnf copr enable user/proyecto
sudo dnf install <paquete>

# ── Upgrade entre versiones ──
sudo dnf system-upgrade download --releasever=XX
sudo dnf system-upgrade reboot
```

### DNF5

A partir de Fedora 41 (2024-2025), Fedora migró a **DNF5**, una reescritura en C++ de DNF (que estaba en Python). Más rápido, menos memoria, sintaxis casi idéntica.

## RPM Fusion (esencial)

Fedora no incluye software no-libre o con patentes por defecto (códecs multimedia, drivers NVIDIA, Steam). **RPM Fusion** es el repositorio comunitario que provee esos paquetes. Ver comandos de instalación en el bloque `dnf` de arriba.

## COPR (Community Projects)

Equivalente a los **PPAs** de Ubuntu: repositorios de terceros alojados en Fedora Copr. Ver comandos en el bloque `dnf` de arriba.

Ver: [copr.fedorainfracloud.org](https://copr.fedorainfracloud.org/)

## Ciclo de lanzamiento

Releases cada ~6 meses (abril y octubre), con ~13 meses de soporte por versión. No hay LTS — hay que actualizar a la siguiente versión o dos versiones después como máximo (cada Fedora recibe actualizaciones hasta 1 mes después del lanzamiento de la 2da versión siguiente).

## Notas de instalación propias

-

## Enlaces externos

- [Sitio oficial de Fedora](https://fedoraproject.org/)
- [Fedora Spins (ediciones alternativas)](https://spins.fedoraproject.org/)
- [Wikipedia — Fedora Linux](https://en.wikipedia.org/wiki/Fedora_Linux)
- [Arch Wiki — Fedora](https://wiki.archlinux.org/title/Fedora)
- [RPM Fusion](https://rpmfusion.org/)
- [Fedora Copr](https://copr.fedorainfracloud.org/)

## Ver también

- [[Rocky Linux]] — clon de RHEL, derivado indirecto de Fedora
- [[Gestores de Paquetes]]
- [[Proceso de Instalacion General]]

#distro
