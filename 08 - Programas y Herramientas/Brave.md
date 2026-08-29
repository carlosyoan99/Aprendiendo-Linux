---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: media
licencia: MPL-2.0
alternativas: [[Chromium]], [[Firefox]], [[Vivaldi]], [[Ungoogled Chromium]]
---

# Brave

> Navegador basado en Chromium/Blink con bloqueo de anuncios y rastreadores integrado, además de un modelo de recompensas (BAT).

## Qué es

**Brave** es un navegador basado en Chromium/Blink con bloqueo de anuncios y rastreadores integrado (motor Shields). Incluye recompensas **BAT** (Basic Attention Token), un firewall y VPN integrados (de pago), y la búsqueda privada Brave Search. Conocido por su enfoque en **privacidad sin sacrificar compatibilidad** con extensiones de Chrome.

## Instalación

```bash
# Debian/Ubuntu (repo oficial)
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update && sudo apt install brave-browser

# Arch / AUR
yay -S brave-bin

# Fedora
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/
sudo dnf install brave-browser

# Flatpak
flatpak install flathub com.brave.Browser
```

## Configuración básica

- **Shields** (escudo): bloqueo de anuncios/rastreadores por sitio, activable desde la barra.
- **Brave Rewards**: programa de recompensas BAT (opcional).
- Configuración en `brave://settings`.

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `Ctrl+Shift+N` | Ventana de incógnito |
| `Ctrl+Shift+U` | Activar/desactivar Shields |
| `Ctrl+T` | Nueva pestaña |
| `Alt+Shift+N` | Nueva ventana privada (Tor) |

## Gestión de perfiles

```bash
ls ~/.config/BraveSoftware/
brave --user-data-dir=~/.config/brave-trabajo
```

## Uso avanzado

- **Ventana privada con Tor**: integra Tor Browser para navegación anónima por sitio (`Alt+Shift+N`).
- Sincronización cifrada entre dispositivos sin cuenta (solo código QR).

## Comparativa con alternativas

| Aspecto | Brave | Firefox | Vivaldi |
|---|---|---|---|
| **Motor** | Blink | Gecko | Blink |
| **Bloqueo integrado** | Sí (Shields) | No (uBlock) | Manual |
| **Extra monetario** | BAT / VPN | Ninguno | Ninguno |
| **Compatibilidad Chrome** | Alta | Media | Alta |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| Sitio se rompe por bloqueo | Shields muy agresivo | Bajar Shields a "Standard" o desactivarlo para el sitio |
| Netflix no reproduce | Widevine | Debe estar habilitado; reinstalar o usar Firefox |

## Notas y advertencias

- El programa de anuncios/BAT de Brave es **opt-in**; se puede desactivar por completo.
- Al compartir base Chromium, consume más RAM que navegadores ligeros.

## Enlaces externos

- [Brave — sitio oficial](https://brave.com/)
- [Wikipedia — Brave (web browser)](https://en.wikipedia.org/wiki/Brave_(web_browser))
- [Arch Wiki — Brave](https://wiki.archlinux.org/title/Brave)

## Ver también

- [[Chromium]] — base open source de Brave
- [[Vivaldi]] — alternativa Chromium muy personalizable
- [[Ungoogled Chromium]] — Chromium sin telemetría
- [[Firefox]] — alternativa Gecko
- [[Navegadores Web]] — índice comparativo

#programa #navegador
