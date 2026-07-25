---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: media
---

# Videojuegos en Linux

## Estado actual

Hasta hace poco, jugar en Linux era una odisea. Hoy, gracias a **Steam + Proton**, **Wine/Lutris** y el auge de la **Steam Deck**, Linux es una plataforma de juego viable: ~90% de los juegos de Windows funcionan, y la cuota de Steam en Linux llegó al **5.33%** en 2026 (frente al 0.9% en 2020).

```bash
Evolución de Linux en Steam (usuarios):
2020: 0.9%
2022: 2.06%  ← Lanzamiento Steam Deck
2026: 5.33%  ← Fin de soporte Windows 10
```

## Stack gráfico para juegos

| Componente | Linux | Windows |
|---|---|---|
| **API gráfica** | Vulkan, OpenGL | DirectX 12, Vulkan |
| **Drivers GPU** | Mesa (AMD/Intel), NVIDIA (prop/nouveau) | NVIDIA, AMD oficial |
| **Capa compatibilidad** | Proton (Wine + DXVK + VKD3D) | Ninguna |
| **Plataformas** | Steam, Heroic, Lutris, itch.io | Steam, Xbox, EA, Epic |
| **Audio** | PipeWire / PulseAudio (baja latencia) | Windows Audio |

### Vulkan: la clave del gaming en Linux

Vulkan es la API gráfica de baja latencia que hace posible que los juegos de Windows funcionen en Linux mediante **traducción DirectX→Vulkan** (DXVK, VKD3D-Proton). Sin Vulkan, el gaming en Linux no sería viable.

```bash
# Verificar soporte Vulkan
sudo apt install vulkan-tools     # Debian/Ubuntu
sudo pacman -S vulkan-tools       # Arch
vulkaninfo --summary              # GPU, driver, versión Vulkan
```

---

## Steam + Proton

### Steam para Linux

Valve lanzó Steam para Linux en 2013. Hoy es la plataforma de juegos más importante en Linux.

```bash
# Instalación
sudo apt install steam-installer      # Debian/Ubuntu
sudo pacman -S steam                  # Arch
sudo dnf install steam                # Fedora (requiere RPM Fusion)
flatpak install flathub com.valvesoftware.Steam
```

### Proton

**Proton** es una capa de compatibilidad de Valve basada en **Wine** + **DXVK** (DirectX 9/10/11 → Vulkan) + **VKD3D-Proton** (DirectX 12 → Vulkan). Viene integrado en Steam y se activa automáticamente para juegos de Windows.

```bash
# Proton se gestiona desde Steam:
# Steam → Settings → Compatibility → Enable Steam Play
# - "Enable Steam Play for all titles"
# - Elegir versión de Proton (Proton Experimental, Proton 9.0, GE-Proton)

# Proton GE (GlitchEgg) — versiones personalizadas con parches extra
# Instalación:
# Descargar desde: https://github.com/GloriousEggroll/proton-ge-custom
# Extraer a ~/.steam/root/compatibilitytools.d/
```

### ProtonDB

