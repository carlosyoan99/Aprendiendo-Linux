---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: troubleshooting
sistema: apt / pacman / dnf
prioridad: alta
---

# Paquete roto / dependencias insatisfechas

> El gestor de paquetes se niega a instalar o actualizar paquetes por dependencias rotas, conflictos de versiones, o una base de datos corrupta. La solución depende del gestor (apt, pacman, dnf) y de la causa raíz.

## Síntoma

Al ejecutar un comando de instalación o actualización, aparecen mensajes como:

```text
# Debian/Ubuntu — apt
The following packages have unmet dependencies:
 libfoo: Depends: libbar (>= 2.0) but 1.5 is installed
E: Unable to correct problems, you have held broken packages.

# Arch — pacman
error: failed to commit transaction (conflicting files)
error: failed to init transaction (unable to lock database)

# Fedora — dnf
Error: Transaction check error:
  file /usr/lib/libfoo.so from install of pkg-2.0 conflicts with file from pkg-1.0
```

El paquete se queda **sin instalar** o **medio instalado** (descomprimido pero sin configurar).

## Diagnóstico

```bash
# ── Debian/Ubuntu ──
sudo apt update                            # refrescar repos
sudo apt --fix-broken install              # intentar reparar dependencias rotas
sudo apt check                             # verificar estado del sistema de paquetes
dpkg --audit                               # buscar paquetes en estado inconsistente
dpkg -l | grep -E '^[a-z][A-Z]'           # ver paquetes con flags raros (pE, iU, etc.)

# Flags dpkg: iF = half-configured, iU = half-installed, pE = reinst-required

# ── Arch ──
sudo pacman -Syu                           # actualizar todo (puede resolver conflictos)
pacman -Qdt                                # paquetes huérfanos (dependencias no usadas)
pacman -Qkk                                # verificar integridad de paquetes instalados
sudo pacman -Dk                            # verificar base de datos (pacman 6+)
pacman -Qi <paquete>                       # info de un paquete en concreto

# ── Fedora ──
sudo dnf check                             # verificar dependencias
sudo dnf repoquery --unsatisfied           # dependencias rotas
sudo rpm -Va                                # verificar integridad de todos los paquetes
```

### Logs relevantes

```bash
# apt: logs de instalación/actualización
grep -i "broken\|error\|dpkg" /var/log/apt/history.log

# pacman: logs de transacciones (los últimos 50 eventos)
tail -50 /var/log/pacman.log

# dnf: logs de transacciones
journalctl -u dnf-makecache.service --no-pager | tail -30
```

## Causa

1. **Actualización interrumpida** — se cerró la terminal, se perdió la conexión, o se apagó el sistema durante `apt upgrade`, `pacman -Syu` o `dnf update`.
2. **Mezcla de repositorios incompatibles** — PPAs de versiones distintas de Ubuntu (ej: PPA de Noble en sistema Jammy), AUR desactualizado respecto a Arch, o repos Fedora de versiones mezcladas.
3. **Paquete instalado manualmente incompatible** — un `.deb` o `.rpm` externo (descargado de internet) que sobreescribe librerías del sistema con versiones incompatibles.
4. **Arch Linux: pacman bloqueado** — otro proceso (como pamac o un `pacman -Syu` interrumpido) dejó el archivo de bloqueo `/var/lib/pacman/db.lck`.
5. **Cambio de rama o mirror** — cambiar de repositorio sin refrescar produce inconsistencias.

## Solución

### Debian / Ubuntu

```bash
# 1. Reparación automática
sudo apt --fix-broken install

# 2. Configurar paquetes descomprimidos
sudo dpkg --configure -a

# 3. Limpiar caché y reintentar
sudo apt clean
sudo apt update
sudo apt upgrade

# 4. Si un paquete específico se resiste:
sudo dpkg --remove --force-remove-reinstreq <paquete>   # forzar eliminación
sudo apt install <paquete>                              # reinstalar

# 5. Solución drástica (⚠️ SOLO EN ÚLTIMO CASO)
# Reinstalar TODOS los paquetes del sistema. Si se interrumpe,
# el sistema puede quedar inutilizable. Preferir los pasos 1-4 primero.
# apt list --installed 2>/dev/null | grep -oP '^[^/]+' | xargs sudo apt install --reinstall -y
```

### Arch Linux

