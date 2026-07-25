---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: distribucion
prioridad: alta
gestor_paquetes: apt (dpkg)
base: Ubuntu
---

# Pop!_OS

## Filosofía / público objetivo

Desarrollada por **System76** (fabricante de laptops/PCs con Linux preinstalado). Fuerte enfoque en **gaming y trabajo técnico/creativo**, con excelente soporte out-of-the-box para GPUs NVIDIA (ISO separada con drivers incluidos). De las pocas distros que trata el soporte NVIDIA como ciudadano de primera clase desde la instalación.

Pop!_OS es la distro flagship de System76, la compañía que fabrica las laptops Thelio, Lemur, Gazelle, Darter, Oryx, Pangolin, etc. Todo el desarrollo de Pop!_OS está orientado a ofrecer la mejor experiencia tanto en hardware System76 como en PCs genéricas.

---

## Diferencial: COSMIC Desktop

Pop!_OS originalmente usaba GNOME con extensiones propias (Pop Shell, tiling automático). A partir de 2023-2024, System76 está desarrollando **COSMIC** desde cero en **Rust**, como un DE independiente — no un fork de GNOME.

| Etapa | Versión | Estado |
|---|---|---|
| **COSMIC antigua** (GNOME + Pop Shell) | Pop!_OS 22.04 LTS | Estable, mantenimiento |
| **COSMIC nueva** (Rust nativo, `cosmic-epoch`) | Pop!_OS 24.04+ | Alpha/Beta 2025, estable ~2026 |

### Arquitectura

COSMIC está construido sobre el toolkit **iced** (Rust) y usa el protocolo **Wayland** de forma nativa (sin X11). Su arquitectura modular:

```
cosmic-comp          → compositor Wayland (reescrito en Rust)
cosmic-app-library  → lanzador de aplicaciones
cosmic-applet-*     → applets del panel (red, sonido, batería, notificaciones)
cosmic-bg           → gestor de fondos de pantalla
cosmic-config       → centro de configuración
cosmic-edit         → editor de texto
cosmic-files        → gestor de archivos
cosmic-greeter      → pantalla de login
cosmic-notify       → sistema de notificaciones
cosmic-osd          → overlays (volumen, brillo, captura)
cosmic-panel        → panel superior / barra de tareas
cosmic-screenshot   → capturas de pantalla
cosmic-settings     → configuración del sistema
cosmic-workspace    → gestión de workspaces
```

### Tiling automático integrado

COSMIC incluye tiling automático como **parte integral del DE**, no como extensión (a diferencia de la Pop Shell antigua sobre GNOME). Funciona sin configurar pero es altamente configurable:

```bash
# Atajos de teclado principales (COSMIC)
Super + Y          → activar/desactivar tiling
Super + Enter      → abrir terminal
Super + D          → mostrar escritorio
Super + ←→↑↓       → mover foco entre ventanas
Super + Ctrl + ←→  → mover ventana entre workspaces
Super + Mouse arr  → reordenar ventanas tileadas con drag & drop
```

| Layout | Descripción |
|---|---|
| **Horizontal** | Ventanas lado a lado (columnas) |
| **Vertical** | Ventanas apiladas (filas) |
| **Grid** | Cuadrícula automática |
| **Focus** | Una ventana grande + el resto minimizadas a la izquierda |

### Workspaces dinámicos

COSMIC usa workspaces dinámicos al estilo GNOME: se crean y destruyen automáticamente según los necesites.

```bash
Super + PageUp/Down  → navegar entre workspaces
Super + Home/End     → ir al primer/último workspace
Super + Shift + ←→   → mover ventana a otro workspace
```

Los workspaces soportan **nombres personalizados** y **colores** desde el centro de configuración.

### Perfiles de energía

COSMIC tiene un selector de perfiles de energía integrado en el panel (icono de batería/rayo):

| Perfil | CPU | GPU | Ventiladores | Ideal para |
|---|---|---|---|---|
| **Battery** (ahorro) | Reducida | Integrada | Silenciosos | Navegación, ofimática, batería |
| **Balanced** | Normal | Automática | Automáticos | Uso diario general |
| **Performance** | Máxima | Dedicada | Agresivos | Gaming, render, ML/AI |

```bash
# Cambiar perfil desde terminal
system76-power profile performance    # performance / balanced / battery

# Ver perfil actual
system76-power profile

# Si no tienes system76-power (hardware no System76):
# COSMIC usa los controles de CPU genéricos (governor, etc.)
```

### Centro de configuración COSMIC (cosmic-settings)

