---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# apt

> Gestor de paquetes de alto nivel para Debian/Ubuntu. Resuelve dependencias automáticamente. El comando diario que reemplaza a `apt-get` + `apt-cache`.

## Sintaxis

```bash
apt [opciones] comando [paquete...]
```

## Descripción

`apt` es la interfaz unificada de APT (Advanced Package Tool) para distribuciones Debian/Ubuntu. Combina lo mejor de `apt-get` (instalación, actualización) y `apt-cache` (búsqueda, consulta) en un solo comando con colores y barras de progreso.

> Para distribuciones basadas en RPM (Fedora, RHEL), el equivalente es `dnf`. Ver [[Gestores de Paquetes]].

**Características clave:**
- Resuelve dependencias automáticamente
- Interfaz interactiva con colores y progreso
- Compatible con múltiples repositorios (sources.list, sources.d)
- Soporta versiones de paquetes, pinning, y control granular

## Formato de salida

```bash
# apt show nginx
Package: nginx
Version: 1.24.0-1ubuntu1
Priority: optional
Section: web
Origin: Ubuntu
Installed-Size: 102 kB
Depends: libc6 (>= 2.34), libpcre3, zlib1g
Description: small, powerful, scalable web/proxy server
```

```bash
# apt list --upgradable
Listing... Done
libssl3/jammy-updates 3.0.2-0ubuntu1.18 amd64 [upgradable from: 3.0.2-0ubuntu1.15]
curl/jammy-updates 7.81.0-1ubuntu1.18 amd64 [upgradable from: 7.81.0-1ubuntu1.16]
```

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-y` | Asumir "sí" a todas las preguntas | `apt install -y htop` |
| `--no-install-recommends` | No instalar paquetes recomendados | `apt install --no-install-recommends wine` |
| `--only-upgrade` | Actualizar paquete sin instalarlo si no existe | `apt install --only-upgrade firefox` |
| `--reinstall` | Reinstalar paquete | `apt install --reinstall network-manager` |
| `--download-only` | Solo descargar, no instalar | `apt install --download-only docker.io` |
| `-s / --simulate` | Simular (no ejecuta cambios) | `apt remove -s firefox` |
| `-q` | Modo silencioso (menos output) | `apt upgrade -q` |
| `-qq` | Muy silencioso (solo errores) | `apt upgrade -qq` |
| `-V` | Mostrar versiones en upgrade | `apt upgrade -V` |
| `--purge` | Purgar al eliminar (sin `purge` aparte) | `apt remove --purge firefox` |

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
| `apt policy <paquete>` | Muestra versiones disponibles e instalada |
| `apt-mark` | Marca/desmarca paquetes como automáticos o manuales |
| `apt changelog <paquete>` | Muestra el changelog del paquete |

## Ejemplos de uso diario

```bash
# ===== Rutina de actualización =====
sudo apt update                 # refrescar índice de paquetes
sudo apt upgrade                # actualizar paquetes instalados

# ===== Instalación =====
sudo apt install htop git curl vim           # varios paquetes a la vez
sudo apt install --no-install-recommends vim # evitar recomendados (más minimalista)
sudo apt install --reinstall network-manager # forzar reinstalación

# ===== Eliminación =====
sudo apt remove firefox              # elimina Firefox (deja config)
sudo apt purge firefox               # elimina Firefox + configuración
sudo apt autoremove                  # limpiar dependencias huérfanas

# ===== Búsqueda y exploración =====
apt search "media player"            # buscar reproductores multimedia
apt show vlc                         # ver detalles de VLC
apt policy vlc                       # ver versiones disponibles
apt list --installed | grep -i python  # qué paquetes de python tengo
apt list --installed | wc -l        # cuántos paquetes instalados

# ===== Actualización =====
apt list --upgradable                # qué se puede actualizar
apt list --upgradable | grep -c upgrade  # contar actualizaciones
sudo apt upgrade -y                  # actualizar todo sin intervención

# ===== Simulación (seguro) =====
apt remove -s firefox               # simular: mostrar qué pasaría
apt install -s nginx                # ver dependencias a instalar

