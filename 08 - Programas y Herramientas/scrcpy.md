---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: baja
---

# scrcpy

## Qué es

scrcpy (screen copy) es una herramienta que permite mostrar y controlar un dispositivo Android desde el ordenador a través de USB o WiFi. Se destaca por su **baja latencia** (~30ms), buena calidad (hasta 4K), y porque **no requiere root** — solo USB Debugging. Es esencial para desarrolladores de apps, grabación de pantallas Android o simplemente usar el móvil desde el PC con teclado y mouse.

## Instalación

```bash
# Arch
sudo pacman -S scrcpy

# Debian/Ubuntu
sudo apt install scrcpy

# Fedora
sudo dnf install scrcpy

# También descargable como AppImage o desde GitHub
```

## Requisitos previos

1. **Activar modo desarrollador** en Android: Ajustes → Acerca del teléfono → Tocar "Número de compilación" 7 veces.
2. **Activar USB Debugging**: Ajustes → Opciones de desarrollador → Depuración USB.
3. **Conectar el móvil por USB** y aceptar la clave de depuración cuando aparezca.

```bash
# Verificar que el dispositivo se detecta
adb devices                               # debería aparecer el dispositivo
```

## Uso básico

```bash
scrcpy                                    # conectar por USB (opciones por defecto)
scrcpy -m 1024                            # limitar resolución a 1024p (menos lag)
scrcpy -b 2M                              # limitar bitrate a 2 Mbps
scrcpy -f                                 # pantalla completa
scrcpy -S                                 # apagar pantalla del móvil al conectar
scrcpy -r grabacion.mp4                   # grabar pantalla sin mostrar
scrcpy --turn-screen-off                  # apagar pantalla del móvil
```

## scrcpy por WiFi

Sin USB, en la misma red:

```bash
# 1. Conectar por USB una vez
adb tcpip 5555                            # habilitar TCP en el móvil

# 2. Desconectar USB y conectar por IP
adb connect 192.168.1.100:5555            # IP del móvil en la red local
scrcpy                                    # funciona igual que por USB

# 3. Para volver a modo USB
adb usb
```

## Atajos de teclado clave (dentro de scrcpy)

| Atajo | Acción |
|---|---|
| `Ctrl + K` | Rotar pantalla |
| `Ctrl + O` | Apagar pantalla del móvil (toggle) |
| `Ctrl + Shift + O` | Encender pantalla del móvil |
| `Ctrl + F` | Pantalla completa (toggle) |
| `Ctrl + H` | Inicio (Home) |
| `Ctrl + Backspace` | Atrás (Back) |
| `Ctrl + S` | App switcher (recientes) |
| `Ctrl + M` | Menú contextual |
| `Ctrl + ↑/↓` | Subir/bajar volumen |
| `Ctrl + P` | Power button |
| `Ctrl + V` | Pegar texto (pega en el móvil) |
| `Ctrl + Shift + V` | Pegar texto como secuencia de teclas |
| `Ctrl + Click derecho` | Atrás (Back) |
| `Ctrl + Click medio` | Inicio (Home) |

## opciones avanzadas

```bash
# Compartir archivos con el móvil (necesita adb)
adb push archivo.mp4 /sdcard/             # copiar archivo al móvil
adb pull /sdcard/foto.jpg .               # copiar archivo desde el móvil

# Tasa de frames alta
scrcpy --max-fps 120                      # solo si el móvil soporta 120Hz

# Sin bordes
scrcpy --window-borderless

# Usar múltiples dispositivos (especificar serie)
scrcpy -s <serial>
```

## Alternativas

| Herramienta | Diferencias |
|---|---|
| **Vysor** | Similar pero versión gratuita limitada |
| **TeamViewer QuickSupport** | Remoto, no local, más latencia |

## Notas y advertencias

- scrcpy no requiere root porque usa el Android Debug Bridge (ADB), que es una herramienta oficial de desarrollo de Android.
- Para mejor rendimiento, usa USB en lugar de WiFi (menos latencia, más estable).
- Si tienes problemas de conexión: verifica que `adb devices` reconozca el dispositivo y que hayas aceptado la clave de depuración en el móvil.
- scrcpy no graba audio por defecto (solo video). Para grabar audio del móvil se necesitan herramientas adicionales.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `Device not found`/sin dispositivos | ADB no detecta el teléfono | Habilitar depuración USB y `adb devices`; probar cable/puerto |
| Pantalla negra / fps bajo | Codec sin aceleración | Probar `--video-codec` y `--max-size`; revisar rendimiento |
| No copia texto al pegar | Clipboards de Android | Usar `scrcpy --vb-codec` / `--clipboard` adecuado a versión |
| Sonido no se escucha en el PC | PipeWire/audio sink | Configurar sink de audio para captura Android |
| Control táctil no responde | Toque no mapeado por app | Reiniciar scrcpy; en apps de juego usar modo especial |

## Ver también

- [[ffmpeg]] — usado por scrcpy para la codificación de video
- [[Gestores de Paquetes]]
- [[Emuladores de Terminal]]

## Enlaces externos

- [Wikipedia — Scrcpy](https://en.wikipedia.org/wiki/Scrcpy)
- [Sitio oficial — scrcpy](https://scrcpy.org/)
- [GitHub — Genymobile/scrcpy](https://github.com/Genymobile/scrcpy)

#programa
