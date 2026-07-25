---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# less

## Sintaxis
```
less [opciones] archivo
```

## Descripción
Visor de archivos paginado que permite navegar hacia adelante y atrás por el contenido sin cargar el archivo completo en memoria. Esencial para leer archivos largos (logs, configs, salida de comandos). No es un editor — solo lectura.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-N` | Muestra números de línea |
| `-S` | No corta líneas largas (hay que desplazarse horizontalmente) |
| `-i` | Búsqueda case-insensitive (ignora mayúsculas/minúsculas) |
| `-g` | Resalta solo la última palabra buscada (más rápido) |
| `+F` | Modo "follow": se comporta como `tail -f` (sigue el archivo en vivo) |
| `-p <patrón>` | Abre el archivo y va directamente a la primera coincidencia |

## Navegación (atajos de teclado una vez dentro)

| Tecla | Acción |
|---|---|
| `q` | Salir |
| `↑ / ↓` o `j / k` | Navegar línea por línea |
| `Ctrl+F / Ctrl+B` | Avanzar / retroceder una página |
| `Ctrl+D / Ctrl+U` | Avanzar / retroceder media página |
| `g` | Ir al principio del archivo |
| `G` | Ir al final del archivo |
| `<num>g` | Ir a la línea `<num>` |
| `/patrón` | Buscar hacia adelante |
| `?patrón` | Buscar hacia atrás |
| `n` | Siguiente coincidencia de búsqueda |
| `N` | Coincidencia anterior |
| `h` | Ayuda (resumen de comandos) |
| `F` | Seguir (modo tail -f). Ctrl+C para salir del modo |
| `:n` | Siguiente archivo (si abriste varios) |

## Ejemplos
```bash
less /var/log/syslog                     # ver log del sistema paginado
less -N archivo.txt                      # ver con números de línea
less -S archivo-largo.csv                # no cortar líneas (scroll horizontal)
less +F /var/log/nginx/access.log        # seguir logs en vivo (como tail -f)
less -p "ERROR" logfile.txt              # abrir y resaltar la palabra "ERROR"
dmesg | less                             # pipear salida larga a less
journalctl -xe | less -N                 # logs de systemd con números de línea
```

## Casos de uso reales

### Navegar logs del sistema en vivo

```bash
less +F /var/log/syslog                  # abrir en modo follow (como tail -f)
# Ctrl+C para salir del modo follow y poder navegar hacia atrás
# Shift+F para volver al modo follow
```

### Buscar errores en logs grandes

```bash
less -N -p "ERROR" /var/log/syslog       # abre y muestra la primera coincidencia
# Dentro de less: /FATAL para buscar fatalidades
# n para siguiente, N para anterior
```

### Ver archivos comprimidos sin descomprimir

```bash
less /var/log/syslog.2.gz                # less abre .gz automáticamente
# Útil para logs rotados sin tener que gunzip primero
```

## Combinaciones comunes con pipe

```bash
# Pipear salida larga de cualquier comando a less
ps aux | less -N                         # lista de procesos paginada con números
find / -type f 2>/dev/null | less        # buscar todos los archivos con paginación

# less acepta stdin y mantiene colores de grep --color
journalctl -xe --no-pager | grep --color=always "ERROR" | less -R
# -R conserva los códigos de color ANSI
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Ventaja |
|---|---|---|
| `less` | `bat` (modo pager) | Resaltado de sintaxis, integración con git |
| `less archivo` | `bat archivo` | `bat` usa less como pager por defecto pero con colores |
| `less +F archivo` | `tail -f archivo` | Más común para seguir logs, menos opciones pero más conocido |
| `less` en pipas | `most` | Pager moderno con colores y compresión |

```bash
# bat usa less internamente, pero añade resaltado de sintaxis
bat --paging=always /var/log/syslog       # ver con less + colores
export PAGER="bat -p"                    # hacer que todos los comandos usen bat como pager

# more (histórico): versión básica que solo avanza (no retrocede)
# En muchas distros, more es un alias a less
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `Warning: filename: Permission denied` | No tienes permisos de lectura | Usar `sudo less /var/log/auth.log` |
| Los colores no se ven al pipear | less no interpreta códigos ANSI sin `-R` | Usar `comando | less -R` para preservar colores |
| `File may be a binary file. Still see it anyway?` | less detectó contenido binario | Pulsa `y` para verlo igual, o usa `strings archivo | less` |
| Menos no abre un archivo comprimido | Falta soporte para gz/bz2 | Instalar `less` con soporte: `sudo apt install less` (normalmente ya lo trae) |

## Notas y advertencias
- `less` es más potente que `more` (permite navegar hacia atrás, `more` no). En muchas distros `more` es un alias a `less`.
- Para seguir logs en vivo: `less +F archivo.log` o directamente `tail -f archivo.log` (más común y conocido).
- `less` puede abrir archivos comprimidos automáticamente si tiene el soporte (`less archivo.gz`).
- Si estás viendo un archivo binario, `less` mostrará advertencia — usar `strings archivo | less` para ver solo texto.

## Ver también
- [[cat]]
- [[tail]]
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — less (Unix)](https://en.wikipedia.org/wiki/Less_(Unix))
- [Sitio oficial — less](https://www.greenwoodsoftware.com/less/)

#comando
