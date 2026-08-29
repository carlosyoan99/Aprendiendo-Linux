---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL-3.0
alternativas: [[Kate]], [[Geany]]
---

# Gedit

> Editor de texto oficial de GNOME: simple, limpio y minimalista, ideal para ediciones rápidas sin distracciones.

## Qué es

**Gedit** es el editor de texto oficial del **entorno GNOME**, parte del proyecto GNOME Core. Su filosofía es la **simplicidad**: una interfaz limpia y minimalista orientada a edición rápida de texto y código en equipos de escritorio GNOME. Está escrito en C y GTK, y hereda de GNOME su integración visual y de atajos. Aunque no es un IDE, dispone de un ecosistema de **plugins** que lo hace muy capaz para tareas intermedias.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install gedit

# Arch
sudo pacman -S gedit

# Fedora
sudo dnf install gedit

# Flatpak
flatpak install flathub org.gnome.gedit
```

> Viene preinstalado con GNOME; en otras distribuciones se instala de forma independiente.

## Configuración básica

- Los ajustes y plugins se gestionan desde **Preferencias → Plugins** y el selector de plugins en **Complementos**.
- El resaltado sintáctico detecta el lenguaje automáticamente por la extensión del archivo.
- Los atajos siguen el estándar de GNOME (`Ctrl+S`, `Ctrl+Shift+S`, `Ctrl+Q`, etc.).

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `Ctrl+T` | Nueva pestaña |
| `Ctrl+Shift+P` | Nueva ventana |
| `Ctrl+F` | Buscar |
| `Ctrl+H` | Reemplazar |
| `Ctrl+Shift+F` | Buscar en archivos (plugin) |
| `Ctrl+Y` | Rehacer (ojo: en GNOME suele ser `Ctrl+Shift+Z`) |
| `Ctrl+I` / `Ctrl+U` | Sangría / anular sangría |

## Uso avanzado

```bash
# Abrir Gedit en modo terminal (no separa del proceso)
gedit --new-window archivo.txt

# Abrir esperando a que se cierre (para scripts)
gedit --wait archivo.txt

# Desde línea de comandos, editar con preferencias limpias
gedit --new-window --encoding=utf-8 archivo.txt
```

- Los plugins de Gedit aportan: mini-mapa, buscapalabras, terminal integrado, listado de símbolos, etc.

## Comparativa con alternativas

| Aspecto | Gedit | Kate | Geany |
|---|---|---|---|
| **Escritorio** | GNOME | KDE | Multi (GTK) |
| **Consumo/RAM** | Muy bajo | Medio | Muy bajo |
| **LSP integrado** | No | Sí | Parcial (plugins) |
| **Licencia** | GPL-3.0 | LGPL | GPL-2.0+ |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| No aplica el tema oscuro | Falta configurar el tema GTK | Ajustar en Configuración → Apariencia de GNOME |
| Faltan plugins | Paquete incompleto | Instalar `gedit-plugins` |

## Notas y advertencias

- Gedit es deliberadamente sencillo; si necesitas terminal integrada o LSP potente, valora [[Geany]] o [[Kate]].
- Los atajos de teclado cambiantes entre GTK2/GTK3 pueden sorprender; revisa Preferencias → Accesos rápidos.

## Enlaces externos

- [Web oficial](https://gedit-text-editor.org/)
- [Wikipedia — Gedit](https://en.wikipedia.org/wiki/Gedit)
- [Arch Wiki — Gedit](https://wiki.archlinux.org/title/Gedit)

## Ver también

- [[Editores de Texto]] — índice + comparativa
- [[Kate]] — alternativa KDE
- [[Geany]] — IDE ligero GTK

#programa #editores
