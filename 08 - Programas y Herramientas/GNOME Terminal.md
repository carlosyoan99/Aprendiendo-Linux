---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL-3.0
alternativas: [[Konsole]], [[Xfce Terminal]]
---

# GNOME Terminal

> Terminal por defecto de GNOME: la más común en Ubuntu, Fedora Workstation y Debian, con GTK y VTE.

## Qué es

**GNOME Terminal** (`gnome-terminal`) es el emulador de terminal oficial del entorno **[[GNOME]]**, basado en la librería **VTE**. Es la terminal más extendida en distribuciones GNU/Linux con GNOME como [[Ubuntu]], [[Fedora]] Workstation o [[Debian]]. Ofrece pestañas nativas, **perfiles** de configuración completos (colores, fuente, transparencia) y soporte de **True Color**, integrado de forma nativa con el tema y atajos de GNOME.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install gnome-terminal

# Arch
sudo pacman -S gnome-terminal

# Fedora
sudo dnf install gnome-terminal
```

## Configuración básica

La configuración se realiza desde la interfaz gráfica: **Preferencias → Perfil**. No hay un archivo de configuración directo a mano; los perfiles se almacenan en **dconf**:

```bash
# Ver/exportar perfiles
dconf dump /org/gnome/terminal/legacy/profiles:/
```

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `Ctrl+Shift+T` | Nueva pestaña |
| `Ctrl+Shift+N` | Nueva ventana |
| `Ctrl+Shift+W` | Cerrar pestaña |
| `Ctrl+Shift+C` / `Ctrl+Shift+V` | Copiar / pegar |
| `Ctrl+Shift+F` | Buscar en la salida |
| `Ctrl+Plus/Minus` | Zoom de fuente |
| `Ctrl+Shift+Up/Down` | Desplazar por pantalla |

## Uso avanzado

```bash
# Lanzar con un perfil concreto
gnome-terminal --profile="Oscuro"

# Abrir una pestaña con un comando y título
gnome-terminal --tab --title="Servidor" -- bash -c "htop; exec bash"

# Abrir terminal en un directorio
gnome-terminal --working-directory=/ruta
```

## Transparencia

Se configura desde **Preferencias → Perfil → Fondo → Transparencia**. GNOME Terminal no usa transparencia translúcida nativa, sino que **desenfoca/difumina el fondo del escritorio** según el tema.

## Comparativa con alternativas

| Aspecto | GNOME Terminal | Konsole | Xfce Terminal |
|---|---|---|---|
| **Escritorio** | GNOME | KDE | XFCE |
| **Splits** | No | Sí | No |
| **Consumo/RAM** | ~25 MB | ~30 MB | ~15 MB |
| **Perfiles** | Sí (dconf) | Sí (SSH/proyectos) | Sí |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| No aplica el tema oscuro | Falta perfil con fondo claro/oscuro | Crear/activar el perfil deseado en Preferencias |
| La función "Perfil por defecto" no aplica | dconf sin permisos/viejo | Reiniciar la sesión o usar `dconf reset` en el perfil |
| Copiar no funciona | Atajos cambiados | Reasignar desde Preferencias → Atajos |

## Notas y advertencias

- GNOME Terminal es la opción más fiable y extendida dentro de GNOME; para división de pantalla valora [[Konsole]].
- Sus opciones se gestionan vía **dconf**, no con un archivo de texto fácil de rootear.

## Enlaces externos

- [GNOME Terminal — GNOME Wiki](https://wiki.gnome.org/Apps/Terminal)
- [Wikipedia — GNOME Terminal](https://en.wikipedia.org/wiki/GNOME_Terminal)
- [Arch Wiki — GNOME Terminal](https://wiki.archlinux.org/title/GNOME/Terminal)

## Ver también

- [[GNOME]] — entorno de escritorio asociado
- [[Emuladores de Terminal]] — índice + comparativa
- [[Konsole]] — alternativa en KDE
- [[Xfce Terminal]] — alternativa ligera

#programa #terminal
