---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: media
---

# pavucontrol

> Panel gráfico de control de volumen y dispositivos de audio para PulseAudio/PipeWire: salida, entrada, aplicación por aplicación.

## Qué es

**pavucontrol** (PulseAudio Volume Control) es un mixer gráfico que permite controlar el volumen de dispositivos de audio, redirigir salidas, seleccionar micrófonos y ajustar el volumen **por aplicación** de forma independiente. Funciona tanto con PulseAudio como con PipeWire (vía la capa de compatibilidad `pipewire-pulse`).

**Casos de uso típicos:**
- Muteear una aplicación específica sin afectar al volumen global
- Redirigir audio de una app a un dispositivo diferente (ej: Spotify → auriculares, navegador → altavoces)
- Seleccionar micrófono cuando hay varios conectados
- Ajustar niveles de grabación (gain del micrófono)

## Instalación

```bash
# Debian/Ubuntu
sudo apt install pavucontrol

# Arch / CachyOS
sudo pacman -S pavucontrol

# Fedora
sudo dnf install pavucontrol

# openSUSE
sudo zypper install pavucontrol
```

## Uso

```bash
pavucontrol        # abrir el panel gráfico
```

## Funcionalidad

| Pestaña | Uso |
|---|---|
| **Reproducción** | Ajusta el volumen por aplicación y redirige la salida |
| **Grabación** | Controla qué app graba y de qué micrófono |
| **Salidas** | Elige dispositivo de salida (altavoces, auriculares, HDMI) y volumen |
| **Entradas** | Selecciona micrófono y su volumen |
| **Configuración** | Modo de cada tarjeta (analógico, digital, HDMI, surround) |

### Volumen por aplicación

En la pestaña **Reproducción** aparecen todos los programas que están emitiendo audio. Puedes:
- Subir/bajar el volumen de cada uno independientemente
- Muteear individualmente (botón de altavoz junto a cada app)
- Redirigir la salida: pulsar el icono de altavoz y elegir otro dispositivo

### Selección de micrófono

En **Entradas**, el micrófono activo tiene una flecha azul. Para cambiar:
1. Seleccionar el micrófono deseado
2. Pulsar la flecha azul para fijarlo como predeterminado
3. Ajustar el nivel de ganancia (volumen de entrada)

## Comparativa con alternativas

| Aspecto | pavucontrol |pw-recording | GNOME Settings | KMix |
|---|---|---|---|---|
| **Volumen por app** | ✅ | ❌ | ❌ | ❌ |
| **Redirigir salida** | ✅ | ❌ | ❌ | ❌ |
| **Selección micrófono** | ✅ | ❌ | ✅ | ✅ |
| **Funciona con PipeWire** | ✅ | N/A | ✅ | ✅ |
| **Ligero** | ✅ | ✅ | ❌ | ❌ |
| **Multi-dispositivo** | ✅ | ❌ | ❌ | ✅ |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No aparecen aplicaciones | PipeWire/PulseAudio no corriendo | `systemctl --user status pipewire pipewire-pulse` |
| Dispositivo no listado | Tarjeta en modo incorrecto | Pestaña Configuración → cambiar modo (ej: Analógico Estéreo) |
| Volumen por app no funciona | app usa ALSA directamente | Configurar la app para usar PulseAudio/PipeWire |
| Sin audio tras suspended | Dispositivo en suspensión | Seleccionar dispositivo activo y pulsar "Deferred" → "Active" |

## Notas personales

- En mi sistema (CachyOS + Noctalia + Niri), pavucontrol se abre cuando necesito ajustes finos que el widget de medios de Noctalia no cubre (cambio de dispositivo o volumen por app).
- El widget OSD de Noctalia controla el volumen global; pavucontrol es para control granular.

## Enlaces externos

- [PulseAudio — pavucontrol](https://freedesktop.org/software/pulseaudio/pavucontrol/)
- [Arch Wiki — PulseAudio/GUI](https://wiki.archlinux.org/title/PulseAudio/GUI)
- [PipeWire — PulseAudio compatibility](https://wiki.archlinux.org/title/PipeWire#PulseAudio_clients)

## Ver también

- [[PipeWire]] — servidor de audio moderno
- [[Audio en Linux]] — guía completa de audio
- [[btop]] — monitorización del sistema
- [[Desktop Shells (Noctalia Caelestia)]] — Noctalia gestiona volumen/mic por OSD

#programa #audio #pulseaudio #pipewire
