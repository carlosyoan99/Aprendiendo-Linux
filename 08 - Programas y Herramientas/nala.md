---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: programa
prioridad: baja
---

# nala

> Frontend moderno para APT con descargas paralelas, historial de transacciones y salida coloreada. Alternativa directa a `apt` para uso interactivo.

## Qué es

**nala** es un gestor de paquetes que envuelve a `apt`/`apt-get` añadiendo funcionalidades que deberían ser nativas:

- **Descarga paralela**: múltiples conexiones simultáneas (mucho más rápido que apt)
- **Historial**: `nala history` permite ver, revertir o re-aplicar transacciones
- **Salida coloreada** y formateada con tablas
- **Mirrors**: `nala fetch` selecciona automáticamente los mirrors más rápidos
- **Progreso visual**: barras de progreso por paquete durante la descarga

Escrito en Python. Solo para distribuciones basadas en Debian/Ubuntu (usa APT como backend).

## Instalación

```bash
# Debian/Ubuntu (desde repos backports o oficiales)
sudo apt install nala

# Instalar última versión desde GitHub
# https://gitlab.com/volian/nala
```

## Uso básico

```bash
# Los comandos son muy similares a apt
sudo nala update                      # actualizar lista de paquetes
sudo nala upgrade                     # actualizar paquetes instalados
sudo nala install firefox            # instalar paquete
sudo nala remove firefox             # eliminar paquete
sudo nala purge firefox              # eliminar incluyendo config
sudo nala autoremove                 # limpiar dependencias huérfanas
sudo nala search firefox             # buscar paquetes
sudo nala show firefox               # información del paquete
```

## Selección de mirrors: `nala fetch`

```bash
# nala fetch selecciona los mirrors más rápidos para tu región
sudo nala fetch                       # modo interactivo (elige país)
sudo nala fetch --auto                # automático (elige el más rápido)
sudo nala fetch --country Argentina   # mirrors de un país específico
sudo nala fetch --dry-run             # simular sin aplicar

# Los mirrors se guardan en /etc/nala/sources.list
# Se pueden restaurar los originales con:
sudo nala fetch --default
```

## Historial de transacciones

```bash
# nala guarda un historial completo de todas las operaciones

nala history                          # listar transacciones
nala history info 1                   # detalle de la transacción 1
sudo nala history undo 1              # deshacer transacción 1
sudo nala history redo 1              # re-aplicar transacción 1
```

### Historial de ejemplo

```
 ID  Date       Time    Action    Packages
 ─────────────────────────────────────────
  5  2026-07-24 14:30   install   firefox, thunderbird
  4  2026-07-23 09:15   remove    htop
  3  2026-07-22 18:00   install   neovim, ripgrep, fd-find
  2  2026-07-21 11:45   upgrade   23 packages
  1  2026-07-20 16:20   install   build-essential
```

## nala vs apt

| Aspecto | nala | apt |
|---|---|---|
| **Descarga paralela** | ✅ Múltiples conexiones | ❌ Una conexión |
| **Historial** | ✅ `nala history undo/redo` | ❌ |
| **Salida coloreada** | ✅ Tablas con colores | ✅ Básico |
| **Selección mirrors** | ✅ `nala fetch` | ❌ Manual (/etc/apt/sources.list) |
| **Barra de progreso** | ✅ Por paquete | ❌ Global |
| **Preinstalado** | ❌ | ✅ |
| **Compatible con scripts** | ❌ (usar apt-get) | ✅ |
| **Backend** | apt/apt-get | apt/apt-get |

> nala es mejor para **uso interactivo**: actualizaciones más rápidas, historial útil, y mejor feedback visual. Para **scripts**, sigue usando `apt-get` por compatibilidad universal.

## nala upgrade vs nala install

```bash
# nala upgrade tiene opciones adicionales
sudo nala upgrade --list              # mostrar paquetes actualizables
sudo nala upgrade --full              # actualizar todo (incluye kernel)
```

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `nala: command not found` | No instalado | Instalar con `sudo apt install nala` |
| `sudo: nala: command not found` | nala no en PATH | Verificar instalación: `which nala` |
| nala no se conecta | Mirrors incorrectos | `sudo nala fetch --auto` |
| Historial muy grande | Muchas transacciones | `nala history` + `sudo nala history undo N` para limpiar |

## Ver también

- [[apt]] — gestor APT clásico
- [[dpkg]] — gestor de paquetes Debian de bajo nivel
- [[Gestores de Paquetes]] — comparativa entre distros

## Enlaces externos

- [GitLab — volian/nala](https://gitlab.com/volian/nala)
- [Sitio oficial](https://nala.debian.net/)

#programa #herramientas #apt
