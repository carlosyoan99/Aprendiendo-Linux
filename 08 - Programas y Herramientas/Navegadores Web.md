---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: programa
prioridad: baja
---

# Navegadores Web

## Motores de renderizado

Todos los navegadores modernos usan uno de tres motores de renderizado. Esta decisión determina la compatibilidad con estándares web, el rendimiento y las extensiones disponibles:

| Motor | Creado por | Lenguaje | JS Engine | Navegadores |
|---|---|---|---|---|
| **Gecko** | Mozilla | C++ | SpiderMonkey | [[Firefox]], LibreWolf, Tor Browser, Waterfox |
| **Blink** | Google (fork de WebKit) | C++ | V8 | Chromium, Google Chrome, Brave, Edge, Vivaldi, Opera, Ungoogled Chromium |
| **WebKit** | Apple (fork de KHTML) | C++ | JavaScriptCore | Safari, GNOME Web (Epiphany), Konqueror (KDE, legacy) |

**Situación actual**: Blink/Chromium domina ~85% del mercado. Gecko es la única alternativa independiente que queda. WebKit está limitado casi exclusivamente a Safari/macOS/iOS.

## Navegadores en orden de popularidad Linux

| Navegador | Motor | Privacidad | RPM/DEB | Flatpak | AUR |
|---|---|---|---|---|---|
| **[[Firefox]]** | Gecko | ⭐⭐⭐⭐ | ✅ | ✅ | ✅ |
| **Chromium** | Blink | ⭐⭐⭐ | ✅ | ✅ | ✅ |
| **Brave** | Blink | ⭐⭐⭐⭐ | ✅ | ✅ | ✅ |
| **Google Chrome** | Blink | ⭐⭐ | ✅ | ❌ | ✅ |
| **LibreWolf** | Gecko | ⭐⭐⭐⭐⭐ | ❌ | ✅ | ✅ |
| **Vivaldi** | Blink | ⭐⭐⭐ | ✅ | ✅ | ✅ |
| **Ungoogled Chromium** | Blink | ⭐⭐⭐⭐⭐ | ❌ | ✅ | ✅ |
| **GNOME Web (Epiphany)** | WebKit | ⭐⭐⭐⭐ | ✅ | ✅ | ✅ |
| **Falkon** | Qt WebEngine | ⭐⭐⭐ | ✅ | ✅ | ✅ |
| **Tor Browser** | Gecko (hardened) | ⭐⭐⭐⭐⭐ | ❌ | ❌ | ✅ |

## Firefox (Gecko)

El navegador por defecto en la mayoría de distros. Ver nota dedicada: [[Firefox]]

## Navegadores basados en Chromium/Blink

```bash
# Chromium — el base open source (sin telemetría de Google)
sudo apt install chromium               # Debian/Ubuntu
sudo pacman -S chromium                 # Arch
# ⚠️ En algunas distros, Chromium viene sin codecs propietarios (MP3, H.264)
# Para añadirlos: sudo apt install chromium-codecs-ffmpeg-extra

# Brave — bloqueo de anuncios integrado
flatpak install flathub com.brave.Browser

# Google Chrome — versión propietaria con más integración Google
# Descargar .deb desde: https://www.google.com/chrome/

# Vivaldi — muy personalizable
flatpak install flathub com.vivaldi.Vivaldi

# Ungoogled Chromium — Chromium sin ningún servicio de Google
flatpak install flathub com.github.Eloston.UngoogledChromium
```

## LibreWolf (Gecko hardened)

Firefox preconfigurado con privacidad máxima:

```bash
flatpak install flathub io.gitlab.librewolf-community
# O descargar appimage desde: https://librewolf.net/
```

## GNOME Web / Epiphany (WebKit)

Navegador nativo de GNOME, usa WebKit (el motor de Safari). Ligero e integrado con el escritorio GNOME:

```bash
sudo apt install epiphany-browser        # Debian/Ubuntu
sudo pacman -S epiphany                  # Arch
```

## Navegador por defecto

```bash
# Ver navegador por defecto
xdg-settings get default-web-browser

# Cambiar
xdg-settings set default-web-browser brave-browser.desktop

# O desde la terminal con $BROWSER
export BROWSER=brave-browser
```

## Gestión de perfiles

```bash
# Firefox
firefox -P trabajo                       # lanzar con perfil específico
ls ~/.mozilla/firefox/                   # perfiles de Firefox

# Chromium / Brave
ls ~/.config/chromium/Default/
ls ~/.config/BraveSoftware/

# Perfiles separados para trabajo/personal
chromium --user-data-dir=~/.config/chromium-trabajo
```

## Ver también

- [[Firefox]] — nota dedicada al navegador por defecto
- [[Gestores de Paquetes]] — Flatpak, AUR y repos oficiales
- [[Utilidades Base del Sistema]] — xdg-utils, xdg-settings

## Enlaces externos

- [Wikipedia — Web browser](https://en.wikipedia.org/wiki/Web_browser)
- [Wikipedia — Comparison of web browsers](https://en.wikipedia.org/wiki/Comparison_of_web_browsers)
- [Wikipedia — Browser engine](https://en.wikipedia.org/wiki/Browser_engine)

#programa #navegador
