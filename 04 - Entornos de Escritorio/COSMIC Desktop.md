---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: Entorno de escritorio (Rust)
motor_composicion: wayland
lenguaje_config: COSMIC settings (gráfico) + TOML bajo `~/.config/cosmic/`
---

# COSMIC Desktop

> Entorno de escritorio construido desde cero en Rust por System76, nativo Wayland, con COSMIC Comp como compositor y tiling + floating integrados.

## Qué es

**COSMIC** (_Computer Operating System MainInterface Component_) es el entorno de escritorio que System76 desarrolla para Pop!_OS y que reemplaza a GNOME a partir de Pop!_OS 24.04. Está escrito íntegramente en **Rust** sobre el toolkit **Iced**, con su propio compositor Wayland (**COSMIC Comp**), su panel, su lanzador, su tienda y su centro de configuración.

- **Filosofía**: modularidad y seguridad en memoria. Cada componente (panel, comp, app-library, settings) es un binario independiente que se puede parar o reiniciar sin tumbar el escritorio.
- **Público**: usuarios que quieren Wayland nativo, tiling opcional y un escritorio moderno sin la pesadez de GNOME.
- **Tiling + floating**: gestor de ventanas híbrido — enmarcar en cuadrícula o dejar flotar, por ventana o por configuración global.
- **Estado (2026)**: beta pública muy avanzada; DE por defecto de Pop!_OS e instalable en otras distros.
- **Servidor gráfico**: solo Wayland (con XWayland para apps X11).

| Aspecto | Detalle |
|---|---|
| **Lenguaje** | Rust |
| **Toolkit** | Iced |
| **Compositor** | COSMIC Comp (Wayland) |
| **Barra** | COSMIC Panel |
| **Lanzador** | COSMIC Launcher + App Library |
| **Configuración** | COSMIC Settings |
| **Tienda** | COSMIC Store (integra Flathub) |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 4 núcleos (x86-64 / ARM64) | 6+ núcleos |
| **RAM** | 4 GB | 8 GB |
| **GPU** | Aceleración 3D (Vulkan/OpenGL 3.3+) | GPU moderna; NVIDIA requiere driver actual configurado para Wayland |

COSMIC hace uso intensivo de la GPU para el render del toolkit con Grafito; en hardware sin aceleración 3D no es usable.

## Instalación

```bash
# Pop!_OS 24.04 LTS — lo trae por defecto (no hay nada que instalar)

# Arch / Arch-based (repos oficiales)
sudo pacman -S cosmic

# Fedora
sudo dnf group install "COSMIC Desktop"

# Debian/Ubuntu (otras)
# Repositorios PPA oficiosos o compilar desde fuente (requiere Rust + meson)
```

La opción más estable es instalar **Pop!_OS**, donde viene integrado y probado por System76.

## Configuración inicial

| Aspecto | Detalle |
|---|---|
| **Archivo de configuración** | Interfaz gráfica (`cosmic-settings`) + archivos bajo `~/.config/cosmic/` |
| **Lenguaje** | Rust (código); configuración a bajo nivel en esquemas/TOML |
| **Recomposición en caliente** | Sí — la mayoría de cambios (tema, layout, atajos) aplican al momento |

```bash
cosmic-settings              # centro de control gráfico (temas, atajos, display…)
```

Las páginas (apariencia, teclado, pantalla, efectividad) se navegan desde la propia ventana de Settings.

### Primera sesión

```bash
# Elegir la sesión COSMIC desde el gestor de pantalla (GDM)
# Configurar esquema de color, atajos y activar tiling desde Settings
# Instalar aplicaciones vía COSMIC Store (Flathub)
```

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Super` | Overview (vista de ventanas y workspaces) |
| `Super + D` | Lanzador de aplicaciones |
| `Super + Enter` | Abrir terminal |
| `Super + Q` | Cerrar ventana activa |
| `Super + Flechas` | Mover el foco en la cuadrícula (tiling) |
| `Super + Shift + Flechas` | Mover la ventana |
| `Super + 1-9` | Cambiar a workspace N |
| `Super + Shift + 1-9` | Mover ventana al workspace N |

Todos son configurables desde `cosmic-settings` → Teclado.

## Personalización visual

- **Temas**: claro, oscuro y oscuro-híbrido, con colores de acento configurables.
- **Efectos**: desenfoque translúcido en paneles y ventanas flotantes, esquinas redondeadas y animaciones suaves.
- **Panel**: barra superior configurable (posición, auto-ocultar, módulos).
- **Notificaciones**: centro de notificaciones integrado estilo GNOME y OSD propio de volumen/brillo.
- **Aplicaciones**: el estilo visual de COSMIC es propio (no GTK ni Qt); las apps de escritorio usan el look Iced nativo.

## Comandos asociados

| Comando | Para qué |
|---|---|
| `cosmic-settings` | Centro de configuración |
| `cosmic-comp` | El compositor Wayland (gestión de ventanas) |
| `cosmic-panel` | Barra superior |
| `cosmic-app-library` | Grid de aplicaciones |
| `cosmic-launcher` | Lanzador (atajo `Super + D`) |
| `cosmic-greeter` | Pantalla de login / bloqueo |

## Comparativa con alternativas

| Aspecto | COSMIC | GNOME | KDE Plasma |
|---|---|---|---|
| **Lenguaje base** | Rust | C (GTK) | C++ (Qt) |
| **Compositor** | COSMIC Comp | Mutter | KWin |
| **Tiling integrado** | Sí (híbrido) | No nativo (extensiones) | Parcial (cuadrículas) |
| **Wayland** | Nativo | Nativo (maduro) | Nativo (maduro) |
| **RAM en idle** | Media | Media-alta | Media |
| **Filosofía** | Modular, "solo lo necesario" | Monolítico, cohesión total | Suite completa (Qt) |

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Rust + Iced: rápido y seguro en memoria | En beta: bugs puntuales y APIs en movimiento |
| Tiling y floating integrados sin extensiones | Ecosistema joven junto a GTK/Qt |
| Nativo Wayland con gestión sólida de mixed-DPI | Requiere GPU 3D decente (render Grafito) |
| Completamente modular y probado por System76 | Aún poco soporte de apps específicas |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| `cosmic-comp` se cierra o pantalla congelada | Bug de GPU/drivers en versiones beta | Actualizar a la última release o notificar en GitHub |
| Aplicaciones X11 borrosas con scaling | XWayland sin escala configurada | Ajustar escala de XWayland en `cosmic-settings` → Pantalla |
| No arranca con NVIDIA vieja | DRM/Vulkan mal soportado por el driver | Driver actual y modo Wayland/Vulkan habilitado |
| Pantalla negra en VM | Sin aceleración 3D | GPU passthrough o probar otro DE |

## Enlaces externos

- [Sitio oficial — System76 COSMIC](https://system76.com/cosmic)
- [Repositorio GitHub — pop-os/cosmic-epoch](https://github.com/pop-os/cosmic-epoch)
- [Soporte — Pop!_OS Help Center](https://support.system76.com/)
- [Arch Wiki — COSMIC](https://wiki.archlinux.org/title/COSMIC)

## Ver también

- [[Pop OS]] — la distro donde viene por defecto
- [[GNOME]] — el DE que reemplaza en Pop!_OS
- [[KDE Plasma]] — la suite completa de referencia en Qt
- [[Deepin]] — otro DE que apostó por una estética propia
- [[Wayland vs X11]] — el protocolo bajo COSMIC Comp

#entorno-escritorio #wayland