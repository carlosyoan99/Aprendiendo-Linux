---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: entorno-escritorio
prioridad: media
tipo: DE
motor_composicion: x11
lenguaje_config: Python
---

# Sugar

> Entorno de escritorio educativo diseñado para niños, originalmente del proyecto **OLPC (One Laptop Per Child)**. Su interfaz se basa en **actividades** en lugar de ventanas, con un enfoque constructivista y colaborativo.

## Qué es

Sugar es un entorno de escritorio de código abierto creado específicamente para la educación infantil. A diferencia de los DEs tradicionales (GNOME, KDE), Sugar no usa metáforas de escritorio, ventanas flotantes ni carpetas. Su diseño se basa en principios de aprendizaje constructivista donde la interfaz es simple, visual y centrada en una sola tarea a la vez.

El proyecto comenzó como parte del proyecto **OLPC** para el portátil XO-1. En mayo de 2008, su desarrollo pasó a **Sugar Labs**, una organización sin ánimo de lucro que lo mantiene como proyecto comunitario independiente.

## Capturas / Imágenes

> ![Sugar Desktop](https://upload.wikimedia.org/wikipedia/commons/thumb/8/8e/Sugar_0.114_Home_View.png/320px-Sugar_0.114_Home_View.png)
> *Sugar Home View con actividades (Fuente: Wikipedia)*

## Instalación

```bash
# Fedora — mejor soporte nativo (SoaS)
sudo dnf groupinstall sugar-desktop

# Debian/Ubuntu
sudo apt install sucrose sugar-activities

# Arch Linux
sudo pacman -S sugar

# Sugar on a Stick (SoaS) — versión portable USB
# Descargar desde: https://wiki.sugarlabs.org/go/Sugar_on_a_Stick
```

## Configuración inicial

| Aspecto | Detalle |
|---|---|
| **Archivo de configuración** | Múltiples archivos en `~/.sugar/` |
| **Lenguaje** | Python (las actividades también) |
| **Display Manager** | GDM, SDDM o LightDM (aparece como "Sugar" en la sesión) |

## Filosofía: Actividades vs. Ventanas

Sugar no usa aplicaciones tradicionales sino **actividades** que se ejecutan a pantalla completa:

| Concepto tradicional | En Sugar |
|---|---|
| Ventanas flotantes | Actividades a pantalla completa |
| Escritorio con iconos | Vistas: Home, Groups, Neighborhood, Journal |
| Guardado manual | Journal guarda automáticamente todo |
| Aplicaciones independientes | Actividades colaborativas entre niños |

### Vistas principales

| Vista | Función |
|---|---|
| **Home** | Actividades disponibles y en ejecución (círculo de iconos) |
| **Journal** | Diario automático de todo el trabajo realizado |
| **Groups** | Compañeros conectados en red local |
| **Neighborhood** | Red local y colaboración entre pares |

## Actividades populares

| Actividad | Función |
|---|---|
| **Browse** | Navegador web sencillo |
| **Write** | Procesador de textos básico |
| **Turtle Blocks** | Programación visual con bloques (lenguaje Logo) |
| **Music Blocks** | Exploración musical y creación de melodías |
| **Pippy** | Entorno de programación Python para niños |
| **Chat** | Mensajería local entre equipos en red |
| **Paint** | Dibujo y pintura digital |
| **Calculate** | Calculadora científica básica |

## Requisitos del sistema

| Componente | Mínimo | Recomendado |
|---|---|---|
| **CPU** | 1 GHz | 2 GHz |
| **RAM** | 1 GB | 2 GB |
| **Disco** | 1 GB | 4 GB |
| **GPU** | Cualquiera con soporte X11 | Integrada moderna |

## Pros / Contras

| ✅ Pros | ❌ Contras |
|---|---|
| Entorno único para aprendizaje infantil | No apto para uso general de escritorio |
| Extremadamente ligero y optimizado | Interfaz poco intuitiva para adultos |
| Colaboración en red local nativa | Pocas actividades disponibles fuera del ecosistema educativo |
| Journal automático (nunca se pierde trabajo) | Sin soporte Wayland |
| Ideal para hardware antiguo o reciclado | Ecosistema pequeño comparado con GNOME/KDE |
| Actividades programables por el usuario | |

## Sugar on a Stick (SoaS)

Implementación portable de Sugar diseñada para ejecutarse desde un pendrive USB. Permite transformar cualquier ordenador en una plataforma educativa sin alterar el sistema operativo principal.

```bash
# Requisitos USB
# - Pendrive de al menos 2 GB
# - Arranque desde USB habilitado en BIOS
# - Descargar ISO desde: https://wiki.sugarlabs.org/go/Sugar_on_a_Stick
```

## Troubleshooting conocido

| Problema | Causa | Solución |
|---|---|---|
| Sugar no aparece en el DM | Paquete incompleto | Instalar `sucrose` completo o `sugar-desktop` |
| Actividades no cargan | Versión Python incorrecta | Verificar Python 3: `python3 --version` |
| Journal no guarda | Permisos en `~/.sugar/` | `chown -R $USER:$USER ~/.sugar` |
| No se ve red local | Firewall bloqueando puertos | Abrir puerto 8080 en firewall local |

## Notas personales

- Sugar no es un DE de escritorio generalista. Es un entorno educativo diseñado para niños, con una metáfora de "actividades" en lugar de ventanas. No lo instales esperando un escritorio tradicional.
- El proyecto OLPC para el que fue creado ya no existe como tal, pero Sugar Labs mantiene el desarrollo para uso educativo en países en desarrollo.
- Se puede probar en una máquina virtual o live USB. Sugar on a Stick es una buena forma de experimentar sin instalarlo.
- Si buscas un DE para niños en casa, Sugar es probablemente la mejor opción que existe en Linux.

## Enlaces externos

- [Sugar Labs — sitio oficial](https://sugarlabs.org/)
- [Sugar Wiki](https://wiki.sugarlabs.org/)
- [Wikipedia — Sugar](https://en.wikipedia.org/wiki/Sugar_(desktop_environment))
- [Sugar on a Stick](https://wiki.sugarlabs.org/go/Sugar_on_a_Stick)
- [GitHub — Sugar Labs](https://github.com/sugarlabs)
- [Arch Wiki — Sugar](https://wiki.archlinux.org/title/Sugar)

## Ver también

- [[Comparativa entornos de escritorio]] — comparativa de todos los DEs
- [[GNOME]] — DE moderno por defecto
- [[XFCE]] — DE ligero generalista
- [[Videojuegos en Linux]] — otras aplicaciones educativas en Linux

#entorno-escritorio
