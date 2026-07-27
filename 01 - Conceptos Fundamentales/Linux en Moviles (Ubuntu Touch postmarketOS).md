---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: concepto
prioridad: baja
---

# Linux en Móviles (Ubuntu Touch, postmarketOS y alternativas)

## Definición

Existen varios proyectos que llevan Linux a dispositivos móviles (teléfonos y tabletas) como sistema operativo principal. A diferencia de [[Android (sistema basado en Linux)|Android]] (que usa el kernel Linux pero con un ecosistema propio), estos proyectos ofrecen experiencias más cercanas al Linux de escritorio, con entornos Plasma Mobile, GNOME adaptado o interfaces táctiles propias.

> Para una visión general de Linux en dispositivos empotrados e IoT, ver [[Linux embebido]].

---

## Ubuntu Touch (UBports)

**Ubuntu Touch** es un sistema operativo móvil basado en Linux, originalmente desarrollado por **Canonical** (presentado el 2 de enero de 2013) y actualmente mantenido por la comunidad **UBports** desde que Canonical abandonó el proyecto en 2017.

### Historia

| Año | Evento |
|---|---|
| **2013** | Canonical anuncia Ubuntu Touch. Primeros ports al Galaxy Nexus |
| **2015** | BQ lanza el Aquaris E4.5 Ubuntu Edition (primer teléfono con Ubuntu Touch, ~170€) |
| **2015** | Meizu lanza el MX4 Ubuntu Edition en China |
| **2017** | Canonical abandona el proyecto (recorta Unity 8 y Ubuntu Touch) |
| **2017-presente** | **UBports** toma el relevo y mantiene el desarrollo comunitario |

### Características

- **Unity 8 / Lomiri**: interfaz táctil basada en gestos (deslizar desde bordes para cambiar de app, acceder al lanzador, multitarea)
- **Convergencia**: al conectar a un monitor externo, ofrece una experiencia de escritorio completo (con dock, ventanas, etc.)
- **Apps nativas**: escritas en **QML** y **C++** (Qt5/Qt6), además de compatibilidad con apps Android via Anbox (limitado)
- **Scopes**: pantallas de inicio temáticas (cerca, música, fotos, redes sociales) — anterior al concepto de "feeds" de iOS/Android
- **libhybris**: permite usar drivers de Android (GPU, WiFi, cámara) sin modificaciones, facilitando el port a dispositivos Android existentes

### Dispositivos compatibles (UBports)

| Fabricante | Modelo | Estado |
|---|---|---|
| BQ | Aquaris E4.5, E5, M10 | ✅ Histórico |
| Meizu | MX4, Pro 5 | ✅ Histórico |
| Google | Pixel 3a, Pixel 3XL, Pixel 2, Nexus 5, Nexus 7 | ✅ Activo (ports comunitarios) |
| OnePlus | OnePlus 3/3T, OnePlus 5/5T, OnePlus 6/6T | ✅ Activo |
| Fairphone | Fairphone 2, Fairphone 3/3+ | ✅ Activo |
| Pine64 | PinePhone, PineTab | ✅ Activo |

```bash
# Instalar UBports en un dispositivo compatible
# Desde la web: https://devices.ubuntu-touch.io/
# O desde terminal (Linux):
sudo apt install ubports-installer
ubports-installer
```

> **Estado 2026**: UBports sigue activo con lanzamientos OTA regulares (actualmente OTA-25+). Lomiri (antes Unity 8) sigue como interfaz principal. Compatible con más de 60 dispositivos.

---

## postmarketOS

**postmarketOS** es un sistema operativo Linux para teléfonos inteligentes basado en **Alpine Linux**. Su objetivo principal es **extender la vida útil de los teléfonos a 10 años**, en contraste con los 2-3 años de soporte típicos de Android/iOS.

| Característica | Detalle |
|---|---|
| **Base** | Alpine Linux (musl + BusyBox) |
| **Primer lanzamiento** | 2017 (proyecto) |
| **Interfaces** | Plasma Mobile, SXMO, Phosh (GNOME), XFCE, MATE |
| **Gestor de paquetes** | `apk` (Alpine Package Keeper) |
| **Licencia** | GPL y código abierto |
| **Enfoque** | Privacidad, longevidad, libertad |

