---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# dpkg

> Gestor de paquetes de bajo nivel para sistemas Debian/Ubuntu. Instala, elimina y consulta paquetes `.deb` individuales. No resuelve dependencias automáticamente — para eso está `apt`.

## Sintaxis

```bash
dpkg [opciones] acción [paquete.deb|nombre]
```

## Descripción

`dpkg` (Debian Package) es la herramienta base del ecosistema APT. Opera directamente sobre archivos `.deb` sin contactar repositorios ni resolver dependencias. Es la capa sobre la que `apt`, `aptitude` y `nala` construyen su lógica de resolución.

**¿Cuándo usar dpkg en vez de apt?**

| Situación | Usar |
|---|---|
| Instalar un `.deb` descargado manualmente | `dpkg -i` |
| Extraer contenido de un `.deb` sin instalarlo | `dpkg -x` / `dpkg -e` |
| Reconfigurar un paquete ya instalado | `dpkg-reconfigure` |
| Forzar instalación a pesar de errores | `dpkg -i --force-all` |
| Ver qué archivos instaló un paquete | `dpkg -L` |
| Saber a qué paquete pertenece un archivo | `dpkg -S` |
| Reparar base de datos dpkg corrupta | `dpkg --configure -a` |
| Ver estado de todos los paquetes | `dpkg -l` |

> **⚠️**: `dpkg` **no resuelve dependencias**. Si instalas un `.deb` que requiere otras librerías, el comando fallará. Solución: `sudo apt install -f` para reparar dependencias rotas tras un `dpkg -i`.

## Formato de salida

```bash
# dpkg -l (lista de paquetes)
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name           Version      Architecture Description
+++-==============-============-============-=================================
ii  bash           5.1-6ubuntu1 amd64        GNU Bourne Again SHell
ii  curl           7.81.0-1     amd64        command line tool for transferring data
rc  firefox        100.0-1      amd64        (config files only — purged status)
```

| Columna | Significado |
|---|---|
| **1er carácter** | Acción deseada: `i`=install, `r`=remove, `p`=purge, `h`=hold, `u`=unknown |
| **2do carácter** | Estado actual: `i`=installed, `n`=not installed, `c`=config-only, `u`=unpacked, `F`=half-configured, `H`=half-installed |
| **3er carácter** | Error: vacío=ok, `R`=reinstall-required |
| **Name** | Nombre del paquete |
| **Version** | Versión instalada |
| **Architecture** | amd64, i386, all, arm64... |
| **Description** | Descripción corta |

```bash
# dpkg -I paquete.deb (info de un .deb)
 new Debian package, version 2.0.
 size 1234567 bytes: control archive= 1234 bytes.
     123 bytes,     5 lines      control
 Package: nginx
 Version: 1.24.0-1ubuntu1
 Architecture: amd64
 Maintainer: Ubuntu Developers
 Installed-Size: 1024
 Depends: libc6 (>= 2.34), libpcre3, zlib1g
 Section: web
 Priority: optional
 Description: small, powerful, scalable web/proxy server
```

## Opciones frecuentes

| Flag / Opción | Efecto | Ejemplo |
|---|---|---|
| `-i` / `--install` | Instalar un `.deb` | `sudo dpkg -i paquete.deb` |
| `-r` / `--remove` | Eliminar paquete (deja config) | `sudo dpkg -r nginx` |
| `-P` / `--purge` | Eliminar paquete + config | `sudo dpkg -P nginx` |
| `-l` / `--list` | Listar paquetes (patrón opcional) | `dpkg -l \| grep python` |
| `-s` / `--status` | Estado de un paquete | `dpkg -s nginx` |
| `-L` / `--listfiles` | Archivos que instaló un paquete | `dpkg -L nginx` |
| `-S` / `--search` | A qué paquete pertenece un archivo | `dpkg -S /bin/ls` |
| `-I` / `--info` | Información de un `.deb` | `dpkg -I paquete.deb` |
| `-c` / `--contents` | Listar contenido de un `.deb` | `dpkg -c paquete.deb` |
| `-x` | Extraer contenido (sin instalación) | `dpkg -x paquete.deb ./dir` |
| `-e` | Extraer scripts de control | `dpkg -e paquete.deb ./dir` |
| `--configure -a` | Reconfigurar paquetes a medio instalar | `sudo dpkg --configure -a` |
| `--get-selections` | Exportar lista de paquetes | `dpkg --get-selections > lista.txt` |
| `--set-selections` | Importar lista de paquetes | `sudo dpkg --set-selections < lista.txt` |
| `--clear-avail` | Limpiar caché de paquetes disponibles | `sudo dpkg --clear-avail` |
| `--force-all` | Forzar instalación (ignorar errores) | `sudo dpkg -i --force-all paquete.deb` |
| `--force-depends` | Ignorar dependencias rotas | `sudo dpkg -i --force-depends paquete.deb` |
| `--audit` | Buscar paquetes rotos | `sudo dpkg --audit` |
| `--verify` | Verificar integridad (debsums) | `sudo dpkg --verify` |

