---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: distribucion
prioridad: media
---

# ChimeraOS

## Qué es

**ChimeraOS** es una distribución Linux inmutable diseñada específicamente para convertir cualquier PC en una **consola de juegos de salón (living room)**. Arranca directamente en Steam Big Picture sobre Gamescope, ofreciendo una experiencia tipo Steam Deck sin necesidad de conocimientos técnicos.

Originalmente llamada **GamerOS**, fue renombrada a ChimeraOS en 2021. **No es un fork de SteamOS**, sino un proyecto independiente que se inspira en la misma filosofía: una consola abierta basada en Linux. Está construida sobre **Arch Linux** como base.

```bash
# ChimeraOS no usa pacman directamente — el sistema es inmutable
# Gestor de actualizaciones: frzr (actualizaciones atómicas)
frzr-update                           # actualizar sistema completo
frzr-rollback                         # revertir a versión anterior
frzr-info                             # información de la imagen actual

# Flatpak — método recomendado para apps adicionales
flatpak install flathub com.valvesoftware.Steam
flatpak install flathub org.mozilla.firefox

# Chimera web app (gestión remota desde el móvil)
# Acceder desde el navegador: http://chimeraos.local
```

| Aspecto | Detalle |
|---|---|
| **Gestor** | frzr (imágenes atómicas) + Flatpak |
| **Base** | Arch Linux |
| **Init** | systemd |
| **Rama** | Rolling (actualizaciones atómicas por imagen) |
| **DE** | Solo Gaming Mode (sin escritorio tradicional) |
| **Gamescope** | Nativo, preconfigurado |
| **Soporte NVIDIA** | Limitado (AMD recomendado) |

## Filosofía y público objetivo

- **Experiencia consola**: el sistema arranca directamente en Steam Big Picture sobre Gamescope. No hay escritorio KDE/GNOME — es solo juegos.
- **Appliance**: diseñado para usuarios que quieren encender el PC, coger el mando y jugar, sin tocar configuraciones.
- **Actualizaciones atómicas**: el sistema usa **frzr**, que descarga imágenes completas y las aplica de forma atómica. Nunca se rompe por una actualización parcial.
- **Rollback instantáneo**: si una actualización falla, se puede revertir desde el menú de arranque.
- **Inmutable**: el sistema raíz es de solo lectura. No se puede instalar paquetes con pacman directamente.
- Público objetivo: jugadores de sofá que quieren una consola Steam en su salón.

## Características clave

### 1. Arquitectura inmutable (frzr)

```
┌─────────────────────────────────────────────────┐
│                  ChimeraOS                        │
├─────────────────────────────────────────────────┤
│ Imagen base: Arch Linux optimizada               │
│ (sistema de solo lectura, inmutable)             │
├─────────────────────────────────────────────────┤
│ frzr gestiona las actualizaciones por imagen:    │
│ - Descarga imagen completa en segundo plano      │
│ - Aplica al reiniciar (intercambio atómico)      │
│ - Rollback seleccionable en bootloader           │
├─────────────────────────────────────────────────┤
│ /home → persistente, escribible                  │
│ /var  → persistente (Flatpaks, configuraciones)  │
│ /usr  → solo lectura                             │
├─────────────────────────────────────────────────┤
│ Flatpaks en /var/lib/flatpak                     │
└─────────────────────────────────────────────────┘
```

### 2. Gamescope + Steam Big Picture

ChimeraOS inicia automáticamente Gamescope con Steam Big Picture:

```bash
# Lo que ejecuta al arrancar (equivalente):
gamescope -W 1920 -H 1080 -r 60 -- steam -gamepadui

# Con FSR para escalado (rendimiento en GPUs medias):
gamescope -W 1280 -H 720 -w 1920 -h 1080 -F fsr -- steam -gamepadui
```

### 3. Chimera web app

ChimeraOS incluye una interfaz web accesible desde cualquier navegador en la misma red:

```bash
# http://chimeraos.local/ — desde el móvil, tablet u otro PC
# Permite:
# - Gestionar juegos fuera de Steam (Epic, GOG, emulación)
# - Ver el estado del sistema (temperatura, almacenamiento)
# - Apagar, reiniciar, actualizar
# - Acceder a la terminal remota
```

### 4. Juegos fuera de Steam

ChimeraOS ofrece una interfaz unificada para juegos de otras plataformas (Epic, GOG, emuladores) a través de la web app, sin necesidad de instalar Lutris o Heroic manualmente.

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | x86_64 (Intel 4ª gen+ / AMD Ryzen) | AMD Ryzen 3000+ |
| **RAM** | 4 GB | 8 GB |
| **GPU** | Vulkan 1.3 (AMD/Intel) | AMD RDNA 1+ (RADV) |
| **Almacenamiento** | 64 GB | 256 GB+ SSD |
| **Arranque** | UEFI | UEFI |
| **Mando** | Xbox o PlayStation vía USB/BT | Control inalámbrico |

> **Nota sobre NVIDIA**: ChimeraOS tiene soporte limitado para NVIDIA. Se recomienda AMD para la mejor experiencia.

## Instalación

```bash
# 1. Descargar ISO desde https://chimeraos.org/
# 2. Grabar en USB
sudo dd if=chimeraos.iso of=/dev/sdX bs=4M status=progress

# 3. Arrancar desde USB e instalar
#    - El instalador es minimalista (similar a Arch Linux)
#    - Seleccionar disco (se borrará todo el contenido)
#    - Crear usuario (se usa para sudo y SSH)
#    - La instalación tarda ~5-10 minutos

# 4. Post-instalación
#    - Conectar el mando vía USB o Bluetooth
#    - Iniciar sesión en Steam (Big Picture se abre automáticamente)
#    - Configurar red desde la interfaz de Steam
```

## Problemas conocidos

| Problema | Causa | Solución |
|---|---|---|
| **Pantalla negra al arrancar** | GPU NVIDIA sin drivers | Usar GPU AMD/Intel o probar Bazzite |
| **No detecta el mando** | Bluetooth no configurado | Probar con cable USB primero |
| **WiFi no funciona** | Firmware no incluido | Usar Ethernet o conectar vía móvil |

## Ver también

- [[HoloISO]] — fork abandonado de SteamOS para PC
- [[Bazzite]] — alternativa activa con soporte NVIDIA
- [[SteamOS]] — la distro gaming original de Valve
- [[Videojuegos en Linux]] — gaming en Linux en general
- [[Gamescope]] — compositor micro-gráfico de Valve

## Enlaces externos

- [ChimeraOS — Página oficial](https://chimeraos.org/)
- [ChimeraOS — GitHub](https://github.com/ChimeraOS/chimeraos)
- [frzr — Sistema de actualizaciones atómicas](https://github.com/ChimeraOS/frzr)

#distro #gaming