Todas las opciones de COSMIC se configuran desde una sola aplicación unificada, sin necesidad de extensiones de terceros ni tweaks:

```bash
# Lanzar configuración
Super + I           → atajo directo
# O desde la terminal:
cosmic-settings

# Categorías disponibles:
# - Apariencia (tema, fondo, dock, panel, acentos)
# - Escritorio (tiling, workspaces, esquinas calientes)
# - Displays (monitores, resolución, escalado por monitor)
# - Energía (perfiles, suspensión, brillo automático)
# - Atajos de teclado (todos editables)
# - Red, Sonido, Notificaciones, Privacidad, Cuentas online
# - Mouse y Touchpad (gestos, aceleración, scroll)
```

---

## Gestor de paquetes

```bash
sudo apt update && sudo apt upgrade
sudo apt install <paquete>
apt search <paquete>
sudo apt remove <paquete>

# Pop!_OS también incluye soporte Flatpak habilitado por defecto
flatpak install flathub <paquete>
```

### Pop!_Shop

Pop!_Shop es la tienda gráfica de aplicaciones, con una interfaz moderna escrita en GTK4/libadwaita:

```bash
# Lanzar desde terminal
pop-shop

# Características:
# - Muestra aplicaciones APT y Flatpak en una sola vista unificada
# - Secciones: Destacadas, Gaming, Desarrollo, Creatividad, Educación
# - Actualizaciones del sistema desde la misma interfaz
# - Soporte para aplicaciones de paquetes .deb manuales
```

Pop!_Shop organiza las aplicaciones por categorías y muestra el origen (APT, Flatpak Flathub). Es comparable a GNOME Software pero con mejor integración de Flatpak y soporte para paquetes .deb.

---

## Soporte NVIDIA y GPUs híbridas

Pop!_OS es la distro recomendada por muchos para gaming y ML/AI con GPUs NVIDIA por su soporte nativo:

```bash
# La ISO "NVIDIA" incluye los drivers privativos listos para usar
# No necesitas instalar nada extra — el driver se configura automáticamente

# Detección automática de GPU en laptops híbridas (Intel/AMD + NVIDIA)
```

### Gestión de GPUs híbridas

Desde el menú de energía (icono de batería en el panel) se puede cambiar el modo gráfico:

| Modo | GPU activa | Batería | Rendimiento | Cuándo usarlo |
|---|---|---|---|---|
| **Integrado** | Solo iGPU | ✅ Excelente | ❌ Bajo | Navegación, ofimática, máxima batería |
| **NVIDIA** | Solo dGPU | ❌ Mínima | ✅ Máximo | Gaming, CUDA, render, ML |
| **Híbrido** | iGPU + dGPU bajo demanda | 🔶 Bueno | 🔶 Alto | Uso diario (lo recomendado) |

```bash
# Cambiar modo gráfico desde terminal
sudo system76-power graphics integrated    # modo integrado
sudo system76-power graphics nvidia        # solo NVIDIA
sudo system76-power graphics compute       # NVIDIA para compute, Intel para display

# Ver modo actual
system76-power graphics

# ⚠️ Cambiar de modo gráfico requiere cerrar sesión y volver a entrar
# (o reiniciar en algunos casos)
```

### Lanzar aplicaciones con GPU dedicada (modo híbrido)

```bash
# Desde terminal: ejecutar con GPU NVIDIA
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia steam

# Desde la GUI: botón derecho sobre la app → "Launch with Discrete GPU"
# COSMIC permite asignar GPU por aplicación desde el menú de configuración
```

### Verificar que NVIDIA funciona

```bash
nvidia-smi                               # estado del driver
glxinfo | grep -i "OpenGL renderer"      # qué GPU está renderizando
```

---

## System76 Hardware

Pop!_OS está diseñado para funcionar de manera óptima en hardware System76, pero funciona perfectamente en cualquier PC:

### Laptops System76

| Modelo | Tipo | CPU | GPU | Peso |
|---|---|---|---|---|
| **Oryx Pro** | Workstation | Intel Core i9/HX | RTX 4070-4090 | 2.5 kg |
| **Gazelle** | Rendimiento | Intel Core i7/H | RTX 4060-4070 | 2.3 kg |
| **Lemur Pro** | Ultraportátil | Intel Core i7/P | Iris Xe (solo iGPU) | 1.1 kg |
| **Darter Pro** | Portátil fino | Intel Core i7/P | Iris Xe / RTX 3050 | 1.5 kg |
| **Pangolin** | Ryzen | AMD Ryzen 7 | Radeon / RX 6000 | 1.8 kg |
| **Galago Pro** | Compacto | Intel Core i7/U | Iris Xe | 1.2 kg |

