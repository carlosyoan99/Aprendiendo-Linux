---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: media
---

# Utilidades Base del Sistema

## Qué es

Muchos programas vienen instalados por defecto en prácticamente cualquier distro Linux. No son aplicaciones con las que interactúes directamente la mayoría del tiempo, pero operan \"por detrás\" gestionando recursos esenciales. Saber que existen te evita instalar cosas que ya tienes, o diagnósticar problemas que parecen de una app y son del sistema base.

| Utilidad | Área | Componentes clave |
|---|---|---|
| **coreutils** | Comandos básicos de archivos/texto | `ls`, `cp`, `mv`, `cat`, `rm`, `mkdir`, `wc`, `sort`, `cut`, `tr`, `tee` |
| **GNU binutils** | Herramientas de binarios | `strings`, `objdump`, `nm`, `strip`, `readelf` |
| **util-linux** | Utilidades de sistema | `lsblk`, `fdisk`, `mount`, `kill`, `dmesg`, `logger`, `nsenter` |
| **procps-ng** | Procesos | `ps`, `top`, `kill`, `uptime`, `free`, `vmstat`, `w`, `pgrep`, `pkill` |
| **systemd** | Init + servicios + logs | `systemctl`, `journalctl`, `systemd-analyze`, `timedatectl`, `hostnamectl` |
| **NetworkManager** | Gestión de red | `nmcli`, `nmtui`, `nm-connection-editor` |
| **CUPS** | Impresión | `lp`, `lpstat`, `lpadmin`, interfaz web en :631 |
| **PipeWire** (o PulseAudio) | Audio | `pw-cli`, `pw-dump`, `pavucontrol` (GUI de PulseAudio que también sirve) |
| **systemd timers/cron** | Tareas programadas | `systemctl list-timers`, `crontab` |
| **GRUB** / systemd-boot | Bootloader | `grub-install`, `grub-mkconfig`, `/boot/`

## coreutils — la base absoluta

Viene en toda distro GNU/Linux. Sin él, no puedes ni listar archivos. Prácticamente todos los comandos que usas a diario (`ls`, `cp`, `mv`, `cat`, `rm`) vienen de aquí.

```bash
# Algunos menos conocidos pero muy útiles
echo "a b c" | cut -d' ' -f2      # imprime "b" — cortar por columnas
sort archivo.txt | uniq -c         # ordenar y contar duplicados
echo "HOLA" | tr 'A-Z' 'a-z'      # convertir a minúsculas
comando | tee archivo.log          # mostrar en pantalla y guardar en archivo
seq 1 10 | paste -s -d+ | bc      # suma del 1 al 10 (¡juegos con pipes!)
```

## Gestores de servicios

| Acción | systemd | openrc (Alpine/Gentoo) |
|---|---|---|
| Iniciar servicio | `systemctl start nginx` | `rc-service nginx start` |
| Activar en boot | `systemctl enable nginx` | `rc-update add nginx default` |
| Ver logs | `journalctl -u nginx -f` | `tail -f /var/log/nginx/access.log` |

Ver [[systemd]] para más detalle.

## Audio: PipeWire

Desde 2022-2023, PipeWire es el servidor de audio por defecto en la mayoría de distros (Fedora, Arch, Ubuntu 23.04+). Reemplaza a PulseAudio y además maneja video (pantallas compartidas en Wayland).

```bash
# Diagnóstico rápido de audio
pactl info                   # info del servidor de audio
pw-cli list-objects | head  # listar dispositivos PipeWire
pavucontrol                  # mezclador de audio gráfico
alsamixer                    # controles de volumen por hardware
```

## Red: NetworkManager

```bash
nmcli device status          # estado de interfaces (conectado/desconectado)
nmcli connection show        # conexiones guardadas
nmtui                        # menú interactivo en terminal
nmcli device wifi connect "MiRed" password "clave123"
```

Ver [[Redes Basicas]].

## Bootloader: GRUB

```bash
# Regenerar configuración de GRUB (hacer después de cambios en /etc/default/grub)
sudo grub-mkconfig -o /boot/grub/grub.cfg

# En distros Debian/Ubuntu
sudo update-grub
```

## Por qué importa

- Muchos de estos programas ya están instalados — no necesitas buscar \"una app para X\" si ya tienes la herramienta correcta.
- Cuando troubleshooteas un problema, saber qué componente es el responsable (¿es de red? → NetworkManager. ¿Es de audio? → PipeWire. ¿Es de arranque? → GRUB) acelera el diagnóstico.

## Ver también

- [[systemd]]
- [[Redes Basicas]]
- [[Cheat Sheet - Comandos Esenciales]]
- [[Automatizacion y Scripts]]

## Enlaces externos

- [Wikipedia — GNU Core Utilities](https://en.wikipedia.org/wiki/GNU_Core_Utilities)
- [Wikipedia — Util-linux](https://en.wikipedia.org/wiki/Util-linux)
- [Sitio oficial — GNU Coreutils](https://www.gnu.org/software/coreutils/)
- [Sitio oficial — util-linux](https://github.com/util-linux/util-linux)

#programa #sistema
