---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: distribucion
prioridad: baja
gestor_paquetes: pacman (AUR, Flatpak)
base: Arch Linux
modelo_lanzamiento: Rolling
init: systemd
arquitecturas:
  - x86_64
---

# Xero Linux

> Distribución basada en **Arch Linux**, localizada en el Líbano, con KDE Plasma 5 altamente personalizado, temas GRUB llamativos, y herramientas preconfiguradas para gaming y uso diario.

## Filosofía / público objetivo

Xero Linux es una distribución Arch Linux que ofrece una experiencia **KDE Plasma 5** lista para usar, con personalizaciones visuales extensas (temas GRUB, Konsole alias, neofetch custom) y soporte para GPU NVIDIA heredado. Está dirigida a usuarios que quieren la estética llamativa de Arch sin configurar nada manualmente.

- **Público**: usuarios de escritorio que valoran la apariencia
- **Enfoque**: KDE personalizado + gaming
- **Base**: Arch Linux (via ALCI/ArcoLinux scripts)

## Características clave

| Aspecto | Detalle |
|---|---|
| **Base** | Arch Linux (via ALCI/ArcoLinux scripts) |
| **Gestor de paquetes** | pacman + AUR (con Paru) + Flatpak |
| **Init** | systemd |
| **Modelo** | Rolling |
| **Entorno por defecto** | KDE Plasma 5 (altamente personalizado) |
| **Instalador** | Calamares |
| **FS por defecto** | XFS |

### Personalizaciones incluidas

- **GRUB themes**: Draft Punk, T-R-O-N, Star Wars, XeroNord, XeroComp
- **Konsole alias**: ejecuta `alias` para ver la lista completa
- **Neofetch personalizado** con más información del sistema
- **Pamac** como GUI storefront (en lugar de Discover)
- **Abrir carpetas como root** desde Dolphin (menú contextual)
- **Comparar archivos** desde menú contextual
- **Herramienta System76 Power Management** disponible

### Soporte GPU

| GPU | Soporte |
|---|---|
| NVIDIA (GTX 10xx+) | ✅ Driver propietario incluido |
| NVIDIA (RTX 20xx+) | ✅ Driver propietario incluido |
| AMD (RX 500+) | ✅ Mesa/AMDGPU |
| Intel (UHD/Iris) | ✅ Mesa |

## Requisitos

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 64-bit x86_64 | 4+ cores |
| **RAM** | 2 GB | 4+ GB |
| **Disco** | 20 GB | 40+ GB |
| **GPU** | Cualquier compatible con Linux | NVIDIA dedicada para gaming |

## Instalación

```bash
# Descargar ISO desde xerolinux.xyz
# El instalador es Calamares (gráfico)

# Opciones de instalación:
# 1. KDE Plasma (por defecto) — recomendado
# 2. XFS como filesystem (por defecto)
# 3. NVIDIA driver (seleccionar si aplica)

# Tras instalar:
# - Actualizar sistema
sudo pacman -Syu

# - Los GRUB themes se instalan con:
sudo pacman -S xero-grub-themes
# Y seleccionar en /etc/default/grub → GRUB_THEME

# - Paru (AUR helper) ya preinstalado:
paru -S paquete-aur
```

## Post-instalación

```bash
# Ver alias de Konsole
alias

# Cambiar tema GRUB
sudo grub-install
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Instalar Flatpak si no está activo
sudo pacman -S flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# System76 Power Management (opcional, para laptops)
sudo pacman -S system76-power
sudo systemctl enable --now system76-power
```

## Comparativa con alternativas

| Aspecto | Xero Linux | EndeavourOS | Manjaro | CachyOS |
|---|---|---|---|---|
| **Base** | Arch (ALCI) | Arch directo | Arch (retrasado) | Arch directo |
| **DE** | KDE (personalizado) | Elección (XFCE default) | Elección (GNOME default) | Elección (GNOME default) |
| **Estética** | Muy llamativa (GRUB themes) | Minimalista | Moderada | Moderada |
| **Gaming** | Soporte NVIDIA | Manual | Manual | Optimizado (kernel) |
| **Repositorio propio** | Sí (Xero repos) | Sí (EOS repos) | Sí (Manjaro repos) | Sí (Cachy repos) |
| **Comunidad** | Pequeña (Líbano) | Grande | Muy grande | Grande |
| **Estabilidad** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `pacman: error while loading shared libraries` | Sistema desactualizado tras instalación | `sudo pacman -Syu` (Actualizar todo primero) |
| NVIDIA no carga después de install | Driver no instalado o blacklisted | `sudo pacman -S nvidia nvidia-utils` + reiniciar |
| GRUB theme no aparece | GRUB_THEME no configurado | Editar `/etc/default/grub` → `GRUB_THEME="/boot/grub/themes/Tema/theme.txt"` |
| Paru no compila paquete AUR | Dependencias faltantes | `paru -S --needed base-devel` |
| Plasma freeze / pantalla negra | Wayland incompatible con NVIDIA | Cambiar a X11 en login screen (gear icon) |
| `error: failed to commit transaction` | Conflicto de paquetes | `sudo pacman -Syyu` o `pacman -S --overwrite '*' paquete` |

## Ver también

- [[Arch Linux]] — distribución base
- [[KDE Plasma]] — escritorio por defecto
- [[EndeavourOS]] — otra distro Arch-based amigable
- [[CachyOS]] — Arch optimizado para gaming
- [[Manjaro]] — Arch-based con repos retrasados

## Enlaces externos

- [Sitio oficial](https://xerolinux.xyz/)
- [GitHub](https://github.com/xerolinux)
- [DistroWatch](https://distrowatch.com/weekly.php?issue=20220307)

#distro #arch #kde
