---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: media
---

# sed

## Sintaxis básica

```bash
sed 'comando' archivo.txt                  # sobre archivo (solo pantalla)
comando | sed 'comando'                    # sobre entrada pipeada
sed -i 'comando' archivo.txt               # editar in-place
sed -i.bak 'comando' archivo.txt           # editar + backup
```

## Sustituciones (s/.../.../)

```bash
sed 's/viejo/nuevo/' archivo.txt              # 1ra ocurrencia por línea
sed 's/viejo/nuevo/g' archivo.txt             # todas (global)
sed 's/viejo/nuevo/2' archivo.txt             # solo la 2da ocurrencia
sed 's/viejo/nuevo/gi' archivo.txt            # global + ignorar mayúsculas
sed 's/  */ /g' archivo.txt                   # colapsar espacios
sed 's/^  *//' archivo.txt                    # eliminar espacios al inicio
sed 's/[0-9]//g' archivo.txt                  # eliminar todos los dígitos
```

## Direcciones (rangos de líneas)

```bash
sed -n '5,10p' archivo.txt                   # imprimir líneas 5-10
sed -n '10q' archivo.txt                     # imprimir hasta línea 10 y salir
sed '1,5d' archivo.txt                       # borrar líneas 1-5
sed '/^#/d' archivo.txt                      # eliminar comentarios
sed '/^$/d' archivo.txt                      # eliminar líneas vacías
sed '/error/,/fin/p' archivo.txt             # desde "error" hasta "fin"
```

## Flags

| Flag | Efecto |
|---|---|
| `g` | Reemplazar todas las ocurrencias |
| `i` | Ignorar mayúsculas/minúsculas |
| `p` | Imprimir la línea (con `-n`) |
| `d` | Borrar la línea |
| `w archivo` | Escribir resultado a archivo |

## Ejemplos reales

```bash
# Redactar IPs en un log
sed -E 's/[0-9]{1,3}(\.[0-9]{1,3}){3}/REDACTED/g' access.log

# Quitar etiquetas HTML
sed 's/<[^>]*>//g' pagina.html

# Extraer sección entre marcadores
sed -n '/### INICIO/,/### FIN/p' documento.md
```

## Ver también

- [[awk]] — procesamiento por columnas
- [[grep]] — filtrar líneas por patrón
- [[Regular Expressions]] — patrones de búsqueda

## Enlaces externos

- [Wikipedia — sed](https://en.wikipedia.org/wiki/Sed)
- [GNU sed manual](https://www.gnu.org/software/sed/manual/sed.html)

#comando