# ===== Control de versiones =====
apt show firefox | grep Version     # ver versión disponible
apt-cache madison firefox           # ver todas las versiones en repos
apt-cache policy firefox            # qué versiones están disponibles (detallado)
```

## Casos de uso reales

| Escenario | Comando |
|---|---|
| **Actualizar el sistema por completo** | `sudo apt update && sudo apt upgrade -y` |
| **Buscar un paquete del que no recuerdas el nombre** | `apt search "video editor" \| grep -i libre` |
| **Saber qué versión de Node.js está disponible** | `apt policy nodejs` |
| **Instalar paquete sin dependencias opcionales** | `apt install --no-install-recommends build-essential` |
| **Saber cuántos paquetes tienes instalados** | `apt list --installed 2>/dev/null \| wc -l` |
| **Descargar paquete .deb sin instalarlo** | `apt download nginx` (descarga .deb al directorio actual) |
| **Fijar versión de un paquete (pinning)** | `apt install postgresql=15.1-1` |
| **Ver qué instaló un paquete específico** | `apt depends nginx` |
| **Ver qué paquetes dependen de otro** | `apt rdepends python3` |
| **Reinstalar un paquete corrupto** | `apt install --reinstall ubuntu-desktop` |
| **Ver changelog de seguridad reciente** | `apt changelog openssl \| head -50` |

## Combinaciones comunes con pipe

```bash
# Contar paquetes instalados por sección
apt list --installed 2>/dev/null | tail -n +2 | cut -d/ -f2 | sort | uniq -c | sort -rn

# Buscar paquetes instalados con grep
apt list --installed 2>/dev/null | grep -i python

# Ver actualizaciones disponibles con formato
apt list --upgradable 2>/dev/null | tail -n +2 | awk -F'/' '{print $1}'

# Buscar paquete y limitar resultados
apt search vlc | head -10

# Ver qué paquetes puede eliminar autoremove (sin ejecutarlo)
sudo apt autoremove -s 2>/dev/null | grep -E '^Remv|^Purg'

# Exportar lista de paquetes instalados (útil para copias)
apt list --installed 2>/dev/null | tail -n +2 | cut -d/ -f1 > paquetes.txt
```

## Pinning y control de versiones

APT permite controlar qué versión de un paquete se instala mediante **pinning** — prioridades en `/etc/apt/preferences.d/`:

```bash
# Ejemplo: mantener Python 3.10, aunque el repo tenga 3.11
echo -e "Package: python3*\nPin: version 3.10*\nPin-Priority: 1001" | \
  sudo tee /etc/apt/preferences.d/python3-pin
```

| Prioridad | Efecto |
|---|---|
| **1001+** | Versión forzada — siempre instala esta (aunque sea más antigua) |
| **990-1000** | Preferida — instala esta a menos que otra tenga mayor prioridad |
| **500-989** | Normal — versión estándar del repositorio |
| **100-499** | Aceptable — instala solo si no hay otra opción |
| **1-99** | No instalar — disponible pero nunca se instala automáticamente |
| **-1** | Prohibido — no se puede instalar ni siquiera explícitamente |

También se puede fijar versión directamente al instalar:
```bash
apt install postgresql=15.1-1              # instalar versión específica
apt install postgresql/testing             # instalar desde repositorio específico

# Para evitar que un paquete se actualice en el futuro:
sudo apt-mark hold postgresql              # retener versión actual
sudo apt-mark showhold                     # ver paquetes retenidos
sudo apt-mark unhold postgresql            # liberar para actualizar
```

## Descargar .deb sin instalar

```bash
# Opción 1: apt download (descarga .deb al directorio actual)
cd ~/deb-packages
apt download nginx           # descarga nginx_version_arch.deb

# Opción 2: apt install --download-only
sudo apt install --download-only nginx
# Los .deb quedan en /var/cache/apt/archives/

# Opción 3: instalar .deb descargado manualmente
sudo dpkg -i ~/deb-packages/nginx*.deb
```

## apt-mark — Control de paquetes automáticos/manuales

```bash
# Ver paquetes instalados manualmente
apt-mark showmanual | head -20

# Ver paquetes instalados automáticamente (dependencias)
apt-mark showauto | head -20

# Marcar paquete como instalado manualmente (no se autoremoverá)
sudo apt-mark manual htop

# Marcar paquete como automático (se autoremoverá si no lo necesita otro)
sudo apt-mark auto firefox

