---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: troubleshooting
sistema: NetworkManager
prioridad: alta
---

# WiFi no conecta / red inalámbrica no funciona

> La red WiFi no aparece, no se conecta aunque la contraseña sea correcta, o la conexión se cae intermitentemente. Las causas van desde firmware faltante hasta NetworkManager sin gestión de la interfaz.

## Síntoma

- El icono de WiFi aparece pero no se ven redes disponibles.
- Al introducir la contraseña, vuelve a pedirla sin conectarse.
- La conexión funciona unos minutos y luego se cae.
- La interfaz WiFi aparece en `ip a` pero no en el gestor de redes gráfico.
- `nmcli device status` muestra la interfaz como "unmanaged" o "disconnected".

## Diagnóstico

```bash
# 1. ¿El hardware de red está presente?
ip a                                       # interfaces de red (wlan0, wlp2s0, etc.)
lspci -k | grep -i network                 # chipset WiFi PCIe
lsusb | grep -i wlan                       # chipset WiFi USB

# 2. ¿El driver/firmware está cargado correctamente?
lspci -k | grep -A 3 -i network            # driver en uso (iwlwifi, ath9k, rtw88, etc.)
dmesg | grep -i firmware                   # errores de firmware WiFi
dmesg | grep -i "iwlwifi\|ath\|rtw"      # mensajes específicos del driver
lsmod | grep -i wl                         # módulos inalámbricos cargados

# 3. ¿NetworkManager está activo y gestiona la interfaz?
systemctl status NetworkManager
nmcli device status                        # estado de cada interfaz
nmcli radio wifi                           # radio on/off

# 4. ¿rfkill bloquea la antena?
rfkill list                                # ver bloqueos Soft/Hard blocked

# 5. Probar conectividad básica
ping -c 4 8.8.8.8                         # sin DNS
ping -c 4 google.com                      # con DNS
```

### Logs relevantes

```bash
# Logs de NetworkManager
journalctl -u NetworkManager --no-pager -n 30 | grep -i wifi
journalctl -u NetworkManager --no-pager -n 50 | grep -E "wlan|wlp|error|fail"

# Logs del kernel relacionados con WiFi
dmesg | grep -iE "wlan|wifi|iwlwifi|firmware" | tail -20

# Ver historial de conexiones (passwords almacenadas)
sudo cat /etc/NetworkManager/system-connections/*.nmconnection 2>/dev/null
```

## Causa

1. **Firmware no instalado** — el chipset WiFi necesita firmware que la distro no incluye (especialmente Debian sin repos non-free, o chipsets Realtek/Broadcom que requieren paquetes externos).
2. **rfkill bloquea el hardware** — soft-block o hard-block (interruptor físico en laptops) desactiva la antena.
3. **NetworkManager no gestiona la interfaz** — la interfaz aparece como "unmanaged" porque otro servicio (systemd-networkd, netplan, ifupdown) la controla.
4. **Problema de autenticación** — WPA3 no soportado por el router o el driver, contraseña incorrecta en el keyring, o cambio de contraseña no reflejado.
5. **Driver inestable o incompatible** — especialmente chipsets Realtek rtl8xxx y algunos Broadcom en kernels recientes.

## Solución

```bash
# 1. Instalar firmware necesario (identificar chipset con lspci -k)

# Intel (más común, buen soporte)
sudo apt install firmware-iwlwifi          # Debian/Ubuntu
sudo pacman -S linux-firmware              # Arch (ya incluye la mayoría)
sudo dnf install iwlwifi-firmware          # Fedora

# Realtek (problemático, requiere pasos extra)
sudo apt install firmware-realtek          # Debian/Ubuntu
# Para rtl88x2bu, rtl88x2cu: compilar desde AUR o fuente
yay -S rtl88x2bu-dkms                     # Arch (ejemplo)

# Broadcom
sudo apt install firmware-b43-installer    # Debian/Ubuntu (chipset antiguo)
sudo apt install broadcom-sta-dkms         # Debian/Ubuntu (chipset moderno)

# 2. Desbloquear antena con rfkill
rfkill list                                # ver bloqueos
sudo rfkill unblock wifi                   # desbloquear WiFi
sudo rfkill unblock all                    # desbloquear todo

# 3. Forzar NetworkManager a gestionar la interfaz
nmcli device status                        # ver estado
sudo nmcli device set <interfaz> managed yes  # ej: wlp2s0
sudo systemctl restart NetworkManager

# Si systemd-networkd gestiona la interfaz (⚠️ VERIFICAR PRIMERO):
# Enmascarar systemd-networkd puede romper IPs estáticas, bridges o VLANs.
# Mejor: configurar NetworkManager para gestionar WiFi sin desactivar systemd-networkd:
#   /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
#   [keyfile]
#   unmanaged-devices=none
# Si realmente quieres desactivar systemd-networkd (solo si no lo usas):
# sudo systemctl mask systemd-networkd

# 4. Conectarse manualmente desde terminal
sudo nmcli device wifi list                # escanear redes
sudo nmcli device wifi connect "MiRed" password "clave123"
sudo nmcli device wifi connect "MiRed" password "clave123" name "MiRed"

# Si hay varias redes con mismo SSID (2.4GHz + 5GHz):
sudo nmcli device wifi connect --bssid "AA:BB:CC:DD:EE:FF" password "clave"

# 5. Recargar módulo del kernel (ejemplo para Intel)
sudo modprobe -r iwlwifi
sudo modprobe iwlwifi

# 6. Editar configuración de NetworkManager para priorizar WiFi
# /etc/NetworkManager/NetworkManager.conf:
# [device]
# wifi.backend=iwd                          # usar iwd en vez de wpa_supplicant
# wifi.scan-rand-mac-address=yes
```

