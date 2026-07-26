---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: baja
---

# Navegadores Web

## Motores de renderizado

Todos los navegadores modernos usan uno de tres motores:

| Motor | Creado por | JS Engine | Navegadores |
|---|---|---|---|
| **Gecko** | Mozilla | SpiderMonkey | [[Firefox]], [[LibreWolf]], Tor Browser |
| **Blink** | Google (fork de WebKit) | V8 | [[Chromium]], Brave, [[Vivaldi]], [[Ungoogled Chromium]], Google Chrome, [[Falkon]] |
| **WebKit** | Apple | JavaScriptCore | Safari, [[GNOME Web (Epiphany)]] |

## Notas individuales

- [[Firefox]] — navegador Gecko por defecto (nota dedicada)
- [[Chromium]] — base open source de los navegadores Blink
- [[Brave]] — Chromium con bloqueo de anuncios integrado
- [[LibreWolf]] — Firefox hardened para privacidad máxima
- [[Vivaldi]] — Chromium altamente personalizable
- [[Ungoogled Chromium]] — Chromium sin servicios de Google
- [[GNOME Web (Epiphany)]] — navegador WebKit nativo de GNOME
- [[Falkon]] — navegador Qt WebEngine ligero

## Navegador por defecto

```bash
xdg-settings get default-web-browser
xdg-settings set default-web-browser brave-browser.desktop
export BROWSER=brave-browser
```

## Gestión de perfiles

```bash
firefox -P trabajo
chromium --user-data-dir=~/.config/chromium-trabajo
```

## Ver también

- [[Gestores de Paquetes]] — Flatpak, AUR y repos oficiales
- [[Utilidades Base del Sistema]] — xdg-utils, xdg-settings

## Enlaces externos

- [Wikipedia — Web browser](https://en.wikipedia.org/wiki/Web_browser)
- [Wikipedia — Comparison of web browsers](https://en.wikipedia.org/wiki/Comparison_of_web_browsers)
- [Wikipedia — Browser engine](https://en.wikipedia.org/wiki/Browser_engine)

#programa #navegador
