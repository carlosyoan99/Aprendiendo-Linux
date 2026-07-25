---
fecha_creacion: 2026-07-20
estado: resuelto
categoria: concepto
prioridad: baja
---

# Firefox OS

> Sistema operativo móvil de **Mozilla** basado en Linux, con aplicaciones escritas enteramente en **HTML5, CSS y JavaScript**. Desarrollado entre 2011 y 2015, enfocado en smartphones de gama baja. Su legado vive en **KaiOS**.

Nombre clave: **Boot to Gecko (B2G)**

## Historia

| Hito | Fecha |
|---|---|
| Inicio del proyecto Boot to Gecko | 2011 |
| Primer teléfono comercial (ZTE Open) | Julio 2013 |
| Expansión a Sudamérica y Europa | 2014 |
| Fin del desarrollo para móviles | Diciembre 2015 |
| Sucesor: KaiOS (fork comunitario) | 2017 |

## Arquitectura

Firefox OS se componía de tres capas:

```
+------------------------------------------+
|  GAIA  — Interfaz de usuario             |
|  (HTML5, CSS, JavaScript)                 |
+------------------------------------------+
|  GECKO — Entorno de ejecución             |
|  (Motor de renderizado, APIs, C++)         |
+------------------------------------------+
|  GONK  — Capa de sistema                  |
|  (Kernel Linux + HAL, heredado de Android) |
+------------------------------------------+
```

| Capa | Función |
|---|---|
| **Gonk** | Kernel Linux + capa de abstracción de hardware (HAL). Heredaba drivers y componentes de Android. |
| **Gecko** | Motor de renderizado de Mozilla. Ejecutaba HTML/CSS/JS, concedía permisos a las aplicaciones y se comunicaba con el hardware. |
| **Gaia** | Interfaz gráfica completa: pantalla de bloqueo, marcador, SMS, cámara, ajustes. Todo escrito en tecnologías web. |

## Características

- **Aplicaciones web nativas**: sin apps nativas tradicionales, todo se basaba en tecnologías web (HTML5, CSS, JS). Aplicaciones hospedadas o empaquetadas.
- **Búsqueda adaptativa**: integración con Everything.me para buscar desde la pantalla de inicio
- **Diseño adaptable**: interfaz Gaia funcionaba en cualquier resolución
- **Permisos**: tres niveles (planas, privilegiadas, certificadas) según el acceso al hardware
- **Firefox Marketplace**: tienda oficial de aplicaciones

## Dispositivos

- **ZTE Open** — primer terminal comercial (2013)
- **Geeksphone Peak** — segundo terminal
- **Alcatel One Touch Fire** — popular en Europa
- **Huawei Y300** — versión con Firefox OS

## Fin del proyecto

En diciembre de 2015, Mozilla anunció el fin del desarrollo para móviles, citando:
- Dificultades comerciales para competir con Android y iOS
- El sistema no logró ventas significativas
- Los costos excedieron los beneficios

El código fue adaptado para smart TVs y dispositivos IoT. La comunidad continuó el proyecto bajo el nombre **KaiOS**, que hoy funciona en millones de feature phones globalmente.

## Enlaces externos

- [Wikipedia — Firefox OS](https://es.wikipedia.org/wiki/Firefox_OS)
- [Boot to Gecko en GitHub](https://github.com/mozilla-b2g)

## Ver también

- [[Linux en Moviles (Ubuntu Touch postmarketOS)]] — otros SOs móviles Linux
- [[Android (sistema basado en Linux)]] — el dominador del mercado móvil

#concepto #movil #mozilla
