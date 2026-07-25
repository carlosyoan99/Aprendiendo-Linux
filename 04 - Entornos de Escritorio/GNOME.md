---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: entorno-escritorio
prioridad: alta
tipo: DE (desktop environment)
---

# GNOME

## Qué es

Entorno de escritorio moderno con interfaz limpia y minimalista, por defecto en Ubuntu, Fedora Workstation y Debian. Usa el compositor **Mutter** y está construido sobre GTK. Desde GNOME 40 (2021) adoptó un layout horizontal de workspaces que se aleja del enfoque tradicional de escritorio tipo "pila de ventanas".

## Instalación

```bash
# Debian/Ubuntu
sudo apt install gnome-shell gdm3       # gdm3 = gestor de sesión (pantalla de login)
sudo apt install ubuntu-desktop         # paquete completo (si estás en Ubuntu mínimo)

# Fedora (ya viene por defecto con Workstation)
sudo dnf group install "GNOME Desktop"

# Arch
sudo pacman -S gnome                     # grupo completo: shell, apps, gdm
sudo systemctl enable gdm                # habilitar gestor de sesión
```

## Configuración inicial

### GNOME Tweaks (esencial)

```bash
sudo apt install gnome-tweaks            # panel de configuración avanzada
# Desde Tweaks: cambiar fuente, tema, iconos, comportamiento de ventanas
```

### Extensiones (extensions.gnome.org)

GNOME se personaliza casi exclusivamente vía extensiones. La web extensions.gnome.org permite instalarlas con un solo clic (requiere el conector del navegador):

```bash
# Connector para Firefox/Chromium
sudo apt install chrome-gnome-shell       # Debian/Ubuntu
sudo pacman -S chrome-gnome-shell         # Arch
```

**Extensiones populares**:

| Extensión | Para qué |
|---|---|
| **Dash to Panel** | Barra de tareas tipo Windows/KDE |
| **ArcMenu** | Menú de inicio alternativo |
| **Blur my Shell** | Efecto de difuminado en paneles y lockscreen |
| **GSConnect** | Integración con Android (KDE Connect) |
| **Vitals** | Monitor de recursos en el panel |
| **Tiling Assistant** | Atajos para mover/redimensionar ventanas con teclado |
| **Sound Input & Output Chooser** | Cambiar dispositivos de audio desde el panel |

### gsettings (config desde terminal)

GNOME almacena su configuración en `dconf`/`gsettings`. Se puede consultar y modificar desde terminal, útil para scripts y sincronización:

```bash
# Consultar
gsettings list-recursively org.gnome.desktop.interface   # todo lo relacionado a interfaz
gsettings get org.gnome.desktop.interface font-name       # fuente actual

# Modificar
gsettings set org.gnome.desktop.interface font-name 'Fira Sans 11'
gsettings set org.gnome.mutter check-alsy-initialized false   # arreglar parpadeo en algunas GPUs

# Exportar/importar config (útil para sync entre máquinas)
dconf dump /org/gnome/ > gnome-settings.conf
dconf load /org/gnome/ < gnome-settings.conf
```

## Atajos de teclado clave

| Atajo | Acción |
|---|---|
| `Super` | Vista de actividades |
| `Super + A` | Ver todas las apps |
| `Super + Tab` | Cambiar de app |
| `Alt + Tab` | Cambiar de ventana dentro de la misma app |
| `Super + Flechas` | Ajustar ventana a mitades de pantalla |
| `Super + PageUp/PageDown` | Cambiar de workspace |
| `Super + Shift + PageUp` | Mover ventana a otro workspace |
| `Alt + F2` | Ejecutar comando (modo "Run Command") |
| `Super + L` | Bloquear pantalla |
| `Super + D` | Mostrar escritorio (toggle) |
| `Alt + Space` | Menú de ventana (cerrar, minimizar, etc.) |

## Pros / Contras

- ✅ Pulido visual, excelente integración con Wayland, accesibilidad fuerte (lector de pantalla Orca, zoom, teclado en pantalla).
- ✅ Extensiones vía web: no requieren instalación manual ni reinicio del DE.
- ❌ Consume más recursos que XFCE (~1-2 GB RAM en reposo con extensiones).
- ❌ Personalización profunda requiere extensiones de terceros — y las extensiones pueden romperse con cada actualización mayor de GNOME.
- ❌ El flujo centrado en la vista de actividades y workspaces divide opiniones (a algunos no les gusta el "escritorio vacío" con dock oculto).

## Wayland vs X11 en GNOME

GNOME usa **Wayland por defecto** desde GNOME 40 en adelante (y Fedora lo tiene por defecto desde Fedora 34). Ubuntu cambió a Wayland por defecto en 23.04.

Para cambiar a X11 en la pantalla de login: engranaje → "GNOME on Xorg".

## Notas personales

- GNOME es el DE que uso en mi portátil principal. La vista de actividades con `Super` y los workspaces horizontales me parecen el sistema más productivo para multitarea.
- Las extensiones son el punto débil: cada actualización mayor de GNOME suele romper varias. Mi consejo: usa las mínimas indispensables.
- GNOME en Wayland es la experiencia más fluida que he probado en Linux. Sin screen tearing, mixed-DPI funciona de maravilla.
- Si vienes de Windows, la curva es pronunciada las primeras semanas. Persiste — cuando le coges el truco a la vista de actividades, no vuelves atrás.

## Enlaces externos

- [Wikipedia — GNOME](https://en.wikipedia.org/wiki/GNOME)
- [Sitio oficial](https://www.gnome.org/)
- [GitLab oficial](https://gitlab.gnome.org/GNOME)

## Ver también

- [[KDE Plasma]] — el otro DE grande, más personalizable
- [[Cinnamon]] — fork de GNOME con escritorio tradicional
- [[Wayland vs X11]]
- [[Shells (bash zsh fish)]]

#entorno-escritorio
