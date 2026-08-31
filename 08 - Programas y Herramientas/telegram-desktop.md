---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: media
---

# Telegram Desktop

> Cliente de escritorio de Telegram. En mi sistema se abre con el atajo `Mod+Shift+T` en niri.

## Qué es

**Telegram Desktop** es el cliente oficial de escritorio para Telegram, la plataforma de mensajería con enfoque en velocidad y seguridad. Ofrece chats, grupos, canales, llamadas de audio/vídeo, y soporte para múltiples cuentas. Es de código abierto (GPLv3) y multiplataforma.

**Ventajas clave:**
- Mensajería rápida y segura (protocolo MTProto)
- Chats secretos con cifrado E2E y autodestrucción
- Canales y grupos grandes (hasta 200k miembros)
- Soporte de archivos grandes (hasta 2GB por archivo)
- Múltiples cuentas en una sola instancia
- Stickers, GIFs, encuestas, bots

## Instalación

```bash
# Debian/Ubuntu
sudo apt install telegram-desktop

# Arch / CachyOS
sudo pacman -S telegram-desktop

# Fedora
sudo dnf install telegram-desktop

# Flatpak
flatpak install flathub org.telegram.desktop

# Snap
snap install telegram-desktop
```

## Uso

```bash
telegram-desktop        # binario instalado como "Telegram"
```

> En niri: `spawn "Telegram"` — el binario se llama `Telegram` en Arch.

## Funcionalidad

| Acción | Descripción |
|---|---|
| Mensajería | Chats, grupos, canales, secret chats |
| Llamadas | Audio y vídeo (P2P y servidores) |
| Múltiples cuentas | Soporta varias sesiones (configuración → agregar cuenta) |
| Notificación | Se integra con el sistema de notificaciones de Noctalia |
| Archivos | Enviar/recibir archivos hasta 2GB |
| Bots | Interactuar con bots de terceros |
| Temas | Temas personalizados y animados |

## Atajos de teclado

| Atajo | Acción |
|---|---|
| `Ctrl+K` | Buscar chat/contacto |
| `Ctrl+F` | Buscar en chat actual |
| `Ctrl+N` | Nuevo chat |
| `Ctrl+Shift+N` | Nuevo grupo |
| `Esc` | Cerrar panel/búsqueda |
| `Ctrl+Q` | Salir |
| `Ctrl+E` | Editar mensaje |
| `Ctrl+L` | Compartir/adjuntar archivo |

## Uso avanzado

```bash
# Abrir un enlace específico de Telegram
telegram-desktop --startintray    # minimizar a bandeja del sistema

# Modo headless (sin GUI, para bots)
# No aplica — Telegram Desktop es puramente GUI
```

### Múltiples cuentas

1. Ir a ☰ → Settings → Agregar cuenta
2. Introducir número de teléfono y verificar con código
3. Cambiar entre cuentas desde el menú lateral

### Temas personalizados

Ir a Settings → Chat Settings → Theme → Browse Themes para temas de la comunidad, o crear el propio editando archivos `.attheme`.

## Comparativa con alternativas

| Aspecto | Telegram Desktop | WhatsApp Desktop | Signal Desktop | Element (Matrix) |
|---|---|---|---|---|
| **Cifrado E2E** | Solo chats secretos | ✅ Todo | ✅ Todo | Depende del homeserver |
| **Código abierto** | ✅ GPLv3 | ❌ | ✅ | ✅ |
| **Múltiples cuentas** | ✅ | ❌ | ❌ | ✅ |
| **Archivos grandes** | 2GB | 2GB | 100MB | Depende |
| **Grupos grandes** | 200k | 1024 | 1000 | Sin límite |
| **Llamadas** | ✅ | ✅ | ✅ | ✅ (Jitsi) |
| **Bots** | ✅ | ❌ | ❌ | ✅ |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No llegan notificaciones | Daemon de notificaciones no activo | Verificar `dunst`/`swaync` o `systemctl --user status notificaciones` |
| Llamadas sin audio | PulseAudio/PipeWire no configurado | `pavucontrol` → verificar dispositivos de entrada/salida |
| Sync lento entre dispositivos | Conexión lenta o cache local | Caché en `~/.local/share/TelegramDesktop/tdata/` — no borrar |
| Tema no se aplica | Versión antigua del cliente | Actualizar: `sudo pacman -Syu telegram-desktop` |

## Notas personales

- En mi sistema se abre con `Mod+Shift+T` en niri.
- Las notificaciones se integran con el sistema de Noctalia.
- Si no usa chats secretos, los mensajes no están cifrados E2E por defecto.

## Enlaces externos

- [Telegram](https://telegram.org/)
- [GitHub — Telegram Desktop](https://github.com/telegramdesktop/tdesktop)
- [Arch Wiki — Telegram](https://wiki.archlinux.org/title/Telegram)
- [Wikipedia — Telegram](https://en.wikipedia.org/wiki/Telegram_(software))

## Ver también

- [[Niri]] — atajo `Mod+Shift+T`
- [[Desktop Shells (Noctalia Caelestia)]] — notificaciones del sistema

#programa #mensajeria #telegram
