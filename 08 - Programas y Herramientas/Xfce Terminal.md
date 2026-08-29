---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL-2.0+
alternativas: [[Konsole]], [[GNOME Terminal]]
---

# Xfce Terminal

> Terminal por defecto de XFCE: ligera, rápida y con lo justo, sin dependencias de GNOME o KDE.

## Qué es

**Xfce Terminal** (`xfce4-terminal`) es el emulador de terminal oficial del entorno **[[XFCE]]**. Destaca por su **ligereza** (~15 MB de RAM) y **velocidad**, ofreciendo exactamente lo necesario: pestañas, perfiles, transparencia y atajos configurables. Al estar construido con GTK y sin depender de GNOME ni KDE, es una opción excelente en equipos con pocos recursos y en escritorios minimalistas.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install xfce4-terminal

# Arch
sudo pacman -S xfce4-terminal

# Fedora
sudo dnf install xfce4-terminal

# Flatpak
flatpak install flathub org.xfce.Terminal
```

## Configuración básica

- Los ajustes se configuran desde **Editar → Preferencias** en la interfaz gráfica.
- Los atajos de teclado se personalizan desde **Editar → Atajos de teclado**.
- Se admiten **perfiles** de configuración intercambiables.

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `Ctrl+Shift+T` | Nueva pestaña |
| `Ctrl+Shift+W` | Cerrar pestaña |
| `Ctrl+Shift+N` | Nueva ventana |
| `Ctrl+Shift+C` | Copiar |
| `Ctrl+Shift+V` | Pegar |
| `Ctrl+Shift+F` | Buscar en la salida |
| `Ctrl+D` | Cerrar terminal actual |

## Uso avanzado

```bash
# Lanzar con un perfil específico
xfce4-terminal --profile=oscuro

# Abrir terminal en un directorio concreto
xfce4-terminal --working-directory=/ruta

# Mantener abierto tras ejecutar un comando
xfce4-terminal -e "htop" --hold
```

- Soporta **fondo de imagen** y **transparencia** para personalización visual.
- Permite usar varias pestañas abiertas con perfiles distintos.

## Comparativa con alternativas

| Aspecto | Xfce Terminal | Konsole | GNOME Terminal |
|---|---|---|---|
| **Escritorio** | XFCE | KDE | GNOME |
| **Ligereza** | Muy alta | Media | Alta |
| **Splits** | No | Sí | No |
| **Integración perfil** | Sí | Sí (SSH/proyectos) | Limitada |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| La transparencia no se ve | Falta compositor en el escritorio | Activar un compositor (p.ej. `picom`) en XFCE |
| Pega el portapapeles de forma inesperada | Interferencia de atajos | Reasignar atajos en Preferencias |

## Notas y advertencias

- Es la opción por defecto más ligera dentro de XFCE; muy estable y predecible.
- Para funcionalidad de división de pantalla, valora [[Konsole]] u otros emuladores avanzados.

## Enlaces externos

- [Xfce Terminal — Documentación](https://docs.xfce.org/apps/terminal/start)
- [Wikipedia — Xfce Terminal](https://en.wikipedia.org/wiki/Xfce_Terminal)
- [Arch Wiki — Xfce Terminal](https://wiki.archlinux.org/title/Xfce_terminal)

## Ver también

- [[XFCE]] — entorno de escritorio asociado
- [[Emuladores de Terminal]] — índice + comparativa
- [[GNOME Terminal]] — alternativa
- [[Konsole]] — alternativa

#programa #terminal