## Ejemplos de uso

```bash
# ===== Instalación de .deb local =====
sudo dpkg -i ~/Descargas/code_1.80.0_amd64.deb   # instalar VSCode .deb
sudo apt install -f                               # reparar dependencias si falla

# ===== Reinstalar / forzar =====
sudo dpkg -i --force-all paquete.deb              # forzar instalación
sudo dpkg --configure -a                          # reparar paquetes a medio instalar
sudo dpkg -i --force-depends paquete.deb          # ignorar dependencias

# ===== Eliminación =====
sudo dpkg -r nginx                                # eliminar (deja config)
sudo dpkg -P nginx                                # purgar (todo)
sudo dpkg -P nginx-common nginx-core              # purgar varios

# ===== Listar y buscar =====
dpkg -l                                           # todos los paquetes
dpkg -l 'python3*'                                # solo python3*
dpkg -l | grep -i lib                             # filtrar librerías
dpkg -L nginx                                     # qué archivos instaló nginx
dpkg -S /bin/ls                                   # ¿qué paquete puso este archivo?
dpkg -S /etc/nginx/nginx.conf                     # ¿a qué paquete pertenece esta config?
dpkg -s nginx                                     # estado del paquete

# ===== Inspeccionar .deb sin instalarlo =====
dpkg -I ~/Descargas/paquete.deb                   # info del .deb
dpkg -c ~/Descargas/paquete.deb                   # contenido del .deb
dpkg -x ~/Descargas/paquete.deb ./tmp             # extraer contenido
dpkg -e ~/Descargas/paquete.deb ./DEBIAN          # extraer scripts de control

# ===== Exportar/importar selección de paquetes =====
dpkg --get-selections > ~/paquetes.txt            # backup de selección
sudo dpkg --set-selections < ~/paquetes.txt       # restaurar selección

# ===== Auditoría y verificación =====
sudo dpkg --audit                                 # buscar paquetes rotos
sudo dpkg --verify                                # verificar integridad
```

## Casos de uso reales

| Escenario | Comandos |
|---|---|
| **Instalar un .deb descargado de internet** | `sudo dpkg -i paquete.deb` y luego `sudo apt install -f` |
| **Saber qué paquete instaló `nginx.conf`** | `dpkg -S /etc/nginx/nginx.conf` |
| **Ver todos los archivos que instaló un paquete** | `dpkg -L nginx` |
| **Buscar un paquete del que no sabes el nombre exacto** | `dpkg -l \| grep -i python` |
| **Reinstalar un paquete corrupto (forzar)** | `sudo dpkg -i --force-all paquete.deb` |
| **Reparar dpkg tras un corte de luz durante una instalación** | `sudo dpkg --configure -a` |
| **Extraer un .deb para inspeccionar su contenido manualmente** | `dpkg -x paquete.deb ./tmp && ls ./tmp` |
| **Ver los scripts pre/post-instalación de un .deb** | `dpkg -e paquete.deb ./DEBIAN && cat ./DEBIAN/postinst` |
| **Backup de paquetes para reinstalar en otra máquina** | `dpkg --get-selections > list.txt` |
| **Forzar instalación de un .deb que se queja de dependencias** | `sudo dpkg -i --force-depends paquete.deb` |
| **Verificar si un paquete está instalado** | `dpkg -s paquete \| grep -E '^Status:'` |
| **Saber cuántos paquetes tienes instalados** | `dpkg -l \| tail -n +6 \| wc -l` |
| **Listar solo paquetes con config residual (purge pendiente)** | `dpkg -l \| grep '^rc'` |

