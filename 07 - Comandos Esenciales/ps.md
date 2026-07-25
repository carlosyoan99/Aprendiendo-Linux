---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# ps

## Sintaxis
```
ps [opciones]
```

## Descripción
Muestra una instantánea de los procesos en ejecución en el momento de ejecutarlo. Es la herramienta de diagnóstico básica para saber qué está corriendo y consumiendo recursos. Usar sin opciones muestra solo los procesos de la terminal actual.

Viene en el paquete `procps-ng` — disponible en toda distro sin instalación adicional.

## Formato de salida

`ps aux` y `ps -ef` son los dos formatos estándar. Muestran esencialmente la misma información:

| Columna | Significado |
|---|---|
| `USER` | Propietario del proceso |
| `PID` | ID del proceso |
| `%CPU` | % de CPU usado desde que el proceso empezó (no en tiempo real) |
| `%MEM` | % de RAM usado (RSS / RAM total × 100) |
| `VSZ` | Memoria virtual total (KB) — incluye librerías compartidas |
| `RSS` | Memoria física residente (KB) — la que realmente ocupa en RAM |
| `STAT` | Estado del proceso (R=running, S=sleeping, Z=zombie, T=stopped, I=idle kernel thread) |
| `START` | Hora/fecha de inicio del proceso |
| `TIME` | CPU total acumulada que ha usado el proceso |
| `COMMAND` | El comando que lo ejecutó (argumentos truncados con aux, completos con auxww) |

**Formato personalizado**: con `-eo` puedes elegir exactamente qué columnas mostrar:

```bash
# Columnas útiles para diagnóstico
ps -eo pid,ppid,user,%cpu,%mem,rss,vsz,stat,nice,start,time,cmd --sort=-%cpu
```

## Opciones frecuentes
| Flag | Efecto | Ejemplo |
|---|---|---|
| `ps aux` | Todos los procesos de todos los usuarios (formato BSD) | `ps aux | grep nginx` |
| `ps -ef` | Todos los procesos (formato estándar POSIX) | `ps -ef --forest` |
| `-u <user>` | Procesos de un usuario específico | `ps -u carlos` |
| `-C <comando>` | Procesos con ese nombre de comando exacto | `ps -C nginx` |
| `-p <PID>` | Información de un PID específico | `ps -p 1234 -o pid,ppid,cmd,lstart` |
| `-eo` | Formato personalizado de columnas | `ps -eo pid,ppid,cmd,%mem,%cpu` |
| `--sort=-%mem` | Ordenar por uso de memoria descendente | `ps aux --sort=-%mem | head -10` |
| `--forest` | Mostrar jerarquía en árbol | `ps -ef --forest` |
| `-L` | Mostrar hilos (threads) de cada proceso | `ps -L -p 1234` |
| `auxww` | `ww` = ancho ilimitado (no truncar COMMAND) | `ps auxww | grep firewall` |

## Ejemplos de uso

```bash
# Caso 1: todos los procesos (lo más común)
ps aux

# Caso 2: filtrar por nombre
ps aux | grep nginx

# Caso 3: mostrar jerarquía de procesos (árbol)
ps -ef --forest

# Caso 4: procesos de root Y www-data
ps -u root -u www-data

# Caso 5: ordenados por RAM descendente
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem

# Caso 6: info detallada de un PID + fecha inicio
ps -p 1234 -o pid,ppid,cmd,lstart

# Caso 7: top 10 procesos por CPU
ps aux --sort=-%cpu | head -10

# Caso 8: top 10 procesos por RAM
ps aux --sort=-rss | head -10

# Caso 9: árbol con estados
ps -eo pid,ppid,stat,cmd --forest

# Caso 10: hilos de un proceso
ps -L -p 1234
```

## Casos de uso reales

### Encontrar procesos zombie

```bash
ps aux | awk '$8 ~ /Z/'                # procesos en estado zombie
# Si hay zombies, el proceso padre no está recolectando hijos
# Identificar el padre: ps -o pid,ppid,stat,cmd -p <PID_del_zombie>
```

### Ver qué está usando más RAM

