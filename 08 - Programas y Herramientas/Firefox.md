---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: media
---

# Firefox

## Qué es

**Firefox** es el navegador web del proyecto Mozilla, con motor propio **Gecko** (y su motor de JavaScript SpiderMonkey). Es el navegador que viene **preinstalado por defecto** en la gran mayoría de distros Linux (Ubuntu, Fedora, Debian, Linux Mint) y destaca por su compromiso con la privacidad y los estándares web.

A diferencia de los navegadores basados en Chromium, Firefox no depende del ecosistema Google/Blink, lo que lo convierte en la única alternativa real para mantener un web diverso.

## Instalación

```bash
# Ya viene instalado en la mayoría de distros
sudo apt install firefox                # Debian/Ubuntu (versión ESR en Debian)
sudo pacman -S firefox                  # Arch
sudo dnf install firefox                # Fedora

# Versión Flatpak (recomendada en distros inmutables)
flatpak install flathub org.mozilla.firefox

# Firefox Developer Edition (versión nightly para desarrolladores)
# Descargar desde: https://www.mozilla.org/firefox/developer/
tar -xjf firefox-*.tar.bz2 -C ~/.local/share/
# Luego lanzar con ~/.local/share/firefox/firefox
```

## Motor: Gecko

Firefox usa el motor de renderizado **Gecko** (junto con SpiderMonkey para JavaScript). Históricamente fue el motor dominante antes del auge de Chromium.

| Motor | Usado por | Lenguaje | JavaScript Engine |
|---|---|---|---|
| **Gecko** | Firefox, LibreWolf, Tor Browser | C++ | SpiderMonkey |
| **Blink** | Chromium, Brave, Edge, Vivaldi, Opera | C++ | V8 |
| **WebKit** | Safari, GNOME Web (Epiphany) | C++ | JavaScriptCore |

**Ventajas de Gecko**: 
- Independencia del ecosistema Google
- Soporte nativo de containers (Multi-Account Containers)
- Estándares web descentralizados (Pocket, reader view)
- Sin integración forzada de servicios cloud

## Hardening (about:config)

Escribe `about:config` en la barra de direcciones y acepta el riesgo. Estas preferencias mejoran la privacidad:

| Preferencia | Cambio | Efecto |
|---|---|---|
| `privacy.trackingprotection.fingerprinting.enabled` | `true` | Bloquea fingerprinting |
| `privacy.resistFingerprinting` | `true` | Ofusca huella digital del navegador |
| `media.peerconnection.enabled` | `false` | Bloquea WebRTC (filtración de IP real tras VPN) |
| `dom.security.https_only_mode` | `true` | Fuerza HTTPS en todos los sitios |
| `browser.uidensity` | `1` | Modo compacto (ahorra espacio vertical) |
| `network.dns.disablePrefetch` | `true` | Desactiva precarga DNS |
| `webgl.disabled` | `true` | Desactiva WebGL (reduce superficie de ataque) |
| `privacy.clearOnShutdown.history` | `true` | Limpiar historial al cerrar |
| `browser.sessionstore.max_tabs_undo` | `0` | No restaurar pestañas cerradas |
| `network.trr.mode` | `3` | DNS over HTTPS (DoH) obligatorio |
| `network.trr.uri` | `https://mozilla.cloudflare-dns.com/dns-query` | Servidor DoH |
| `security.OCSP.enabled` | `1` | Validación OCSP estricta |
| `geo.enabled` | `false` | Desactivar geolocalización |

### user.js — configuración portable

Un archivo `user.js` en tu perfil de Firefox se aplica automáticamente al iniciar. Puedes tener un `user.js` hardened para privacidad máxima:

```bash
# Ubicación del archivo user.js
ls ~/.mozilla/firefox/*.default-release/user.js

# Usar perfiles pre-hechos:
# arkenfox (https://github.com/arkenfox/user.js) — el más completo
# betterfox (https://github.com/yokoffing/Betterfox) — balance privacidad+usabilidad

# Instalar betterfox:
cd ~/.mozilla/firefox/*.default-release/
curl -sLO https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js
```

## Sincronización (Firefox Sync)

- Menú → Ajustes → Sync → Cuenta Mozilla
- Sincroniza: marcadores, historial, contraseñas, pestañas abiertas, addons, config
- **Cifrado extremo a extremo**: Mozilla no puede ver tus contraseñas ni marcadores

```bash
# Ver perfil de Firefox (útil para backups)
firefox -P                        # gestor de perfiles
firefox --ProfileManager          # alternativa
```

## Extensiones recomendadas

| Extensión | Propósito |
|---|---|
| **uBlock Origin** | Bloqueador de anuncios y rastreadores (el mejor) |
| **Multi-Account Containers** | Aislar sesiones (trabajo, personal, banco) |
| **Bitwarden** | Gestor de contraseñas |
| **Dark Reader** | Modo oscuro en todos los sitios |
| **NoScript** | Controlar JavaScript por sitio (máxima seguridad) |
| **Vimium** | Navegación por teclado al estilo Vim |

## Firefox ESR (Extended Support Release)

Usada en Debian estable y Ubuntu LTS, recibe solo parches de seguridad durante ~1 año:

```bash
sudo apt install firefox-esr             # Debian
# ESR vs Stable:
# - ESR: actualizaciones de seguridad cada ~4 semanas
# - Stable: nuevas features cada 4 semanas
# - Nightly: builds diarios para desarrollo
```

## Firefox en Wayland

```bash
# Firefox corre nativamente en Wayland desde la versión 121+
# Forzar Wayland (si no se detecta automáticamente):
export MOZ_ENABLE_WAYLAND=1
firefox

# Para hacerlo permanente, añadir a ~/.profile o /etc/environment
# echo \"export MOZ_ENABLE_WAYLAND=1\" >> ~/.profile
```

## Ver también

- [[Navegadores Web]] — comparativa general con motores y alternativas
- [[Personalización en Linux]] — temas para Firefox (Firefox Color, temas de opendesktop)
- [[Gestores de Paquetes]] — Flatpak, AUR, repos oficiales

## Enlaces externos

- [Wikipedia — Firefox](https://en.wikipedia.org/wiki/Firefox)
- [Sitio oficial — Firefox](https://www.mozilla.org/firefox/)
- [Mozilla — GitHub](https://github.com/mozilla)

#programa #navegador
