---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: comando
prioridad: alta
---

# apt

## Sintaxis
```bash
apt [opciones] comando [paquete...]
```

## Descripción
Gestor de paquetes de alto nivel para distribuciones basadas en Debian/Ubuntu. Resuelve dependencias automáticamente. Reemplaza a `apt-get` y `apt-cache` para uso interactivo diario.

> Para distribuciones basadas en RPM (Fedora, RHEL), el equivalente es `dnf`. Ver [[Gestores de Paquetes]].

## Comandos esenciales

| Comando | Efecto |
|---|---|
| `apt update` | Actualiza la lista de paquetes disponibles en los repositorios |
| `apt upgrade` | Actualiza todos los paquetes instalados a sus últimas versiones |
| `apt full-upgrade` | Como upgrade pero resuelve cambios de dependencias (puede instalar/eliminar paquetes) |
| `apt install <paquete>` | Instala un paquete (resuelve dependencias automáticamente) |
| `apt remove <paquete>` | Elimina un paquete (deja archivos de configuración) |
| `apt purge <paquete>` | Elimina un paquete incluyendo archivos de configuración |
| `apt autoremove` | Limpia dependencias que ya no son necesarias |
| `apt search <término>` | Busca paquetes que coincidan con el término |
| `apt show <paquete>` | Muestra información detallada de un paquete |
| `apt list --installed` | Lista todos los paquetes instalados |
| `apt list --upgradable` | Lista paquetes con actualización disponible |
| `apt edit-sources` | Edita los archivos de sources.list |

## Ejemplos de uso diario

```bash
# Rutina de actualización diaria
sudo apt update                 # refrescar índice de paquetes
sudo apt upgrade                # actualizar paquetes instalados

# Instalar software
sudo apt install htop git curl vim   # varios paquetes a la vez

# Eliminar software
sudo apt remove firefox              # elimina Firefox (deja config)
sudo apt purge firefox               # elimina Firefox + configuración
sudo apt autoremove                  # limpiar dependencias huérfanas

# Buscar y explorar
apt search "media player"            # buscar reproductores multimedia
apt show vlc                         # ver detalles de VLC
apt list --installed | grep -i python  # qué paquetes de python tengo

# Información del sistema
apt list --upgradable                # qué se puede actualizar
apt-cache policy firefox             # qué versiones están disponibles
```

## Buenas prácticas

| Práctica | Detalle |
|---|---|
| **`apt update` primero** | Siempre ejecuta `apt update` antes de `apt upgrade` |
| **`apt upgrade` vs `full-upgrade`** | Usa `full-upgrade` solo cuando `upgrade` no pueda resolver dependencias |
| **`apt search` sin sudo** | No necesita `sudo` para buscar |
| **`apt install` con `sudo`** | La instalación necesita permisos de superusuario |
| **Leer antes de confirmar** | `apt` siempre muestra qué va a instalar/eliminar antes de pedir confirmación |
| **`-y` para automatización** | `apt install -y htop` responde sí automáticamente (para scripts) |

## Troubleshooting

| Error | Causa | Solución |
|---|---|---|
| `Unable to locate package` | El paquete no está en los repos o el índice está desactualizado | `sudo apt update` e intentar de nuevo |
| `dpkg was interrupted` | Una instalación anterior falló | `sudo dpkg --configure -a` |
| `Could not get lock /var/lib/dpkg/lock` | Otro proceso de apt está corriendo | Esperar o `sudo kill` el proceso |
| `The following packages have been kept back` | Dependencias conflictivas | `sudo apt install <paquete>` (individual) o `sudo apt full-upgrade` |

## Ver también
- [[Gestores de Paquetes]] — comparativa con otras distros
- [[dpkg]] — bajo nivel (instalar .deb directamente)
- [[Snap y Flatpak]] — formatos portables alternativos
- [[Proceso de Instalacion General]]
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia - APT](https://en.wikipedia.org/wiki/APT_(software))
- [Debian Wiki - APT](https://wiki.debian.org/Apt)
- [Ubuntu Manpage - apt](https://manpages.ubuntu.com/manpages/jammy/en/man8/apt.8.html)

#comando #apt