# ¿Por qué está instalado este paquete?
apt-mark showauto | grep python3
```

## Buenas prácticas

| Práctica | Detalle |
|---|---|
| **`apt update` primero** | Siempre ejecuta `apt update` antes de `apt upgrade` |
| **`apt upgrade` vs `full-upgrade`** | Usa `full-upgrade` solo cuando `upgrade` no pueda resolver dependencias |
| **`apt search` sin sudo** | No necesita `sudo` para buscar o mostrar información |
| **Leer antes de confirmar** | `apt` siempre muestra qué va a instalar/eliminar antes de pedir confirmación |
| **`-y` para automatización** | `apt install -y htop` responde sí automáticamente (para scripts) |
| **Simular cambios** | Usar `-s` antes de ejecutar comandos destructivos (`apt remove -s`) |
| **`autoremove` regular** | Ejecutar `apt autoremove` periódicamente para mantener el sistema limpio |
| **`.d` directories** | En `/etc/apt/sources.list.d/` se organizan repositorios adicionales |
| **No mezclar `apt` con `apt-get`** | Son compatibles, pero `apt` tiene salida más amigable; usa uno para cada tarea |
| **`apt list` quiet** | Redirigir `2>/dev/null` porque `apt list` escribe warnings a stderr |

## Alternativas

| Herramienta | Ventaja | Cuándo usarla |
|---|---|---|
| **apt** | Unificado, colores, barra de progreso | Uso diario interactivo |
| **apt-get** | Más estable, output parseable | Scripts, automatización (salida predecible) |
| **apt-cache** | Búsquedas avanzadas y consultas | `apt-cache policy`, `apt-cache madison` |
| **nala** | Frontend moderno con paralelismo | Descargas más rápidas, historial de transacciones |
| **aptitude** | Interfaz ncurses + CLI avanzada | Gestión interactiva, resolución de dependencias complejas |
| **dpkg** | Bajo nivel (paquetes .deb individuales) | `apt no puede hacerlo`: reinstalar fuerza bruta, extraer .deb |
| **gdebi** | Instala .deb locales con dependencias | Alternativa ligera a `dpkg -i` + `apt install -f` |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `Unable to locate package` | El paquete no está en los repos o el índice está desactualizado | `sudo apt update` e intentar de nuevo |
| `dpkg was interrupted` | Una instalación anterior falló y dejó dpkg en estado inconsistente | `sudo dpkg --configure -a` |
| `Could not get lock /var/lib/dpkg/lock` | Otro proceso de apt/dpkg está corriendo | Esperar, o `sudo lsof /var/lib/dpkg/lock` para ver qué proceso |
| `The following packages have been kept back` | Dependencias conflictivas o cambios mayores | `sudo apt install <paquete>` o `sudo apt full-upgrade` |
| `E: Unable to fetch some archives` | Repositorio caído, URL mal, o problema de red | Verificar conexión, probar con mirror distinto |
| `W: GPG error: ... NO_PUBKEY` | Falta clave GPG del repositorio | `sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys <KEY>` |
| `E: Package cache is corrupted` | Caché corrupta | `sudo rm -rf /var/cache/apt/archives/* && sudo apt update` |
| `E: Sub-process /usr/bin/dpkg returned an error code` | Error en script post-instalación de un paquete | Ver mensaje de error, reinstalar el paquete problemático |
| `Packages with held back` | Paquete marcado como `hold` | `apt-mark showhold` para verlos, `apt-mark unhold <paquete>` |
| `apt list: W: --force-yes is deprecated` | Uso de flag obsoleto en script | Reemplazar `--force-yes` con `APT::Get::force-yes` en config |
| `E: Could not open lock file /var/lib/apt/lists/lock` | Sin permisos | Ejecutar con `sudo` |

## Notas y advertencias

- **`apt` vs `apt-get`**: `apt` está diseñado para uso interactivo (barras de progreso, colores). Para scripts, prefiere `apt-get` porque su salida es más estable y parseable.
- **`apt full-upgrade` puede eliminar paquetes**: Lee la lista antes de confirmar. `full-upgrade` puede resolver dependencias eliminando paquetes conflictivos.
- **Seguridad**: Verifica las claves GPG de los repositorios que añadas. `apt update` te avisará si falta una clave.
- **Caché local**: Los .deb descargados se almacenan en `/var/cache/apt/archives/`. `apt clean` los elimina.
- **Repositorios**: Definidos en `/etc/apt/sources.list` y `/etc/apt/sources.list.d/*.list` con formato:
  ```
  deb http://archive.ubuntu.com/ubuntu jammy main restricted
  # tipo   URL                              distribución  componentes
  ```

## Enlaces externos

- [Wikipedia - APT](https://en.wikipedia.org/wiki/APT_(software))
- [Debian Wiki - APT](https://wiki.debian.org/Apt)
- [Ubuntu Manpage - apt](https://manpages.ubuntu.com/manpages/jammy/en/man8/apt.8.html)
- [Debian Wiki - Pinning](https://wiki.debian.org/AptPinning)
- [Arch Wiki - APT (en)](https://wiki.archlinux.org/title/APT)

## Ver también

- [[Gestores de Paquetes]] — comparativa entre distros
- [[dpkg]] — bajo nivel (instalar .deb directamente)
- [[Snap y Flatpak]] — formatos portables alternativos
- [[Proceso de Instalación General]] — guía de instalación desde cero
- [[Post-Instalación Checklist]] — qué hacer tras instalar
- [[nala]] — frontend moderno para APT
- [[Cheat Sheet - Comandos Esenciales]]

#comando #apt #debian