```bash
ps aux --sort=-%mem | head -15         # los 15 procesos que más RAM consumen
# vsz = memoria virtual reservada, rss = memoria física real
# Una app con vsz=2G pero rss=150M ha reservado mucho pero usado poco
```

### Listar procesos de un usuario específico

```bash
ps -u carlos -o pid,%cpu,%mem,cmd --sort=-%cpu
# Ver qué está ejecutando un usuario (útil en servidores compartidos)
```

### Diagnóstico de fuga de memoria

```bash
# Capturar RSS de un proceso cada 30 segundos
while sleep 30; do ps -p <PID> -o rss= >> rss.log; done
# Si RSS sube constantemente sin bajar → fuga de memoria
```

## Combinaciones comunes con pipe

```bash
# Contar procesos en estado zombie
ps aux | awk '$8 ~ /Z/' | wc -l

# Matar todos los procesos de un usuario (peligroso)
ps -u carlos -o pid= | xargs kill

# Encontrar el PID de un proceso sin grep -v grep
ps aux | grep "[n]ginx"                # la expresión regular evita que grep se liste a sí mismo

# Mostrar procesos que no son del kernel (RSS > 0 y sin corchetes)
ps aux | awk '$6 > 0 && $11 !~ /^\\[/'
```

## Alternativas modernas

| Herramienta | Ventaja |
|---|---|
| **htop** | Interactivo, colores, kill con F9, filtros visuales |
| **procs** | `procs` — reemplazo moderno escrito en Rust, colores por defecto, búsqueda fuzzy |
| **pgrep / pkill** | Buscar/matar por nombre sin la tubería `ps aux | grep` |

```bash
# pgrep es más directo que ps | grep:
pgrep -u carlos nginx                   # PIDs de nginx del usuario carlos
pgrep -a nginx                          # PIDs + línea de comandos completa

# Instalar procs (Rust)
sudo apt install procs                  # disponible en repos recientes
# o: cargo install procs
procs                                    # salida similar a ps pero con colores y tree
```

## Troubleshooting / Errores comunes

| Problema | Causa | Solución |
|---|---|---|
| `ps aux | grep proceso` también muestra `grep` | El propio grep aparece en la lista | Usar `pgrep proceso` o `ps aux | grep "[p]roceso"` |
| `%MEM` no suma 100% | %MEM es por proceso, no por total del sistema | Usar `free -h` para ver RAM total |
| La columna COMMAND se corta | Pantalla demasiado estrecha | Usar `ps auxww` (ww = sin límite) |
| `ps aux` no encuentra procesos de otros usuarios | Sin permisos de root | Usar `sudo ps aux` para ver todos |
| Procesos con vsz enorme (>1TB) | Memoria virtual reservada pero no usada (normal en Java, Chromium) | Comparar VSZ vs RSS — si RSS es normal, no hay problema |

## Notas y advertencias
- `ps aux` (sin guión) y `ps -ef` (con guión) son dos sintaxis diferentes (BSD vs POSIX) pero muestran esencialmente lo mismo. La más usada es `ps aux`.
- `ps` da una foto fija. Para monitoreo en tiempo real usar [[top]] o `htop`.
- Procesos en estado **Z** (zombie) no consumen recursos pero indican que el proceso padre no recolectó su código de salida. Unos pocos zombies son normales; muchos pueden indicar un bug.
- Para buscar un PID sin ver toda la lista: `pgrep <nombre>`.
- La columna `%CPU` de `ps` es el **promedio desde que el proceso inició**, no el uso actual. Para CPU en tiempo real usar `top` o `htop`.

## Enlaces externos

- [Wikipedia — ps (Unix)](https://en.wikipedia.org/wiki/Ps_(Unix))
- [procps-ng — ps manual](https://man.archlinux.org/man/ps.1)

## Ver también
- [[top]] — monitorización en tiempo real
- [[kill]] — enviar señales a procesos
- [[free]] — memoria RAM del sistema
- [[Procesos y Senales]] — gestión de procesos
- [[htop btop]] — alternativas interactivas
- [[Cheat Sheet - Comandos Esenciales]]

#comando
