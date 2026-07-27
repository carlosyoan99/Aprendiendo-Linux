---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: sistema
prioridad: alta
---

# Wayland vs X11

> El **protocolo de servidor de pantalla** (display server) es el software que media entre el hardware gráfico, el kernel, los gestores de ventanas y las aplicaciones. X11 es el estándar clásico (desde 1984); Wayland es su reemplazo moderno diseñado entre 2008 y 2010 por Kristian Høgsberg.

## Definición

- **X11 (X Window System)**: Protocolo cliente-servidor desarrollado en el MIT en 1984. El servidor X gestiona la pantalla, el teclado y el ratón, y cada aplicación (cliente) se conecta a él para dibujar ventanas y recibir input. El compositor es un gestor de ventanas adicional (como [i3], [Compiz], [KWin]) que se sitúa entre el servidor X y las apps.
- **Wayland**: Protocolo más moderno donde el **compositor es también el servidor**. Elimina la separación servidor-cliente del X11 legacy: el compositor (gestor de ventanas) habla directamente con el kernel DRM/KMS para controlar la pantalla, y con libinput para el input. Cada aplicación se comunica directamente con el compositor.

## Diferencias clave

| Aspecto | X11 | Wayland |
|---|---|---|
| **Arquitectura** | Cliente-servidor con compositor externo opcional | El compositor ES el servidor (todo en uno) |
| **Año de creación** | 1984 (MIT) | 2008-2010 (Kristian Høgsberg, freedesktop.org) |
| **Seguridad** | ❌ Cualquier app puede leer input/pantalla de otras apps (Keyloggers posibles) | ✅ Aislamiento por diseño: las apps no ven lo que pasa fuera de sus ventanas |
| **Screen tearing** | ⚠️ Requiere compositor externo (Picom, Compton) | ✅ Vsync integrado y obligatorio por defecto |
| **Rendering** | Cada app dibuja su ventana, el compositor combina | Cada app dibuja en un buffer, el compositor presenta directamente |
| **Latencia** | Mayor (varios saltos entre app → servidor X → compositor) | Menor (app → compositor → KMS directo) |
| **Compatibilidad** | ✅ Universal, décadas de software existente | ⚠️ Apps X11 funcionan vía XWayland (capa de traducción) |
| **Soporte multi-monitor** | Complejo (cada pantalla es un servidor X distinto) | Nativo (el compositor gestiona todos los monitores) |
| **Hot-plugging** | Limitado | Nativo (monitores se conectan/desconectan sin reiniciar) |
| **HDR** | No | ✅ Sí en compositores modernos (GNOME, KDE) |
| **HiDPI mixto** | ⚠️ Problemático (monitores con diferentes escalados) | ✅ Soporte nativo de escalado por monitor |
| **WMs compatibles** | i3, DWM, Awesome, Openbox, bspwm, herbstluftwm | Hyprland, Niri, River, Sway, KWin, Mutter |

## Arquitectura: diagrama simplificado

```
X11:
┌──────────┐   ┌──────────┐   ┌──────────┐
│  App GTK │   │  App Qt  │   │ App Xterm│
└────┬─────┘   └────┬─────┘   └────┬─────┘
     └──────────────┼──────────────┘
                    ▼
            ┌──────────────┐
            │  Servidor X  │ ← Gestiona input, pantalla
            └──────┬───────┘
                   ▼
            ┌──────────────┐
            │  Compositor  │ ← WM (KWin, i3, Picom)
            │ (opcional)   │
            └──────────────┘
                   ▼
              ┌──────────┐
              │  Kernel  │
              │ DRM/KMS  │
              └──────────┘

Wayland:
┌──────────┐   ┌──────────┐   ┌──────────┐
│  App GTK │   │  App Qt  │   │ App nativa│
└────┬─────┘   └────┬─────┘   └────┬─────┘
     └──────────────┼──────────────┘
                    ▼
          ┌──────────────────┐
          │  Compositor =    │ ← El WM ES el servidor
          │  Servidor Wayland│
          │  (Hyprland/Sway/ │
          │   KWin/Mutter)   │
          └────────┬─────────┘
                   ▼
              ┌──────────┐
              │  Kernel  │
              │ DRM/KMS  │
              └──────────┘
```