### Verificación

```bash
nmcli device status                        # interfaz debe mostrar "connected"
nmcli connection show --active             # conexión activa
ping -c 4 8.8.8.8                         # conectividad a internet
```

## Escenarios / Variantes

| Variante / Síntoma | Causa | Solución |
|---|---|---|
| **WiFi aparece pero no conecta** | Contraseña incorrecta o WPA3 incompatible | Usar WPA2 en el router, o conectar con `nmcli device wifi connect "SSID" password "..." --wifi-sec.key-mgmt wpa-psk` |
| **Conexión se cae cada pocos minutos** | Power saving del WiFi o driver inestable | `iw dev wlp2s0 set power_save off` o `sudo nano /etc/NetworkManager/conf.d/wifi-power-save.conf` con `[connection] wifi.powersave=2` |
| **WiFi lento comparado con otros dispositivos** | Canal congestionado o banda incorrecta | Forzar 5GHz: `nmcli connection modify "MiRed" 802-11-wireless.band a` |
| **"No wifi adapter found"** en distro nueva | Firmware no incluido por licencia | En Debian: agregar repos non-free-firmware y `apt install firmware-iwlwifi`. En Fedora: `dnf install rpmfusion-nonfree-release` |
| **Interfaz aparece como "unmanaged"** | systemd-networkd, netplan o ifupdown gestiona la interfaz | `sudo systemctl mask systemd-networkd` o configurar netplan para que NetworkManager gestione WiFi |
| **WiFi no funciona tras suspensión** | Módulo no se reinicia al reanudar | Crear `/etc/systemd/system/wifi-resume.service` que ejecute `modprobe -r iwlwifi && modprobe iwlwifi` al reanudar |
| **Intel AX201/AX210 no detectado** | Falta firmware iwlwifi-QuZ | Instalar `linux-firmware` actualizado (Debian: backports, Arch: pacman -Syu linux-firmware) |

## Prevención

1. **Antes de instalar una distro**, verificar que el chipset WiFi tenga buen soporte en Linux (Intel es lo más compatible; evitar Broadcom y ciertos Realtek).
2. **Mantener `linux-firmware` actualizado**: `sudo apt update && sudo apt upgrade linux-firmware`.
3. **Usar NetworkManager** como gestor de red (no systemd-networkd para WiFi) — tiene mejor manejo de conexiones inalámbricas.
4. **Si reinstalas la distro**, guardar las conexiones WiFi: `/etc/NetworkManager/system-connections/*.nmconnection`.
5. **Desactivar power saving** en conexiones inestables: en `/etc/NetworkManager/conf.d/wifi-power-save.conf` añadir `[connection] wifi.powersave=2`.

## Notas adicionales

- Si tienes dos gestores de red activos (NetworkManager + systemd-networkd), uno bloqueará al otro. Decide cuál usar y desactiva el otro.
- El firmware de Intel se actualiza con el paquete `linux-firmware`. Si tu chipset es muy nuevo, puede que necesites una versión más reciente (Debian backports, o kernel mainline).
- Para Realtek, la experiencia varía enormemente según el chipset exacto. Consultar la compatibilidad antes de comprar un adaptador USB WiFi.
- `wpa_supplicant` es el backend por defecto de NetworkManager. Puede reemplazarse por `iwd` (Intel Wireless Daemon) para mejor rendimiento: `sudo apt install iwd` y configurar `wifi.backend=iwd` en `NetworkManager.conf`.

## Enlaces externos

- [Arch Wiki — Network configuration/Wireless](https://wiki.archlinux.org/title/Network_configuration/Wireless)
- [Debian Wiki — WiFi](https://wiki.debian.org/WiFi)
- [Ubuntu Help — WiFi troubleshooting](https://help.ubuntu.com/stable/ubuntu-help/net-wireless-troubleshooting.html)
- [Arch Wiki — iwd](https://wiki.archlinux.org/title/Iwd)
- [NetworkManager docs](https://networkmanager.dev/docs/)

## Ver también

- [[Redes Basicas]] — conceptos de red en Linux
- [[systemd]] — systemd-networkd como alternativa a NetworkManager
- [[ip]] — comandos de red
- [[ss]] — diagnóstico de sockets
- [[Error de permisos]] — problemas de permisos en red

#troubleshooting
