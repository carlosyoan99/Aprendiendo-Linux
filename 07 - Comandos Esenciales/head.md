---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: alta
---

# head

## Sintaxis
```
head [opciones] [archivo...]
```

## Descripción
Muestra las primeras líneas de uno o más archivos o de la entrada estándar. Por defecto muestra las primeras 10 líneas. Esencial para echar un vistazo rápido a archivos grandes (logs, CSVs, datos) sin cargarlos completos, o para ver la cabecera de un archivo antes de procesarlo. Es la contraparte de `tail`.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-n <N>` | Muestra las primeras N líneas (ej. `-n 20`) |
| `-c <N>` | Muestra los primeros N bytes |
| `-q` | No muestra cabeceras de archivo cuando se pasan varios archivos |
| `-v` | Verboso: siempre muestra cabeceras de archivo |

## Ejemplos básicos

```bash
head /var/log/syslog                      # primeras 10 líneas
head -n 50 /var/log/syslog                # primeras 50 líneas
head -c 500 archivo.bin                   # primeros 500 bytes
head -n +20 archivo.txt                   # desde la línea 1 hasta la 20

head -n 5 *.log                           # primeras 5 líneas de cada .log
head -v archivo1.txt archivo2.txt         # con cabecera (nombre del archivo)
```

## Casos de uso reales

### Inspección rápida de archivos

```bash
# Ver las primeras líneas de un CSV (para saber columnas)
head -n 5 datos.csv

# Ver la cabecera de un archivo de log
head -n 1 /var/log/syslog                  # formato de fecha, hostname

# Ver qué contiene un archivo antes de procesarlo
head -n 20 archivo-desconocido.txt

# Ver los primeros N bytes de un binario
head -c 100 programa.bin | xxd             # ver en hexdump
```

### Procesamiento de pipelines

```bash
# Tomar solo los primeros 10 resultados
ps aux | sort -nrk 4 | head -10            # top 10 por memoria
find /etc -name "*.conf" | head -5         # solo 5 archivos de ejemplo
ls -lt | head -20                          # los 20 archivos más recientes

# Combinar con tail: líneas N a M de un archivo
head -n 50 archivo.txt | tail -n 10        # líneas 41 a 50

# Primera línea de cada archivo .md en el vault
find . -name "*.md" -exec head -n 3 {} \; | grep "^# "
# (encuentra títulos de todas las notas)

# Ver las primeras líneas de archivos comprimidos
zcat archivo.log.gz | head -n 20
```

### Análisis de logs

```bash
# Primeros accesos del día en un log de nginx
head -n 100 /var/log/nginx/access.log | awk '{print $1, $4}' | head -10

# Ver las primeras entradas de journald de hoy
journalctl --since today | head -n 30

# Cabecera de un log: formato, columnas
head -n 1 /var/log/apache2/access.log

# Ver el comienzo de un log de arranque del kernel
dmesg | head -n 20
```

### Scripting y automatización

```bash
# Extraer solo la cabecera de un archivo y guardarla aparte
head -n 1 datos.csv > cabecera.csv

# Verificar que un archivo tiene al menos N líneas
if [ $(wc -l < archivo.txt) -ge 10 ]; then
    echo "El archivo tiene al menos 10 líneas"
fi

# Mostrar solo los títulos de las notas en el vault (para un índice rápido)
head -n 100 *.md | grep "^# " | head -30

# En un backup: ver el principio del archivo de log
head -n 5 backup.log
```

### Combinaciones con otros comandos

```bash
# head + tail: la línea N exacta
head -n 15 archivo.txt | tail -n 1         # la línea 15

# head + wc: contar las primeras N líneas
head -n 100 archivo.txt | wc -l            # confirmar que salen 100

# head + sort + tail: el rango medio de datos ordenados
sort -n numeros.txt | head -n 50 | tail -n 10   # líneas 41-50

# head + grep: solo primeras coincidencias
head -n 1000 access.log | grep " 404 "     # buscar en las primeras 1000 líneas nada más

# Para archivos enormes: procesar solo el principio sin leer todo
# (head corta el pipe, lo que hace que el comando anterior se detenga)
find / -type f 2>/dev/null | head -n 10    # solo 10 resultados, no espera todo el find
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `head` muestra menos líneas de las pedidas | El archivo tiene menos líneas que `-n` | Es correcto — head muestra hasta donde llegue el archivo |
| `head -c` muestra en texto plano | Bytes sin formato legible | Pipe a `xxd` o `od`: `head -c 100 archivo \| xxd` |
| `head -n +5` no funciona como espero | `+5` en head = desde línea 1 hasta 5, no \"desde línea 5\" | Eso es comportamiento de `tail`. Head siempre desde el inicio |
| El pipeline se cuelga con archivos enormes | El comando upstream produce salida sin fin (ej: `tail -f`) | `head` termina el upstream al recibir suficientes líneas. Usar `timeout` si es necesario |
| `head -n 0` no muestra nada | 0 líneas = salida vacía | Usar `head -n 0 -v` para al menos ver la cabecera del archivo |
| head + comando lento: parece congelado | El comando upstream genera datos lentamente | head no puede mostrar lo que no ha recibido aún — es normal |

## Notas y advertencias
- `head` es eficiente: deja de leer el archivo en cuanto obtiene las líneas pedidas. No lee el archivo completo.
- En pipelines, `head` **cierra el pipe** cuando recibe suficientes líneas, lo que envía SIGPIPE al comando upstream. Esto puede causar errores como `Broken pipe` que son normales e inofensivos.
- `head` es la contraparte de `tail`. Juntos permiten ver cualquier rango de líneas de un archivo.
- Los flags `-q` y `-v` son útiles al procesar múltiples archivos: `-q` suprime cabeceras, `-v` las fuerza.
- Para archivos enormes (GB) donde no quieres esperar a que cargue completo, `head` es la herramienta ideal.

## Ver también
- [[tail]] — ver las últimas líneas
- [[cat]] — ver archivos completos
- [[less]] — ver archivos con navegación
- [[wc]] — contar líneas (complementario)
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — head](https://en.wikipedia.org/wiki/Head_(Unix))
- [GNU Coreutils — head manual](https://www.gnu.org/software/coreutils/manual/html_node/head-invocation.html)

#comando