## XWayland — la capa de compatibilidad

Para que las aplicaciones viejas de X11 funcionen en Wayland, existe **XWayland**: un servidor X embebido que traduce las llamadas X11 a buffers Wayland.

```bash
# Verificar si XWayland está activo
ps aux | grep Xwayland

# Forzar una aplicación a usar XWayland (si da problemas en Wayland)
GDK_BACKEND=x11 firefox         # GTK apps
QT_QPA_PLATFORM=xcb firefox     # Qt apps
```

**Limitaciones de XWayland**:
- Screen tearing posible (hereda el problema de X11)
- No soporta gestos táctiles nativos
- No soporta arrastrar archivos entre apps XWayland y Wayland nativas
- No soporta menús que requieren posicionamiento absoluto
- No soporta HDR

## Estado de adopción (2026)

| Entorno | Soporte Wayland | Estado |
|---|---|---|
| **GNOME** | ✅ Nativo desde 2016 | Por defecto desde 40+ |
| **KDE Plasma** | ✅ Nativo desde 5.22 | Por defecto desde 6.0 (2024) |
| **Hyprland** | ✅ Wayland nativo | Solo Wayland |
| **Sway** | ✅ Wayland nativo | Solo Wayland |
| **Niri** | ✅ Wayland nativo | Solo Wayland |
| **River** | ✅ Wayland nativo | Solo Wayland |
| **XFCE** | ⚠️ Experimental | Por defecto X11 aún |
| **MATE** | ⚠️ Experimental | Por defecto X11 |
| **Cinnamon** | ⚠️ Experimental en 6.x | Por defecto X11 |
| **i3** | ❌ No | X11 (usar Sway para Wayland) |
| **bspwm** | ❌ No | X11 |
| **DWM** | ❌ No | X11 (usar river o hyprland) |

## Cuándo usar cada uno

### Sigue con X11 si...
- Usas WMs clásicos (i3, bspwm, DWM, Openbox)
- Necesitas aplicaciones que requieren X11 legacy (CI de software, algunas herramientas empresariales)
- Usas tecnologías como screen sharing en apps antiguas (X11 lo maneja mejor)
- Necesitas gestos táctiles granulares (XInput2 no está disponible en todos los compositores Wayland)
- Usas compartir pantalla remota vía VNC/TeamViewer (X11 tiene soporte nativo)

### Migra a Wayland si...
- Empiezas desde cero (sin legacy que mantener)
- Usas GNOME o KDE (ya lo usan por defecto)
- Quieres gaming con menos latencia y sin tearing
- Tienes monitores con distinto escalado HiDPI
- Te preocupa la seguridad (aislamiento entre apps)
- Quieres HDR y VRR (tasa de refresco variable)

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| App X11 se ve mal en Wayland | XWayland limitaciones | `GDK_BACKEND=wayland app` para forzar Wayland |
| Screen tearing en Wayland | Driver NVIDIA sin modosetting | Usar `nvidia-drm.modeset=1` en kernel params |
| Portapapeles no funciona entre apps | Protocolos de selección no implementados | `wl-clipboard` para CLI, `copyq` para GUI |
| Screenshot no funciona | Falta protocolo ext-screencopy | Instalar `xdg-desktop-portal-wlr` o `grim` |
| Drag & drop entre XWayland y Wayland no funciona | Limitación conocida de XWayland | Usar apps nativas Wayland |
| Cursor se ve pixelado | Tamaño de cursor no coincide con escalado | Establecer `XCURSOR_SIZE` en entorno |
| Compartir pantalla no funciona en apps Electron | Electron no usa pipewire | Activar `--enable-features=WebRTCPipeWireCapturer` |

## Historia y arquitectura de X11

X11 fue desarrollado en **1984 en el MIT** como parte del **Proyecto Athena** (DEC, MIT, IBM). Su nombre deriva del sistema **W** (letra anterior en el alfabeto). La primera versión (X1) usó un protocolo asíncrono, reemplazando el sincrónico de W. X11R1 se lanzó el **15 de septiembre de 1987** y el protocolo sigue siendo compatible con aquella versión.

