---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL-3.0
alternativas: [[Firefox]], [[Chromium]]
---

# GNOME Web (Epiphany)

> El navegador web nativo de GNOME, basado en WebKit, ligero e integrado con el escritorio.

## Qué es

**GNOME Web** (también conocido como Epiphany) es el navegador nativo de GNOME. Usa el motor **WebKit** (el mismo de Safari). Es ligero, está integrado con el escritorio GNOME y consume menos recursos que Chromium o Firefox. Está pensado para usuarios que priorizan simplicidad e integración con el ecosistema GTK/GNOME.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install epiphany-browser

# Arch
sudo pacman -S epiphany

# Fedora
sudo dnf install epiphany

# Flatpak
flatpak install flathub org.gnome.Epiphany
```

## Configuración básica

- Integra **videollamadas** y reproducción HTML5 vía los paquetes `gst-*` de GNOME.
- Soporta extensiones (modestas) y sincronización con Firefox Sync.
- Política de ventanas emergentes y bloqueo de rastreadores activables por defecto.

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `Ctrl+T` | Nueva pestaña |
| `Ctrl+Shift+P` | Ventana privada |
| `Ctrl+L` | Barra de direcciones/búsqueda |

## Uso avanzado

```bash
# Abrir una URL directamente
epiphany https://example.com

# Abrir en ventana de aplicación (PWA-like)
epiphany --application-mode=https://example.com
```

## Comparativa con alternativas

| Aspecto | GNOME Web | Firefox | Chromium |
|---|---|---|---|
| **Motor** | WebKit | Gecko | Blink |
| **Consumo** | Bajo | Medio | Alto |
| **Integración GNOME** | Alta | Media | Baja |
| **Extensiones** | Reducidas | Muchas | Muchas |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| No reproduce vídeo HTML5 | Faltan paquetes GStreamer | Instalar `gstreamer1.0-plugins-*` |
| Algunos sitios WebKit modernos fallan | Compatibilidad de WebKit | Usar Firefox/Chromium para esos sitios |

## Notas y advertencias

- Su ecosistema de extensiones es reducido en comparación con Firefox/Chrome.
- Excelente para equipos con pocos recursos o para un navegador "de respaldo" ligero.

## Enlaces externos

- [GNOME Web — documentación oficial](https://wiki.gnome.org/Apps/Web)
- [Wikipedia — GNOME Web](https://en.wikipedia.org/wiki/GNOME_Web)
- [Arch Wiki — Epiphany](https://wiki.archlinux.org/title/Epiphany)

## Ver también

- [[Firefox]] — navegador Gecko por defecto
- [[Chromium]] — navegador Blink
- [[Navegadores Web]] — índice comparativo

#programa #navegador
