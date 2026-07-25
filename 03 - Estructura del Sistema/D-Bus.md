---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: sistema
prioridad: alta
---

# D-Bus

## Definición

**D-Bus** es el sistema de comunicación entre procesos (IPC) del escritorio Linux moderno. Permite que aplicaciones y servicios del sistema se comuniquen entre sí de forma estructurada, enviando mensajes y exponiendo métodos, señales y propiedades.

Es una capa invisible pero fundamental: [[systemd]], [[PipeWire]], [[systemd-networkd|NetworkManager]], [[Audio en Linux|PulseAudio/PipeWire]], [[Gestores de Archivos|GNOME Files]], [[Firewall|firewalld]], y prácticamente cualquier servicio del escritorio moderno lo usa.

```bash
D-Bus en el ecosistema Linux:

  Aplicaciones:
  Firefox · Thunderbird · GNOME Files · KDE Apps
         │              │                    │
         ▼              ▼                    ▼
    ┌──────────────────────────────────────────┐
    │              D-Bus Session Bus            │  ← por usuario
    │  (comunicación entre apps de escritorio)  │
    └──────────────────────────────────────────┘
                        │
                        ▼
    ┌──────────────────────────────────────────┐
    │              D-Bus System Bus              │  ← global (root)
    │  (servicios del sistema: systemd, udev,   │
    │   NetworkManager, firewalld, logind)      │
    └──────────────────────────────────────────┘
                        │
                        ▼
    ┌──────────────────────────────────────────┐
    │          Aplicaciones / Servicios          │
    └──────────────────────────────────────────┘
```

## Dos buses

D-Bus tiene dos buses independientes:

### 1. System Bus

Bus **global** del sistema, gestiona servicios del sistema operativo. Corre como root y lo usa:

- **systemd** (gestión de servicios, logind)
- **NetworkManager** (gestión de redes)
- **firewalld** / **ufw** (firewall)
- **udisks2** (montaje de discos)
- **upower** (gestión de energía)
- **bluez** (Bluetooth)
- **colord** (gestión de color)

```bash
# Listar servicios en el system bus
busctl list --system               # lista de nombres de servicios
# Ejemplo de salida:
# org.freedesktop.NetworkManager
# org.freedesktop.systemd1
# org.freedesktop.UDisks2
# org.freedesktop.UPower
# org.bluez
```

### 2. Session Bus

Bus **por usuario**, uno por sesión gráfica. Lo usan las aplicaciones de escritorio:

- **GNOME Shell** / **KDE Plasma**
- **PipeWire** / **WirePlumber**
- **PulseAudio**
- **Gestores de archivos** (Nautilus, Dolphin)
- **Notificaciones del sistema**
- **Portapapeles**

```bash
# Listar servicios en el session bus
busctl list --user               # servicios de tu sesión
# Ejemplo:
# org.freedesktop.Notifications
# org.gnome.Shell
# org.freedesktop.PulseAudio
# org.freedesktop.portal.Desktop
# org.mpris.MediaPlayer2.firefox
```

## Conceptos clave

### Bus name (nombre en el bus)

Cada servicio se registra con un nombre único estilo DNS inverso:

```bash
org.freedesktop.NetworkManager     # servicio de red
org.freedesktop.systemd1           # systemd
org.gnome.Shell                    # GNOME Shell
org.mpris.MediaPlayer2.firefox     # Firefox reproduciendo música
```

### Objetos y paths

Cada servicio expone objetos en el bus con paths estilo sistema de archivos:

```bash
/org/freedesktop/NetworkManager          # objeto principal
/org/freedesktop/NetworkManager/Devices  # lista de dispositivos
/org/freedesktop/NetworkManager/Settings # configuración

/org/freedesktop/systemd1               # systemd
/org/freedesktop/systemd1/unit/nginx_2eservice  # servicio nginx
```

### Interfaces

Los objetos exponen interfaces (conjuntos de métodos, propiedades y señales):

