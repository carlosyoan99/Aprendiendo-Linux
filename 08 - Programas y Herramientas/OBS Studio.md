---
fecha_creacion: 2026-09-03
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: media
licencia: GPLv2
alternativas: [[Grabación de pantalla y streaming]]
---

# OBS Studio

> Software libre de **grabación de pantalla y streaming en vivo** (Open Broadcaster Software). La herramienta estándar de creadores de contenido en Linux: escenas, fuentes, audio por canales, cámara virtual y codificación por GPU.

## Qué es

OBS Studio es un programa multiplataforma (Linux/Windows/macOS) para capturar vídeo y audio, componerlos en **escenas** y emitirlos a un stream (Twitch, YouTube) o grabarlos en un archivo local. En Linux destaca por:

- **Gratuito y de código abierto** (GPLv2) — la misma versión que en otros SO.
- Soporte de captura **X11 y Wayland** (vía `pipewire`/`wlroots` y `obs-vkcapture` para juegos).
- Codificación por GPU: **NVENC** (NVIDIA), **VAAPI/AMF** (AMD), **QSV** (Intel) y **AV1** en hardware reciente.
- **Cámara virtual** (v4l2loopback) para usar la captura como webcam en videollamadas.
- API de **plugins** (Lua/C) y websocket para control remoto.

> Para codificadores, parámetros de calidad y alternativas (wf-recorder, gpu-screen-recorder, ffmpeg) ver [[Grabación de pantalla y streaming]].

## Instalación

```bash
# Debian/Ubuntu (PPA oficial con versiones nuevas)
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt update && sudo apt install obs-studio

# Fedora (RPM Fusion)
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install obs-studio

# Arch
sudo pacman -S obs-studio

# Flatpak (recomendado en Wayland por sandbox)
flatpak install flathub com.obsproject.Studio
```

### Dependencias útiles en Linux

```bash
# Cámara virtual (compartir pantalla como webcam)
sudo apt install v4l2loopback-dkms          # Debian/Ubuntu
sudo pacman -S v4l2loopback-dkms            # Arch

# Captura de juegos en Wayland (portal / obs-vkcapture)
sudo pacman -S obs-studio-git obs-vkcapture # Arch (AUR)
flatpak install flathub com.obsproject.Studio.Plugin.OBSVkCapture   # Flatpak
```

## Workflow completo de grabación/streaming

1. **Autoconfiguración** — al primer arranque, OBS ofrece un asistente que detecta tu GPU y propone ajustes base (`Herramientas → Autoconfiguración`). Elegir "Optimizar para streaming" o "grabación" según el uso.
2. **Crear escenas** — una escena por contexto: `Escena · Juego`, `Escena · Cámara`, `Escena · Escritorio`, `Escena · BRB`.
3. **Añadir fuentes** — dentro de cada escena: captura de pantalla, ventana, cámara (v4l2), texto, imagen, navegador web, audio.
4. **Ajustar audio** — añadir dispositivos de captura (micrófono) y de salida (escritorio) en `Mezclador`; aplicar filtros.
5. **Probar la salida** — `Archivo → Ver` (monitor) o `Herramientas → Vista previa`; revisar CPU/GPU en `Ver → Estadísticas`.
6. **Configurar la salida** — `Ajustes → Salida`: encoder, bitrate y ruta de grabación (ver tabla abajo).
7. **Emitir o grabar** — `Controles → Iniciar transmisión` / `Iniciar grabación`; usar atajos y `Grabación instantánea` (replay buffer).

## Escenas y fuentes (buenas prácticas)

| Fuente | Uso típico | Notas |
|---|---|---|
| Captura de pantalla (PipeWire/Wayland) | Escritorio completo | Con `obs-vkcapture` para juegos Vulkan/OpenGL en Wayland |
| Captura de ventana | Aplicación concreta | X11: por ventana; Wayland: limitado a la ventana activa |
| Dispositivo de captura de vídeo | Webcam física | Formato MJPEG preferido para bajo uso de CPU |
| Cámara virtual | Usar la escena como webcam | Requiere v4l2loopback cargado |
| Fuente de audio (entrada) | Micrófono | Añadir ruido/compresor como filtros |
| Fuente de audio (salida) | Audio del sistema | Puede duplicarse con la captura del juego |
| Texto (GDI+/FreeType) | Títulos, overlay | Evitar re-render innecesario: imágenes estáticas mejor |
| Navegador | Alertas, chat, overlays | Con OBS Browser Source, alojados en localhost |