### Interfaces disponibles

| Interfaz | Descripción | Base |
|---|---|---|
| **Plasma Mobile** | Escritorio KDE adaptado a pantallas táctiles | KDE Plasma / Qt6 |
| **Phosh** | Interfaz GNOME para móviles (similar a PureOS) | GNOME / GTK4 |
| **SXMO** | Interfaz minimalista basada en scripts y gestos | Sway (Wayland) |
| **XFCE / MATE** | Escritorios clásicos adaptados | GTK |

```bash
# postmarketOS no se instala como un SO normal
# Se usa pmbootstrap para generar una imagen personalizada
git clone https://gitlab.com/postmarketOS/pmbootstrap
./pmbootstrap.py init
./pmbootstrap.py install
```

### Dispositivos compatibles

| Dispositivo | Interfaz recomendada | Estado |
|---|---|---|
| **PinePhone** (Pine64) | Plasma Mobile / Phosh | ✅ Excelente |
| **PinePhone Pro** (Pine64) | Plasma Mobile | ✅ Excelente |
| **Librem 5** (Purism) | Phosh | ✅ Bueno |
| **OnePlus 6/6T** | Plasma Mobile | ✅ Bueno |
| **Xiaomi POCO F1** | Phosh | ⚠️ Experimental |
| **Google Pixel 3a** | Plasma Mobile | ⚠️ Experimental |

---

## Sailfish OS

**Sailfish OS** es un sistema operativo móvil desarrollado por la empresa finlandesa **Jolla** (fundada por exempleados de Nokia). Combina un núcleo Linux con una interfaz táctil basada en gestos.

| Característica | Detalle |
|---|---|
| **Desarrollador** | Jolla (Finlandia) |
| **Primera versión** | 2013 |
| **UI** | Interfaz basada en gestos (Sailfish Silica) |
| **Licencia** | Código cerrado (UI) + Linux kernel (GPL) |
| **Compatibilidad Android** | ✅ Sí (capa Alien Dalvik) |
| **Dispositivos** | Jolla Phone, Sony Xperia 10 III/IV/V, tablet Jolla |

Históricamente, **Maemo** (Nokia N900) y **MeeGo** (Nokia N9) fueron los predecesores conceptuales de Sailfish OS. Nokia N9 con MeeGo es considerado por muchos como el mejor teléfono que Nokia nunca supo aprovechar.

### Proyecto Mer

**Mer** es la distribución GNU/Linux base sobre la que está construido Sailfish OS. Es un fork de **MeeGo** (la plataforma del Nokia N9) optimizado para dispositivos móviles, dirigido a fabricantes de hardware. Está basado en Qt5/Qt6, HTML5 y JavaScript, y se rige por un modelo de gobierno meritocrático.

| Característica | Detalle |
|---|---|
| **Origen** | Fork de MeeGo (2011-2012) |
| **Base** | GNU/Linux, Qt5/Qt6, HTML5 |
| **Gobierno** | Meritocracia (cualquier interesado puede participar) |
| **Uso principal** | Base para Sailfish OS (Jolla) |
| **Licencia** | Open source (varias licencias según componente) |

Mer es la capa intermedia entre el kernel Linux y la interfaz de usuario de Sailfish OS. Proporciona:
- Gestión de paquetes
- Middleware de hardware (cámara, sensores, telefonía)
- Librerías Qt específicas para dispositivos móviles
- Marco de aplicaciones multitouch

> El proyecto Mer es menos conocido que Sailfish OS porque es una base para fabricantes, no un producto final para consumidores.

---

## Otros sistemas operativos móviles basados en Linux

| Sistema | Base | Estado | Característica única |
|---|---|---|---|
| **KaiOS** | Linux (Gonk) + Gecko | ✅ Activo | Para feature phones (t9), apps HTML5, 150M+ usuarios |
| **Firefox OS** (B2G) | Linux + Gecko | ❌ Descontinuado (2016) | Apps en HTML5/JS, impulsado por Mozilla. Su fork **KaiOS** heredó el código |
| **webOS** (LG) | Linux | ⚠️ Legacy | Interfaz de tarjetas, usado en TVs LG |
| **Replicant** | Android (AOSP) libre | ⚠️ Mantenimiento | 100% libre (sin blobs), soporte legacy |
| **Plasma Mobile** | Linux (postmarketOS base) | ✅ Activo | KDE Plasma en el teléfono |

