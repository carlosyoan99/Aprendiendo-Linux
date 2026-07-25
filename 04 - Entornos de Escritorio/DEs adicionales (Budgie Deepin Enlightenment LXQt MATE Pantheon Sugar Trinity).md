---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: entorno-escritorio
prioridad: baja
---

# Entornos de escritorio adicionales

Además de los entornos con nota individual, existen otros DEs con enfoques distintos. Esta nota recoge los que no tienen nota dedicada y sirve como índice de los que sí.

## Notas individuales

- [[MATE]] — continuación de GNOME 2, clásico y ligero
- [[Budgie]] — moderno, GTK, panel flexible, Raven
- [[LXQt]] — ligero en Qt, sucesor de LXDE
- [[Deepin]] — estética cuidada, DTK, macOS-like
- [[Pantheon]] — nativo de elementary OS, diseño pulido
- [[Enlightenment]] — ligero, EFL propio, efectos visuales

---

## Enlightenment (E)

### Qué es

Escritorio ligero y visualmente llamativo, con efectos gráficos (transparencias, desvanecimientos, sombras) desde antes de que existiera Compiz. Usa la toolkit **EFL** (Enlightenment Foundation Libraries) propia.

| Aspecto | Detalle |
|---|---|
| **Base** | EFL (propia) |
| **Display Manager** | Entrance (propio) o LightDM |
| **Gestor ventanas** | Enlightenment WM (integrado) |
| **RAM en idle** | ~200-400 MB |
| **Wayland** | Soporte básico |
| **Popular en** | Bodhi Linux |

```bash
sudo apt install enlightenment       # Debian/Ubuntu
sudo pacman -S enlightenment         # Arch
```

**Características**: Extremadamente ligero, efectos visuales nativos, gestión de temas potente, configuración modular, gestor de archivos propio (efm).

---

## Sugar
→ [[Sugar]] — DE educativo del proyecto OLPC, interfaz basada en actividades

---

## Trinity
→ [[Trinity]] — fork de KDE 3.5 con TQt, ligero y estable

---

## Tabla comparativa

| DE | Toolkit | RAM idle | Estética | Wayland |
|---|---|---|---|---|
| **Enlightenment** | EFL | ~200-400 MB | Única, efectos visuales | Básico |
| **Sugar** | GTK/Python | ~150-300 MB | → [[Sugar]] | No |
| **Trinity** | Qt 3 | ~200-350 MB | → [[Trinity]] | No |

## Enlaces externos

- [Wikipedia — Enlightenment](https://en.wikipedia.org/wiki/Enlightenment_(software))
- [Sitio oficial de Enlightenment](https://www.enlightenment.org/)
- [Wikipedia — Sugar (desktop environment)](https://en.wikipedia.org/wiki/Sugar_(desktop_environment))
- [Sitio oficial de Sugar Labs](https://sugarlabs.org/)
- [Wikipedia — Trinity Desktop Environment](https://en.wikipedia.org/wiki/Trinity_Desktop_Environment)
- [Sitio oficial de Trinity](https://trinitydesktop.org/)

## Ver también

- [[MATE]]
- [[Budgie]]
- [[LXQt]]
- [[Deepin]]
- [[Pantheon]]
- [[GNOME]] — el DE por defecto en la mayoría de distros
- [[KDE Plasma]] — el DE más completo y personalizable
- [[XFCE]] — el DE ligero por excelencia
- [[Cinnamon]] — DE clásico de Linux Mint
- [[Desktop Shells (Noctalia Caelestia)]] — capas de personalización sobre DEs

#entorno-escritorio
