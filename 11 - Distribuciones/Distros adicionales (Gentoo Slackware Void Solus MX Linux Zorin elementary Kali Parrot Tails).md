---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: distribucion
prioridad: baja
---

# Distribuciones adicionales

Además de las distribuciones con nota individual, existen otras distribuciones notables. Esta nota recoge las que no tienen nota dedicada y sirve como índice de las que sí.

## Notas individuales

- [[Gentoo]] — source-based, Portage, máximo control
- [[Kali Linux]] — pentesting, seguridad informática
- [[Void Linux]] — rolling, xbps, runit (sin systemd)
- [[Tails]] — anonimato extremo, live USB, Tor
- [[MX Linux]] — Debian Stable + MX Tools
- [[Zorin OS]] — migración desde Windows
- [[elementary OS]] — diseño cuidado, Pantheon
- [[Slackware]] — la distro activa más antigua, sin systemd
- [[Solus]] — rolling independiente con Budgie
- [[Parrot OS]] — pentesting + privacidad basado en Debian
- [[ChimeraOS]] — distro gaming inmutable para living room
- [[HoloISO]] — fork abandonado de SteamOS para PC (no recomendado)

---

## Slackware

### Qué es

La distribución activa más antigua (1993). Filosofía: simplicidad y fidelidad a Unix. Sin systemd, sin dependencias automáticas complejas, sin asistentes gráficos de configuración.

```bash
# Gestor de paquetes: pkgtools
installpkg paquete.txz                # instalar paquete
removepkg paquete                     # desinstalar
upgradepkg paquete.txz                # actualizar
slackpkg update                       # actualizar lista
slackpkg install-all                  # instalar todo un conjunto
```

| Aspecto | Detalle |
|---|---|
| **Gestor** | pkgtools / slackpkg |
| **Base** | Independiente |
| **Init** | rc (BSD-style, sin systemd) |
| **Instalación** | Sencilla pero manual |
| **Ideal para** | Tradicionalistas, amantes de Unix clásico |

---

## Solus

### Qué es

Distribución **rolling** independiente, diseñada para escritorio. Creada por Ikey Doherty. Usa su propio gestor **eopkg** y escritorio Budgie por defecto. Conocida por su pulido y facilidad de uso.

```bash
# Gestor de paquetes: eopkg
sudo eopkg update-repo                  # actualizar repos
sudo eopkg install firefox              # instalar paquete
sudo eopkg remove firefox               # desinstalar
sudo eopkg upgrade                      # actualizar sistema
```

| Aspecto | Detalle |
|---|---|
| **Gestor** | eopkg (PiSi-based) |
| **Base** | Independiente |
| **Init** | systemd |
| **Rama** | Rolling |
| **Ideal para** | Escritorio moderno sin ser Ubuntu |

---

## Parrot OS

### Qué es

Distribución basada en **Debian Testing**, similar a Kali pero con enfoque en **privacidad, anonimato y seguridad**. Incluye herramientas de pentesting, pero también está diseñada para uso diario con encriptación y anonimato.

```bash
# Basada en Debian, usa apt
sudo apt update
sudo apt install parrot-tools-full      # todas las herramientas

# AnonSurf (túnel a Tor)
sudo anonsurf start                     # iniciar Tor
sudo anonsurf stop                      # detener Tor
sudo anonsurf status                    # verificar estado
```

| Aspecto | Detalle |
|---|---|
| **Gestor** | apt |
| **Base** | Debian Testing |
| **DE por defecto** | MATE (también XFCE) |
| **Ideal para** | Pentesters que también usan el equipo para daily driving |

---

## Tabla comparativa

| Distro | Base | Gestor | Init | Tipo | Ideal para |
|---|---|---|---|---|---|
| **Slackware** | Independiente | pkgtools | rc (BSD-style) | Binaria clásica | Tradicionalistas Unix |
| **Solus** | Independiente | eopkg | systemd | Rolling | Escritorio pulido |
| **Parrot OS** | Debian Testing | apt | systemd | Rolling | Pentesting + privacidad |
| **ChimeraOS** | Arch Linux | frzr + Flatpak | systemd | Rolling inmutable | Consola living room |
| **HoloISO** | SteamOS (Arch) | pacman + Flatpak | systemd | Rolling inmutable | ⚠️ Abandonado — no usar |

### Forks y alternativas a SteamOS para PC

| Aspecto | SteamOS | Bazzite | ChimeraOS | HoloISO |
|---|---|---|---|---|
| **Base** | Arch Linux | Fedora Silverblue | Arch Linux | SteamOS (Arch) |
| **ISO para PC** | ❌ (solo Deck) | ✅ | ✅ | ✅ (abandonado) |
| **Soporte NVIDIA** | ❌ | ✅ Nativo | ❌ (limitado) | ❌ |
| **Inmutable** | ✅ Dual root-a/root-b | ✅ rpm-ostree | ✅ frzr | ✅ SteamOS-style |
| **Gamescope** | ✅ Nativo | ✅ | ✅ | ✅ Heredado |
| **Modo Gaming** | ✅ Steam Big Picture | ✅ Steam Big Picture | ✅ Steam Big Picture | ✅ Steam Big Picture |
| **Modo Escritorio** | ✅ KDE Plasma | ✅ KDE / GNOME | ❌ Solo gaming | ✅ KDE Plasma |
| **Gestor paquetes** | pacman + Flatpak | rpm-ostree + Flatpak | frzr + Flatpak | pacman + Flatpak |
| **Rollback** | ✅ Bootloader | ✅ rpm-ostree rollback | ✅ frzr-rollback | ✅ Bootloader |
| **MangoHUD** | ✅ Integrado | ✅ Preinstalado | ❌ | ❌ |
| **Chimera web app** | ❌ | ❌ | ✅ Gestión remota | ❌ |
| **Mantenimiento** | ✅ Oficial (Valve) | ✅ Activo (Universal Blue) | ✅ Activo | ❌ Abandonado |
| **Ideal para** | Steam Deck | PC gaming / NVIDIA / Handhelds | Living room / consola | ❌ No recomendado |

## Ver también

- [[Gentoo]]
- [[Kali Linux]]
- [[Void Linux]]
- [[Tails]]
- [[MX Linux]]
- [[Zorin OS]]
- [[elementary OS]]
- [[Ubuntu]] — base de Zorin, elementary
- [[Debian]] — base de MX, Kali, Parrot, Tails
- [[Arch Linux]] — alternativa rolling a Gentoo
- [[Compilación desde Código Fuente]] — relevante para Gentoo
- [[SteamOS]] — la distro gaming original de Valve
- [[Bazzite]] — fork activo de SteamOS para PC con soporte NVIDIA
- [[Videojuegos en Linux]] — gaming en Linux en general
- [[Gamescope]] — compositor micro-gráfico de Valve

## Enlaces externos

- [Bazzite — Alternativa activa](https://bazzite.gg/)
- [SteamOS — Valve](https://store.steampowered.com/steamos/)

#distro #gaming