**Sugerencias**:
- Usar **"Escena" como fuente de otra escena** (nested scenes) para mantener la composición en un solo lugar (p. ej. la webcam + marco, reutilizada en todas las escenas).
- Nombra fuentes con prefijos: `[Juego]`, `[Cam]`, `[Audio]` — facilita mantener proyectos grandes.
- Activa `Ajustes → Avanzado → Mostrar el rendimiento` para ver FPS de render y pérdida de fotogramas.

## Audio: la cadena completa

En el **Mezclador** cada fuente tiene su volumen y sus **filtros** (doble clic):

```text
Micrófono (captura) ──► Ruido (Gate) ──► Supresión de ruido (RNNoise) ──► Compresor ──► Límite
                                                                              │
Salida del escritorio ──► (sin filtros normalmente) ───────────────────────►  ▼
                                                                        Mezclador → Salida
```

- **Supresión de ruido**: filtro integrado (RNNoise) — gratis y eficaz en CPU baja.
- **Gate de ruido**: corta el micrófono cuando no hablas (evita respirar/teclado).
- **Compresor + Limitador**: iguala volumen y evita picos (distorsión) al gritar.
- **Monitorización**: botón de altavoz en cada fuente para escuchar solo esa pista.
- **Múltiples pistas de audio**: en `Salida → Grabación → Pistas`, activa pistas 1-4 y asigna cada fuente a una pista (doble clic → Avanzado). Permite editar el audio del juego y la voz por separado después.

## Atajos de teclado (Ajustes → Atajos)

| Atajo (por defecto) | Acción |
|---|---|
| `Ctrl+Shift+F5` | Iniciar transmisión |
| `Ctrl+Shift+F6` | Iniciar/detener grabación |
| `Ctrl+Shift+F7` | Pausar/reanudar grabación |
| `Ctrl+Shift+F8` | Captura instantánea (replay buffer) |
| `Ctrl+Shift+F9` | Cambiar a siguiente escena (o atajo por escena) |
| `Ctrl+Shift+M` | Silenciar/activar audio |
| `Ctrl+Shift+D` | Modo oculto de escritorio (hide) |

Puedes asignar atajos **por fuente** (p. ej. silenciar el micrófono con una tecla dedicada) y **por escena** para cambios sin ratón.

## Replay buffer (grabación instantánea)

Guarda en RAM los últimos N segundos y solo los escribe a disco cuando lo pides — perfecto para clips de momentos inesperados.

1. `Ajustes → Salida → Grabación`: marcar **Activar buffer de reproducción** y poner segundos (30-60).
2. Asignar atajo a *Guardar el buffer de reproducción* (p. ej. `Ctrl+Shift+F8`).
3. Requiere ~100 MB de RAM por minuto a 1080p — suficiente con 8 GB.

## Cámara virtual

Convierte la escena actual en una webcam `/dev/video*` para Zoom/Meet/Firefox:

```bash
# Cargar el módulo (una vez por arranque)
sudo modprobe v4l2loopback exclusive_caps=1

# En OBS: Controles → Iniciar cámara virtual
```

En Flatpak, el permiso de dispositivo ya lo gestiona el sandbox; en paquetes nativos necesitas el módulo del kernel.

## Plugins esenciales

| Plugin | Función |
|---|---|
| **obs-vkcapture** | Capturar juegos Vulkan/OpenGL en Wayland (como fuente "Captura de juego") |
| **OBS Websocket** (integrado) | Control remoto por API (p. ej. desde Streamer.bot o scripts) |
| **StreamFX** | Filtros de vídeo avanzados (blur, chroma key mejorado, bordes) |
| **advanced-scene-switcher** | Cambio automático de escena por ventana activa/audio |
| **OBS Shaderfilter / OBS Virtualcam** | Shaders GLSL y cámara virtual mejorada |

En Flatpak: `flatpak install flathub com.obsproject.Studio.Plugin.<Nombre>` (por ejemplo `...Plugin.OBSVkCapture`).

