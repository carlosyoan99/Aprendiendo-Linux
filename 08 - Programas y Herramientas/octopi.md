---
fecha_creacion: 2026-08-30
fecha_modificacion: 2026-08-30
estado: resuelto
categoria: programa
prioridad: media
---

# Octopi

> Interfaz gráfica para el gestor de paquetes de Arch (pacman), con asistente opcional para el AUR. En CachyOS es una forma cómoda de gestionar paquetes sin terminal.

## Qué es

**Octopi** es un frontend gráfico para pacman, el gestor de paquetes de Arch Linux y derivados. Permite buscar, instalar, actualizar y eliminar paquetes de forma visual. Incluye un asistente AUR opcional (requiere `paru` o `yay`), notificador de actualizaciones y limpiador de caché.

**Ventajas:**
- Interfaz visual para pacman sin necesidad de terminal
- Integración con AUR vía helpers externos
- Notificador de actualizaciones en bandeja del sistema
- Limpieza de caché de paquetes descargados
- Búsqueda rápida de paquetes en repos y AUR

## Instalación

```bash
# Arch / CachyOS
sudo pacman -S octopi

# Para el asistente AUR, instalar un helper:
sudo pacman -S paru        # o yay
```

> **Nota**: Octopi solo está disponible en repos Arch-based. No hay versión para Debian/Ubuntu/Fedora.

## Uso

```bash
octopi             # abrir la interfaz gráfico
```

## Funcionalidad

| Acción | Descripción |
|---|---|
| Buscar / instalar | Busca en los repos y AUR y gestiona paquetes gráficamente |
| `AUR assistant` | Requiere un helper instalado aparte (paru/yay) |
| Octopi-notifier | Avisa de actualizaciones disponibles si se habilita |
| Octopi-cachecleaner | Limpia la caché de paquetes descargados |
| Sync databases | Actualiza las bases de datos de pacman |

> Solo usa Octopi para consultar y administrar; el asistente AUR necesita `paru` o `yay` instalados por separado.

## Configuración

### Activar notificador de actualizaciones

```bash
# Habilitar el servicio de notificación
systemctl --user enable --now octopi-notifier.service
```

El icono aparecerá en la bandeja del sistema y avisará cuando haya actualizaciones disponibles.

### Configurar asistente AUR

En Octopi → Preferencias → AUR → seleccionar `paru` o `yay` como helper.

## Comparativa con alternativas

| Aspecto | Octopi | pacman (CLI) | pamac | yay/paru (CLI) |
|---|---|---|---|---|
| **Interfaz** | Gráfica (Qt) | Línea de comandos | Gráfica (GTK) | Línea de comandos |
| **AUR** | Vía helper externo | ❌ | ✅ Integrado | ✅ Integrado |
| **Notificador** | ✅ | ❌ | ✅ | ❌ |
| **Limpieza caché** | ✅ | `pacman -Sc` | ✅ | `paru -Sc` |
| **Disponible en** | Solo Arch | Solo Arch | Arch, Manjaro | Solo Arch |
| **Ligero** | ✅ | ✅ | ❌ (GTK pesado) | ✅ |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| AUR assistant no encontrado | No hay helper instalado | `sudo pacman -S paru` o `sudo pacman -S yay` |
| Icono no aparece en bandeja | Servicio no habilitado | `systemctl --user enable --now octopi-notifier.service` |
| Error al instalar paquetes AUR | Permisos o helper mal configurado | Verificar en Preferencias → AUR que el helper está seleccionado |
| Base de datos desactualizada | No se ha sincronizado | Pulsar "Sync databases" o `sudo pacman -Syu` |

## Notas personales

- En CachyOS lo uso para consultas rápidas y para ver qué hay disponible en AUR sin escribir comandos.
- Para instalaciones frecuentes, `paru` desde terminal es más rápido y flexible.

## Enlaces externos

- [Octopi — sitio](https://tari.in/www/software/octopi/)
- [GitHub — Octopi](https://github.com/aarnt/octopi)
- [Arch Wiki — Octopi](https://wiki.archlinux.org/title/Octopi)

## Ver también

- [[Pacman]] — el gestor real detrás de Octopi
- [[nala]] — frontend gráfico para APT (Debian/Ubuntu)
- [[CachyOS]] — distribución donde está instalado

#programa #gestor-paquetes #gui
