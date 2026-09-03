---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: baja
---

# hexyl

> Visor hexadecimal con colores. Muestra archivos en formato hex + ASCII con resaltado por tipo de byte (NULL, ASCII, multibyte, high bytes).

## Qué es

**hexyl** es un `hexdump`/`xxd` moderno escrito en Rust que colorea los bytes según su tipo: NULL en gris, ASCII imprimible en verde, bytes altos en morado, etc. Mucho más legible que `hexdump -C` para inspeccionar archivos binarios.

**Ventajas sobre `hexdump`:**
- Colores automáticos por tipo de byte
- Soporte de rango de bytes (`--range`)
- Formatos de salida: hex, octal, binario, decimal
- Rápido (Rust) y limpio

## Instalación

```bash
# Debian/Ubuntu
sudo apt install hexyl

# Arch / CachyOS
sudo pacman -S hexyl

# Fedora
sudo dnf install hexyl

# Cargo
cargo install hexyl
```

## Uso

```bash
hexyl archivo                    # ver en hex + ASCII
hexyl --length 64 archivo        # primeros 64 bytes
hexyl --range 0x10..0x20 archivo # bytes del offset 16 al 32
hexyl --block-skip 16 archivo    # saltar primeros 16 bytes
hexyl --no-unicode archivo       # solo ASCII (sin Unicode)
hexyl --bytes 32 archivo         # primeros 32 bytes
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `--length <N>` | Número de bytes a mostrar |
| `--range <START>..<END>` | Rango de bytes (hex o decimal) |
| `--block-skip <N>` | Saltar primeros N bytes |
| `--format hex\|octal\|bin\|decimal` | Formato de salida |
| `--color <auto\|always\|never>` | Control de colores |
| `--no-unicode` | No usar caracteres Unicode para bloques |
| `--plain` | Sin colores ni decoración |

## Ejemplo de salida

```
   Offset: 00 01 02 03 04 05 06 07  08 09 0A 0B 0C 0D 0E 0F
00000000: 7f 45 4c 46 02 01 01 00  00 00 00 00 00 00 00 00  .ELF............
00000010: 03 00 3e 00 01 00 00 00  40 10 40 00 00 00 00 00  ..>.....@.@.....
```

**Leyenda de colores:**
- Verde → ASCII imprimible
- Gris → NULL / bytes no imprimibles
- Morado → bytes altos (>127)
- Azul → delimitadores (nueva línea, tab)

## Comparativa con alternativas

| Aspecto | hexyl | xxd | hexdump -C | od -A x -t x1z | xxd -i |
|---|---|---|---|---|---|
| **Colores** | ✅ Sintácticos (ASCII/null/NULL) | ❌ Sin colores | ❌ Sin colores | ❌ Sin colores | ❌ Sin colores |
| **Unicode** | ✅ Bloques UTF-8 | ❌ | ❌ | ❌ | ❌ |
| **Rango de offsets** | ✅ `--skip/--length` | ⚠️ Limitado | ❌ Todo el archivo | ⚠️ Limitado | ❌ Todo el archivo |
| **Formato salida** | hex + ASCII + leyenda | hex + ASCII | hex + ASCII | hex + texto | C array |
| **Velocidad** | Rápido (Rust) | Muy rápido | Rápido | Rápido | Rápido |
| **Dependencias** | Ninguna (binario estático) | vim | coreutils | coreutils | vim |
| **Ideal para** | Inspección visual rápida | Edición hex en vim | Scripts, pipes | Configuración | Generar arrays C |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Salida sin colores | Terminal no soporta ANSI | Usar un terminal compatible o `--force-color` si está disponible |
| No abre binario grande | Render volcado gigante | Limitar con `head -c <n> fichero \| hexyl` o `--len`/`--skip` |
| `hexyl: command not found` | No instalado en PATH | `sudo apt install hexyl`/`pacman -S hexyl` o instalar desde release |
| Pipe de gzip muestra bytes de cabecera | Es comprimido | Descomprimir antes: `zcat fichero.gz \| hexyl` |

## Ver también

- `xxd` — hexdump clásico (viene con vim)
- `hexdump -C` — hexdump del sistema
- `od` — octal dump
- [[binutils]] — `objdump -s` para binarios ELF

## Enlaces externos

- [GitHub — hexyl](https://github.com/sharkdp/hexyl)
- [Arch Wiki — hexyl](https://wiki.archlinux.org/title/Hexyl)

#programa #hex #binarios
