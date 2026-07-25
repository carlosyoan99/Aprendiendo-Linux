---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: baja
---

# bandwhich

> Monitor de ancho de banda en terminal. Muestra qué procesos, conexiones y direcciones IP están consumiendo más tráfico de red en tiempo real.

## Qué es

**bandwhich** (antes llamado `sniffer`) es una herramienta TUI que muestra el uso de ancho de banda desglosado por proceso, conexión y dirección IP remota. A diferencia de `nethogs` (que solo muestra por proceso), bandwhich también muestra por conexión individual y por IP.

Escrito en Rust. Necesita permisos root para capturar paquetes.

## Instalación

```bash
# Debian/Ubuntu (disponible en repos recientes)
sudo apt install bandwhich

# Arch
sudo pacman -S bandwhich

# Fedora
sudo dnf install bandwhich

# Desde GitHub (binario estático)
# https://github.com/imsnif/bandwhich/releases

# Con cargo (Rust)
cargo install bandwhich
```

## Uso básico

```bash
# Necesita sudo para capturar paquetes
sudo bandwhich                         # monitorear interfaz por defecto
sudo bandwhich -i eth0                 # interfaz específica
sudo bandwhich -i wlan0                # WiFi
bandwhich --version                    # verificar instalación
```

## Atajos esenciales

| Tecla | Acción |
|---|---|
| `q` | Salir |
| `Tab` | Cambiar entre vistas (por proceso / por conexión / por IP) |
| `Flechas` | Navegar lista |
| `Esc` | Cerrar panel de detalles |

## Interpretación de la salida

```
bandwhich — monitoring eth0 (192.168.1.10)
↑ 245 KB/s  ↓ 1.2 MB/s

Procesos:
  firefox                  ↑ 120 KB/s  ↓ 800 KB/s
  chromium                 ↑ 80 KB/s   ↓ 250 KB/s
  apt                      ↑ 0 B/s     ↓ 120 KB/s

Conexiones (por proceso):
  firefox → 142.250.80.46:443      ↑ 50 KB/s   ↓ 400 KB/s
  firefox → 157.240.1.35:443       ↑ 30 KB/s   ↓ 200 KB/s
  chromium → 216.58.214.14:443     ↑ 40 KB/s   ↓ 150 KB/s
```

## Casos de uso

```bash
# Ver qué aplicación está consumiendo más ancho de banda
sudo bandwhich

# Monitorear una interfaz específica
sudo bandwhich -i wlan0

# Guardar raw data para análisis (combinar con tee + jq no soportado)
# bandwhich no tiene salida JSON, usar en TUI directamente

# Identificar picos de tráfico
# 1. Abrir bandwhich
# 2. Realizar la acción problemática
# 3. Identificar el proceso/IP culpable
```

## Comparativa

| Herramienta | Por proceso | Por conexión | Por IP | Interfaz |
|---|---|---|---|---|
| **bandwhich** | ✅ | ✅ | ✅ | TUI interactiva |
| **nethogs** | ✅ | ❌ | ❌ | TUI simple |
| **bmon** | ❌ | ❌ | ❌ | TUI por interfaz |
| **iftop** | ❌ | ✅ | ✅ | TUI por conexión |
| **nload** | ❌ | ❌ | ❌ | TUI por interfaz |

> bandwhich es la herramienta más completa para identificar **qué proceso** está consumiendo ancho de banda. Para ver tráfico por conexión sin filtrar por proceso, [[iftop]] es más ligero.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `permission denied` | Necesita root para capturar paquetes | Ejecutar con `sudo bandwhich` |
| No veo tráfico | Interfaz incorrecta | Especificar con `-i eth0` o `-i wlan0` |
| Muestra 0 B/s | No hay tráfico activo en ese momento | Abrir un navegador o hacer ping |
| No funciona en WSL | WSL no soporta raw sockets | Usar en Linux nativo |

## Ver también

- [[nethogs]] — ancho de banda por proceso (más simple)
- [[bmon]] — monitor de ancho de banda por interfaz
- [[ss]] — estadísticas de conexiones
- [[ip]] — configuración de interfaces
- [[TUI tools]] — otras herramientas TUI

## Enlaces externos

- [GitHub — imsnif/bandwhich](https://github.com/imsnif/bandwhich)

#programa #tui #red
