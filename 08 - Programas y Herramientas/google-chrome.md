---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-31
estado: resuelto
categoria: programa
prioridad: media
---

# Google Chrome

> Navegador web de Google. En mi sistema es el navegador principal (junto a Firefox), lanzado con aceleración de vídeo VAAPI.

## Qué es

- Navegador web de Google basado en el proyecto open source **Chromium**, del que se diferencia por incorporar codecs propietarios (H.264, AAC, Widevine) y componentes cerrados de sincronización/actualización.
- Muy popular por su rendimiento, ecosistema de extensiones y sincronización con la cuenta de Google entre dispositivos.
- En Linux se distribuye como **paquete `.deb`/`.rpm`** oficial y, en Arch, vía AUR; no hay build oficial de la comunidad como en otros navegadores.

## Instalación

```bash
yay -S google-chrome       # AUR / CachyOS repos
# Debian/Ubuntu: .deb oficial desde google.com/chrome
# Fedora: .rpm oficial desde google.com/chrome (o rpm fusion)
```

## Sintaxis

```bash
google-chrome-stable                # lanzar navegador
google-chrome-stable --new-window <url>
google-chrome-stable --incognito
google-chrome-stable --profile-directory="Person 2"
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
- Perfiles múltiples: crear con "Añadir persona" o `--profile-directory`.

## Chrome vs Chromium vs Firefox

| Aspecto | Chrome | Chromium | Firefox |
|---|---|---|---|
| Origen | Google (cerrado) | Open source | Mozilla (open) |
| Codecs propios (H.264/AAC) | Sí | No | Sí |
| Sincronización Google | Nativa | Limitada | Cuenta Mozilla |
| Extensiones | Chrome Web Store | Store + laterales | addons.mozilla.org |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Video sin aceleración en Intel | Falta flag VAAPI o driver | Usar `--enable-features=VaapiVideoDecoder` |
| No inicia (sandbox) en Wayland | Falta soporte | Probar `--ozone-platform=wayland` |
| Mucho uso de RAM | Perfil con muchas pestañas/extensiones | Cerrar pestañas o usar modo proceso por WebUI |

## Ver también

- [[Chromium]] — base open source
- [[Firefox]] — alternativa
- [[CachyOS]] — distro donde está instalado (iGPU Haswell + VAAPI)

## Enlaces externos

- [Google Chrome](https://www.google.com/chrome/)

#programa #navegador #google