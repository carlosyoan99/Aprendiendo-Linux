---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL-2.0+
alternativas: [[Gedit]], [[Kate]]
---

# Geany

> IDE ligero basado en GTK: más que un editor de texto, menos que un IDE completo; ideal para equipos modestos.

## Qué es

**Geany** es un **IDE ligero** escrito en C y GTK, pensado para quienes quieren algo más que un editor de texto pero sin el peso de un IDE completo como Eclipse o Visual Studio. Su punto fuerte es la **velocidad y el bajo consumo** (~15 MB de RAM, arranque casi instantáneo), lo que lo hace excelente en equipos con pocos recursos o en uso ocasional. Soporta decenas de lenguajes con resaltado, plegado de código, un sistema de proyectos ligero y un ecosistema de plugins.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install geany

# Arch
sudo pacman -S geany

# Fedora
sudo dnf install geany

# Flatpak
flatpak install flathub org.geany.Geany
```

## Configuración básica

- La configuración se guarda en `~/.config/geany/`.
- Los plugins se gestionan desde **Herramientas → Gestor de plugins**.
- El editor puede usar formatos de color (temas) instalables desde `~/.config/geany/colorschemes/`.

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `F9` | Compilar (build) |
| `F5` | Ejecutar el script/binario |
| `F8` | Cambiar entre archivo de cabecera y fuente |
| `Ctrl+D` | Borrar la línea actual |
| `Ctrl+Shift+D` | Duplicar la línea |
| `Ctrl+Space` | Autocompletar (completar símbolo) |
| `Alt+Up/Down` | Mover línea arriba/abajo |

## Uso avanzado

```bash
# Abrir Geany cargando varios archivos a la vez
geany archivo1.c archivo2.c archivo3.py

# Abrir un proyecto reciente desde terminal
geany --session=/ruta/mis.session
```

- Geany incluye **terminal embebida** (vía plugin) y un sistema de "build" configurable por lenguaje.
- Permite definir **plantillas de archivo** propias en `~/.config/geany/templates/`.

## Comparativa con alternativas

| Aspecto | Geany | Gedit | Kate |
|---|---|---|---|
| **Enfoque** | IDE ligero | Editor simple | Editor avanzado |
| **LSP** | Parcial (plugins) | No | Sí |
| **Terminal integrada** | Sí (plugin) | Sí (plugin) | Sí |
| **Consumo/RAM** | Muy bajo | Muy bajo | Medio |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| No resalta un lenguaje | Falta definición de archivo | Comprobar en Documento → Tipo de archivo |
| El autocompletado no funciona | LSP/ClangD no configurado | Activar el plugin "LSP" y configurar el servidor |

## Notas y advertencias

- Excelente para Arduino, Python, C, Shell y scripting rápido.
- Para funcionalidades de IDE moderno (Refactor, etc.) alternativas más completas: [[Zed]], [[Helix]], [[Lapce]].

## Enlaces externos

- [Web oficial](https://www.geany.org/)
- [Documentación — Geany Manual](https://www.geany.org/manual/)
- [Wikipedia — Geany](https://en.wikipedia.org/wiki/Geany)
- [Arch Wiki — Geany](https://wiki.archlinux.org/title/Geany)

## Ver también

- [[Editores de Texto]] — índice + comparativa
- [[Kate]] — alternativa KDE
- [[Gedit]] — alternativa GNOME

#programa #editores
