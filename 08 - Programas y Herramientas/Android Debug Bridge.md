---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: alta
licencia: Apache 2.0
alternativas: fastboot, scrcpy (usa ADB internamente)
---

# Android Debug Bridge (ADB)

> Herramienta de depuración universal para dispositivos Android. Permite instalar apps, acceder a un shell Unix, transferir archivos, ver logs, capturar pantallas y mucho más, todo desde la terminal de tu PC.

## Qué es

**ADB** (Android Debug Bridge) es una herramienta de línea de comandos desarrollada por Google que permite comunicarse con un dispositivo Android desde una computadora. Usa una arquitectura **cliente-servidor-demonio**: un cliente CLI se comunica con un servidor en segundo plano, que a su vez se conecta al demonio `adbd` dentro del dispositivo Android.

Está incluida en el Android SDK y también disponible como descarga independiente (Platform Tools).

## Instalación

```bash
# Debian/Ubuntu
sudo apt install adb
sudo apt install android-sdk-platform-tools-common  # reglas udev (opcional pero recomendado)

# Arch Linux
sudo pacman -S android-tools

# Fedora
sudo dnf install android-tools

# Desde Google (versión más actualizada)
# Descargar: https://developer.android.com/studio/releases/platform-tools
# Extraer y añadir al PATH

# Verificar instalación
adb --version
```

## Habilitar ADB en el dispositivo Android

1. **Activar Opciones de desarrollador**: Ajustes → Acerca del teléfono → Presionar "Número de compilación" 7 veces
2. **Activar Depuración USB**: Ajustes → Opciones de desarrollador → Depuración USB → ON
3. **Conectar por USB** y aceptar la huella digital RSA en el dispositivo

```bash
# Verificar que el dispositivo es detectado
adb devices
# Debe mostrar: List of devices attached
#              0123456789ABCDEF    device
```

## Comandos esenciales

```bash
# --- Información y diagnóstico ---
adb devices                    # listar dispositivos conectados
adb get-state                  # device | offline | unauthorized
adb shell getprop ro.build.version.sdk  # versión de Android SDK
adb shell dumpsys battery      # estado de la batería
adb shell dumpsys meminfo      # uso de memoria

# --- Shell remoto ---
adb shell                      # terminal interactiva en el dispositivo
adb shell ls /sdcard/          # ejecutar comando único
adb shell pm list packages     # listar apps instaladas
adb shell dumpsys package      # info detallada de apps

# --- Instalar y gestionar apps ---
adb install app.apk            # instalar APK
adb install -r app.apk         # reinstalar (conservando datos)
adb install -t app.apk         # instalar APK de testing
adb uninstall com.miapp       # desinstalar app
adb shell pm path com.miapp   # ruta del APK instalado

# --- Transferencia de archivos ---
adb push archivo.txt /sdcard/   # copiar PC → dispositivo
adb pull /sdcard/archivo.txt .  # copiar dispositivo → PC

# --- Logs y debugging ---
adb logcat                      # mostrar logs del sistema
adb logcat -c                   # limpiar logs
adb logcat | grep -i error      # filtrar errores
adb bugreport                   # reporte completo (logs + diagnóstico)

# --- Capturas y grabación ---
adb shell screencap /sdcard/screenshot.png
adb pull /sdcard/screenshot.png

adb shell screenrecord /sdcard/video.mp4  # grabar pantalla (Ctrl+C para detener)
adb pull /sdcard/video.mp4

# --- Gestión de particiones y recovery ---
adb reboot                     # reiniciar
adb reboot bootloader          # reiniciar en modo fastboot/bootloader
adb reboot recovery            # reiniciar en recovery
adb reboot edl                 # reiniciar en modo EDL (Qualcomm)
```

## ADB por Wi-Fi (Android 11+)

