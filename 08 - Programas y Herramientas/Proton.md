---
fecha_creacion: 2026-08-31
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: programa
prioridad: media
licencia: BSD
---

# Proton

> Capa de compatibilidad de **Valve** basada en **Wine**, integrada en Steam, que permite ejecutar juegos de Windows en Linux (y en la Steam Deck) con un clic. Es el motor del éxito de los juegos en Linux: **~90% de los juegos de Windows** corren vía Proton.

## Qué es

**Proton** es una distribución modificada de Wine que Valve mantiene y empaqueta para Steam. Añade a Wine capas específicas de juegos:

- **DXVK** — traduce Direct3D 11/10/9 a Vulkan (API gráfica moderna).
- **vkd3d-proton** — traduce Direct3D 12 a Vulkan.
- **WineD3D / DXVK** retrocompatibles.
- Soporte de la API de Steam, **Denuvo/DRM**, antivirus de EAC/BattlEye y parches por juego específico.

Se activa por **compatibilidad de juego** en Steam: activar Proton para un título y funciona con un clic, sin configurar nada (a diferencia de Wine/Lutris).

## Instalación y activación

Proton **no se instala por separado** — viene dentro de Steam:

```bash
# 1. Instalar Steam
sudo pacman -S steam                      # Arch / CachyOS
sudo apt install steam                    # Debian / Ubuntu
sudo dnf install steam                    # Fedora / RHEL

# 2. En Steam: Ajustes → Compatibilidad → activar "Proton experimental" o una versión estable
# 3. En la biblioteca: clic derecho en un juego → Compatibilidad → "Forzar compatibilidad con..."
```

Para forzar una versión concreta de Proton en línea de comandos:

```bash
# Ver versiones instaladas
ls ~/.steam/root/compatibilitytools.d/

# Forzar proton Experimental para un juego
STEAM_COMPAT_DATA_PATH=~/.steam/root/steamapps/compatdata/<APPID> \
  proton run /path/to/game.exe
```

## Estado de compatibilidad

El portal comunitario que consulta si un juego corre es **ProtonDB**:

```bash
# Ejemplos (https://www.protondb.com/)
- "Platinum"   → corre sin ajustes OOB
- "Gold"       → corre con un parche menor
- "Silver/Native" → Corre con Wine/Proton en vez de nativo
```

**~90%** de los juegos de Steam funcionan con Proton (ProtonDB: ~80% impactan Platinum/Gold). Los anti-cheat (EAC/BattlEye/FACEIT) son el límite principal: requieren soporte del desarrollador.

## Configuración avanzada

- **Proton Experimental** — última versión con fixes recientes (recomendado para juegos nuevos).
- **Proton 9.0** — versión estable general.
- **Proton Hotfix** — correcciones urgentes entre versiones.
- **Proton GE (GloriousEggroll)** — versión comunitaria con parches adicionales (install manual desde GitHub).
- **DXVK_ASYNC** — parche para reducir stuttering en juegos con mucho shader compilation.

```bash
# Instalar Proton GE manualmente
mkdir -p ~/.steam/root/compatibilitytools.d/
tar -xf Proton-GE.tar.gz -C ~/.steam/root/compatibilitytools.d/
# Reiniciar Steam para que lo detecte
```

## Proton vs Wine

| Aspecto | Proton | Wine |
|---|---|---|
| Origen | Valve/Steam | Comunidad WineHQ |
| Instalación | Automática (Steam) | Manual |
| API redes | Steam API | Sin la API de Steam |
| DXVK/vkd3d | Integrados | Hay que añadir |
| DRM/anti-cheat | Soportado (con versiones) | Limitado |
| Ideal | Juegos de Steam | Toda app de Windows |

El punto clave: **Proton** = Wine + DXVK + Steam/DRM + parches de juegos, y además con sofisticado auto-configurado por juego.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Juego no arranca | Proton incompatible | Probar Proton Experimental o GE |
| Stuttering inicial | Shader compilation | Dejar que el juego compile shaders (esperar o usar DXVK_ASYNC) |
| Negro en pantalla | Driver GPU obsoleto | Actualizar driver (Mesa o NVIDIA proprietary) |
| Anti-cheat bloquea | EAC/BattlEye sin soporte Linux | Verificar en ProtonDB si el juego tiene soporte |
| Audio no funciona | PipeWire/PulseAudio | Verificar `PULSE_SERVER` o usar `protontricks` |

## Ver también

- [[Wine]] — la base de Proton (el motor real)
- [[Videojuegos en Linux]] — panorama de gaming en Linux (DXVK, Lutris, Steam Deck)
- [[CachyOS]] — distro de esta máquina, usada para jugar vía Steam+Proton

## Enlaces externos

- [Proton — Valve/GitHub de steam community](https://github.com/ValveSoftware/Proton)
- [ProtonDB — base de datos de compatibilidad](https://www.protondb.com/)
- [Proton — Wikipedia](https://en.wikipedia.org/wiki/Proton_(software))
#programa #gaming #steam #wine
