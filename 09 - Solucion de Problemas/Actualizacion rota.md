---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: troubleshooting
prioridad: media
---

# Actualización rota

> Troubleshooting cuando apt, dnf o pacman falla durante una actualización: paquetes rotos, dependencias, dpkg locked, kernel incompleto.

## Síntoma

El gestor de paquetes falla durante `apt upgrade`, `dnf upgrade` o `pacman -Syu`. Puede dejar el sistema en un estado intermedio con paquetes a medias.

## Diagnóstico

```bash
# Debian/Ubuntu
sudo dpkg --configure -a           # reconfigurar paquetes pendientes
sudo apt --fix-broken install       # reparar dependencias rotas
sudo apt install -f                 # alias del anterior

# Fedora/RHEL
sudo dnf distro-sync               # sincronizar con repos
sudo rpm --rebuilddb                # reconstruir RPM database

# Arch
sudo pacman -Syyu                   # forzar refresh + upgrade
sudo pacman -Scc                    # limpiar caché
```

## Causas y soluciones

### 1. Paquete roto / dependencias
```bash
# Debian/Ubuntu
sudo apt --fix-broken install
sudo dpkg --configure -a

# Si nada funciona:
sudo apt -o Dpkg::Options::="--force-depends" --fix-broken install
```

### 2. dpkg locked
```bash
# Ver quién tiene el lock
sudo lsof /var/lib/dpkg/lock*
sudo fuser /var/lib/dpkg/lock

# Matar proceso y reintentar
sudo kill <PID>
sudo dpkg --configure -a
```

### 3. Kernel incompleto
```bash
# Si actualizaste kernel y no arranca:
# 1. Desde GRUB, elegir kernel anterior
# 2. Una vez dentro:
sudo apt install --reinstall linux-image-$(uname -r)
sudo update-grub
```

### 4. Disco lleno durante actualización
```bash
sudo apt clean                       # limpiar caché
sudo apt autoremove                  # remover paquetes huérfanos
sudo journalctl --vacuum-size=100M   # limpiar logs
```

### 5. Recovery mode (emergencia)
```bash
# Desde GRUB → Advanced options → Recovery mode
# Opciones disponibles:
# - Clean: limpiar disco
# - Dpkg: reparar paquetes
# - Root: shell root
# - Network: habilitar red
```

## Prevención

- Siempre revisar qué se va a instalar antes de aceptar: `apt upgrade --simulate`
- Mantener espacio libre en `/boot` (mínimo 500MB)
- No interrumpir actualizaciones en curso
- Hacer backup antes de dist-upgrade mayor

## Ver también

- [[Gestores de Paquetes]], [[apt]], [[pacman]], [[Post-Instalacion Checklist]]

#troubleshooting #paquetes
