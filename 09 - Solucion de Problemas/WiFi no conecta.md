---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: troubleshooting
sistema: NetworkManager
prioridad: alta
---

# WiFi no conecta / red no funciona

## Síntoma

La red WiFi no aparece en el gestor de conexiones, no se conecta aunque la contraseña sea correcta, o la conexión se cae intermitentemente.

## Diagnóstico

```bash
# 1. ¿El hardware de red está presente?
ip a                                       # ver interfaces (wlan0, wlp2s0, etc.)
lspci -k | grep -i network                 # chipset WiFi (si es PCIe)
lsusb | grep -i wlan                       # chipset WiFi (si es USB)

# 2. ¿El driver está cargado?
lspci -k | grep -A 3 -i network           # driver en uso (ej. iwlwifi, ath9k)
dmesg | grep -i firmware                   # errores de firmware WiFi

# 3. ¿NetworkManager está activo?
systemctl status NetworkManager
nmcli device status                        # estado de cada interfaz (conectado/desconectado/no gestionado)
nmcli radio wifi                           # on/off

# 4. ¿El módulo del kernel está presente?
lsmod | grep -i wl                        # buscar módulo inalámbrico

# 5. Probar conectividad básica
ping -c 4 8.8.8.8                         # conectar a internet (sin DNS)
ping -c 4 google.com                      # conectar con DNS
```

## Causa

Las causas más frecuentes son:

1. **Driver no instalado** — el chipset WiFi no tiene el firmware necesario (especialmente en distros como Debian que no incluyen firmware no-libre por defecto).
2. **rfkill bloquea el hardware** — el interruptor de software bloquea la antena WiFi.
3. **NetworkManager no gestiona la interfaz** — la interfaz aparece como "unmanaged".
4. **Problema de contraseña/protocolo** — WPA3 no soportado, o contraseña incorrecta en el keyring.

## Solución

```bash
# 1. Instalar firmware si falta (identificar chipset primero)
# Intel
sudo apt install firmware-iwlwifi          # Debian/Ubuntu
sudo pacman -S linux-firmware              # Arch (ya incluye la mayoría)
# Broadcom
sudo apt install firmware-b43-installer    # Debian/Ubuntu
# Realtek
sudo apt install firmware-realtek          # Debian/Ubuntu

# 2. Desbloquear con rfkill
rfkill list                                # ver qué está bloqueado (Soft blocked: yes)
sudo rfkill unblock wifi                   # desbloquear todo WiFi
sudo rfkill unblock all                    # desbloquear todo

# 3. Forzar NetworkManager a gestionar la interfaz
sudo nmcli device set wlp2s0 managed yes
sudo systemctl restart NetworkManager

# 4. Conectarse manualmente desde terminal
sudo nmcli device wifi list                # listar redes disponibles
sudo nmcli device wifi connect "MiRed" password "clave123"

# 5. Si nada funciona, reiniciar servicios
sudo systemctl restart NetworkManager
sudo modprobe -r iwlwifi && sudo modprobe iwlwifi  # recargar módulo (ejemplo Intel)
```

## Referencias

- [[Redes Basicas]]
- [[systemd]] — systemd-networkd como alternativa a NetworkManager
- Arch Wiki: [Network configuration/Wireless](https://wiki.archlinux.org/title/Network_configuration/Wireless)
- Debian Wiki: [WiFi](https://wiki.debian.org/WiFi)

#troubleshooting
