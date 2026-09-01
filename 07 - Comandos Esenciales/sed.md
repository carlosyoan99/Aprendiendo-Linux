---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: comando
prioridad: media
---

# sed

> Editor de flujo no interactivo. Realiza transformaciones sobre texto línea por línea: sustituciones, eliminaciones, inserciones. Fundamental en scripts para manipular archivos de configuración y logs.

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
sed -E 's/([0-9]+)\.([0-9]+)/v\1.\2/g'       # grupos de captura (ERE)
```

## Direcciones (rangos de líneas)

```bash
sed -n '5,10p' archivo.txt                   # imprimir líneas 5-10
sed -n '10q' archivo.txt                     # imprimir hasta línea 10 y salir
sed '1,5d' archivo.txt                       # borrar líneas 1-5
sed '/^#/d' archivo.txt                      # eliminar comentarios
sed '/^$/d' archivo.txt                      # eliminar líneas vacías
sed '/error/,/fin/p' archivo.txt             # desde "error" hasta "fin"
sed '1d' archivo.txt                         # eliminar primera línea
sed '$d' archivo.txt                         # eliminar última línea
```

## Otras operaciones

```bash
# Insertar línea después de un patrón
sed '/\[server\]/a listen=8080' config.ini   # añadir después de [server]

# Insertar línea antes de un patrón
sed '/\[server\]/i server_name=miapp' config.ini

# Cambiar línea completa
sed '/^server_name=/c server_name=nuevo' config.ini

# Imprimir solo líneas que coincidan (como grep)
sed -n '/error/p' log.txt

# Duplicar una línea
sed '/patrón/p' archivo.txt

# Extraer texto entre marcadores
sed -n '/### INICIO/,/### FIN/p' documento.md
```

## Flags

| Flag | Efecto |
|---|---|
| `g` | Reemplazar todas las ocurrencias |
| `i` | Ignorar mayúsculas/minúsculas |
| `p` | Imprimir la línea (con `-n`) |
| `d` | Borrar la línea |
| `w archivo` | Escribir resultado a archivo |
| `I` | Ignorar mayúsculas (GNU sed) |
| `e` | Ejecutar comando en cada línea |

## Ejemplos reales

```bash
# Redactar IPs en un log
sed -E 's/[0-9]{1,3}(\.[0-9]{1,3}){3}/REDACTED/g' access.log

# Quitar etiquetas HTML
sed 's/<[^>]*>//g' pagina.html

# Modificar archivo de configuración
sed -i 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Añadir línea al final de un archivo
sed -i '$a\# Última línea' archivo.txt

# Eliminar comentarios y líneas vacías
sed -e '/^#/d' -e '/^$/d' archivo.conf

# Convertir CSV a texto legible
sed 's/,/\t/g' datos.csv

# Reemplazar en múltiples archivos (GNU sed)
sed -i 's/texto_viejo/texto_nuevo/g' *.txt

# Backup automático al editar
sed -i.bak 's/old/new/g' config.yml
```

## Ver también

- [[awk]] — procesamiento por columnas
- [[grep]] — filtrar líneas por patrón
- [[Regular Expressions]] — patrones de búsqueda
- [[sed y awk]] — índice combinado
- [[cut]] — extraer columnas
- [[Coreutils y util-linux]] — paquete que incluye sed

## Enlaces externos

- [Wikipedia — sed](https://en.wikipedia.org/wiki/Sed)
- [GNU sed manual](https://www.gnu.org/software/sed/manual/sed.html)
- [Sed One-Liners](https://www.grymoire.com/Unix/Sed.html)
- [Arch Wiki — sed](https://man.archlinux.org/man/sed.1)

#comando #texto #scripts
