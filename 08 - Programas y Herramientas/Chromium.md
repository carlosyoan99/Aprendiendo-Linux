---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: media
licencia: BSD-3-Clause
alternativas: [[Brave]], [[Vivaldi]], [[Ungoogled Chromium]]
---

# Chromium

> El navegador open source que sirve de base a Google Chrome, Brave, Vivaldi, Edge y Opera.

## Qué es

**Chromium** es el navegador open source que sirve como base para Google Chrome, Brave, Vivaldi, Edge y Opera. Usa el motor **Blink** (fork de WebKit) y el JS engine **V8**.

A diferencia de Google Chrome, Chromium no incluye telemetría de Google, ni DRM (Widevine), ni codecs propietarios (MP3, H.264) — aunque estos se pueden añadir por separado.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install chromium

# Arch
sudo pacman -S chromium

# Fedora
sudo dnf install chromium

# Flatpak
flatpak install flathub org.chromium.Chromium

# Codecs adicionales (MP3, H.264)
sudo apt install chromium-codecs-ffmpeg-extra
```

## Configuración básica

- Ajustes en `chrome://settings` y flags experimentales en `chrome://flags`.
- Extensiones desde la **Chrome Web Store** (manual en distros sin sandbox configurado).

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `Ctrl+T` | Nueva pestaña |
| `Ctrl+Shift+N` | Ventana de incógnito |
| `Ctrl+H` | Historial |
| `F12` | Herramientas de desarrollador |

## Gestión de perfiles

```bash
chromium --user-data-dir=~/.config/chromium-trabajo
ls ~/.config/chromium/Default/
```

## Comparativa con alternativas

| Aspecto | Chromium | Chrome | Brave |
|---|---|---|---|
| **Telemetría** | Mínima | Alta | Sin |
| **DRM (Widevine)** | No (manual) | Sí | Sí |
| **Codecs propietarios** | No | Sí | Sí |
| **Licencia** | BSD-3 | Propietaria | MPL-2.0 |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| Sin MP3/H.264 | Codecs propietarios no incluidos | `chromium-codecs-ffmpeg-extra` |
| Netflix/Spotify no funcionan | Sin Widevine | Añadir Widevine o usar Chrome/Firefox |
| `Running as root without --no-sandbox` | Sandbox sin permisos | Configurar sandbox (usermod de chrome-sandbox) |

## Notas y advertencias

- En Debian/Ubuntu se distingue de Chrome por la **falta de codecs y DRM** por defecto.
- Para compatibilidad total con streaming, Chrome o Firefox son más simples.

## Enlaces externos

- [Chromium — proyecto oficial](https://www.chromium.org/)
- [Wikipedia — Chromium (web browser)](https://en.wikipedia.org/wiki/Chromium_(web_browser))
- [Arch Wiki — Chromium](https://wiki.archlinux.org/title/Chromium)

## Ver también

- [[Brave]] — fork de Chromium con bloqueo de anuncios integrado
- [[Vivaldi]] — navegador Chromium muy personalizable
- [[Ungoogled Chromium]] — Chromium sin servicios de Google
- [[Firefox]] — alternativa Gecko
- [[Navegadores Web]] — índice comparativo

#programa #navegador
