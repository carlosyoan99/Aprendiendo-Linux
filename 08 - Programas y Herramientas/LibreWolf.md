---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: MPL-2.0 (Firefox base)
alternativas: [[Firefox]], [[Ungoogled Chromium]], [[Brave]]
---

# LibreWolf

> Fork de Firefox preconfigurado para privacidad máxima, sin telemetría y con bloqueo integrado.

## Qué es

**LibreWolf** es un fork de Firefox preconfigurado con privacidad máxima. Incluye uBlock Origin, desactivación de telemetría de Mozilla, resistencia a fingerprinting y motor de búsqueda por defecto privado (DuckDuckGo/Searx). Su objetivo es hacer de Firefox una herramienta segura "out of the box", sin depender de una larga configuración manual.

## Instalación

```bash
# Debian/Ubuntu (repo oficial)
curl -fsSL https://deb.librewolf.net/install.sh | sh

# Arch / AUR
yay -S librewolf-bin

# Fedora (COPR)
sudo dnf copr enable bgstack15/aftermozilla
sudo dnf install librewolf

# Flatpak
flatpak install flathub io.gitlab.librewolf-community

# AppImage: desde https://librewolf.net/
```

## Configuración básica

- Perfil en `~/.librewolf/` (similar a `~/.mozilla/firefox/` de Firefox).
- `about:config` para ajustes avanzados (heredado de Firefox).
- Trae por defecto: resistFingerprinting, RFP, `firstPartyIsolate`, bloqueo de anuncios.

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `Ctrl+Shift+N` | Ventana privada |
| `Ctrl+Shift+P` | Ventana privada (Firefox) |
| `Ctrl+T` | Nueva pestaña |

## Uso avanzado

```bash
# Perfil separado para trabajo
librewolf --profile=~/librewolf-trabajo --no-remote

# Forzar modo kiosco/privado
librewolf --private-window
```

## Comparativa con alternativas

| Aspecto | LibreWolf | Firefox | Brave | Ungoogled Chromium |
|---|---|---|---|---|
| **Motor** | Gecko | Gecko | Blink | Blink |
| **Privacidad out-of-box** | Máxima | Media | Media | Alta |
| **Extensiones** | Firefox (con restricciones) | Todas | Chrome | Chrome |
| **Telemetría** | Sin | Con opciones | Sin | Sin |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| Sitio no carga correctamente | Resistencia a fingerprinting muy estricta | Desactivar `resistFingerprinting` o RFP para el sitio |
| No se actualiza el sandbox | Flatpak sin permisos de red | `flatpak override --user io.gitlab.librewolf-community --socket=system-bus` |
| Fallan algunos sitios de vídeo/DRM | Sin Widevine por privacidad | Instalar Widevine externamente o usar Firefox |

## Notas y advertencias

- Al priorizar privacidad, **algunos sitios detectan el bloqueo** y pueden romperse.
- La configuración por defecto es más restrictiva que Firefox estándar — requiere aceptar pequeñas fricciones.

## Enlaces externos

- [LibreWolf — sitio oficial](https://librewolf.net/)
- [Wikipedia — LibreWolf](https://en.wikipedia.org/wiki/LibreWolf)
- [Arch Wiki — LibreWolf](https://wiki.archlinux.org/title/LibreWolf)

## Ver también

- [[Firefox]] — base de LibreWolf
- [[Navegadores Web]] — índice comparativo

#programa #navegador
