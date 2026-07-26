---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
---

# delta

> Pager de diff para Git con syntax highlighting, side-by-side view y navigación. Reemplaza `less` en `git diff`.

## Instalación

```bash
sudo apt install delta          # Debian/Ubuntu
cargo install git-delta         # desde fuente
```

## Configurar con Git

```bash
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
```

## Atajos (en delta)

| Tecla | Acción |
|---|---|
| `j/k` | Mover arriba/abajo |
| `q` | Salir |
| `?` | Ayuda |
| `n/p` | Siguiente/anterior archivo |

## Ver también

- [[Git]], [[diff]]

#programa #git