```bash
# 1. Verificar que no haya otro pacman corriendo
ps aux | grep pacman

# 2. Eliminar bloqueo (SOLO si no hay otro proceso activo)
sudo rm /var/lib/pacman/db.lck

# 3. Refrescar repos y llaves
sudo pacman -Syy
sudo pacman -S archlinux-keyring
sudo pacman -Syu

# 4. Si hay conflictos de archivos:
sudo pacman -Syu --overwrite='*'          # forzar sobreescritura (usar con precaución)

# 5. Verificar y limpiar
sudo pacman -Dk                            # diagnosticar base de datos
pacman -Qdtq | sudo pacman -Rs -          # eliminar paquetes huérfanos
sudo pacman -Sc                            # limpiar caché
```

### Fedora

```bash
# 1. Sincronizar con repositorios
sudo dnf distro-sync

# 2. Reinstalar paquete específico
sudo dnf reinstall <paquete>

# 3. Eliminar versiones duplicadas
sudo dnf remove --duplicates

# 4. Limpiar caché
sudo dnf clean all
sudo dnf makecache
```

### Verificación

```bash
# apt/snap
sudo apt check

# pacman
sudo pacman -Syu    # debe ejecutarse sin errores

# dnf
sudo dnf check
```

## Escenarios / Variantes

| Variante / Síntoma | Causa | Solución |
|---|---|---|
| **apt: "package is in a very bad inconsistent state"** | Paquete descomprimido pero no instalado por interrupción | `sudo dpkg --configure -a` seguido de `sudo apt --fix-broken install` |
| **apt: "Could not get lock /var/lib/dpkg/lock"** | Otro proceso de apt en ejecución | Verificar con `ps aux \| grep apt`, esperar o matar el proceso, eliminar lock si es seguro |
| **pacman: "conflicting files"** | Paquete instalado manualmente (/usr/local) que choca con un paquete del repo | `sudo pacman -Syu --overwrite '/ruta/al/archivo'` |
| **pacman: "invalid or corrupted package"** | Caché corrupto o mirror inconsistente | `sudo pacman -Sc` (limpiar caché) y `sudo pacman -Syy` (refrescar forzado) |
| **dnf: "Nothing to do" pero hay paquetes rotos** | Caché desactualizado | `sudo dnf clean all && sudo dnf makecache && sudo dnf distro-sync` |
| **dpkg: error unpacking** | Disco lleno durante la instalación | Liberar espacio y `sudo dpkg --configure -a` |
| **Snap: broken** | Snap daemon no responde | `sudo snap repair` o `sudo systemctl restart snapd` |

## Prevención

1. **No interrumpir actualizaciones**: dejar que `apt upgrade`, `pacman -Syu` o `dnf update` terminen completamente antes de cerrar la terminal o apagar.
2. **Usar `apt list --upgradable`** antes de actualizar para ver qué cambia.
3. **No mezclar repositorios de distintas versiones** de la misma distro (ej: no añadir PPAs de Ubuntu 24.10 si usas 24.04).
4. **Tener espacio libre en disco**: `df -h` para verificar antes de grandes actualizaciones.
5. **Usar `tmux` o `screen`** para actualizaciones remotas vía SSH — si la conexión se cae, el proceso sigue corriendo.
6. **Arch: mantener `archlinux-keyring` actualizado** antes de `pacman -Syu`.

```bash
# Antes de una actualización grande, verificar:
df -h /var/cache/apt / /var/lib/pacman/  # suficiente espacio libre
sudo apt check                            # sistema sano
```

## Notas adicionales

- Los flags de dpkg (`dPkg`): `iF` = half-configured, `iU` = half-installed, `pE` = reinst-required, `pR` = purge-required, `n` = not-installed (pero quedan archivos de configuración).
- En Arch, las actualizaciones parciales NO están soportadas. Siempre usar `pacman -Syu`, nunca `pacman -S paquete` sin actualizar antes.
- `dpkg --force-remove-reinstreq` es una operación peligrosa que puede dejar el sistema en estado inconsistente. Usar solo como último recurso.

## Enlaces externos

- [Arch Wiki — Pacman/Troubleshooting](https://wiki.archlinux.org/title/Pacman/Troubleshooting)
- [Debian Wiki — Broken packages](https://wiki.debian.org/BrokenPackages)
- [Ubuntu Help — FixBroken](https://help.ubuntu.com/community/FixBroken)
- [Fedora — DNF troubleshooting](https://docs.fedoraproject.org/en-US/quick-docs/dnf/)
- [dpkg man page](https://man.archlinux.org/man/dpkg.1)

## Ver también

- [[Gestores de Paquetes]] — comandos básicos de cada gestor
- [[apt]] — comandos avanzados de apt
- [[pacman]] — comandos avanzados de pacman
- [[df y du]] — diagnóstico de espacio en disco
- [[Actualizacion entre versiones mayores]] — upgrade de distro

#troubleshooting
