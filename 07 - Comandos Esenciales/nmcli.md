---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: comando
prioridad: alta
---

# nmcli

> Herramienta de línea de comandos para gestionar NetworkManager. Permite configurar conexiones WiFi, Ethernet, VPN y dispositivos de red con cambios persistentes.

## Sintaxis

```bash
nmcli [opciones] {general | radio | device | connection | networking} comando [argumentos]
```

## Descripción

`nmcli` (NetworkManager CLI) es la interfaz de terminal de NetworkManager, el gestor de red estándar en la mayoría de distros (GNOME, KDE...). A diferencia de `ip` — que configura la red de forma inmediata pero temporal —, `nmcli` guarda los cambios como conexiones persistentes que se reactivan al reiniciar. Leer estados no requiere privilegios; modificar, sí (se suele anteponer `sudo`). No es destructivo en su uso habitual, aunque `nmcli connection delete` elimina conexiones guardadas si se usa a la ligera.

## Formato de salida

`nmcli device status`:

| Columna | Significado |
|---|---|
| `DEVICE` | Interfaz (wlan0, eth0, lo...) |
| `TYPE` | Tipo (wifi, ethernet, loopback...) |
| `STATE` | Estado (connected, disconnected, unmanaged...) |
| `CONNECTION` | Nombre de la conexión activa |

`nmcli connection show` presenta las propiedades de cada conexión en pares clave/valor.

## Opciones frecuentes

| Flag / Opción | Efecto | Ejemplo |
|---|---|---|
| `-a` | Interactivo: pide contraseñas | `nmcli -a dev wifi connect MiRed` |
| `-p` | Salida pretty (tablas humanas) | `nmcli -p connection show` |
| `-t` | Salida terse, para scripts | `nmcli -t -f NAME connection show` |
| `-f` | Filtrar campos | `nmcli -f DEVICE,TYPE device` |
| `-g` | Solo valores, sin encabezados | `nmcli -g GENERAL.STATE device` |
| `--ask` | Pregunta credenciales en línea | `nmcli --ask connection up MiRed` |

## Ejemplos de uso

```bash
nmcli general status                    # estado global de NetworkManager
nmcli device status                     # interfaces y su estado
nmcli device wifi list                  # redes WiFi disponibles
nmcli device wifi connect "MiRed" password "secreto"
nmcli connection show                   # conexiones guardadas
nmcli connection up "MiRed"             # activar una conexión
nmcli connection down "MiRed"           # desactivarla
nmcli connection delete "MiRed"         # borrarla (¡cuidado!)
nmcli device disconnect wlan0           # soltar el dispositivo
nmcli radio wifi off                    # apagar la radio WiFi

sudo nmcli connection modify "ETH" ipv4.addresses 192.168.1.50/24
sudo nmcli connection modify "ETH" ipv4.gateway 192.168.1.1
sudo nmcli connection modify "ETH" ipv4.dns 8.8.8.8
sudo nmcli connection modify "ETH" ipv4.method manual
```

## Casos de uso reales

- Conectar una Raspberry Pi (o un servidor headless) a WiFi vía SSH, sin entorno gráfico.
- Fijar IP estática en un servidor casero: con `ip` el cambio se pierde al reiniciar; con `nmcli` persiste.
- Compartir la conexión (hotspot) desde la terminal: `nmcli device wifi hotspot ssid X password Y`.
- Scripts de automatización: parsear `nmcli -t` dentro de `bash` o cron.
- Reordenar la prioridad de reconexión de varias conexiones con `connection.autoconnect-priority`.

## Combinaciones comunes con pipe

```bash
nmcli -t -f DEVICE,STATE device | grep connected        # interfaces conectadas
nmcli device wifi list | awk 'NR>1 {print $1, $2}' | sort -u   # SSID y BSSID
nmcli -g GENERAL.STATE device                             # solo estados
nmcli connection show | grep -i vpn                       # conexiones VPN
nmcli -f SSID,SIGNAL,SECURITY device wifi list | column -t
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Ventaja |
|---|---|---|
| `nmcli` (prompt) | `nmtui` | Asistente de texto interactivo (TUI) |
| `nmcli dev wifi list` | `nm-applet` | Panel gráfico en el escritorio |
| `nmcli conn modify` | `systemd-networkd` | Config declarativa por archivo `.network` |
| `nmcli` | `networkctl` | Alternativa fuera de NetworkManager |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `Error: NetworkManager is not running` | Daemon NM detenido | `sudo systemctl enable --now NetworkManager` |
| `nmcli: command not found` | Paquete `network-manager` ausente | `sudo apt install network-manager` |
| `Device not available` | Interfaz deshabilitada o sin firmware | `nmcli radio all` y revisar `dmesg` |
| No conecta a WiFi nueva | Falta contraseña o red oculta | `nmcli -a dev wifi connect` y `hidden yes` |
| La IP no persiste tras reiniciar | Se configuró con `ip`, no con `nmcli` | Redefinir con `nmcli connection modify` |

## Notas y advertencias

- Con NetworkManager activo, `nmcli` es la vía recomendada: respeta el daemon y las políticas del escritorio.
- Los cambios con `nmcli` son persistentes por diseño: revisa antes de borrar una conexión.
- Para diagnóstico de puertos y tráfico usa `ss`, no `nmcli`; este sirve para configurar.
- Las contraseñas WiFi quedan guardadas en `/etc/NetworkManager/system-connections/` (con permisos de root): no las expongas.
- Para cambios ad-hoc sin persistir, `ip` sigue siendo la herramienta rápida.

## Enlaces externos

- [Arch Wiki — NetworkManager](https://wiki.archlinux.org/title/NetworkManager)
- [man nmcli(1)](https://man7.org/linux/man-pages/man1/nmcli.1.html)
- [NetworkManager docs](https://networkmanager.dev/docs/api/latest/)

## Ver también

- [[NetworkManager]] — el daemon que gestiona detrás de nmcli
- [[ip]] — configuración temporal de red
- [[ss]] — puertos y conexiones activas (diagnóstico)
- [[Redes Basicas]] — fundamentos de red
- [[systemd]] — gestión del servicio NetworkManager
- [[journalctl]] — ver el log de NetworkManager para diagnosticar

#comando #redes