### Modelo cliente-servidor (al revés)

X usa un modelo donde **el servidor X es el que corre localmente** (gestiona pantalla, teclado, ratón) y **los clientes X son las aplicaciones** (pueden ejecutarse en remoto). Esto confunde a nuevos usuarios porque los términos parecen invertidos:

| Componente | Dónde corre | Qué hace |
|---|---|---|
| **Servidor X** | En tu máquina local | Dibuja ventanas, gestiona input de teclado/ratón |
| **Cliente X** | Puede estar en remoto | Es la aplicación (Firefox, terminal, etc.) |

```bash
# Ejecutar app remota mostrándola localmente (X forwarding sobre SSH)
ssh -X usuario@servidor firefox          # --X forwarding
ssh -Y usuario@servidor firefox          # --trusted X forwarding (menos seguro)

# Manualmente (si no usas SSH -X):
export DISPLAY="192.168.1.10:0"          # decirle a la app remota dónde mostrar
firefox &                                 # se abre en la pantalla local
```

### Implementaciones históricas

| Implementación | Período | Notas |
|---|---|---|
| **XFree86** | 1992-2004 | Dominó el ecosistema Linux. Fork de X386. Cambio de licencia en 2004 provocó migración masiva |
| **X.Org Server** | 2004-presente | Fork de XFree86 bajo licencia MIT. Es la implementación actual estándar |
| **Xnest / Xephyr** | Varios | Servidores X anidados (X dentro de X). Útiles para testing |

### Principios de diseño de X

Establecidos por Bob Scheifler y Jim Gettys en 1984:

- "No añadan funcionalidad a menos que un implementador no pueda completar una aplicación real sin ella"
- "Es tan importante decidir qué no es el sistema, como decidir qué es"
- "Proporcionen un mecanismo en vez de una política"
- "Si pueden conseguir el 90% del efecto deseado con el 10% del trabajo, usen la solución más simple"

Estos principios explican por qué X11 no define botones, menús ni estilos de interfaz — eso queda para los toolkits (GTK, Qt) y gestores de ventanas.

### Terminales X (cliente ligero clásico)

Un **terminal X** era un dispositivo hardware que solo ejecutaba un servidor X. Se usaban en los 90 para que múltiples usuarios compartieran un servidor Unix central, ejecutando cada uno su sesión gráfica desde un terminal ligero. Conceptualmente similar a los thin clients modernos.

### Historial de versiones de X11

| Versión | Fecha | Innovación |
|---|---|---|
| X11R1 | 1987-09 | Protocolo base |
| X11R3 | 1988-10 | XDM (display manager) |
| X11R4 | 1989-12 | twm, XDMCP |
| X11R5 | 1991-09 | X386 (servidor para PC) |
| X11R6 | 1994-05 | ICCCM v2.0, Session Management |
| X11R6.4 | 1998-03 | **Xinerama** (múltiples monitores) |
| X11R6.6 | 2001-04 | Corrección de errores |
| X11R6.7 | 2004-04 | Primer lanzamiento de **X.Org Foundation** |
| X11R7.0 | 2005-12 | **Modularización** del código fuente |
| X11R7.7 | 2012-06 | Última versión del protocolo X11 |

---

## Ver también

- [[Hyprland]] — compositor Wayland moderno
- [[Niri]] — compositor Wayland con scroll
- [[i3]] — WM clásico X11
- [[DWM]] — WM minimalista X11
- [[Sway]] — i3-compatible para Wayland
- [[GNOME]] — DE con Wayland por defecto
- [[KDE Plasma]] — DE con Wayland por defecto desde v6
- [[Permisos y Propietarios]] — base de seguridad en Linux

## Enlaces externos

- [Wayland Wiki](https://wayland.freedesktop.org/)
- [X.org Wiki](https://www.x.org/wiki/)
- [Arch Wiki — Wayland](https://wiki.archlinux.org/title/Wayland)
- [Are We Wayland Yet?](https://arewewaylandyet.com/)
- [Wikipedia — X11](https://en.wikipedia.org/wiki/X_Window_System)
- [Wikipedia — Wayland](https://en.wikipedia.org/wiki/Wayland_(protocol))

#sistema
