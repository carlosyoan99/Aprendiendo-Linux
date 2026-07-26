---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: baja
---

# nnn

Gestor de archivos de terminal extremadamente ligero, escrito en **C**. Ideal para WMs minimalistas donde se prioriza el bajo consumo de recursos.

## Instalación

```bash
sudo apt install nnn             # Debian/Ubuntu
sudo pacman -S nnn               # Arch
sudo dnf install nnn             # Fedora
```

## Atajos clave

| Atajo | Acción |
|---|---|
| `↑↓` | Navegar |
| `/` | Buscar archivo |
| `!` | Abrir shell en el directorio actual |
| `.` | Toggle archivos ocultos |
| `d` | Detalle de tamaño de directorio |
| `q` | Salir |

## Características

- Extremadamente ligero (escrito en C)
- Teclas configurables
- Vista detallada de tamaño de directorios
- Búsqueda integrada
- Abre shell en el directorio actual con `!`
- Soporte de plugins (previsualización, archivos, etc.)

## Ventajas

- Consumo mínimo de recursos
- Arranque instantáneo
- Ideal para servidores o sistemas embebidos

## Ver también

- [[ranger]] — navegador tipo vim con preview
- [[yazi]] — gestor TUI moderno en Rust
- [[lf]] — gestor TUI rápido en Go
- [[Gestores de Archivos]] — índice + comparativa

## Enlaces externos

- [GitHub — nnn](https://github.com/jarun/nnn)
- [Wiki de nnn](https://github.com/jarun/nnn/wiki)

#programa #archivos
