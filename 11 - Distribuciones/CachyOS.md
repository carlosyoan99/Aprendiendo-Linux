---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: distribucion
prioridad: alta
gestor_paquetes: pacman (+ repos propios optimizados x86-64-v3/v4)
base: Arch Linux
---

# CachyOS

## Qué es

**CachyOS** es una distribución Linux basada en **Arch Linux** con un enfoque radical en **rendimiento máximo**. Compila todos sus paquetes con optimizaciones agresivas (`-O3`, LTO, PGO) para arquitecturas modernas (x86-64-v3, x86-64-v4, Zen4+), usa un kernel propio con schedulers alternativos y ofrece un instalador gráfico amigable sin perder acceso al AUR.

Es la opción ideal para quien quiere la flexibilidad de Arch pero con **binarios pre-optimizados** — sin necesidad de compilar desde fuente como en Gentoo.

| Versión | Base | Estado |
|---|---|---|
| **2022** | Arch Linux | Primeros lanzamientos |
| **2023** | Arch Linux | Madurez, comunidad creciente |
| **2024** | Arch Linux | Soporte Handheld (ROG Ally, Legion Go) |
| **2026** | Arch Linux | Activo, rolling release continuo |

## Filosofía y público objetivo

- **Performance-first**: cada paquete está compilado con las optimizaciones más agresivas posibles sin romper compatibilidad.
- **Arch compatible**: 100% compatible con pacman y AUR — no pierdes nada del ecosistema Arch.
- **Instalador gráfico**: Calamares con perfiles preconfigurados (KDE, GNOME, Hyprland, Handheld).
- **Gaming ready**: kernel BORE, Proton, Gamescope, MangoHUD y Gamemode preconfigurados.
- **Handheld support**: edición específica para ROG Ally, Legion Go y Steam Deck con parches de hardware.
- Público objetivo: entusiastas del rendimiento, jugadores, usuarios de Arch que quieren optimización sin trabajo manual.

## Gestor de paquetes

```bash
# pacman — igual que Arch, pero con repositorios optimizados de CachyOS
sudo pacman -Syu                       # actualizar sistema
sudo pacman -S paquete                 # instalar
sudo pacman -Ss paquete                # buscar
sudo pacman -R paquete                 # eliminar

# Repositorios adicionales de CachyOS
# cachyos-v3 → paquetes para x86-64-v3 (Haswell+, Ryzen+)
# cachyos-v4 → paquetes para x86-64-v4 (Intel Ice Lake+, AMD Zen4+)
# cachyos-core → kernels y drivers optimizados

# AUR — 100% compatible (yay, paru)
yay -S paquete-aur
paru -S paquete-aur

# Flatpak — también disponible
flatpak install flathub com.valvesoftware.Steam
```

## Ciclo de lanzamiento

- **Rolling release**: igual que Arch, actualizaciones continuas.
- **CachyOS actualiza sus repos** semanalmente con las últimas versiones compiladas.
- Los kernels se actualizan con cada release upstream (a menudo en horas).
- No hay versiones discretas — instalas una vez y actualizas siempre.

```bash
# Ver versión del kernel CachyOS
uname -r                              # debe contener "cachyos"

# Ver repositorios activos
pacman -Sl | grep cachyos

# Cambiar entre repos v3 y v4
# Desde CachyOS Hello → Repository Selection
# O editar manualmente /etc/pacman.conf y cambiar los mirrors
```

## Características clave

### 1. Kernel linux-cachyos

El kernel propio de CachyOS es su característica más distintiva. Ofrece múltiples variantes:

```bash
# Variantes del kernel linux-cachyos
sudo pacman -S linux-cachyos           # BORE scheduler (por defecto)
sudo pacman -S linux-cachyos-eevdf     # EEVDF scheduler
sudo pacman -S linux-cachyos-lts       # Long Term Support
sudo pacman -S linux-cachyos-hardened  # Seguridad reforzada
sudo pacman -S linux-cachyos-deckify   # Optimizado para handhelds (ROG Ally, Legion Go)
sudo pacman -S linux-cachyos-rc        # Release candidate (lo último)
```

| Scheduler | Característica | Ideal para |
|---|---|---|
| **BORE** (Burst-Oriented Response Enhancer) | Máxima capacidad de respuesta en escritorio | Gaming, uso interactivo |
| **EEVDF** | Estándar moderno con ajustes de latencia | Servidores, cargas mixtas |
| **BMQ** | Colas de penalización múltiple | Cargas balanceadas |

Optimizaciones del kernel:
- Compilado con **Clang + ThinLTO** en vez de GCC estándar
- **AutoFDO** (Profile-Guided Optimization) para rutas de código calientes
- Ajustes de frecuencia de tick (`tickless` dinámico)
- Preempción voluntaria (baja latencia en escritorio)
- Parches de **input lag** reducido para gaming

```bash
# Ver scheduler activo
cat /sys/kernel/debug/sched/preempt

# Ver parámetros del kernel
cat /proc/cmdline                       # debe incluir optimizaciones CachyOS
```

### 2. Repositorios optimizados (x86-64-v3/v4)