```bash
org.freedesktop.NetworkManager        # interfaz principal
org.freedesktop.NetworkManager.Device  # interfaz de dispositivo de red
org.freedesktop.systemd1.Manager       # interfaz de gestión systemd
org.freedesktop.DBus.Properties       # interfaz para propiedades (todas las apps)
```

### Métodos, señales y propiedades

| Concepto | Descripción | Ejemplo |
|---|---|---|
| **Método** | Llamada que hace algo (RPC) | `NetworkManager.ActivateConnection()` |
| **Señal** | Evento que el servicio emite | `Device.StateChanged` (cable conectado/desconectado) |
| **Propiedad** | Estado que se puede leer/cambiar | `NetworkManager.WirelessEnabled` (true/false) |

## Comandos prácticos con busctl

**busctl** es la herramienta principal para interactuar con D-Bus (parte de systemd). También existe **gdbus** (GLib) y **qdbus** (Qt).

```bash
# === Información general ===

# Listar todos los servicios en el bus del sistema
busctl list --system

# Listar servicios del session bus (tu sesión gráfica)
busctl list --user

# === Inspeccionar un servicio ===

# Ver objetos y sus interfaces
busctl introspect --system org.freedesktop.NetworkManager
busctl introspect --user org.mpris.MediaPlayer2.firefox

# === Llamar a un método ===

# Pedir a systemd el estado de nginx
busctl call --system org.freedesktop.systemd1 \
  /org/freedesktop/systemd1 \
  org.freedesktop.systemd1.Manager \
  GetUnit ss "nginx.service"

# Pausar reproducción de música (MPRIS)
busctl call --user org.mpris.MediaPlayer2.firefox \
  /org/mpris/MediaPlayer2 \
  org.mpris.MediaPlayer2.Player \
  PlayPause

# === Leer una propiedad ===

# WiFi habilitada en NetworkManager
busctl get-property --system org.freedesktop.NetworkManager \
  /org/freedesktop/NetworkManager \
  org.freedesktop.NetworkManager \
  WirelessEnabled

# === Monitorizar señales ===

# Ver toda la actividad D-Bus en tiempo real
busctl monitor --system

# Ver solo un servicio específico
busctl monitor --system org.freedesktop.systemd1

# === Enviar notificación al escritorio ===

busctl call --user org.freedesktop.Notifications \
  /org/freedesktop/Notifications \
  org.freedesktop.Notifications \
  Notify s u s s s a{sv} i \
  "MiApp" 0 "dialog-info" "Título" "Mensaje" 0 5000
```

## gdbus (alternativa GLib)

```bash
# Introspect (similar a busctl)
gdbus introspect --session --dest org.freedesktop.Notifications --object-path /org/freedesktop/Notifications

# Llamar a método
gdbus call --session \
  --dest org.freedesktop.Notifications \
  --object-path /org/freedesktop/Notifications \
  --method org.freedesktop.Notifications.Notify \
  "MiApp" 0 "dialog-info" "Título" "Mensaje" '[]' '{}' 5000
```

## Ejemplos prácticos por servicio

### Controlar systemd

```bash
# Apagar el sistema
busctl call --system org.freedesktop.login1 \
  /org/freedesktop/login1 \
  org.freedesktop.login1.Manager \
  PowerOff b true

# Suspender
busctl call --system org.freedesktop.login1 \
  /org/freedesktop/login1 \
  org.freedesktop.login1.Manager \
  Suspend b true
```

### Controlar reproducción multimedia (MPRIS)

Todos los reproductores compatibles (Firefox, Spotify, VLC, MPV) exponen la interfaz MPRIS:

```bash
# Obtener título de la canción actual
busctl get-property --user org.mpris.MediaPlayer2.firefox \
  /org/mpris/MediaPlayer2 \
  org.mpris.MediaPlayer2.Player \
  Metadata

# Siguiente canción (método sin argumentos)
busctl call --user org.mpris.MediaPlayer2.firefox \
  /org/mpris/MediaPlayer2 \
  org.mpris.MediaPlayer2.Player \
  Next

# Subir volumen (Volume es una propiedad, no un método — usar set-property)
busctl set-property --user org.mpris.MediaPlayer2.firefox \
  /org/mpris/MediaPlayer2 \
  org.mpris.MediaPlayer2.Player \
  Volume d 0.5   # 0.0 a 1.0
```

