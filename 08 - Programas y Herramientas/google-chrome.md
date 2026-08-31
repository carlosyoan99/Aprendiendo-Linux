---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: media
---

# Google Chrome

> Navegador web de Google. En mi sistema es el navegador principal (junto a Firefox), lanzado con aceleración de vídeo VAAPI.

## Instalación

```bash
yay -S google-chrome      # AUR / CachyOS repos
```

## Sintaxis

```bash
google-chrome-stable                # lanzar navegador
google-chrome-stable --new-window <url>
```

## Aceleración VAAPI (usado en mi setup)

Para aceleración de vídeo por hardware (útil con la iGPU Intel Haswell):

```bash
google-chrome-stable --enable-features=VaapiVideoDecoder
```

En niri el atajo de lanzamiento es `Mod+B` y usa este flag:

```bash
spawn-sh "google-chrome-stable --enable-features=VaapiVideoDecoder"
```

## Perfiles y sincronización

- Perfil por defecto en `~/.config/google-chrome/`.
- Sincronización de marcadores/extensiones con cuenta de Google.

## Ver también

- [[Chromium]] — base open source
- [[Firefox]] — alternativa
- [[CachyOS]] — distro donde está instalado (iGPU Haswell + VAAPI)

## Enlaces externos

- [Google Chrome](https://www.google.com/chrome/)

#programa #navegador #google