CachyOS recompila ~4000 paquetes del ecosistema Arch con optimizaciones:

| Arquitectura | Requisito CPU | Flags extra |
|---|---|---|
| **x86-64-v3** | Haswell (2013), Ryzen 1ª gen+ | AVX2, BMI1/BMI2, FMA, LZCNT, MOVBE |
| **x86-64-v4** | Intel Ice Lake (2019), AMD Zen4+ | AVX512, AVX-VNNI |
| **Zen4+** | AMD Ryzen 7000+ | AVX512 nativo + Zen4 tuning |

```bash
# Ver qué microarquitectura soporta tu CPU
/lib/ld-linux-x86-64.so.2 --help | grep "x86-64"

# Probar si tu CPU soporta v3
/lib/ld-linux-x86-64.so.2 --help | grep "x86-64-v3"

# Ganancia típica frente a paquetes genéricos:
# ~5-10% en CPU-bound workloads
# ~10-20% en gaming y compilación
# ~5% en navegación general
```

### 3. CachyOS Hello

Herramienta gráfica de post-instalación y configuración:

```bash
# Abrir CachyOS Hello
cachyos-hello

# Funciones disponibles:
# - Instalar drivers NVIDIA
# - Cambiar entre repos v3/v4
# - Configurar kernels (instalar, eliminar, cambiar por defecto)
# - Aplicar parches de seguridad
# - Configurar Btrfs con snapshots automáticos
# - Instalar metapaquetes gaming
# - Optimizar sysctl (kernel parameters)
# - Configurar inicio automático de servicios
```

### 4. Gaming

CachyOS incluye optimizaciones gaming out-of-the-box:

```bash
# Metapaquete gaming completo
sudo pacman -S cachyos-gaming-meta

# Incluye:
# - Steam, Proton, Proton GE
# - Gamescope
# - MangoHUD
# - Gamemode
# - Lutris, Heroic Games Launcher
# - Wine, DXVK, VKD3D
# - Drivers Mesa actualizados

# Gamemode activado por defecto
gamemoderun steam                       # lanzar Steam con gamemode

# MangoHUD (ver rendimiento en juegos)
mangohud steam                          # overlay de rendimiento
```

### 5. Handheld Edition

CachyOS tiene una edición específica para consolas portátiles:

| Dispositivo | Soporte |
|---|---|
| **ASUS ROG Ally** | ✅ Completo (control TDP, botones, RGB) |
| **Lenovo Legion Go** | ✅ Completo (controladores, pantalla) |
| **Steam Deck** | ✅ Compatible (aunque SteamOS es la opción por defecto) |
| **AYA NEO, GPD Win** | ✅ Soporte básico |

```bash
# Kernel deckify para handhelds
sudo pacman -S linux-cachyos-deckify

# Incluye parches para:
# - Control de TDP y ventiladores
# - Botones y joysticks
# - Gyroscope y acelerómetros
# - Pantalla rotación/resolución
```

### 6. Btrfs + Snapper preconfigurado

CachyOS configura **Btrfs** con snapshots automáticos mediante snapper:

```bash
# Los snapshots se crean automáticamente antes de cada actualización
# Ver snapshots disponibles
snapper list

# Revertir a un snapshot anterior (desde GRUB o terminal)
sudo snapper rollback <número>

# Configurar número de snapshots a mantener
sudo snapper -c root set-config NUMBER_CLEANUP=10
```

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | x86-64-v2 (Intel Core 2+, AMD K8+) | **x86-64-v3** (Haswell / Ryzen 1ª gen+) |
| **RAM** | 2 GB | 8 GB (16 GB para gaming) |
| **Disco** | 20 GB | 64 GB+ SSD |
| **GPU** | Cualquier compatible con Mesa | AMD RDNA+ / NVIDIA RTX+ (Vulkan 1.3) |
| **Arranque** | BIOS o UEFI | UEFI |

> **Nota**: Para aprovechar los paquetes optimizados (v3/v4), se recomienda CPU de 2013+ (Haswell o Ryzen). En CPUs antiguas funcionará con paquetes genéricos.

## Instalación

```bash
# 1. Descargar ISO desde https://cachyos.org/download/
#    Elegir edición:
#    - Desktop (KDE Plasma, GNOME, Hyprland, XFCE, i3, Sway, Niri, COSMIC)
#    - Handheld (ROG Ally, Legion Go)

# 2. Grabar en USB
sudo dd if=cachyos-*.iso of=/dev/sdX bs=4M status=progress

# 3. Arrancar desde USB
#    CachyOS usa Calamares (instalador gráfico)
#    - Seleccionar idioma, teclado, zona horaria
#    - Particionado: recomendado Btrfs (con snapper automático)
#    - Elegir escritorio (KDE recomendado)
#    - Seleccionar kernel (linux-cachyos por defecto)
#    - Crear usuario (sudo habilitado)
#    - Elegir repositorio: v3, v4, o estándar
#    - Confirmar e instalar (~5-10 minutos)

# 4. Opciones de instalación avanzadas:
#    - Cifrado LUKS completo
#    - Zram o swap file
#    - Perfiles de energía (laptop, desktop, gaming)
```

