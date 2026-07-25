---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: distribucion
prioridad: alta
gestor_paquetes: eopkg
base: Independiente
---

# Solus

## Qué es

**Solus** es una distribución Linux **rolling independiente**, diseñada específicamente para **escritorio**. No está basada en ninguna otra distro (ni Debian, ni Arch, ni Fedora). Creada por **Ikey Doherty** (ex-desarrollador de Intel/Clear Linux), comenzó como Evolve OS y fue renombrada a Solus en 2015.

Su sello distintivo: un **rolling release curado** — recibe actualizaciones continuas pero cada una se prueba antes de llegar al usuario, evitando la inestabilidad del rolling tradicional.

```bash
┌─────────────────────────────────────────────────┐
│                   Solus                           │
├─────────────────────────────────────────────────┤
│  2015 — Lanzamiento oficial como Solus           │
│  2015 — Crea Budgie DE como escritorio nativo    │
│  2018 — Ikey Doherty deja el proyecto            │
│  2022 — Josh Strobl (Experience Lead) se va      │
│  2023 — Reorganización: "A New Voyage"           │
│  2024 — Migración a GitHub, nuevo equipo         │
│  2026 — Activo, actualizaciones semanales        │
└─────────────────────────────────────────────────┘
```

## Filosofía

- **Independiente**: no hereda problemas de otras distros; todo se construye desde cero
- **Rolling curado**: actualizaciones continuas pero probadas antes de publicarse
- **Escritorio first**: diseñado para el usuario de escritorio, no para servidores
- **Coherente**: las aplicaciones se integran bien entre sí (no mezclas de toolkits)
- **Instalar una vez, actualizar siempre**: sin reinstalaciones

## Gestor de paquetes: eopkg

```bash
# Gestor principal
sudo eopkg update-repo                 # actualizar lista de repos
sudo eopkg upgrade                     # actualizar sistema
sudo eopkg install firefox             # instalar paquete
sudo eopkg remove firefox              # desinstalar
sudo eopkg search chromium             # buscar paquete
sudo eopkg info firefox                # información del paquete
sudo eopkg history                     # historial de operaciones

# Gestión de paquetes huérfanos
sudo eopkg remove-orphans              # eliminar dependencias no usadas

# Repositorios (por defecto solo uno: main)
sudo eopkg list-repo                   # listar repos
# Solus no tiene PPA ni AUR — el software está en el repo central
```

| Aspecto | Detalle |
|---|---|
| **Gestor** | eopkg (basado en PiSi de Pardus Linux) |
| **Formato** | `.eopkg` (tar + XML + compresión) |
| **Dependencias** | Automáticas |
| **Repos** | Un solo repo oficial (main) |
| **PPAs/AUR** | No tiene — todo pasa por el repo central |
| **Init** | systemd |
| **Rama** | Rolling (actualizaciones semanales — "Friday Sync") |

## Ediciones oficiales

| Edición | DE | Público |
|---|---|---|
| **Budgie** | [[Budgie]] | Escritorio moderno (por defecto) |
| **GNOME** | [[GNOME]] | Experiencia GNOME pura |
| **Plasma** | [[KDE Plasma]] | Personalización máxima |
| **Xfce** | [[XFCE]] | Equipos ligeros o antiguos |

```bash
# Cada edición usa el mismo sistema base
# Cambiar de DE es tan simple como instalar otro metapaquete:
sudo eopkg install solus-desktop-gnome   # cambiar a GNOME
sudo eopkg install solus-desktop-kde     # cambiar a KDE
```

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | x86_64 (x86-64-v2) | x86-64-v2, 2 GHz quad-core |
| **RAM** | 4 GB | 8 GB |
| **Disco** | 10 GB | 25 GB+ SSD |
| **GPU** | Cualquier compatible con Mesa | AMD/Intel/NVIDIA moderna |
| **Arranque** | UEFI (recomendado) o BIOS | UEFI |

## Instalación

```bash
# 1. Descargar ISO desde https://getsol.us/download/
#    Elegir edición (Budgie, GNOME, Plasma, Xfce)

# 2. Grabar en USB
sudo dd if=solus-*.iso of=/dev/sdX bs=4M status=progress

# 3. Arrancar desde USB
#    Solus usa Calamares como instalador gráfico
#    - Seleccionar idioma, zona horaria, teclado
#    - Particionado (manual o automático)
#    - Crear usuario (sudo habilitado)
#    - Confirmar e instalar (~5-10 minutos)

# 4. Post-instalación
#    Solus ya incluye:
#    - Firefox, LibreOffice, gestor de archivos
#    - Codecs multimedia
#    - Drivers NVIDIA (si aplica)
#    - Flathub configurado ([[Snap y Flatpak|Flatpak]] disponible)
```

## Post-instalación checklist

```bash
# 1. Actualizar sistema
sudo eopkg upgrade

# 2. Instalar apps adicionales
sudo eopkg install vlc gimp krita steam

# 3. Flatpak (ya configurado)
flatpak install flathub com.spotify.Client

# 4. Configurar firewall (ufw disponible)
sudo eopkg install ufw
sudo ufw enable

# 5. Drivers NVIDIA (si aplica)
#    Solus detecta GPU NVIDIA y ofrece instalar drivers
sudo eopkg install nvidia-glx
```

## Problemas conocidos

| Problema | Causa | Solución |
|---|---|---|
| **Paquete no disponible** | Solus tiene un repo único, menos software que Arch/Debian | Usar Flatpak o compilar desde fuente |
| **eopkg lento** | Tras mucho tiempo sin actualizar | `sudo eopkg upgrade` limpia el caché |
| **Budgie se congela** | Extensión problemática | Deshabilitar extensiones desde Budgie Settings |
| **No reconoce WiFi** | Firmware no incluido | `sudo eopkg install linux-firmware` |

## Solus vs alternativas

| Aspecto | Solus | Manjaro | openSUSE Tumbleweed |
|---|---|---|---|
| **Base** | Independiente | Arch | Independiente (SUSE) |
| **Gestor** | eopkg | pacman | zypper |
| **Rolling** | ✅ Curado (semanal) | ✅ Curado | ✅ OpenQA testeado |
| **Tamaño repo** | Pequeño (curado) | Grande (Arch + AUR) | Grande |
| **DE por defecto** | Budgie | Xfce/KDE | KDE |
| **Independiente** | ✅ Sí | ❌ (basado en Arch) | ✅ Sí |
| **Ideal para** | Escritorio pulido | Acceso AUR | Sysadmin amantes SUSE |

## Ver también

- [[Budgie]] — DE creado por y para Solus
- [[Manjaro]] — otra rolling curada pero basada en Arch
- [[openSUSE]] — otra rolling independiente con Tumbleweed
- [[Arch Linux]] — rolling pura, sin curación
- [[Gestores de Paquetes]] — comparativa de gestores
- [[Distros adicionales (Gentoo Slackware Void Solus MX Linux Zorin elementary Kali Parrot Tails)]]

## Enlaces externos

- [Solus — Página oficial](https://getsol.us/)
- [Solus — Blog](https://getsol.us/blog/)
- [Solus — GitHub](https://github.com/getsolus)
- [Solus — Foro](https://discuss.getsol.us/)
- [Solus — Wikipedia](https://en.wikipedia.org/wiki/Solus_(operating_system))
- [eopkg — Documentación](https://github.com/getsolus/eopkg)

#distro
