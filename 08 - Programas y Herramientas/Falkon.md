---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL-3.0
alternativas: [[Chromium]], [[Firefox]]
---

# Falkon

> Navegador web ligero basado en Qt WebEngine (Blink), orientado al escritorio KDE/Qt.

## Qué es

**Falkon** (antes QupZilla) es un navegador web ligero basado en **Qt WebEngine** (Blink). Es el navegador por defecto en algunos entornos KDE/Qt y destaca por su **bajo consumo de recursos**, su integración con el escritorio KDE y su sencillez. Aunque usa el motor Blink, no incluye los servicios de Google de Chromium.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install falkon

# Arch
sudo pacman -S falkon

# Fedora
sudo dnf install falkon

# Flatpak
flatpak install flathub org.kde.falkon
```

## Configuración básica

- Perfiles y ajustes se guardan en `~/.config/falkon/`.
- Motor de búsqueda y página de inicio configurables desde Ajustes → Buscar.
- Soporta **AdBlock** integrado (reglas de EasyList) y gestor de marcadores.

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `Ctrl+T` | Nueva pestaña |
| `Ctrl+Shift+P` | Ventana privada |
| `Ctrl+L` | Ir a la barra de direcciones |
| `Ctrl+J` | Descargas |

## Uso avanzado

```bash
# Abrir con un perfil/usuario específico
falkon -profile=~/falkon-trabajo

# Abrir una URL directa
falkon https://example.com
```

## Comparativa con alternativas

| Aspecto | Falkon | Chromium | Konqueror |
|---|---|---|---|
| **Motor** | Blink (Qt WebEngine) | Blink | KHTML/WebKit |
| **Consumo** | Bajo | Medio | Muy bajo |
| **Integración KDE** | Alta | Ninguna | Muy alta |
| **Licencia** | GPL-3.0 | BSD | GPL |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| Reproducción de vídeo falla | Faltan codecs de Qt WebEngine | Instalar los codecs de ffmpeg de Qt (`qt5-webengine` con codecs) |
| No reproduce DRM (Netflix) | Sin Widevine | Considerar usar Firefox/Chromium para esos sitios |

## Notas y advertencias

- Al ser un navegador Qt, es especialmente cómodo en entornos KDE Plasma.
- Menos extensiones que Firefox/Chrome: su ecosistema es reducido.

## Enlaces externos

- [Falkon — sitio oficial](https://www.falkon.org/)
- [Wikipedia — Falkon](https://en.wikipedia.org/wiki/Falkon)
- [Arch Wiki — Falkon](https://wiki.archlinux.org/title/Falkon)

## Ver también

- [[Chromium]] — base del motor Blink
- [[Firefox]] — alternativa Gecko
- [[Navegadores Web]] — índice comparativo

#programa #navegador
