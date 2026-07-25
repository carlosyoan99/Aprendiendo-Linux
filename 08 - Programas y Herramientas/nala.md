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

`nala` es un gestor de paquetes que envuelve a `apt`/`apt-get` añadiendo:
- **Descarga paralela**: múltiples conexiones simultáneas (mucho más rápido)
- **Historial**: `nala history` permite ver, revertir o re-aplicar transacciones
- **Salida coloreada** y formateada con tablas
- **Mirrors**: `nala fetch` selecciona los mirrors más rápidos automáticamente

## Instalación

```bash
# Debian/Ubuntu
sudo apt install nala

# Uso diario (mismos comandos que apt)
sudo nala update
sudo nala upgrade
sudo nala install firefox
sudo nala remove firefox

# Historial de transacciones
nala history
sudo nala history undo 1   # deshacer transacción 1
```

## Ver también

- [[apt]] — gestor APT clásico
- [[dpkg]] — bajo nivel
- [[Gestores de Paquetes]] — comparativa entre distros

#programa #herramientas #apt
