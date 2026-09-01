---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: media
---

# Dolphin

Gestor de archivos por defecto de [[KDE Plasma]]. Considerado uno de los gestores más completos y potentes del ecosistema Linux.

## Instalación

```bash
sudo apt install dolphin         # Debian/Ubuntu
sudo pacman -S dolphin           # Arch
sudo dnf install dolphin         # Fedora
```

## Atajos clave

| Atajo | Acción |
|---|---|
| `F3` | Split panel (dos paneles) |
| `F4` | Abrir terminal incrustada |
| `F7` | Panel de navegación rápida |
| `Ctrl+I` | Búsqueda avanzada |
| `F2` (múltiple) | Renombrado batch |

## Características

- Split panel nativo
- Terminal integrada (`F4`)
- Renombrado batch (seleccionar varios archivos + `F2`)
- Búsqueda avanzada con filtros
- Paneles laterales (navegación, información, metadatos)
- Vista dividida, vista de árbol
- Integración con Git (muestra estado de archivos versionados)
- Previsualización de imágenes, vídeos, documentos
- Servicios (menú contextual con acciones personalizables)

## Terminal integrada

La terminal integrada (`F4`) permite ejecutar comandos en el directorio actual sin cambiar de ventana, combinando la potencia de la GUI con la flexibilidad de la terminal.

## Dolphin vs Nautilus vs Thunar

| Aspecto | Dolphin | Nautilus | Thunar |
|---|---|---|---|
| Entorno | KDE/nativo | GNOME | XFCE/ligero |
| Split panel | Sí (`F3`) | No | No |
| Terminal integrada | Sí (`F4`) | No | Sí (plugin) |
| Renombrado batch | Sí | No | Sí (con plugin) |
| Consumo | Medio | Medio | Bajo |
| Integración Git | Sí | No | No |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No abre desde GNOME | Falta tema/servicio KDE | Lanzar con `dolphin` o instalar `dolphin-plugins` |
| Vista previa de vídeo no carga | Falta `ffmpegthumbs` | `sudo pacman -S ffmpegthumbs` / equivalente |
| Tema del título feo en otro DE | Falta integración KDE | Usar `breeze` o el tema del entorno |
| Más lento en red/devolución | Previsualización automática de red | Desactivar previews en carpetas remotas |

## Notas personales

- Al combinar con la terminal integrada (`F4`) Dolphin es mi gestor principal cuando uso plasma.
- El split de `F3` es muy útil para mover archivos entre dos destinos.

## Ver también

- [[Nautilus]] — gestor de GNOME
- [[Thunar]] — alternativa ligera
- [[Nemo]] — fork de Nautilus
- [[Atajos de teclado - Nautilus Thunar Dolphin]] — accesos rápidos por defecto
- [[Konsole]] — terminal asociada a KDE
- [[Gestores de Archivos]] — índice + comparativa

## Enlaces externos

- [Dolphin — KDE Aplicaciones](https://apps.kde.org/dolphin/)
- [Wikipedia — Dolphin](https://en.wikipedia.org/wiki/Dolphin_(file_manager))

#programa #archivos