## Combinaciones comunes con pipe

```bash
# Contar paquetes instalados
dpkg -l | tail -n +6 | wc -l

# Buscar paquetes por nombre
dpkg -l | grep -i nginx

# Ver paquetes con config residual (rc = removed but config remains)
dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo dpkg -P

# Listar archivos de un paquete por tipo
dpkg -L bash | grep -E '/bin/'
dpkg -L bash | grep -E '/usr/share/man/'

# Exportar solo nombres de paquetes instalados
dpkg -l | tail -n +6 | awk '{print $2}' > installed.txt

# Ver qué paquetes dependen de una librería
grep -r 'libc6' /var/lib/dpkg/info/*.list 2>/dev/null | grep -oP '^[^:]+' | sort -u | sed 's|.*/||;s/\.list$//'

# Encontrar archivos grandes instalados por un paquete
dpkg -L nginx | xargs ls -lh 2>/dev/null | grep -E '^\S+\s+\S+\s+\S+\s+\S+\s+[0-9]+[MGK]' | sort -k5 -h | tail -10

# Comparar paquetes entre dos máquinas
# En máquina A: dpkg --get-selections > a.txt
# En máquina B: diff <(cut -f1 a.txt) <(dpkg --get-selections | cut -f1)

# Ver scripts de mantenimiento de un paquete
ls -la /var/lib/dpkg/info/nginx.*
# preinst, postinst, prerm, postrm, conffiles, list, md5sums, shlibs, symbols, triggers
```

## dpkg vs apt

| Característica | dpkg | apt |
|---|---|---|
| **Nivel** | Bajo (paquetes .deb individuales) | Alto (repositorios + dependencias) |
| **Resuelve dependencias** | ❌ No | ✅ Sí (automáticamente) |
| **Trabaja con repositorios** | ❌ No | ✅ Sí |
| **Instala .deb local** | ✅ Sí (`dpkg -i`) | ❌ No directamente |
| **Extrae .deb sin instalar** | ✅ Sí (`dpkg -x`, `-c`, `-e`) | ❌ No (solo `apt download` para bajar) |
| **Lista archivos de un paquete** | ✅ (`dpkg -L`) | ❌ No directamente |
| **Busca por archivo** | ✅ (`dpkg -S`) | ❌ No (usar `apt-file`) |
| **Velocidad** | ⭐ Muy rápido | 🐢 Más lento (consulta repos) |
| **Scripting** | ⭐ Salida estable | ✅ Pero menos estable que dpkg |
| **Reparar instalación** | ✅ `dpkg --configure -a` | ❌ No |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `dpkg: dependency problems prevent configuration` | Faltan dependencias del paquete | `sudo apt install -f` para resolverlas automáticamente |
| `dpkg was interrupted` | Corte de luz / Ctrl+C durante instalación | `sudo dpkg --configure -a` |
| `dpkg: error processing package (--configure)` | Script postinst falló | Ver mensaje de error específico, reinstalar paquete problemático |
| `dpkg: status database area is locked by another process` | Otro dpkg/apt corriendo | `sudo lsof /var/lib/dpkg/lock`, matar el proceso |
| `dpkg: too many errors, stopping` | Errores encadenados | Revisar el primero de la lista, resolverlo, luego `dpkg --configure -a` |
| `dpkg-deb: error: subprocess paste was killed by signal` | Disco lleno o permisos | `df -h` para verificar espacio, `sudo dpkg --configure -a` |
| `Package `X` is not installed` | Nombre incorrecto o no instalado | `dpkg -l \| grep X` para verificar |
| `dpkg: warning: files list file for package missing` | Archivo .list borrado accidentalmente | `sudo apt install --reinstall paquete` |
| `subprocess installed post-installation script returned error` | Script de mantenimiento falla | Ejecutar el script manualmente para ver el error real |
| `dpkg: unrecoverable fatal error` | Base de datos dpkg corrupta | Restaurar backup de `/var/lib/dpkg/` o reinstalar paquete base |
| `conflicto de archivos` | Dos paquetes intentan instalar el mismo archivo | `dpkg -i --force-overwrite paquete.deb` |
| `paquete es de la arquitectura i386 pero el sistema es amd64` | Arquitectura incorrecta | Verificar con `dpkg --print-architecture` y `dpkg --print-foreign-architectures` |

