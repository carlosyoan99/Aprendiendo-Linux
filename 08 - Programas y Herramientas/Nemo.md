---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL-2.0+
alternativas: [[Nautilus]], [[Dolphin]]
---

# Nemo

> Gestor de archivos por defecto de Cinnamon: un fork de Nautilus con más opciones y funcionalidades.

## Qué es

**Nemo** es el gestor de archivos por defecto del entorno **[[Cinnamon]]** (el escritorio de Linux Mint). Nació como un **fork de Nautilus** (GIO/GTK) con el objetivo de recuperar funcionalidad que el proyecto Nautilus fue simplificando. De ahí que ofrezca **más opciones**: panel dividido, terminal incrustada, renombrado en lote, scripts y complementos, y una mejor búsqueda que el Nautilus original. Funciona también de forma independiente en otros escritorios.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install nemo

# Arch
sudo pacman -S nemo

# Fedora
sudo dnf install nemo
```

## Atajos clave

| Atajo | Acción |
|---|---|
| `F3` | Split panel |
| `F4` | Terminal incrustada |
| `Ctrl+T` | Nueva pestaña |
| `Ctrl+H` | Mostrar archivos ocultos |
| `F2` | Renombrar |
| `Ctrl+Shift+N` | Nueva carpeta |
| `Ctrl+L` | Ir a la barra de direcciones |

## Características

- **Split panel** (`F3`) — comparar/transferir entre dos carpetas
- **Terminal incrustada** (`F4`) — terminal dentro del gestor
- **Renombrado batch** — renombrar varios archivos a la vez
- **Búsqueda potente** — mejor que el Nautilus original
- **Soporte de complementos y scripts** — acciones personalizables
- **Barra de navegación breadcrumb**

## Configuración avanzada

```bash
# Abrir terminal incrustada siempre que se desee (atajo F4)
# Abrir Nemo como root (usar con cuidado)
pkexec nemo
```

Los complementos van en `~/.local/share/nemo/actions/` y permiten añadir entradas al menú contextual.

## Comparativa con alternativas

| Aspecto | Nemo | Nautilus | Dolphin |
|---|---|---|---|
| **Origen** | Fork de Nautilus | GNOME | KDE |
| **Terminal incrustada** | Sí | No | Panel |
| **Split panel** | Sí | No | Sí |
| **Complementos/scripts** | Sí | Limitado | Servicios |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| La terminal incrustada no aparece | Dependencia `nemo-terminal` ausente | Instalarla y reiniciar Nemo |
| Los scripts no se muestran | Permiso de ejecución o ruta | Establecer `+x` y ubicarlos en `~/.local/share/nemo/actions/` |
| Nemo abre dos ventanas al inicio | Gestor de archivos por defecto | Ajustar la aplicación por defecto en el centro de control |

## Notas y advertencias

- Nemo es la elección por defecto en **Linux Mint/Cinnamon** gracias a su equilibrio entre funcionalidad y ligereza.
- Al estar basado en GIO/GTK, integra bien con los escritorios GNOME/GTK.

## Enlaces externos

- [Nemo — Linux Mint (GitHub)](https://github.com/linuxmint/nemo)
- [Wikipedia — Nemo (file manager)](https://en.wikipedia.org/wiki/Nemo_(file_manager))
- [Arch Wiki — Nemo](https://wiki.archlinux.org/title/Nemo)

## Ver también

- [[Nautilus]] — proyecto original del que deriva
- [[Cinnamon]] — DE asociado
- [[Dolphin]] — gestor de KDE
- [[Gestores de Archivos]] — índice + comparativa

#programa #archivos
