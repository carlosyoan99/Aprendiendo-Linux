---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: media
---

# fd (fd-find)

> Alternativa moderna a `find`. Busca archivos en tiempo real con colores, respeta `.gitignore`, y es mucho más rápido que `find` para uso diario.

## Qué es

`fd` es un reemplazo de `find` escrito en Rust. No usa base de datos indexada (como `locate`), sino que recorre el sistema de archivos en tiempo real pero optimizado con paralelismo y filtros inteligentes.

**Ventajas sobre `find`:**
- Sintaxis intuitiva: `fd patrón` en vez de `find -name 'patrón'`
- Colores por tipo (archivo, directorio, symlink, ejecutable)
- Respeta `.gitignore` por defecto (ideal para proyectos)
- Regex sin escapar caracteres
- Hasta 5-10× más rápido que `find`

## Instalación

```bash
# Debian/Ubuntu
sudo apt install fd-find

# Arch
sudo pacman -S fd

# Fedora
sudo dnf install fd-find

# Uso (el binario puede llamarse fdfind en Debian)
fdfind patrón
# O crear alias: alias fd='fdfind'
```

## Ver también

- [[find]] — búsqueda clásica
- [[locate]] — búsqueda indexada
- [[fzf]] — búsqueda difusa interactiva
- [[grep]] — buscar contenido en archivos

#programa #herramientas #busqueda