## Notas y advertencias

- **Siempre ejecutar `apt install -f` tras `dpkg -i`**: `dpkg` no toca repositorios ni resuelve dependencias. Casi siempre que instalas un `.deb` manual, faltarán dependencias. `sudo apt install -f` las descarga e instala automáticamente.
- **Forzar (`--force-*`) con cuidado**: Las opciones `--force-all`, `--force-depends`, `--force-overwrite` te permiten saltarte errores, pero pueden dejar el sistema en un estado inconsistente. Úsalas solo cuando sepas lo que haces.
- **`dpkg --configure -a` es el primer comando de rescate**: Si una instalación se interrumpió (corte de luz, terminal cerrada), este comando retoma todos los paquetes a medio configurar.
- **Base de datos en `/var/lib/dpkg/`**: Aquí se almacena todo: `status` (estado de paquetes), `info/` (scripts, listas de archivos), `available` (catálogo). **No edites estos archivos manualmente** a menos que estés recuperando de un desastre.
- **Paquetes con config residual (`rc`)**: Aparecen cuando hiciste `dpkg -r` pero no `dpkg -P`. Limpiarlos: `dpkg -l | grep '^rc' | awk '{print $2}' | xargs sudo dpkg -P`.
- **`dpkg -i` también puede usar URLs**: Aunque no es común, dpkg acepta URLs HTTP si descargas el .deb antes. `wget URL && sudo dpkg -i archivo.deb`.
- **`dpkg-reconfigure` (comando aparte)**: Vuelve a ejecutar los diálogos de configuración de un paquete: `sudo dpkg-reconfigure dash` (para elegir dash vs bash).
- **Paquetes hold**: `dpkg --set-selections` permite marcar paquetes con `hold` (no se actualizarán). Complementa a `apt-mark hold`.

## Alternativas

| Herramienta | Ventaja |
|---|---|
| **gdebi** | Instala `.deb` locales resolviendo dependencias. No requiere `apt install -f` después |
| **apt** | Instalación desde repositorios con resolución de dependencias |
| **aptitude** | Resolución de dependencias más inteligente para casos complejos |
| **nala** | Frontend moderno con descarga paralela e historial de transacciones |
| **edos-debcheck** | Verifica dependencias de un `.deb` sin instalarlo |
| **dpkg-deb** | Comando interno usado por dpkg para empaquetar/desempaquetar `.deb` |
| **deborphan** | Encuentra paquetes huérfanos (no dependidos por ningún otro) |

## Enlaces externos

- [Wikipedia — dpkg](https://en.wikipedia.org/wiki/Dpkg)
- [Debian Wiki — dpkg](https://wiki.debian.org/dpkg)
- [Linux man page — dpkg(1)](https://man.archlinux.org/man/dpkg.1)
- [dpkg-dev — empaquetado Debian](https://man7.org/linux/man-pages/man1/dpkg-deb.1.html)
- [Debian Wiki — dpkg-reconfigure](https://wiki.debian.org/dpkgReconfigure)

## Ver también

- [[apt]] — alto nivel, resuelve dependencias automáticamente
- [[Gestores de Paquetes]] — comparativa entre distros
- [[Snap y Flatpak]] — formatos portables alternativos
- [[gdebi]] — instalador gráfico de .deb con dependencias
- [[Proceso de Instalación General]] — guía completa
- [[Cheat Sheet - Comandos Esenciales]]

#comando #dpkg #debian
