---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: DE
motor_composicion: x11
lenguaje_config: TQt (fork de Qt 3)
---

# Trinity

> Entorno de escritorio clásico, **fork de KDE 3.5** que preserva y moderniza la experiencia de escritorio tradicional de los 2000, con bajo consumo de recursos y compatibilidad con hardware antiguo y moderno.

## Qué es

Trinity Desktop Environment (TDE) es un proyecto independiente nacido en **2010** como fork del código de **KDE 3.5** tras la migración a KDE 4. Fue creado por **Timothy Pearson** (coordinador de versiones KDE 3.x en Kubuntu) y un grupo de desarrolladores que consideraban que KDE 4 y posteriores perdían la usabilidad clásica del escritorio KDE 3.

A diferencia de KDE Plasma 5/6, TDE mantiene la filosofía de escritorio tradicional: panel inferior, menú clásico (Kickoff/Kicker), barra de tareas, applets heredados y el gestor de archivos **Konqueror** como pieza central. No es una continuación de KDE 3 mantenida por KDE e.V., sino un proyecto totalmente autónomo con su propia comunidad y ciclo de desarrollo.

## Capturas / Imágenes

> ![Trinity Desktop](https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/Trinity_Desktop_R14.0.9.png/320px-Trinity_Desktop_R14.0.9.png)
> *Trinity R14.0.9 con menú y panel clásicos (Fuente: Wikipedia)*

## Instalación

```bash
# Debian/Ubuntu (repositorio oficial)
# Añadir repositorio primero
echo "deb https://mirror.trinitydesktop.org/trinity/mirror.txt $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trinity.list
sudo apt update
sudo apt install trinity-desktop

# Arch Linux (AUR)
yay -S trinity-desktop

# Fedora / RedHat
# Ver: https://wiki.trinitydesktop.org/Category:Installation

# Q4OS — distribución con Trinity preinstalado
# Descargar desde: https://q4os.org/
```

## Configuración inicial

| Aspecto | Detalle |
|---|---|
| **Archivo de configuración** | `~/.trinity/` (directorio completo) |
| **Lenguaje** | TQt, configuración vía paneles de control (kcontrol) |
| **Display Manager** | TDM (Trinity Display Manager), GDM o SDDM |
| **Gestor de archivos** | Konqueror (clásico) |

## Características clave

| Aspecto | Detalle |
|---|---|
| **Toolkit** | TQt (fork de Qt 3 mantenido por Trinity) |
| **Panel** | Kicker (panel clásico inferior con menú, barra de tareas, bandeja) |
| **Menú** | KMenu (estilo KDE 3) con pestañas y favoritos |
| **Gestor archivos** | Konqueror (navegador + gestor de archivos integrado) |
| **Centro de control** | KControl (configuración centralizada al estilo KDE 3) |
| **Applets** | Reloj, monitor de sistema, bandeja, paginador de escritorios |
| **RAM en idle** | ~200-350 MB |
| **Modelo** | Escritorio clásico tradicional |

## Aplicaciones incluidas

| Aplicación | Función |
|---|---|
| **Konqueror** | Navegador web y gestor de archivos |
| **KWrite** | Editor de texto simple |
| **Kate** | Editor de texto avanzado con sintaxis |
| **KMail** | Cliente de correo |
| **Kontact** | Suite de gestión personal (correo, calendario, contactos) |
| **K3b** | Grabación de CD/DVD |
| **KOrganizer** | Calendario y agenda |
| **Gwenview** | Visor de imágenes |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 500 MHz | 1 GHz |
| **RAM** | 256 MB | 1 GB |
| **Disco** | 2 GB | 5 GB |
| **GPU** | Cualquiera con soporte X11 | Integrada básica |

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Extremadamente ligero (~200-350 MB RAM) | Toolkit TQt desactualizado técnicamente |
| Interfaz familiar para usuarios KDE 3 veteranos | Sin soporte Wayland |
| Funciona en hardware de los 2000 | No compatible con aplicaciones Qt5/Qt6 modernas |
| Aplicaciones clásicas maduras y estables | Ecosistema pequeño comparado con Plasma |
| Ciclo de lanzamientos estable (cada 6 meses) | Repositorios no incluidos por defecto en distros |
| Comunidad activa (R14.1.6, abril 2026) | Integración limitada con tecnologías modernas |

## Trinity vs KDE Plasma

| Característica | Trinity (TDE) | KDE Plasma 5/6 |
|---|---|---|
| **Filosofía** | Preservar escritorio clásico KDE 3.5 | Innovación, widgets modernos |
| **Toolkit** | TQt (fork de Qt 3) | Qt 5 / Qt 6 |
| **Interfaz** | Tradicional, fija | Altamente personalizable, modular |
| **RAM** | ~200-350 MB | ~600-1200 MB |
| **Wayland** | No (solo X11) | Sí (Plasma 6 nativo) |
| **Aplicaciones modernas** | Limitado | Compatible con apps Qt6 modernas |
| **Hardware antiguo** | Excelente | Funciona pero pesado |

## Distribuciones con Trinity

| Distro | Soporte |
|---|---|
| **Q4OS** | Entorno principal, preinstalado |
| **Debian Trinity** | Repositorio oficial mantenido |
| **Exe GNU/Linux** | Distribución con Trinity por defecto |
| **MX Linux** | Disponible como instalación opcional |
| **Arch Linux** | Disponible vía AUR (arch-tde) |
| **Slackware, Gentoo** | Soporte comunitario |

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Trinity no aparece en DM | TDM no está configurado | `sudo apt install tdm` o configurar sesión en SDDM |
| Aplicaciones Qt5 no se ven bien | Estilos GTK/Qt5 no instalados | Instalar `qt5-style-plugins` y configurar `QT_QPA_PLATFORMTHEME=gtk2` |
| Konqueror no carga web | SSL desactualizado | Usar navegador moderno (Firefox) para web, Konqueror para archivos |
| Sonido no funciona | PulseAudio no detectado | `sudo apt install pulseaudio pulseaudio-module-x11` |
| Pantalla negra al iniciar sesión | Controlador gráfico incorrecto | Usar controladores vesafb o modesetting en lugar de propietarios |

## Notas personales

-

## Notas personales

- Trinity es para nostálgicos de KDE 3.x. Si usaste KDE entre 2002 y 2008, Trinity te transportará directamente a esa época.
- Técnicamente, es un fork de KDE 3.5 que mantiene la misma apariencia y comportamiento, actualizado para correr en distros modernas.
- No lo recomiendo para uso diario a menos que tengas una razón muy específica para necesitar KDE 3. Plasma 6 es superior en todo.
- Q4OS es la distro que mejor integra Trinity. Si quieres probarlo, esa es la vía más sencilla.

## Enlaces externos

- [Trinity Desktop — sitio oficial](https://trinitydesktop.org/)
- [Wiki oficial de instalación](https://wiki.trinitydesktop.org/Category:Installation)
- [Wikipedia — Trinity](https://en.wikipedia.org/wiki/Trinity_Desktop_Environment)
- [Repositorio GitHub](https://github.com/TrinityDesktop)
- [Q4OS — distro con Trinity preinstalado](https://q4os.org/)
- [Foro Trinity](https://trinitydesktop.org/community.php)

## Ver también

- [[Comparativa entornos de escritorio]] — comparativa de todos los DEs
- [[KDE Plasma]] — el DE moderno del que Trinity es fork
- [[MATE]] — concepto similar (fork de GNOME 2)
- [[XFCE]] — DE ligero alternativo

#entorno-escritorio