## Post-instalación checklist

```bash
# 1. Actualizar sistema
sudo pacman -Syu

# 2. Abrir CachyOS Hello
cachyos-hello

# 3. Instalar drivers NVIDIA (si aplica)
#    Desde CachyOS Hello → Install NVIDIA drivers

# 4. Instalar metapaquete gaming
sudo pacman -S cachyos-gaming-meta

# 5. Configurar AUR helper
sudo pacman -S yay
yay -Y --gendb

# 6. Flatpak (opcional)
sudo pacman -S flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 7. Verificar kernel
uname -r                                  # debe contener "cachyos"

# 8. Verificar optimizaciones CPU
/lib/ld-linux-x86-64.so.2 --help | grep "x86-64-v3"
```

## Diagnóstico básico

```bash
# Verificar versión de CachyOS
cat /etc/os-release | grep -E "^VERSION|^PRETTY"

# Ver kernel activo y scheduler
uname -r
cat /sys/kernel/debug/sched/preempt

# Ver repositorios activos
pacman -Sl | grep cachyos

# Verificar soporte Vulkan
vulkaninfo --summary | grep "GPU\\|Vulkan"

# Logs del sistema
journalctl -p 3 -xb
journalctl -f

# Ver espacio en disco
df -h /

# Ver snapshots de snapper
snapper list
```

## Problemas conocidos

| Problema | Causa | Solución |
|---|---|---|
| **Paquete no disponible en repos v3/v4** | No está en los repos optimizados | Usar pacman estándar o AUR |
| **x86-64-v3 no funciona en CPU antigua** | CPU anterior a Haswell (2013) | Usar repos estándar (genéricos) |
| **Kernel deckify inestable** | Parches muy recientes para handhelds | Cambiar a linux-cachyos estándar |
| **NVIDIA no detecta** | Drivers no instalados | `cachyos-hello` → Install NVIDIA drivers |
| **AUR no compila** | Optimizaciones CachyOS incompatibles | Compilar con `CFLAGS` estándar: `CFLAGS="-O2" yay -S paquete` |
| **Btrfs snapshots ocupan espacio** | Demasiados snapshots | `sudo snapper -c root set-config NUMBER_CLEANUP=5` |

## CachyOS vs alternativas

| Aspecto | CachyOS | Arch vanilla | EndeavourOS | Manjaro |
|---|---|---|---|---|
| **Base** | Arch | Arch | Arch | Arch (retrasado) |
| **Instalador** | Calamares (avanzado) | Manual | Calamares (simple) | Calamares |
| **Paquetes optimizados** | ✅ v3/v4/Zen4 | ❌ Genéricos | ❌ Genéricos | ❌ Genéricos |
| **Kernel propio** | ✅ linux-cachyos | ❌ linux stock | ❌ linux stock | ❌ linux stock |
| **Rendimiento** | Máximo | Medio | Medio | Medio-bajo |
| **AUR** | ✅ 100% | ✅ 100% | ✅ 100% | ⚠️ Conflictos |
| **Handheld** | ✅ ROG Ally, Legion Go | ❌ Manual | ❌ | ❌ |
| **Facilidad** | Media | Baja | Alta | Alta |
| **Ideal para** | Rendimiento máximo, gaming | Control total, aprendizaje | Transición a Arch | Puerta de entrada Arch |

> **CachyOS vs Bazzite para gaming**: CachyOS prioriza rendimiento puro (binarios optimizados, kernel BORE), mientras que Bazzite prioriza inmutabilidad y soporte NVIDIA out-of-the-box. CachyOS es mejor para CPUs modernas AMD/Intel; Bazzite para GPUs NVIDIA o sistemas que necesitan rollback atómico.

## Ver también

- [[Arch Linux]] — base de CachyOS
- [[SteamOS]] — distro gaming de Valve (comparar enfoques)
- [[Bazzite]] — distro gaming inmutable basada en Fedora
- [[Videojuegos en Linux]] — gaming en Linux en general
- [[Gamescope]] — compositor micro-gráfico de Valve
- [[Hyprland]] — WM Wayland, perfil de instalación disponible
- [[KDE Plasma]] — escritorio recomendado
- [[Manjaro]] — alternativa Arch-friendly
- [[EndeavourOS]] — otra alternativa Arch-friendly

## Enlaces externos

- [CachyOS — Página oficial](https://cachyos.org/)
- [CachyOS — Wiki](https://wiki.cachyos.org/)
- [CachyOS — Foro](https://discuss.cachyos.org/)
- [CachyOS — GitHub](https://github.com/CachyOS)
- [CachyOS — Repositorios](https://repo.cachyos.org/)
- [CachyOS — Benchmark (Phoronix)](https://www.phoronix.com/review/cachyos-x86-64-v3-v4)
- [linux-cachyos — GitHub](https://github.com/CachyOS/linux-cachyos)
- [Arch Linux — Wiki](https://wiki.archlinux.org/)
- [ProtonDB — Compatibilidad de juegos](https://www.protondb.com/)

#distro #gaming #rendimiento
