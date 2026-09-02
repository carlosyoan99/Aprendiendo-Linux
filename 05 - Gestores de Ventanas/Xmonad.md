---
fecha_creacion: 2026-09-02
fecha_modificacion: 2026-09-02
estado: borrador
categoria: entorno-escritorio
prioridad: baja
tipo: WM tiling (dinámico)
motor_composicion: x11
lenguaje_config: Haskell (config.hs compilada)
---

# Xmonad

> Gestor de ventanas **tiling dinámico** escrito y configurado íntegramente en **Haskell**, basado en el estado puro de cuántas ventanas hay, con layouts automáticos y atajos potentes, manteniendo la simplicidad de un WM minimalista en X11.

## Qué es

**Xmonad** es un window manager de tiling (como i3/DWM) pero con una característica única: **toda la configuración se escribe en Haskell** — `~/.xmonad/xmonad.hs` — que se compila en el arranque. No hay sistema de menús; todo se controla con teclado y layouts.

- **Layouts dinámicos**: master + stack (como DWM), but abarca muchos módulos
- **Config recompilada** (`xmonad --recompile`)
- **Extensible con módulos** (xmonad-contrib): docks, layout per monitor, etc.
- **X11** (y experimental en Wayland con `xmonad-wayland`)
- Filosofía de **pura centralidad**: el estado se define solo por el número de ventanas

Va dirigido a programadores funcionales y usuarios que quieren control total vía código Haskell.

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | x86_64 1 núcleo | 2+ |
| **RAM** | 512 MB | 1 GB (muy ligero) |
| **GPU** | Básica | Compatible X11 |

## Instalación

```bash
# En Debian/Ubuntu
sudo apt install xmonad

# En Arch
sudo pacman -S xmonad xmonad-contrib

# En Fedora
sudo dnf install xmonad

# Post-instalación (dependencias para compilar config)
sudo apt install libghc-xmonad-contrib-dev cabal-install
```

Tras instalar, se crea el `xmonad.hs` la primera vez que arranca.

## Configuración inicial

| Aspecto | Detalle |
|---|---|
| **Archivo de configuración** | `~/.xmonad/xmonad.hs` (compilado con `xmonad --recompile`) |
| **Lenguaje** | Haskell |
| **Recomposición en caliente** | Sí (`Mod + q` recarga) |

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Mod + Enter` | Nueva terminal (launch) |
| `Mod + j/k` | Mover foco abajo/arriba |
| `Mod + h/l` | Ajustar tamaño master/alargar |
| `Mod + space` | Cambiar layout |
| `Mod + Tab` | Ciclar ventanas |
| `Mod + Shift + q` | Salir (restart) |
| `Mod + q` | Recargar config |

## Personalización visual

- Todo vía Haskell: `managedHook`, `startupHook`, `layoutHook`, `workspaces`, `keys`
- Barras de estado externas: **xmobar**, polybar, dzen (vía `mod+`,`logHook`)
- `xmonad-contrib` ofrece cientos de módulos (layouts propio de Xmonad como `Layout.PerMonad`, docks, etc.)
- Temas y pantallas configurables a bajo nivel

## Comandos asociados

| Comando | Para qué |
|---|---|
| `xmonad --restart` | Recargar |
| `xmonad --recompile` | Recompilar config |
| `mod+q` | Recarga en caliente |
| `xmonadctl` | Control remoto (con extensión) |

## Comparativa con alternativas

| Aspecto | Xmonad | i3 | DWM |
|---|---|---|---|
| **Rendimiento** | Muy alto | Alto | Muy alto |
| **RAM en idle** | ~50 MB | ~80 MB | ~30 MB |
| **Curva aprendizaje** | Alta (Haskell) | Media | Alta (C) |
| **Personalización** | Altísima | Alta | Config en código |

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Config funcional, tipada, recompilable | Requiere saber Haskell |
| Light y rápido | Sin panels/menús integrados |
| Miles de módulos en xmonad-contrib | Foco en X11 (wayland experimental) |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| No compila config | Error de dependencias | `xmonad --recompile` leyendo errores; instalar `libghc-xmonad-contrib-dev` |
| Regresa a layout por defecto | Config no aplicada | `xmonad --restart` y revisar `xmonad.hs` |
| Sin barra | No hay loghook/polybar | Configurar `logHook` + `xmobar` |

## Notas personales
- Es la mejor opción si ya programas en Haskell o quieres tiling puro programable.
- Extremadamente estable y personalizable, con una comunidad pequeña pero activa.

## Enlaces externos
- [Sitio oficial](https://xmonad.org/)
- [Wiki oficial](https://xmonad.org/documentation.html)
- [Arch Wiki — xmonad](https://wiki.archlinux.org/title/Xmonad)
- [Wikipedia — Xmonad](https://en.wikipedia.org/wiki/Xmonad)
- [GitHub](https://github.com/xmonad/xmonad)

## Ver también
- [[i3]] — WM tiling popular X11
- [[DWM]] — WM tiling minimalista en C
- [[Wayland vs X11]] — servidor gráfico subyacente

#DE-WM