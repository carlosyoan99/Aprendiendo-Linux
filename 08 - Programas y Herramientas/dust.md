---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: media
---

# dust

> `du` moderno con gráficos de barras y colores. Muestra qué directorios están consumiendo más espacio de forma visual e intuitiva.

## Qué es

**dust** (du + dust) es un analizador de uso de disco escrito en Rust que muestra el tamaño de directorios con barras de progreso proporcionales. A diferencia de `du`, que muestra números crudos, dust da una vista visual de qué carpetas pesan más.

**Ventajas sobre `du`:**
- Barras de progreso visuales con colores
- Ordena automáticamente por tamaño (los más grandes primero)
- Filtrado por tamaño mínimo
- Colores por profundidad
- Rápido (escrito en Rust)

## Instalación

```bash
# Debian/Ubuntu
sudo apt install dust        # Ubuntu 24.04+
sudo snap install dust

# Arch / CachyOS
sudo pacman -S dust

# Fedora
sudo dnf install dust

# Cargo
cargo install du-dust
```

## Uso

```bash
dust                          # análisis del directorio actual
dust /home                    # analizar /home
dust -n 20                    # mostrar solo los 20 más grandes
dust -d 3                     # profundidad máxima 3
dust -s                      # solo mostrar directorios (sin archivos)
dust -r                      # orden inverso (más pequeños primero)
dust -e                      # ocultar barras (solo números)
dust -S                      # mostrar tamaño en bytes
dust -p                      # usar puntos en vez de barras
dust --no-percent             # ocultar porcentaje
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `-n <N>` | Mostrar top N directorios |
| `-d <N>` | Profundidad máxima |
| `-s` / `--apparent-size` | Tamaño aparente (sin contar archivos de enlace) |
| `-r` | Invertir orden |
| `-e` | Modo-only números (sin barras) |
| `-S` | Tamaño en bytes |
| `-p` | Carácter de barra por defecto |
| `-c` | Forzar colores |
| `-w <N>` | Ancho de terminal |
| `--no-percent` | Ocultar porcentaje |
| `--reverse` | Orden inverso |

## Ejemplo de salida

```
    7.2G  ┃ total
    3.1G  ┣━ Documents
    2.8G  ┣━ Downloads
    856M  ┣━ .cache
    234M  ┣━ .config
    112M  ┗━ Pictures
```

## Comparativa con alternativas

| Aspecto | dust | ncdu | du + sort | duf |
|---|---|---|---|---|
| **Barras visuales** | ✅ | ✅ | ❌ | ✅ |
| **Interactivo** | ❌ | ✅ | ❌ | ❌ |
| **Orden automático** | ✅ | ✅ | ❌ (necesita pipe) | ✅ |
| **Rendimiento** | ⚡ Rust | ⚡ C | ⚡ C | ⚡ Go |
| **Uso de disco** | ~2MB | ~5MB | ~1MB | ~3MB |

## Ver también

- `du` — el clásico
- `ncdu` — explorador interactivo de uso de disco
- [[duf]] — df moderno con colores
- [[df y du]] — comandos clásicos de espacio en disco
- `baobab` — analizador gráfico de disco (GNOME)

## Enlaces externos

- [GitHub — dust](https://github.com/bootandy/dust)
- [Arch Wiki — dust](https://wiki.archlinux.org/title/Dust)

#programa #tui #disco
