---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: media
---

# watch

> Ejecuta un comando repetidamente (cada 2 segundos por defecto) y muestra su salida en pantalla. Esencial para monitorear cambios en tiempo real sin herramientas gráficas.

## Sintaxis

```bash
watch [opciones] comando
watch [opciones] 'comando | pipeline'
```

## Descripción

`watch` ejecuta un comando en bucle, limpia la pantalla cada vez, y muestra la salida actualizada. Sirve para monitorizar procesos (`ps`), uso de disco (`df`), temperatura (`sensors`), conexiones de red (`ss`), o cualquier comando cuya salida cambie con el tiempo. Sin `watch`, tendrías que ejecutar el comando manualmente una y otra vez.

**⚠️ Nota**: `watch` ejecuta el comando como el usuario actual. Si necesitas monitorear algo que requiere root, usa `sudo watch ...`.

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-n <seg>` | Intervalo entre ejecuciones (defecto: 2s) | `watch -n 5 free -h` — cada 5 segundos |
| `-d` | Resalta las diferencias entre ejecuciones | `watch -d 'ss -tulpn'` — cambios en puertos se marcan |
| `-t` | Oculta el encabezado (solo muestra la salida) | `watch -t 'date +%T'` — reloj limpio |
| `-g` | Sale cuando la salida cambia (exit on change) | `watch -g 'pgrep apt'` — esperar a que apt termine |
| `-e` | Congela si el comando da error (no sigue actualizando) | `watch -e 'curl -f http://localhost'` — para de actualizar si falla |
| `--color` | Interpreta secuencias ANSI de color | `watch --color 'htop'` (si htop soporta modo batch) |
| `-x` | Ejecuta el comando con `exec` (evita el shell intermediario) | `watch -x ls -la` |

## Formato de salida

```text
# Encabezado (se puede ocultar con -t):
Every 2.0s: date +%T                                     hostname: Mon Jul 24 10:00:00 2026

# Salida del comando:
10:00:00
```

Con `-d` las líneas que cambiaron aparecen **resaltadas** (normalmente en blanco sobre fondo oscuro, o el color inverso de la terminal).

## Ejemplos

```bash
# 1. Reloj en terminal
watch -n 1 date

# 2. Monitorear uso de RAM, resaltando cambios
watch -d free -h

# 3. Ver puertos abiertos y detectar cuándo se abre/cierra uno
watch -d 'ss -tulpn'

# 4. Monitorear espacio en disco
watch -n 5 'df -h / /home /var'

# 5. Top procesos por CPU (actualizado cada 2s)
watch -d 'ps aux --sort=-%cpu | head -10'

# 6. Esperar a que un proceso termine y ejecutar acción
watch -g 'pgrep -x apt' && echo "✅ apt terminó"

# 7. Tamaño de carpeta mientras se descarga algo
watch -n 5 'du -sh ~/Descargas/'

# 8. Temperatura de CPU
watch -n 2 sensors

# 9. Monitorear conexiones activas a un puerto específico
watch -n 1 'ss -tlnp | grep :3000'

# 10. Reloj sin encabezado (limpio, solo la hora)
watch -t 'date +%H:%M:%S'
```

## Casos de uso reales

| Escenario | Comando |
|---|---|
| **Esperar instalación** — saber cuándo apt termina en otra terminal | `watch -g 'pgrep apt' && echo "apt terminó"` |
| **Depurar red** — ver si un puerto se abre al iniciar un servicio | `watch -d 'ss -tlnp | grep :8080'` |
| **Monitorizar backup** — ver tamaño y archivos durante rsync | `watch -n 10 'du -sh /backup/'` |
| **Desarrollo web** — ver logs de servidor en tiempo real | `watch -n 1 'tail -5 /var/log/nginx/access.log'` |
| **Monitorizar GPU** — ver uso de VRAM (NVIDIA) | `watch -n 1 nvidia-smi` |

## Combinaciones comunes con pipe

```bash
# Monitorear procesos por consumo de CPU y memoria
watch -d 'ps aux --sort=-%mem | head -15'

# Ver solo logs de errores actualizados
watch -d 'journalctl -n 10 --no-pager | grep -i error'

# Contar conexiones IP activas
watch -n 5 'ss -tun | tail -n +2 | awk "{print $5}" | cut -d: -f1 | sort | uniq -c | sort -rn'

# Monitorear inodos (espacio de archivos pequeños)
watch -d 'df -i /'
```

## Alternativas modernas

| Herramienta | Ventaja sobre watch |
|---|---|
| **htop** / **btop** | Monitor interactivo con gráficas, filtros, matar procesos. No es reemplazo directo pero cubre el 80% de los casos de monitoreo de procesos |
| **Inotifywait** (inotify-tools) | Espera cambios reales en el sistema de archivos (no polling), más eficiente que `watch` para detectar modificaciones de archivos |
| **Delta** / **difftastic** | Para detectar cambios en la salida de comandos, `watch -d` es suficiente. Delta es para diffs de archivos |
| **tmux** + split | Divide la terminal en paneles — puedes tener `watch` en un panel mientras trabajas en otro |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| **Comando con pipes no funciona** | El pipe se interpreta antes de llegar a watch | Encerrar entre comillas: `watch 'ps aux | grep nginx'` |
| **Colores no se ven** | watch por defecto no pasa secuencias ANSI | `watch --color tu_comando` |
| **El intervalo es más lento de lo esperado** | El comando tarda más que el intervalo en ejecutarse | Aumentar el intervalo: `watch -n 5 ...` |
| **La pantalla parpadea** | Terminal lenta o intervalo muy corto | Usar `-t` para ocultar encabezado o aumentar intervalo a 1s+ |
| **Comando con $PATH incorrecto** | watch usa su propio entorno | Usar rutas absolutas: `watch /usr/bin/mi_comando` |

## Notas y advertencias

- **Comillas**: si el comando contiene pipes (`|`), redirecciones (`>`), o variables (`$`), encerrarlo entre **comillas simples** para evitar que el shell los interprete antes de pasarlos a watch.
- **Rendimiento**: watch ejecuta el comando cada N segundos sin importar si la salida cambió. Para monitoreo eficiente de archivos, usar `inotifywait`.
- **Intervalo mínimo**: `-n 0.1` suele funcionar, pero valores menores pueden no ser respetados por el sistema.
- **Scripting con `-g`**: `watch -g` es ideal para scripts que esperan una condición. Ej: `watch -g 'docker ps | grep healthy' && echo "Contenedor listo"`.
- **Alternativa sin watch**: muchos shells permiten bucles: `while true; do clear; comando; sleep 2; done`. Pero `watch` es más eficiente y tiene resaltado de diferencias.

## Enlaces externos

- [Wikipedia — watch (Unix)](https://en.wikipedia.org/wiki/Watch_(Unix))
- [Linux man page — watch(1)](https://man7.org/linux/man-pages/man1/watch.1.html)
- [procps-ng GitHub](https://gitlab.com/procps-ng/procps)

## Ver también

- [[top]] — monitor interactivo de procesos
- [[htop btop]] — monitores más avanzados con interfaz TUI
- [[tail]] — monitorear archivos de log en tiempo real
- [[ss]] — monitorear sockets y conexiones
- [[journalctl]] — ver logs del sistema
- [[Cheat Sheet - Comandos Esenciales]]

#comando
