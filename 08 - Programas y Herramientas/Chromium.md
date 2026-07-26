---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: media
---

# Chromium

## Qué es

**Chromium** es el navegador open source que sirve como base para Google Chrome, Brave, Vivaldi, Edge y Opera. Usa el motor Blink (fork de WebKit) y el JS engine V8.

A diferencia de Google Chrome, Chromium no incluye telemetría de Google, ni DRM (Widevine), ni codecs propietarios (MP3, H.264) — aunque estos se pueden añadir por separado.

## Instalación

```bash
sudo apt install chromium               # Debian/Ubuntu
sudo pacman -S chromium                 # Arch

# Codecs adicionales (MP3, H.264)
sudo apt install chromium-codecs-ffmpeg-extra
```

## Gestión de perfiles

```bash
chromium --user-data-dir=~/.config/chromium-trabajo
ls ~/.config/chromium/Default/
```

## Ver también

- [[Brave]] — fork de Chromium con bloqueo de anuncios integrado
- [[Vivaldi]] — navegador Chromium muy personalizable
- [[Ungoogled Chromium]] — Chromium sin servicios de Google
- [[Firefox]] — alternativa Gecko
- [[Navegadores Web]] — índice comparativo

## Enlaces externos

- [Chromium](https://www.chromium.org/) — proyecto oficial

#programa #navegador
