---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-18
estado: resuelto
categoria: troubleshooting
sistema: apt / pacman / dnf
prioridad: alta
---

# Paquete roto / dependencias insatisfechas

## Síntoma

Al intentar instalar o actualizar un paquete, el gestor de paquetes muestra errores de dependencias rotas, conflictos entre versiones, o paquetes mantenidos atrás.

## Diagnóstico

```bash
# Debian/Ubuntu
sudo apt update
sudo apt --fix-broken install              # intentar reparar dependencias rotas
sudo apt check                             # verificar estado del sistema

# Arch
sudo pacman -Syu                           # actualizar todo (puede resolver conflictos)
pacman -Qdt                                # paquetes huérfanos (dependencias no usadas)
pacman -Qkk                                # verificar integridad de paquetes instalados

# Fedora
sudo dnf check                             # verificar dependencias
sudo dnf repoquery --unsatisfied           # dependencias rotas
```

## Causa

1. **Actualización interrumpida** — se cerró la terminal o se perdió la conexión durante una actualización.
2. **Mezcla de repositorios incompatibles** — PPAs incompatibles con la versión de Ubuntu, o AUR desactualizado respecto a Arch.
3. **Paquete instalado manualmente incompatible** — un `.deb` o `.rpm` externo que sobreescribe librerías del sistema.
4. **Arch Linux: pacman bloqueado** — otro proceso bloqueó la base de datos.

## Solución

```bash
# ── Debian/Ubuntu ──
sudo apt --fix-broken install              # reparación automática
sudo dpkg --configure -a                   # configurar paquetes descomprimidos
sudo apt clean && sudo apt update          # limpiar caché y reintentar

# Si un paquete específico se resiste:
sudo dpkg --remove --force-remove-reinstreq <paquete>   # forzar eliminación
sudo apt install <paquete>                              # reinstalar

# ── Arch ──
# Si pacman está bloqueado:
ps aux | grep pacman                      # VERIFICAR que no hay otro pacman corriendo
sudo rm /var/lib/pacman/db.lck            # eliminar bloqueo (solo si no hay otro proceso activo)
sudo pacman -Syu

# Reconstruir base de datos:
sudo pacman -Syy                           # forzar refresco de repos
sudo pacman -S archlinux-keyring           # actualizar llaves de firma
sudo pacman -Syu

# ── Fedora ──
sudo dnf distro-sync                       # sincronizar paquetes con repos
sudo dnf reinstall <paquete>               # reinstalar paquete específico
sudo dnf remove --duplicates               # eliminar versiones duplicadas
```

## Referencias

- [[Gestores de Paquetes]] — comandos básicos de cada gestor
- Arch Wiki: [Pacman/Troubleshooting](https://wiki.archlinux.org/title/Pacman/Troubleshooting)

#troubleshooting