### Desktop System76

| Modelo | Tipo | CPU | GPU |
|---|---|---|---|
| **Thelio** | Workstation/Render | Threadripper / Core i9 | Hasta RTX 6000 / Radeon Pro W7900 |
| **Thelio Mira** | Compacto | Core i7/Ryzen 7 | Hasta RTX 4080 |
| **Thelio Mega** | Servidor | Threadripper Pro Dual | Sin GPU (cálculo) |

### Firmware (coreboot + EDK2)

System76 usa **coreboot** + **EDK2** como firmware en sus equipos, en lugar del firmware propietario tradicional. Esto permite:

```bash
# Actualizar firmware desde Linux (sin Windows)
sudo apt update
sudo apt install system76-firmware
sudo system76-firmware-cli update

# Ver versión actual del firmware
sudo system76-firmware-cli info

# Acceder a la configuración del firmware desde el arranque
# (pulsar Supr o F2 durante el POST)
```

---

## Recovery Partition (Recuperación)

Pop!_OS crea una **partición de recuperación** durante la instalación que permite reparar o reinstalar el sistema sin necesidad de un USB externo:

```bash
# Acceder a la recuperación:
# 1. Durante el arranque, mantener ESPACIADA (o Enter en el menú GRUB)
# 2. Elegir "Recovery Mode"

# Opciones disponibles en el modo recovery:
# - Reparar paquetes rotos (dpkg --configure -a)
# - Reinstalar Pop!_OS conservando /home
# - Reinstalar Pop!_OS desde cero (borra todo)
# - Restaurar el bootloader
# - Abrir una terminal con acceso root

# Verificar que la partición de recuperación existe:
lsblk | grep recovery
# Debería haber una partición etiquetada "recovery" de ~4-8 GB

# Si no existe, se puede crear desde Pop!_OS:
sudo pop-upgrade recovery create
```

**Ventaja sobre otras distros:** No necesitas un USB de rescate. Si el sistema se rompe, arrancas en recovery desde el menú GRUB y puedes reparar o reinstalar sin depender de otro medio.

---

## Ciclo de lanzamiento

Sigue el ritmo de Ubuntu (LTS cada 2 años), con versiones intermedias menos frecuentes. System76 prioriza estabilidad sobre rapidez en nuevas features.

| Versión | Base Ubuntu | COSMIC | Lanzamiento | Soporte hasta |
|---|---|---|---|---|
| 22.04 LTS | 22.04 | GNOME + Pop Shell | Abril 2022 | Abril 2027 |
| 24.04 LTS | 24.04 | COSMIC Rust nativo | Abril 2024 | Abril 2029 |
| 24.10 | 24.10 | COSMIC (actualizaciones) | Oct 2024 | Jul 2025 |

---

## Notas de instalación propias

```bash
# Al instalar Pop!_OS:
# 1. Elegir la ISO correcta: "NVIDIA" si tienes GPU NVIDIA, "Intel/AMD" si no
# 2. El instalador crea automáticamente la partición de recovery (~4-8 GB)
# 3. Opcional: cifrado de disco (LUKS) disponible durante la instalación
# 4. Pop!_OS detecta y configura NVIDIA automáticamente

# Post-instalación recomendada:
sudo apt update && sudo apt full-upgrade -y
sudo apt install pop-desktop             # asegurar paquetes COSMIC completos
```

## Ver también

- [[Ubuntu]] — base de Pop!_OS
- [[Linux Mint]] — otra alternativa amigable para escritorio
- [[CachyOS]] — distro gaming optimizada (alternativa)
- [[Bazzite]] — distro gaming inmutable (alternativa)
- [[Gestores de Paquetes]] — apt, Flatpak, dpkg
- [[coreboot]] — firmware libre que usa System76
- [[Videojuegos en Linux]] — gaming en Pop!_OS

## Enlaces externos

- [Pop!_OS — Página oficial](https://pop.system76.com/)
- [System76 — Hardware](https://system76.com/)
- [COSMIC Desktop — Repositorio GitHub](https://github.com/pop-os/cosmic-epoch)
- [Pop!_OS Documentation](https://support.system76.com/)
- [Pop!_OS Wiki](https://github.com/pop-os/pop/wiki)
- [Wikipedia — Pop!_OS](https://en.wikipedia.org/wiki/Pop!_OS)

#distro
