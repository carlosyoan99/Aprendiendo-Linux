---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: comando
prioridad: media
---

# watch

## Sintaxis
```
watch [opciones] comando
```

## Descripción
Ejecuta un comando periódicamente (cada 2 segundos por defecto) y muestra su salida en pantalla. Esencial para monitorear cambios en tiempo real: procesos, uso de disco, logs, conexiones de red, etc. Sin watch, tendrías que ejecutar el mismo comando manualmente una y otra vez.

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-n <seg>` | Intervalo entre ejecuciones (ej. `-n 5` = cada 5 segundos) |
| `-d` | Resalta las diferencias entre una ejecución y la anterior |
| `-t` | No mostrar el título/encabezado (solo la salida del comando) |
| `-g` | Salir cuando la salida del comando cambie (exit on change) |
| `-e` | Freeze si el comando da error (deja de actualizar) |

## Ejemplos
```bash
watch -n 1 date                           # ver la hora actualizarse cada segundo
watch -d free -h                          # monitorear RAM, resaltando cambios
watch -d 'ss -tulpn'                      # ver puertos abiertos y cambios
watch -n 5 'df -h /'                      # monitorear espacio en disco raíz cada 5s
watch -d 'ps aux | sort -nrk 3 | head'    # top procesos por CPU, actualizado
watch -g 'pgrep apt' && echo "apt terminó"  # esperar a que apt termine

# Monitorear tamaño de una carpeta
watch -n 10 'du -sh ~/Descargas/'

# Monitorear temperatura de CPU (si sensors está instalado)
watch -n 2 sensors
```

## Notas y advertencias
- Para monitoreo más avanzado, [[htop btop]] ofrece una vista interactiva más rica.
- Si el comando es muy largo, encerrarlo entre comillas simples: `watch 'comando | grep algo | sort'`.
- `watch -d` resalta diferencias, útil para ver qué cambió entre refrescos sin estar mirando fijo.
- El intervalo mínimo respetado suele ser 0.1s (valores menores se redondean).
- Con `-g` puedes hacer que un script espere a que ocurra un cambio: `watch -g 'ls -la' && echo "cambio detectado"`.

## Ver también
- [[top]]
- [[htop btop]]
- [[tail]] — otra forma de monitorear cambios (logs)
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia - watch](https://en.wikipedia.org/wiki/Watch_(Unix))
- [GNU Coreutils - watch (procps)](https://man7.org/linux/man-pages/man1/watch.1.html)

#comando
