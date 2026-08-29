---
fecha_creacion: 2026-07-23
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: comando
prioridad: alta
---

# df y du

## Descripción

`df` y `du` son los dos comandos de diagnóstico de disco imprescindibles y complementarios. La diferencia clave:

- **`df`** (disk free) mira el sistema de archivos **montado**: cuánto espacio libre y usado hay en la partición completa, visto desde abajo, conforme a los bloques que el FS reporta.
- **`du`** (disk usage) mira **archivos y directorios**: suma el tamaño real de lo que hay dentro de una ruta, visto desde arriba.

En la práctica: `df` responde "¿cuánto queda?" y `du` responde "¿qué está ocupando?". Por eso siempre se usan juntos para diagnosticar un disco lleno.

## Comparativa rápida

| Variable | `df` | `du` |
|---|---|---|
| Qué mide | Sistemas de archivos montados | Contenido de un directorio |
| Visión | Desde el FS (bloques del disco) | Desde los archivos |
| Respuesta | Espacio libre/total por montaje | Suma del tamaño de archivos y carpetas |
| Incluye | Metadatos y espacio reservado a root | Solo lo que hay en la ruta |
| Coste | Muy rápido | Puede tardar en árboles grandes |
| Flag típico | `-h`, `-T`, `-i` | `-h`, `-s`, `-sh` |

## Diagnóstico combinado

```bash
# 1. ¿Qué montaje está lleno?
df -h

# 2. ¿Qué directorio de la raíz ocupa más?
du -sh /* 2>/dev/null | sort -rh | head -10

# 3. Profundizar en el sospechoso
du -h --max-depth=1 /home | sort -rh | head -10

# 4. Buscar los archivos más grandes dentro de /var
du -aR /var | sort -rn | head -10

# 5. Comprobar si el problema es de inodos en vez de bloques
df -i && du -x --summarize / | awk '{print $4, "bloques usados"}'
```

## Cuándo usar cada uno

- Usar `df` primero: localiza qué sistema de archivos se está llenando.
- Usar `du` después: encuentra qué subdirectorio es el responsable.
- `df -i` cuando el error es de inodos ("no space" con `df -h` al 40 %).
- `du` sobre una ruta concreta cuando ya sabes qué disco aprieta y quieres limpiar.
- Scriptar con `du -s` para umbrales de alerta (100 MB de logs, etc.).

## Notas individuales

- [[df]] — espacio en disco, opciones `-h`, `-T`, `-i`
- [[du]] — uso de disco por directorio, profundidad, exclusión

## Ver también

- [[Disco lleno (No space left on device)]] — el problema que ambos diagnostican
- [[Sistemas de Archivos]] — por qué `df` muestra montajes y no particiones
- [[free]] — memoria RAM y swap (cuando el problema no es disco)
- [[duf]] — alternativa que fusiona la presentación de ambos

## Enlaces externos

- [Wikipedia — df](https://en.wikipedia.org/wiki/Df_(Unix))
- [Wikipedia — du](https://en.wikipedia.org/wiki/Du_(Unix))
- [man df(1)](https://man7.org/linux/man-pages/man1/df.1.html) · [man du(1)](https://man7.org/linux/man-pages/man1/du.1.html)

#comando