## Grabación local (ajustes recomendados)

| Uso | Encoder | Bitrate/Calidad | Formato |
|---|---|---|---|
| Clase/tutorial 1080p | `x264` (CPU) o VAAPI/NVENC | CRF 18-20 o CQ 18 | MKV (→ MP4 si necesitas) |
| Gaming 1080p60 | NVENC/AMF/QSV | CQ 16-18 | MKV |
| Gaming 4K/AV1 | AV1 (RTX 40 / RX 7000 / Arc) | CQ 25-30 | MKV |
| Archivo ligero | x264 fast | CRF 23 | MP4 |

> Graba en **MKV** mientras transmites: si OBS se cae, el archivo parcial no se corrompe; luego `Archivo → Remux` a MP4 para compatibilidad.

## Streaming (ajustes recomendados)

| Plataforma | Resolución | Bitrate | Notas |
|---|---|---|---|
| Twitch | 1080p60 | 6000 Kbps (CBR) | Twitch solo admite 6000-8000 |
| YouTube | 1080p60 / 4K | 9000-12000 Kbps (CBR) | Mejor tolerancia de bitrate |
| Kick / otros | 1080p60 | 6000-8000 | Según plataforma |

Configuración clave en `Ajustes → Salida → Transmisión`:
- **Modo de salida: Avanzado**, encoder NVENC/VAAPI para no cargar la CPU.
- `Tasa de bits`: CBR con los valores de la tabla.
- **Intervalo de keyframes: 2 s** — imprescindible para baja latencia.
- Preestablecido NVENC: `P5` (calidad) o `P6` si la CPU aguanta.
- **Bicúbico** como filtro de escala, con resolución de salida 1920x1080.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Pantalla negra al capturar en Wayland | Falta portal o obs-vkcapture | Usar Flatpak (pipewire) o lanzar el juego con `obs-vkcapture` |
| "No se pudo iniciar el servidor de streaming" | Credenciales/URL del servicio | `Ajustes → Transmisión` → pegar la clave de stream de Twitch/YouTube |
| Fotogramas perdidos (dropped frames) | Bitrate excesivo o subida insuficiente | Bajar bitrate, elegir servidor de ingesta cercano, revisar con `Ctrl+Shift+E` |
| Audio del micrófono con eco | Monitorización activa | Silenciar monitor de la fuente en el Mezclador |
| NVENC no aparece | Drivers NVIDIA sin paquete de soporte | Instalar `nvidia-utils` + reiniciar; en Flatpak añadir permiso de GPU |
| Grabación cortada/corrupta | MP4 durante stream y caída | Grabar en MKV y remux; recuperar el MKV parcial |
| Alto uso de CPU en juegos | x264 en vez de hardware | Cambiar a encoder de GPU (NVENC/VAAPI) |
| Cámara virtual no aparece | v4l2loopback no cargado | `sudo modprobe v4l2loopback exclusive_caps=1` o cargar al arranque |

## Comparativa rápida

| Herramienta | Ideal para | Notas |
|---|---|---|
| **OBS Studio** | Streaming + grabación profesional | Escenas, audio multi-track, plugins, cámara virtual |
| wf-recorder | Grabar la pantalla Wayland simple | CLI puro, un solo comando |
| gpu-screen-recorder | Baja latencia en NVIDIA | Mínimo impacto en FPS |
| ffmpeg | Automatización/scripting | Todo lo que hace OBS, sin GUI |

Ver la comparativa completa y encoders en [[Grabación de pantalla y streaming]].

## Ver también

- [[Grabación de pantalla y streaming]] — encoders, baja latencia, alternativas
- [[PipeWire]] — captura de audio/screen share en Wayland
- [[Problemas de audio avanzados]] — latencia, Bluetooth, multi-device
- [[Compatibilidad Wayland]] — captura de pantalla por portal
- [[ffmpeg]] — alternativa CLI

## Enlaces externos

- [Sitio oficial](https://obsproject.com/)
- [OBS Wiki — Linux](https://obsproject.com/wiki/unofficial-linux-builds-ubuntu-debian-mint)
- [obs-vkcapture](https://github.com/nowrep/obs-vkcapture)
- [Guía de streaming en OBS](https://obsproject.com/kb)

#programa #multimedia #streaming