---

## Comparativa de sistemas móviles Linux

| Característica | Ubuntu Touch | postmarketOS | Sailfish OS | KaiOS | Android |
|---|---|---|---|---|---|
| **Base** | Ubuntu (Canonical) | Alpine Linux | Mer (openSUSE) | Linux (Gonki) | Linux (AOSP) |
| **Código abierto** | ✅ Mayormente | ✅ Completo | ❌ UI cerrada | ⚠️ Parcial | ✅ AOSP |
| **Apps nativas** | Qt/QML + HTML5 | Qt/GTK + Wayland | Qt + Silica | HTML5 + JS | Java/Kotlin |
| **Apps Android** | ⚠️ (Anbox, limitado) | ❌ No | ✅ (Alien Dalvik) | ❌ No | ✅ Nativo |
| **Google Services** | ❌ No | ❌ No | ❌ No (opcional) | ❌ No | ✅ Integrado |
| **Dispositivos** | ~60 ports | ~50 ports | ~10 oficiales | ~200+ | Miles |
| **Enfoque** | Convergencia móvil/PC | Longevidad (10 años) | Privacidad + Android | Feature phones baratos | Ecosistema masivo |

---

## Relación con Android

Todos estos sistemas comparten algo importante: usan **el kernel Linux como base**, pero difieren drásticamente de [[Android (sistema basado en Linux)|Android]] en:

- **Android** usa el kernel Linux pero con su propio framework (Java/Kotlin, ART, Binder)
- **Ubuntu Touch** usa la pila completa de Ubuntu + Unity/Lomiri
- **postmarketOS** es Alpine Linux puro con interfaz gráfica encima
- **Sailfish OS** usa Mer (fork de MeeGo) como middleware

> Android es técnicamente un sistema Linux, pero su ecosistema es tan distinto que se considera una plataforma separada. Los sistemas móviles Linux aquí listados ofrecen experiencias más cercanas al Linux de escritorio.

---

## Cómo instalar y probar

### Opción 1: Dispositivo dedicado (más fácil)

| Dispositivo | Precio aprox. | SO recomendado |
|---|---|---|
| **PinePhone** (Pine64) | ~200€ | postmarketOS / Ubuntu Touch |
| **PinePhone Pro** | ~400€ | postmarketOS / Ubuntu Touch |
| **Librem 5** (Purism) | ~1,200€ | PureOS / postmarketOS |

### Opción 2: Port en dispositivo Android existente

```bash
# Verificar compatibilidad en:
# https://devices.ubuntu-touch.io/   (Ubuntu Touch)
# https://wiki.postmarketos.org/wiki/Devices  (postmarketOS)

# La instalación requiere:
# 1. Desbloquear bootloader
# 2. Flashear recovery (TWRP o similar)
# 3. Flashear la imagen del SO
# 4. Opcional: instalar gapps (para Android)

# Alternativa: usar el instalador web
# Ubuntu Touch: https://ubuntu-touch.io/get-ubports/
# postmarketOS: usa pmbootstrap (CLI)
```

---

## Ver también

- [[Android (sistema basado en Linux)]] — Android como sistema Linux
- [[Linux embebido]] — Linux en sistemas integrados e IoT
- [[Alpine Linux]] — base de postmarketOS
- [[Debate Tanenbaum-Torvalds]] — el kernel Linux en distintos contextos

## Enlaces externos

- [UBports / Ubuntu Touch](https://ubuntu-touch.io/)
- [postmarketOS](https://postmarketos.org/)
- [Sailfish OS](https://sailfishos.org/)
- [KaiOS](https://www.kaiostech.com/)
- [Plasma Mobile](https://plasma-mobile.org/)
- [PinePhone (Pine64)](https://pine64.org/)

#concepto #movil #linux
