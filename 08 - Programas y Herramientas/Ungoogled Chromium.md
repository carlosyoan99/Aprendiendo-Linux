---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: BSD-3-Clause
alternativas: [[Chromium]], [[Brave]], [[Firefox]]
---

# Ungoogled Chromium

> Chromium sin ningún servicio de Google: la opción más privada dentro de los navegadores basados en Chromium.

## Qué es

**Ungoogled Chromium** es Chromium con todos los servicios de Google eliminados a nivel de compilación: sin cuentas Google, sin sincronización en la nube, sin actualización automática a servicios de Google y sin telemetría. Es mantenido por la comunidad y ofrece una versión de Chromium "limpia" para quien prioriza la privacidad al máximo manteniendo el motor Blink.

## Instalación

```bash
# Flatpak (recomendado)
flatpak install flathub com.github.Eloston.UngoogledChromium

# Arch / AUR
yay -S ungoogled-chromium-bin

# AppImage / binarios: desde el release de GitHub
```

## Configuración básica

- Perfiles en `~/.config/ungoogled-chromium/` (o el del Flatpak).
- Al no tener cuentas Google, la sincronización se hace **manualmente** (exportar marcadores, etc.).
- Permite añadir extensiones de la **Chrome Web Store** de forma manual.

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `Ctrl+T` | Nueva pestaña |
| `Ctrl+Shift+N` | Ventana de incógnito |
| `Ctrl+H` | Historial |

## Uso avanzado

```bash
# perfil separado
ungoogled-chromium --user-data-dir=~/ungoogled-trabajo
```

## Comparativa con alternativas

| Aspecto | Ungoogled | Chromium | Brave |
|---|---|---|---|
| **Telemetría Google** | Ninguna | Mínima | Ninguna |
| **Sincronización** | Manual | Cuenta Google | Cuenta Brave |
| **Extensiones** | Chrome (manual) | Chrome | Chrome |
| **Actualizaciones** | Manual/Flatpak | Automáticas | Automáticas |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| No hay actualización automática | Se elimina el updater de Google | Actualizar a través de Flatpak o del paquete de la distro |
| DRM (Netflix) no funciona | Sin Widevine | Instalar Widevine por separado o usar otro navegador |

## Notas y advertencias

- Al no tener telemetría ni actualizador, **mantenerlo actualizado es responsabilidad del usuario** (usar Flatpak/ParkMuze facilita esto).
- Es la opción más privada del ecosistema Blink, pero requiere algo más de mantenimiento manual.

## Enlaces externos

- [Ungoogled Chromium — GitHub](https://github.com/ungoogled-software/ungoogled-chromium)
- [Arch Wiki — Chromium (política de privacidad)](https://wiki.archlinux.org/title/Chromium)
- [Ungoogled Chromium — página de Flatpak](https://flathub.org/apps/com.github.Eloston.UngoogledChromium)

## Ver también

- [[Chromium]] — base open source
- [[Brave]] — Chromium con privacidad intermedia
- [[Firefox]] — alternativa Gecko
- [[Navegadores Web]] — índice comparativo

#programa #navegador