[ProtonDB](https://www.protondb.com/) es una base de datos colaborativa donde los usuarios reportan qué tan bien funciona cada juego en Linux con Proton:

| Estado | Significado |
|---|---|
| **Platinum** | Funciona perfecto sin configuración |
| **Gold** | Funciona bien con configuración mínima |
| **Silver** | Funciona con algunos problemas |
| **Bronze** | Funciona pero con problemas graves |
| **Borked** | No funciona |

```bash
# Juegos populares con estado Platinum en ProtonDB:
# - Elden Ring, Cyberpunk 2077, Baldur's Gate 3
# - Red Dead Redemption 2, Hogwarts Legacy
# - God of War, Spider-Man, Horizon Zero Dawn
# - Todos los juegos de Valve (nativos)
```

### Steam Deck

Consola portátil de Valve que corre **SteamOS** (basado en Arch Linux). Ha sido el mayor impulsor del gaming en Linux:

- Lanzamiento: febrero 2022
- SO: SteamOS 3.x (Arch Linux + KDE Plasma + Gamescope)
- Proton incluido por defecto
- Certificación "Verified" o "Playable" para miles de juegos

---

## Wine

**Wine** (Wine Is Not an Emulator) es la capa de compatibilidad base para ejecutar aplicaciones de Windows en Linux. Proton está construido sobre Wine.

```bash
# Instalación
sudo apt install wine wine32 wine64   # Debian/Ubuntu
sudo pacman -S wine                   # Arch
sudo dnf install wine                 # Fedora

# Configurar Wine (se ejecuta una vez)
winecfg       # configuración gráfica (versión Windows, drives, librerías)
winetricks    # instalar componentes VC++ , .NET, DirectX, etc.

# Ejecutar un .exe
wine juego.exe

# Dónde se instalan los "programas"
ls ~/.wine/drive_c/   # equivalente a C:\ en Windows
```

### Wine vs Proton

| Aspecto | Wine | Proton |
|---|---|---|
| **Base** | Wine puro | Wine + DXVK + VKD3D + parches Valve |
| **DirectX** | DirectX 9/10/11 → OpenGL | DirectX 9/10/11 → Vulkan (DXVK) |
| **DirectX 12** | ❌ | ✅ VKD3D-Proton |
| **Integración** | Manual (wine, winetricks) | Automática (desde Steam) |
| **Rendimiento** | ~60-80% del nativo | ~90-100% del nativo |
| **Ideal para** | Apps Windows, juegos fuera de Steam | Juegos de Steam |

---

## Lutris

**Lutris** es un gestor de juegos (game launcher) para Linux que unifica todas las fuentes: Steam, GOG, Epic, Ubisoft Connect, itch.io, Humble Bundle, emuladores, y juegos nativos.

```bash
# Instalación
sudo apt install lutris                    # Debian/Ubuntu
sudo pacman -S lutris                      # Arch
sudo dnf install lutris                    # Fedora
flatpak install flathub net.lutris.Lutris

# Usar Lutris:
# 1. Abre Lutris
# 2. Inicia sesión en las plataformas que uses (Steam, GOG, etc.)
# 3. Los juegos aparecen automáticamente
# 4. Para juegos fuera de plataformas: "Add Game"
```

**Características**:
- Instaladores con config pre-hecha (Wine, Proton, runners)
- Soporte para múltiples versiones de Wine/Lutris/Wine-GE
- Gestión de emuladores (RetroArch, Dolphin, PCSX2, RPCS3)
- Sincronización con librerías de Steam, GOG, Epic, Humble
- Scripts de instalación mantenidos por la comunidad

```bash
# Instalar juegos con Lutris:
# https://lutris.net/games/ → buscar juego → "Install" → se abre en Lutris
# O desde la CLI:
lutris -i https://lutris.net/api/installers/.../script
```

---

## Heroic Games Launcher

**Heroic** es un launcher open source para **Epic Games Store** y **GOG** en Linux. Esencial para quienes tienen juegos gratis de Epic o compras en GOG.

```bash
# Instalación
flatpak install flathub com.heroicgameslauncher.hgl
# O desde AUR:
yay -S heroic-games-launcher-bin

# Características:
# - Tienda integrada de Epic Games y GOG
# - Juegos gratis semanales de Epic
# - Gestión de Wine/Proton (puedes elegir la versión)
# - Cloud saves (Epic y GOG)
# - DXVK/VKD3D configurables por juego
# - Modo offline
```

---

## Bottles

[[Bottles]] es un frontend gráfico moderno para Wine que organiza aplicaciones en **botellas** (entornos aislados). A diferencia de Lutris (enfocado en bibliotecas de juegos), Bottles está diseñado para gestionar entornos Wine completos con un clic.

```bash
# Instalación (Flatpak recomendado)
flatpak install flathub com.usebottles.bottles

# Características clave:
# - Entornos preconfigurados: Gaming, Software, Custom
# - Gestión de dependencias integrada (vcrun, dotnet, directx, etc.)
# - Runners: Caffe, Wine-GE, Proton GE, Soda
# - DXVK/VKD3D/Fsync/Esync configurables por botella
# - Exportación e importación de botellas completas
```

**Cuándo usar Bottles vs Lutris**:
- **Bottles**: ideal para apps sueltas, entornos aislados, pruebas rápidas
- **Lutris**: ideal para bibliotecas grandes, integración con Steam/Epic/GOG, scripts comunitarios

Ver [[Bottles]] para la nota completa.

---

## GameHub

**GameHub** es un gestor de bibliotecas de juegos unificado para Linux que centraliza tus juegos de **Steam, GOG, Humble Bundle e itch.io** en una sola interfaz, independientemente de si son nativos de Linux o requieren Wine/Proton.

```bash
# Instalación
flatpak install flathub com.github.tkashkin.gamehub

# Características:
# - Unifica todas las plataformas en una sola vista
# - Soporte para Steam, GOG, Humble Bundle, itch.io
# - Gestión de Wine/Proton por juego
# - Descarga directa de juegos (GOG, Humble, itch.io)
# - Estadísticas de tiempo jugado
# - Búsqueda y filtros por plataforma, estado, género
```

**Cuándo usar GameHub**:
- Tienes juegos repartidos en múltiples plataformas y quieres una vista unificada
- Quieres descargar juegos directo sin abrir el navegador
- Prefieres una interfaz GTK moderna sobre la web de cada plataforma

---

## itch.io

**itch.io** es una plataforma de distribución indie con su propio launcher de código abierto para Linux. Es el hogar de miles de juegos independientes, game jams y assets de desarrollo.

```bash
# Instalación del launcher
flatpak install flathub io.itch.itch
# O descargar desde: https://itch.io/app

# Características:
# - Navegador y tienda integrados
# - Descarga y actualización automática de juegos
# - Gestión de biblioteca indie
# - Soporte para juegos nativos Linux y Windows (Wine/Proton)
# - Integración con game jams (Ludum Dare, GMTK, etc.)
# - Colecciones y búsqueda por tags
```

**itch.io en la práctica**:
- Ideal para descubrir juegos indie, demos y prototipos
- Muchos juegos tienen versión nativa Linux
- Para juegos Windows sin Linux, se puede ejecutar con Wine/Lutris/Bottles
- El launcher itch.io en Linux es compatible con Steam Deck

---

## Emulación

Linux es la mejor plataforma para emulación gracias a la gran cantidad de emuladores nativos de alto rendimiento. La mayoría están disponibles como **Flatpak** (para aislamiento y facilidad de actualización) o como paquetes nativos.

### Tabla completa de emuladores

| Consola | Emulador | Estado en Linux | Instalación |
|---|---|---|---|
| **PlayStation 1** | DuckStation | ✅ Excelente, ciclo preciso | `flatpak install flathub org.duckstation.DuckStation` |
| **PlayStation 2** | PCSX2 | ✅ Excelente | `flatpak install flathub net.pcsx2.PCSX2` |
| **PlayStation 3** | RPCS3 | ✅ Muy bueno | `flatpak install flathub net.rpcs3.RPCS3` |
| **PlayStation Vita** | Vita3K | ✅ En desarrollo activo | `flatpak install flathub org.vita3k.Vita3K` |
| **PSP** | PPSSPP | ✅ Excelente | `flatpak install flathub org.ppsspp.PPSSPP` |
| **Nintendo Switch** | Ryujinx / Yuzu | ✅ Ryujinx activo (Yuzu discontinuado) | `flatpak install flathub org.ryujinx.Ryujinx` |
| **Wii U** | Cemu | ✅ Bueno, fork nativo Linux | `flatpak install flathub info.cemu.Cemu` |
| **GameCube / Wii** | Dolphin | ✅ Excelente | `flatpak install flathub org.DolphinEmu.dolphin-emu` |
| **Nintendo DS** | MelonDS | ✅ Muy bueno | `flatpak install flathub net.melonds.MelonDS` |
| **Nintendo 3DS** | Citra / Lime3DS | ✅ Bueno (Citra discontinuado) | `flatpak install flathub io.github.lime3ds.Lime3DS` |
| **Xbox (original)** | Xemu | ✅ Bueno | `flatpak install flathub app.xemu.xemu` |
| **Sega Dreamcast** | Flycast | ✅ Excelente | `flatpak install flathub org.flycast.Flycast` |
| **Arcade / MAME** | MAME | ✅ Nativo | `apt install mame` |
| **Multi-sistema** | RetroArch | ✅ Unifica todos los cores | `flatpak install flathub org.libretro.RetroArch` |

### Ryujinx — emulador de Nintendo Switch

**Ryujinx** es el emulador de Nintendo Switch más activo en Linux (Yuzu fue discontinuado en 2024 por demandas legales). Escrito en C#, soporta la mayoría del catálogo de Switch.

```bash
# Instalación
flatpak install flathub org.ryujinx.Ryujinx

# Requisitos:
# - CPU: x86_64 con soporte AVX2
# - GPU: Vulkan 1.3 (AMD/Intel/NVIDIA)
# - RAM: 8 GB mínimo, 16 GB recomendado
# - Firmware de Switch (requiere dump de consola real)

# Rendimiento:
# - La mayoría de juegos AAA funcionan a 30-60 FPS
# - Soporte de escalado (2x, 3x, 4x resolución)
# - Save states, shader cache, mulitplayer local
# - Soporte para mandos (JoyCon, Pro Controller, Xbox, DualSense)
```

### Vita3K — emulador de PlayStation Vita

**Vita3K** es el primer y único emulador funcional de PlayStation Vita. Está en desarrollo activo pero ya ejecuta una buena cantidad de títulos comerciales.

```bash
# Instalación
flatpak install flathub org.vita3k.Vita3K

# Estado actual:
# - Alrededor de 500+ juegos arrancan (muchos con problemas gráficos)
# - ~100 juegos considerados jugables
# - Soporte para archivos .vpk (homebrew) y .pkg (comerciales)
# - Renderizado por OpenGL y Vulkan
# - Save states

# Requisitos:
# - CPU: x86_64
# - GPU: OpenGL 4.3+ o Vulkan 1.1+
# - RAM: 4 GB mínimo
# - Firmware de Vita (descargable legalmente desde Sony)
```

### DuckStation — emulador de PlayStation 1

**DuckStation** es el emulador de PS1 más preciso, con ciclo exacto de CPU/GPU, soporte de parches de parpadeo de texturas y escalado a resolución 4K/8K.

```bash
flatpak install flathub org.duckstation.DuckStation
```

### Xemu — emulador de Xbox original

**Xemu** emula la Xbox original de Microsoft (2001). Requiere el BIOS/MCpx de la consola (dump legal necesario).

```bash
flatpak install flathub app.xemu.xemu
```

### Cemu — emulador de Wii U

**Cemu** comenzó como emulador de Wii U para Windows (2015) y desde 2022 tiene versión nativa Linux. Ejecuta la mayoría del catálogo de Wii U a 60 FPS.

```bash
flatpak install flathub info.cemu.Cemu
```

### RetroArch — el frontend universal

[RetroArch](https://www.retroarch.com/) es el emulador todo-en-uno que unifica decenas de sistemas en una sola interfaz mediante **cores** (bibliotecas de emulación intercambiables).

```bash
# Instalación
flatpak install flathub org.libretro.RetroArch

# Cores populares:
# - PCSX-ReARMed     → PlayStation 1
# - SwanStation      → PlayStation 1 (precisión)
# - Beetle PSX HW    → PlayStation 1 (GPU acelerada)
# - PCSX2            → PlayStation 2
# - Dolphin          → GameCube / Wii
# - PPSSPP           → PSP
# - MelonDS          → Nintendo DS
# - Snes9x           → Super Nintendo
# - Genesis Plus GX  → Mega Drive / Genesis
# - Mupen64Plus      → Nintendo 64
# - Flycast          → Dreamcast
# - MAME 2003+       → Arcade

# Descargar cores desde RetroArch:
# Main Menu → Online Updater → Core Downloader

# Configuración recomendada para GPU:
# Settings → Video → Output → Fullscreen Mode
# Settings → Video → Synchronization → Wait for VSync
# Settings → Audio → Resampler → Sinc (calidad)
```

---

## Juegos nativos de código abierto

Linux tiene una amplia colección de juegos libres y de código abierto de gran calidad:

| Juego | Tipo | Instalación |
|---|---|---|
| **0 A.D.** | Estrategia histórica (Age of Empires-like) | `apt install 0ad` |
| **SuperTuxKart** | Carreras karting | `apt install supertuxkart` |
| **Warzone 2100** | Estrategia en tiempo real | `apt install warzone2100` |
| **OpenTTD** | Simulación de transporte (Transport Tycoon) | `apt install openttd` |
| **Freeciv** | Estrategia por turnos (Civilization-like) | `apt install freeciv` |
| **Battle for Wesnoth** | Estrategia por turnos fantasy | `apt install wesnoth` |
| **Luanti (antes Minetest)** | Mundo abierto tipo Minecraft | `apt install luanti` |
| **Hedgewars** | Estrategia por turnos (Worms-like) | `apt install hedgewars` |

```bash
# Todos estos juegos se instalan con el gestor de paquetes del sistema
# y están en los repos oficiales de la mayoría de distros
```

---

## Distribuciones para gaming

| Distro | Base | Ideal para |
|---|---|---|
| **SteamOS** | Arch | Steam Deck, consolas |
| **Nobara Linux** | Fedora | Gaming de escritorio (mantenida por GloriousEggroll) |
| **Garuda Linux** | Arch | Gaming, preconfigurado |
| **Pop!_OS** | Ubuntu | Gaming + productividad |
| **CachyOS** | Arch | Gaming, optimizado |
| **Fedora** | Fedora | Gaming con RPM Fusion |

---

## Troubleshooting

```bash
# 1. Verificar drivers gráficos
glxinfo | grep "OpenGL renderer"       # renderer OpenGL
vulkaninfo --summary | grep "GPU"      # Vulkan device
DRI_PRIME=1 glxinfo | grep "OpenGL renderer"  # GPU dedicada (laptop con hybrid)

# 2. Errores comunes y soluciones

# "Vulkan not found" → instalar drivers Vulkan
sudo apt install mesa-vulkan-drivers vulkan-tools     # AMD/Intel
sudo pacman -S vulkan-radeon vulkan-tools              # AMD
sudo pacman -S vulkan-intel vulkan-tools               # Intel
sudo pacman -S nvidia-utils vulkan-tools               # NVIDIA

# "DLL not found" → instalar con winetricks
winetricks vcrun2022 corefonts directx9

# Juego no arranca en Steam con Proton → probar Proton GE
# o lanzar con:
PROTON_LOG=1 %command%               # genera log en ~/steam-*.log
# Ver el log para identificar errores

# Pantalla negra al lanzar juego → probar con:
# Opciones de lanzamiento en Steam:
PROTON_USE_WINED3D=1 %command%        # forzar OpenGL en vez de Vulkan
# O:
gamemoderun %command%                 # con Feral GameMode (optimizador de CPU/GPU)

# 3. GameMode (optimización automática)
sudo apt install gamemode              # Debian/Ubuntu
sudo pacman -S gamemode                # Arch
# Activar por juego en Steam: añadir "gamemoderun %command%" en opciones de lanzamiento
```

---

## Enlaces externos

- [ProtonDB](https://www.protondb.com/) — base de datos de compatibilidad
- [Lutris](https://lutris.net/) — game launcher universal
- [Heroic Games Launcher](https://heroicgameslauncher.com/) — Epic/GOG en Linux
- [WineHQ](https://www.winehq.org/) — documentación oficial de Wine
- [GlitchEgg's Proton GE](https://github.com/GloriousEggroll/proton-ge-custom) — Proton personalizado
- [Gaming on Linux](https://www.gamingonlinux.com/) — noticias y guías

## Ver también

- Wine — capa de compatibilidad base (ver sección en esta nota)
- [[Gestores de Paquetes]] — instalar Steam, Lutris, emuladores
- [[PipeWire]] — audio de baja latencia para juegos
- [[Multimedia (GStreamer HandBrake VLC MPV)]] — codecs y aceleración
- [[Personalización en Linux]] — temas gaming para el escritorio

#programa #juegos
