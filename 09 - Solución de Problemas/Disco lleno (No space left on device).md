---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: troubleshooting
sistema: almacenamiento
prioridad: alta
---

# Disco lleno — "No space left on device"

> El sistema muestra el error "No space left on device", las aplicaciones no pueden escribir archivos, o el sistema operativo se comporta de forma errática por falta de espacio en disco.

## Síntoma

- Mensaje `No space left on device` al intentar crear/guardar archivos
- `/tmp` lleno impide ejecutar programas
- El sistema va lento, especialmente al arrancar
- Las actualizaciones fallan por falta de espacio temporal
- El navegador no puede descargar archivos
- `journald` deja de registrar logs

## Diagnóstico

```bash
# 1. Ver espacio usado por partición
df -h                                    # discos montados, uso en %
df -h / /home /var /tmp                  # particiones específicas
df -i /                                   # **inodos** — a veces hay espacio pero se acabaron los inodos

# 2. Encontrar los directorios que más pesan (desde la raíz)
sudo du -sh /* 2>/dev/null | sort -rh | head -20   # nivel superior
sudo du -sh /var/* 2>/dev/null | sort -rh | head -10
sudo du -sh /home/* 2>/dev/null | sort -rh | head -10

# 3. Buscar archivos grandes (>100MB) en todo el sistema
sudo find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null | sort -k5 -rh | head -20

# 4. Espacio ocupado por logs
sudo journalctl --disk-usage               # logs de systemd
sudo du -sh /var/log                        # logs tradicionales
sudo du -sh /var/cache/apt                   # caché de paquetes (Debian/Ubuntu)

# 5. Snap y Flatpak (ocupan sorprendentemente mucho)
snap list                                   # paquetes Snap instalados
du -sh /var/lib/snapd                       # espacio total de Snap
flatpak list --columns=all                  # aplicaciones Flatpak
du -sh /var/lib/flatpak                     # espacio total de Flatpak

# 6. Docker (si aplica)
docker system df                            # espacio usado por imágenes/contenedores
```

## Causa

1. **Logs acumulados** — `journald` o rsyslog sin límite de tamaño pueden ocupar GBs con el tiempo.
2. **Caché de paquetes** — `apt` guarda `.deb` descargados en `/var/cache/apt/archives/`.
3. **Snap/Flatpak/Docker** — imágenes y paquetes ocupando espacio sin control.
4. **Inodos agotados** — particiones con muchos archivos pequeños (caches de npm, ~/.cache, ~/.thumbnails).
5. **Archivos temporales** — `/tmp` no se limpia adecuadamente (especialmente si no es tmpfs).
6. **Núcleos viejos** — kernels antiguos acumulados en `/boot`.

## Solución

```bash
# 1. Limpiar logs de journald
sudo journalctl --vacuum-size=200M         # dejar solo 200MB de logs
sudo journalctl --vacuum-time=7d           # dejar solo últimos 7 días
# Configurar límite permanente:
# sudo nano /etc/systemd/journald.conf
# SystemMaxUse=200M

# 2. Limpiar caché de paquetes
# Debian/Ubuntu
sudo apt clean                             # borrar todos los .deb cacheados
sudo apt autoclean                         # borrar solo los obsoletos
sudo apt autoremove                        # eliminar dependencias huérfanas

# Arch
sudo pacman -Sc                            # limpiar caché (./cache/pacman/pkg)
sudo pacman -Scc                           # limpiar todo (incluyendo repo db)

# Fedora
sudo dnf clean all

# 3. Kernels antiguos (liberan espacio en /boot)
# Debian/Ubuntu
sudo apt autoremove --purge                # elimina kernels viejos automáticamente

# Arch — mantener solo los 2 últimos
sudo pacman -Rns $(pacman -Qdtq)           # dependencias huérfanas
# Para kernels: pacman -Rns linux-OLD

# 4. Limpiar Snap
snap list --all                            # ver versiones viejas
sudo snap remove --revision <REV> <PAQUETE>  # eliminar revisión específica
# O limpiar automáticamente:
sudo snap set system refresh.retain=2      # mantener solo 2 versiones por paquete

# 5. Limpiar Flatpak
flatpak uninstall --unused                 # runtimes no usados
flatpak remove --delete-data <APP>         # eliminar app + datos

# 6. Sistema de archivos con inodos agotados
# Si df -i muestra 100% de uso aunque haya espacio, necesitas eliminar archivos pequeños
# Típicamente ~/.cache, ~/.thumbnails, node_modules
find ~/.cache -type f | wc -l             # contar archivos
rm -rf ~/.cache/*                          # limpiar caché de usuario

# 7. Docker
docker system prune -a --volumes           # ¡cuidado! borra contenedores e imágenes no usados
```

### Verificación

```bash
df -h                                      # espacio libre debe haber aumentado
df -i /                                    # inodos libres (si ese era el problema)
touch ~/test.txt                           # confirmar que se puede escribir
```

## Prevención

- Configurar `journald` con límite de tamaño (`SystemMaxUse=200M`) desde el inicio
- Ejecutar `sudo apt autoremove` y `sudo apt autoclean` periódicamente
- En servidores, configurar `logrotate` con políticas de retención
- Usar `ncdu` (instalable vía apt/pacman) para explorar uso de disco interactivamente
- Monitorear con `df -h` semanalmente (añadir a `cron` o `systemd timer`)
- En distros rolling, eliminar kernels viejos manualmente si `pacman -Sc` no lo hace

## Enlaces externos

- [Arch Wiki — Improving performance#Storage devices](https://wiki.archlinux.org/title/Improving_performance#Storage_devices)
- [Debian Wiki — Disk full](https://wiki.debian.org/DiskFull)
- [Ubuntu Help — Free up disk space](https://help.ubuntu.com/community/SwapFaq#How_to_free_up_disk_space)

## Ver también

- [[df y du]] — comandos de espacio en disco
- [[Logging del sistema (rsyslog journald logrotate)]] — gestión de logs
- [[Docker]] — limpieza de contenedores e imágenes
- [[Snap y Flatpak]] — formatos portables y su consumo de espacio

#troubleshooting
