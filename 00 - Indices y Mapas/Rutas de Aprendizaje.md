---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: indice
---

# Rutas de Aprendizaje — Qué priorizar por categoría

Criterio: **alta** = base indispensable para entender/usar Linux día a día, sin esto el resto no tiene contexto. **media** = amplía o profundiza, útil pero no bloqueante. **baja** = nicho, curiosidad, o alternativa a algo que ya está cubierto por una nota de prioridad alta.

Cada nota tiene ahora `prioridad` en su frontmatter — la tabla de arriba en [[Dashboard]] filtra automáticamente todo lo marcado `alta`.

## Conceptos Fundamentales
1. **Alta**: [[Que es Linux]], [[systemd]], [[Permisos y Propietarios]], [[Wayland vs X11]] — sin esto, cualquier troubleshooting o elección de WM no tiene base.
2. Media: [[Variables de Entorno y PATH]], [[Procesos y Senales]], [[Symlinks y Dotfiles]] — se vuelven relevantes en cuanto empiezas a configurar cosas a mano.

## Instalación
1. **Alta**: [[Proceso de Instalacion General]], [[Creacion de USB Booteable]] — lo mínimo para poner cualquier distro a andar.
2. Media: [[Particionado y Esquemas de Disco]], [[Post-Instalacion Checklist]].
3. Baja: [[Dual Boot con Windows]] — solo si de verdad vas a compartir disco con Windows.

## Distribuciones
1. **Alta**: [[Ubuntu]] (la más documentada/soportada, mejor punto de entrada) y [[Arch Linux]] (entender su filosofía explica de rebote a CachyOS, Manjaro y el AUR).
2. Media: [[Fedora]], [[Debian]], [[Linux Mint]], [[CachyOS]] — variantes con enfoques claramente distintos que vale la pena conocer.
3. Baja por ahora: [[Manjaro]], [[Pop OS]], [[openSUSE]], [[NixOS]], [[Alpine Linux]], [[Rocky Linux]] — interesantes pero cada una es un nicho (gaming, declarativo, contenedores, servidores) que tiene sentido explorar después de dominar las de arriba.

## Entornos gráficos y WMs
1. **Alta**: [[GNOME]] y [[KDE Plasma]] (cubren la enorme mayoría de escritorios reales) + [[Hyprland]] (representa bien a dónde va la tendencia Wayland/tiling moderno).
2. Media: [[XFCE]], [[i3]], [[Niri]] — buenas alternativas una vez tengas claro qué buscas (ligereza vs. paradigma scrollable).
3. Baja: [[Cinnamon]], [[Awesome WM]], [[DWM]] — válidas pero redundantes conceptualmente con algo de prioridad alta/media ya cubierto.

## Terminal y Comandos
1. **Alta**: [[La Shell]], [[Cheat Sheet - Comandos Esenciales]], [[grep]] — uso diario constante.
2. Media: [[find]] — muy útil pero de menor frecuencia que grep.

## Programas y Herramientas
1. **Alta**: [[Shells (bash zsh fish)]], [[Gestores de Paquetes]] — la forma en que instalas/interactúas con todo lo demás.
2. Media: [[Utilidades Base del Sistema]], [[Editores de Texto]], [[Emuladores de Terminal]], [[Gestores de Archivos]].
3. Baja: [[Navegadores Web]], [[LibreOffice]] — casi no requieren aprendizaje, son "instalar y usar".

## Sistema y Operativa
- **Alta**: [[Filesystem Hierarchy Standard]], [[Solucion de Problemas - Recursos]] — se usan constantemente al depurar cualquier cosa.
- Media: [[Automatizacion y Scripts]] — alto valor pero tiene sentido una vez ya te manejas con lo anterior.

## Enlaces externos

- [Linux Foundation — Training and certification](https://training.linuxfoundation.org/)
- [The Linux Documentation Project](https://tldp.org/) — guías clásicas de Linux
- [Arch Wiki — General recommendations](https://wiki.archlinux.org/title/General_recommendations)
- [Red Hat — Learning path for Linux administrators](https://www.redhat.com/en/services/training/learning-path-linux-administrator)

#indice #prioridades