### Gestionar redes con NetworkManager

```bash
# Listar conexiones disponibles
busctl call --system org.freedesktop.NetworkManager \
  /org/freedesktop/NetworkManager/Settings \
  org.freedesktop.NetworkManager.Settings \
  ListConnections

# Activar WiFi
busctl set-property --system org.freedesktop.NetworkManager \
  /org/freedesktop/NetworkManager \
  org.freedesktop.NetworkManager \
  WirelessEnabled b true
```

## D-Bus y seguridad (PolicyKit)

D-Bus se integra con **PolicyKit** para controlar qué usuarios pueden llamar a qué métodos. Por ejemplo, apagar el sistema requiere autenticación:

```bash
# Ver políticas de D-Bus
ls /usr/share/polkit-1/actions/
cat /usr/share/polkit-1/actions/org.freedesktop.login1.policy
```

## D-Bus vs otros métodos IPC

| Método IPC | Ámbito | Velocidad | Facilidad | Usado por |
|---|---|---|---|---|
| **D-Bus** | Sistema/escritorio | Media | Alta | systemd, NetworkManager, GNOME, KDE |
| **Pipes/Unix sockets** | Entre procesos locales | Alta | Baja | Shell scripts, programas C |
| **Señales Unix** | Entre procesos | Muy alta | Muy baja | Kernel, procesos relacionados |
| **Memoria compartida** | Entre procesos locales | Máxima | Muy baja | Bases de datos, multimedia |
| **gRPC/REST** | Red (local o remota) | Media | Alta | Microservicios |

## Por qué importa D-Bus

- **Es invisible pero omnipresente**: todo el escritorio Linux moderno depende de él.
- **Permite scripting del sistema**: puedes apagar, suspender, reproducir música, cambiar WiFi, enviar notificaciones — todo desde la terminal sin herramientas específicas.
- **Es la base de integración**: GNOME y KDE pueden interoperar porque ambos hablan D-Bus.
- **Entender D-Bus es entender cómo se comunican los servicios del sistema**: cuando falla algo (notificaciones rotas, volumen que no cambia, Bluetooth que no conecta), a menudo el problema está en D-Bus.

## Diagnóstico de problemas

```bash
# Verificar que D-Bus está corriendo
systemctl --user status dbus          # session bus
systemctl status dbus                # system bus

# Logs de D-Bus
journalctl -u dbus -f                # monitorear errores

# Si D-Bus no arranca (sesión gráfica rota)
# No se puede arreglar desde la sesión — reiniciar el display manager:
sudo systemctl restart gdm            # o sddm, lightdm, etc.

# Comprobar conectividad con el bus
busctl call --system org.freedesktop.DBus \
  /org/freedesktop/DBus \
  org.freedesktop.DBus.Peer \
  Ping

# Ver nombres de servicios y su estado
busctl list --system | wc -l          # cuántos servicios en system bus
busctl list --user | wc -l            # cuántos en session bus
```

## Enlaces externos

- [freedesktop.org: D-Bus Specification](https://dbus.freedesktop.org/doc/dbus-specification.html)
- [Wikipedia: D-Bus](https://en.wikipedia.org/wiki/D-Bus)
- [D-Bus Tutorial (freedesktop)](https://dbus.freedesktop.org/doc/dbus-tutorial.html)

## Ver también

- [[systemd]] — usa D-Bus para comunicar su estado (systemctl usa busctl por debajo)
- [[systemd-networkd]] — NetworkManager usa D-Bus intensivamente
- [[PipeWire]] — usa D-Bus en el session bus
- [[Firewall]] — firewalld usa D-Bus (firewall-cmd usa D-Bus internamente)
- [[Procesos y Senales]] — otras formas de IPC en Linux
- [[Redes Basicas]] — NetworkManager vía D-Bus#sistema
#ipc
