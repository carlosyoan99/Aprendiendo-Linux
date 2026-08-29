---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: LGPL-2.0+
alternativas: [[Gedit]], [[Geany]]
---

# Kate

> Editor de texto avanzado de KDE Plasma: multipestaña, con LSP integrado y una posición intermedia entre editor de texto e IDE.

## Qué es

**Kate** (KDE Advanced Text Editor) es el editor de texto **oficial de KDE Plasma**, parte del proyecto KDE Gear. A diferencia de un editor minimalista, Kate ofrece un conjunto muy completo de funcionalidad: **LSP integrado** (autocompletado, diagnóstico, ir a definición), terminal embebida, pestañas y vistas divididas, resaltado de cientos de lenguajes y una API de scripting. Esto lo sitúa a medio camino entre un editor de texto y un IDE ligero.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install kate

# Arch
sudo pacman -S kate

# Fedora
sudo dnf install kate

# Flatpak
flatpak install flathub org.kde.kate
```

> Viene preinstalado con KDE Plasma; en otras distribuciones se instala de forma independiente.

## Configuración básica

- La configuración se guarda en `~/.config/katerc` y los perfiles/resaltados en `~/.local/share/kate/`.
- Los componentes (terminal, pestañas, etc.) se activan desde el menú **Vista**.
- El resaltado sintáctico detecta el lenguaje automáticamente.

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `Ctrl+T` | Nueva pestaña |
| `Ctrl+W` | Cerrar pestaña |
| `Ctrl+Shift+V` | Dividir verticalmente |
| `Ctrl+Shift+H` | Dividir horizontalmente |
| `Ctrl+Alt+F12` | Mostrar/ocultar terminal |
| `F8` | Mostrar/ocultar explorador de archivos |
| `Ctrl+Shift+B` | Ir a la línea |

## Uso avanzado

```bash
# Abrir Kate con una línea concreta
kate archivo.txt:42

# Abrir esperando a que se cierre (útil en scripts/editor de git)
kate --block archivo.txt

# Definir el LSP por lenguaje en Preferencias → LSP Clientes
```

- Kate hereda la arquitectura KTextEditor, la misma que usan otros editores KDE, por lo que los resaltados y plugins son compartibles.
- Dispone de **modo Vim** integrado (Viper) y **mini-mapa**.

## Comparativa con alternativas

| Aspecto | Kate | Gedit | Geany |
|---|---|---|---|
| **Escritorio** | KDE | GNOME | Multi (GTK) |
| **LSP integrado** | Sí | No | Parcial (plugins) |
| **Vistas divididas** | Sí | No | No |
| **Consumo/RAM** | Medio | Muy bajo | Muy bajo |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| El LSP no da sugerencias | El servidor de lenguaje no está instalado | Instalar el servidor correspondiente (p.ej. `pyright`, `clangd`) |
| Atajos diferentes a los esperados | Kompare/otros procesos capturan atajos | Reasignar desde Preferencias → Atajos |

## Notas y advertencias

- Es la opción recomendada dentro de KDE para programación sin instalar un IDE completo.
- Los archivos de sesión de Kate permiten restaurar pestañas y proyectos al reabrir.

## Enlaces externos

- [Web oficial](https://kate-editor.org/)
- [Wikipedia — Kate](https://en.wikipedia.org/wiki/Kate_(text_editor))
- [Arch Wiki — Kate](https://wiki.archlinux.org/title/Kate)

## Ver también

- [[Editores de Texto]] — índice + comparativa
- [[Gedit]] — alternativa GNOME
- [[Geany]] — alternativa GTK ligera
- [[KDE Plasma]]

#programa #editores
