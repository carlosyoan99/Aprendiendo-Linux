---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: Propietaria (freeware)
alternativas: [[Chromium]], [[Brave]], [[Firefox]]
---

# Vivaldi

> Navegador basado en Chromium/Blink, creado por el cofundador de Opera, conocido por su altísima personalización.

## Qué es

**Vivaldi** es un navegador basado en Chromium/Blink creado por el equipo original de Opera (Jon von Tetzchner). Destaca por su **alta personalización**: pestañas apilables, paneles laterales, gestos del ratón, división de pantalla (tiling), comandos rápidos y un salvapantallas de nueva pestaña muy configurable. Es propietario (freeware), pero gratis.

## Instalación

```bash
# Debian/Ubuntu (repo oficial)
wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/vivaldi.gpg
echo "deb [signed-by=/usr/share/keyrings/vivaldi.gpg] https://repo.vivaldi.com/archive/deb/ stable main" | sudo tee /etc/apt/sources.list.d/vivaldi.list
sudo apt update && sudo apt install vivaldi-stable

# Arch / AUR
yay -S vivaldi

# Flatpak
flatpak install flathub com.vivaldi.Vivaldi
```

## Configuración básica

- Ajustes muy completos en `vivaldi://settings`.
- **Comandos rápidos** (`F2` o `Ctrl+Space`): lanzar acciones, pestañas, marcadores.
- Pestañas apilables y con agrupación, paneles laterales configurables.

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `F2` | Comandos rápidos |
| `Ctrl+F2` | Notas |
| `Ctrl+Shift+L` | Dividir pantalla (tiling) |
| `Alt+→/←` | Navegar pestañas apiladas |

## Uso avanzado

```bash
# lanzar Vivaldi con un perfil separado
vivaldi --user-data-dir=~/vivaldi-trabajo
```

## Comparativa con alternativas

| Aspecto | Vivaldi | Brave | Firefox |
|---|---|---|---|
| **Personalización** | Muy alta | Media | Media-alta |
| **Motor** | Blink | Blink | Gecko |
| **Bloqueo integrado** | Manual | Integrado | uBlock opcional |
| **Licencia** | Propietaria | MPL-2.0 (opcional BAT) | MPL-2.0 |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| Consumo de RAM alto | Muchas características activas | Desactivar animaciones/paneles no usados |
| Sincronización limitada | Sin cuenta Vivaldi/Sync cifrado | Activar Vivaldi Sync desde ajustes |

## Notas y advertencias

- Incluye Sync de Vivaldi, que requiere cuenta (con cifrado de dispositivo a dispositivo).
- No es open source completo: la lógica propietaria se une a Chromium.

## Enlaces externos

- [Vivaldi — sitio oficial](https://vivaldi.com/)
- [Wikipedia — Vivaldi (web browser)](https://en.wikipedia.org/wiki/Vivaldi_(web_browser))
- [Arch Wiki — Vivaldi](https://wiki.archlinux.org/title/Vivaldi)

## Ver también

- [[Chromium]] — base open source de Vivaldi
- [[Brave]] — alternativa Chromium con bloqueo de anuncios
- [[Navegadores Web]] — índice comparativo

#programa #navegador