```bash
# 1. Conectar por USB primero
# 2. Habilitar ADB por Wi-Fi en el dispositivo
adb tcpip 5555
# 3. Desconectar USB y conectar por IP
adb connect 192.168.1.100:5555
adb devices                    # debe mostrar 192.168.1.100:5555  device

# 4. Para desconectar
adb disconnect 192.168.1.100:5555
```

## Comandos avanzados

```bash
# Backup completo (sin root, Android < 12)
adb backup -apk -shared -all -f backup.ab

# Restaurar backup
adb restore backup.ab

# Forzar app a detenerse
adb shell am force-stop com.miapp

# Enviar un Intent (abrir app/web)
adb shell am start -a android.intent.action.VIEW -d https://google.com

# Simular entrada táctil
adb shell input tap 500 1000             # tocar coordenadas (x, y)
adb shell input swipe 500 1000 500 100   # deslizar
adb shell input keyevent KEYCODE_HOME    # botón home

# Ver actividades en primer plano
adb shell dumpsys window | grep -E 'mCurrentFocus|mFocusedApp'
```

## Arquitectura interna

```
┌──────────────┐       TCP/5037       ┌──────────────┐      USB/TCP      ┌──────────────┐
│   Cliente    │ ──────────────────►  │   Servidor   │ ───────────────►  │   Demonio    │
│  (adb CLI)   │                      │  (adb fork)  │                  │  (adbd en    │
│              │                      │              │                  │   Android)   │
└──────────────┘                      └──────────────┘                  └──────────────┘
```

- **Cliente**: el comando `adb` que ejecutas en la terminal
- **Servidor**: proceso en segundo plano en el PC (puerto TCP 5037)
- **Demonio (adbd)**: proceso en el dispositivo Android

## Seguridad

- **Autenticación RSA**: Al conectar, el dispositivo muestra una huella digital RSA que debes aceptar (a partir de Android 4.2.2)
- **Malware**: ADB abierto a internet es explotado por botnets (ADB.Miner, Ares, IPStorm). **Nunca expongas el puerto 5555 a internet**
- **RageAgainstTheCage**: Exploit antiguo (Android < 2.2) que agotaba PIDs para conseguir shell root

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `unauthorized` | No aceptaste la clave RSA en el dispositivo | Revisar pantalla del dispositivo y aceptar |
| `device offline` | ADB perdió conexión | `adb kill-server && adb start-server && adb devices` |
| `no permissions` | Faltan reglas udev | `sudo apt install android-sdk-platform-tools-common` |
| `adb: error: connect failed: Connection refused` | ADB por Wi-Fi no habilitado | `adb tcpip 5555` desde USB primero |
| `error: insufficient permissions for device` | Usuario no en grupo plugdev | `sudo usermod -aG plugdev $USER` y reconectar |

## Notas personales

- ADB es la herramienta más útil para cualquier persona que tenga un dispositivo Android y un PC Linux
- Combinado con `scrcpy` puedes controlar el teléfono desde el PC (ver [[scrcpy]])
- Para usuarios avanzados: ADB + Tasker = automatización ilimitada del teléfono sin root
- ADB es esencial si alguna vez rompes el sistema Android y necesitas recuperar datos

## Enlaces externos

- [Documentación oficial ADB (Android Developers)](https://developer.android.com/tools/adb)
- [Platform Tools (descarga directa)](https://developer.android.com/studio/releases/platform-tools)
- [Arch Wiki — Android Debug Bridge](https://wiki.archlinux.org/title/Android_Debug_Bridge)
- [Gentoo Wiki — Android/adb](https://wiki.gentoo.org/wiki/Android/adb)
- [LineageOS Wiki — Using ADB and fastboot](https://wiki.lineageos.org/adb_fastboot_guide)
- [Wikipedia — Android Debug Bridge](https://es.wikipedia.org/wiki/Android_Debug_Bridge)

## Ver también

- [[scrcpy]] — controlar Android desde el PC (usa ADB)
- [[Android (sistema basado en Linux)]] — Android como sistema Linux
- [[Git]] — control de versiones, también esencial para desarrollo

#programa #android #depuracion
