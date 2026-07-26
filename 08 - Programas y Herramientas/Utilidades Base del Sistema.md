---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: media
---

# Utilidades Base del Sistema — Índice

Muchos programas vienen instalados por defecto en prácticamente cualquier distro Linux. Esta página mapea los paquetes base y sus notas asociadas.

## Paquetes base

| Paquete | Área | Componentes clave | Nota |
|---|---|---|---|
| **coreutils** | Archivos/texto | `ls`, `cp`, `mv`, `cat`, `rm`, `mkdir`, `sort`, `cut`, `tr`, `tee` | [[Coreutils y util-linux]] |
| **util-linux** | Sistema | `lsblk`, `fdisk`, `mount`, `kill`, `dmesg`, `logger` | [[Coreutils y util-linux]] |
| [[binutils]] | Binarios | `strings`, `objdump`, `nm`, `strip`, `readelf` | Propia |
| [[procps-ng]] | Procesos | `ps`, `top`, `kill`, `uptime`, `free`, `vmstat` | Propia |
| **systemd** | Init + logs | `systemctl`, `journalctl`, `timedatectl` | [[systemd]] |
| **NetworkManager** | Red | `nmcli`, `nmtui` | [[NetworkManager]] |
| **CUPS** | Impresión | `lp`, `lpstat`, `lpadmin` | [[Impresión (CUPS)]] |
| **PipeWire** | Audio | `pw-cli`, `pw-dump`, `pavucontrol` | [[PipeWire]] |
| **GRUB** / systemd-boot | Bootloader | `grub-mkconfig`, `update-grub` | [[Bootloaders (GRUB Limine systemd-boot)]] |
| **Cron / systemd timers** | Tareas | `crontab`, `systemctl list-timers` | [[Cron]], [[systemd timers]] |

## Por qué importa

- Muchos ya están instalados — no necesitas buscar "una app para X" si ya tienes la herramienta.
- Cuando troubleshooteas, saber qué componente es responsable acelera el diagnóstico.

## Ver también

- [[Coreutils y util-linux]] — comandos base GNU
- [[systemd]] — init y servicios
- [[Cheat Sheet - Comandos Esenciales]]
- [[Automatización y Scripts]]

## Enlaces externos

- [Wikipedia — GNU Core Utilities](https://en.wikipedia.org/wiki/GNU_Core_Utilities)
- [Wikipedia — Util-linux](https://en.wikipedia.org/wiki/Util-linux)
- [Sitio oficial — GNU Coreutils](https://www.gnu.org/software/coreutils/)
- [Sitio oficial — util-linux](https://github.com/util-linux/util-linux)

#programa #sistema
