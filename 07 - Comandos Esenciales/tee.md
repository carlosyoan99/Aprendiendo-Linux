---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# tee

## Sintaxis
```
comando | tee [opciones] archivo
```

## Descripción
Lee de la entrada estándar y escribe **simultáneamente** a la salida estándar (la terminal) y a uno o más archivos. Como un splitter de tubería: lo que pase por el pipe, lo ves en pantalla y se guarda en un archivo a la vez.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-a` | Añadir al archivo (append), no sobrescribir |
| `-i` | Ignorar señal de interrupción (Ctrl+C) |

## Ejemplos
```bash
# Guardar salida de un comando Y verla en pantalla
ls -la | tee salida.txt                   # ves el listado y se guarda en salida.txt

# Añadir a un log sin sobrescribir
echo "Iniciando backup..." | tee -a ~/backup.log

# Combinar con sudo (necesario para archivos protegidos)
echo "127.0.0.1  mi-sitio.local" | sudo tee -a /etc/hosts

# Registrar salida completa de un script
./compilar.sh 2>&1 | tee build.log        # stdout y stderr van al archivo Y a la terminal

# Múltiples archivos
echo "datos importantes" | tee archivo1.txt archivo2.txt archivo3.txt

# En combinación con pipe (seguir viendo en pantalla mientras se filtra)
ps aux | tee procesos.txt | grep nginx    # guarda todo, pero solo ves nginx
```

## Casos de uso reales

### Registrar una compilación para depurar errores

```bash
# Compilas un proyecto y quieres ver el error en pantalla pero también guardarlo
make 2>&1 | tee build.log
# Si falla, puedes revisar build.log después sin tener que recompilar
```

### Añadir entradas al /etc/hosts con sudo

```bash
echo "127.0.0.1  misitio.local" | sudo tee -a /etc/hosts
# Esto funciona porque tee corre como root (via sudo), mientras que la redirección > no
```

### Loggear la salida de un script que corre en background

```bash
./script_largo.sh 2>&1 | tee -a /var/log/mi-script.log &
# Puedes hacer otras cosas mientras ves el progreso en terminal
```

## Combinaciones comunes con pipe

```bash
# Loggear con timestamp
./comando | while IFS= read -r line; do echo "$(date '+%H:%M:%S') $line"; done | tee -a log.txt

# Loggear solo errores pero ver todo
./comando 2>&1 | tee full.log | grep -i error > errores.log

# Múltiples destinos de log
./comando | tee >(gzip > output.gz) | tee stdout.log
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Nota |
|---|---|---|
| `tee` | — | No hay alternativa directa. `tee` es único en su función |
| `comando > archivo` + `comando` | `tee archivo` | Hace ambas cosas a la vez |
| `sudo echo ... > archivo` | `echo ... | sudo tee archivo` | Forma correcta de escribir archivos protegidos |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `Permission denied` al escribir archivo | No tienes permisos sobre el archivo de salida | Usar `sudo tee archivo` (no `sudo comando | tee archivo` — el sudo debe ir en tee) |
| El archivo de log está vacío | El comando original falló antes de producir salida | Verificar el código de retorno: `echo $?` después |
| No veo stderr en el log | stderr no pasa por pipe a menos que se redirija | Usar `2>&1 | tee log` |
| `tee -a` no añade, sobrescribe | Olvidaste la `-a` | tee sin `-a` sobrescribe el archivo |

## Notas y advertencias
- `tee` es la solución al problema "quiero ver la salida en pantalla pero también guardarla en un archivo". Sin tee, tendrías que elegir entre redirigir (`>`) o ver en pantalla.
- Para archivos del sistema que requieren `sudo`, usar `comando | sudo tee archivo` en vez de `sudo comando > archivo` (porque el redirect `>` se ejecuta como usuario normal, no como root).
- `tee -a` añade sin sobrescribir, equivalente a `>>` en redirección.
- La salida de error (stderr) no pasa por tee a menos que la redirijas: `comando 2>&1 | tee log`.

## Ver también
- [[xargs]]
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — tee](https://en.wikipedia.org/wiki/Tee_(command))
- [GNU Coreutils — tee manual](https://www.gnu.org/software/coreutils/manual/html_node/tee-invocation.html)

#comando
