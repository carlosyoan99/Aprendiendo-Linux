---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# Cheat Sheet: Comandos Esenciales

Referencia rápida de comandos de uso diario. Cada comando tiene su propia nota; usa [[Dia a Dia en CLI]] para una guía priorizada de aprendizaje.

## Navegación

| Comando | Uso | Ejemplo |
|---|---|---|
| `pwd` | Ruta actual absoluta | `pwd` → `/home/usuario` |
| `ls` | Listar archivos | `ls -la` (detallado + ocultos) → [[ls]] |
| `cd` | Cambiar directorio | `cd ~` (al home), `cd -` (al anterior) → [[cd]] |

## Archivos y directorios

| Comando | Uso | Flag clave |
|---|---|---|
| `cp` | Copiar | `cp -r dir/ destino/` (recursivo) |
| `mv` | Mover / renombrar | `mv origen destino` |
| `rm` | Eliminar | `rm -rf dir/` (recursivo + forzar — ¡cuidado!) |
| `mkdir` | Crear carpeta | `mkdir -p a/b/c` (crea padres intermedios) |
| `touch` | Crear archivo vacío / actualizar fecha | `touch archivo.txt` |
| `ln` | Crear enlaces | `ln -s origen destino` (symlink — ver [[Symlinks y Dotfiles]]) |

## Visualización de archivos

| Comando | Uso |
|---|---|
| `cat` | Ver contenido completo (archivos cortos) |
| `less` / `more` | Ver contenido paginado (flechas, `/buscar`, `q` salir) |
| [[head]] | Primeras 10 líneas (`head -n 20`) |
| `tail` | Últimas 10 líneas (`tail -f log` para seguir en vivo) |
| `wc` | Contar líneas/palabras/caracteres (`wc -l`) |

## Búsqueda y filtrado

| Comando | Uso |
|---|---|
| `grep` | Buscar texto dentro de archivos (`-i` ignorar mayúsculas, `-r` recursivo) |
| `find` | Buscar archivos por nombre/tipo/fecha |
| `locate` | Búsqueda rápida por índice (si no existe, instalar `mlocate` o `plocate`) |

Ver [[grep]] y [[find]].

## Sistema e información

| Comando | Uso |
|---|---|
| `uname -a` | Info del kernel |
| `lsb_release -a` | Versión de la distro (si está instalado) |
| `df -h` | Espacio en discos (legible para humanos) |
| `du -sh *` | Tamaño de cada carpeta/archivo en el directorio actual |
| `free -h` | Uso de RAM y swap |
| `uptime` | Cuánto lleva encendido el sistema + carga |

## Procesos

| Comando | Uso |
|---|---|
| `ps aux` | Todos los procesos en ejecución |
| `top` / `htop` | Monitor interactivo de procesos |
| `kill <PID>` | Terminar proceso (SIGTERM) |
| `kill -9 <PID>` | Forzar terminación (SIGKILL — último recurso) |
| `pgrep <nombre>` | Buscar PID por nombre |
| `pkill <nombre>` | Matar por nombre |

Ver [[Procesos y Senales]].

## Permisos y propietarios

| Comando | Uso |
|---|---|
| `chmod` | Cambiar permisos |
| `chown` | Cambiar propietario/grupo |
| `umask` | Definir permisos por defecto para archivos nuevos |

```bash
chmod 755 script.sh          # dueño:rwx, grupo:rx, otros:rx
chmod +x script.sh           # añadir ejecución (modo simbólico)
chown usuario:grupo archivo  # cambiar dueño y grupo
```

Ver [[Permisos y Propietarios]].

## Red

| Comando | Uso |
|---|---|
| `ping` | Probar conectividad (`ping -c 4 8.8.8.8`) |
| `ip a` | Ver interfaces e IPs (reemplaza `ifconfig`) |
| `ip route` | Ver gateway |
| `ss -tulpn` | Puertos abiertos y qué proceso los usa (reemplaza `netstat`) |
| `dig` / `nslookup` | Consultar DNS |
| `curl` / `wget` | Descargar / consultar recursos web |
| `nmcli` | Estado de red vía NetworkManager |

Ver [[Redes Basicas]] y [[SSH]].

## Compresión y archivos

| Comando | Uso |
|---|---|
| `tar -czf archivo.tar.gz carpeta/` | Comprimir |
| `tar -xzf archivo.tar.gz` | Extraer |
| `zip -r archivo.zip carpeta/` | ZIP |
| `unzip archivo.zip` | Descomprimir ZIP |

## Ayuda

| Comando | Uso |
|---|---|
| `man <comando>` | Manual completo del comando (navegar con `q` para salir) |
| `<comando> --help` o `-h` | Resumen rápido de opciones |
| `whatis <comando>` | Descripción en una línea |
| `apropos <tema>` | Buscar comandos relacionados con un tema |

## Encadenamiento

```bash
comando1 | comando2           # pipe: pasar salida de 1 a 2
comando1 && comando2          # ejecutar 2 solo si 1 tuvo éxito (exit code 0)
comando1 || comando2          # ejecutar 2 solo si 1 falló
comando1; comando2            # ejecutar 2 siempre, sin importar éxito
comando > archivo             # redirigir salida a archivo (sobrescribe)
comando >> archivo            # redirigir salida a archivo (añade)
comando 2>&1                  # redirigir stderr a stdout
```

## Por qué importa

Este cheat sheet es tu **referencia de bolsillo**. Si un comando concreto te interesa, busca su nota específica (estilo Plantilla - Comando.md) para explorar opciones, ejemplos y advertencias.

## Ver también

- [[La Shell]]
- [[grep]]
- [[SSH]]

## Enlaces externos

- [Wikipedia - Unix commands](https://en.wikipedia.org/wiki/List_of_Unix_commands)
- [Linux man pages online](https://man7.org/linux/man-pages/)

#comandos #cheatsheet
