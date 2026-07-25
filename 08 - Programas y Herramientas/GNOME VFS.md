---
fecha_creacion: 2026-07-20
estado: resuelto
categoria: programa
prioridad: baja
---

# GNOME VFS

> Capa de abstracción del sistema de archivos para GNOME, obsoleta desde 2008 y reemplazada por **GVFS** + **GIO**. Usada por Nautilus y aplicaciones GNOME clásicas.

## Definición

GnomeVFS proporcionaba una API unificada para leer, escribir y ejecutar archivos independientemente de su ubicación física (local, FTP, HTTP, SSH, etc.). Fue el sistema de archivos virtual de GNOME hasta la versión 2.22.

> **Confusión común**: La abstracción del sistema de archivos del kernel Linux también se llama VFS (Virtual File System), pero está a más bajo nivel. GnomeVFS operaba a nivel de usuario, no del kernel.

## Historia y motivos del reemplazo

GnomeVFS fue desarrollado como parte del escritorio GNOME 1.x para proporcionar acceso transparente a archivos remotos. Usado por **Nautilus** y otras aplicaciones GNOME clásicas.

**Razones del abandono**:
- Rendimiento deficiente en operaciones de red
- Arquitectura difícil de mantener (monolítica)
- Sin soporte para montaje mediante **FUSE**
- Dependencia directa de Nautilus — no era usable fuera de GNOME
- Código legacy difícil de depurar

En abril de 2008, GNOME declaró obsoleto GnomeVFS en favor de **GIO** (la nueva capa de E/S de GLib) + **GVFS** (el sistema de archivos virtual basado en D-Bus).

## Sucesor: GVFS + GIO

| Característica | GnomeVFS | GVFS |
|---|---|---|
| Estado | ❌ Obsoleto (2008) | ✅ Activo |
| Montaje FUSE | ❌ No | ✅ Sí |
| Rendimiento | Bajo | Alto |
| Soporte actual | ❌ No | ✅ Sí |
| Base | API propietaria GNOME | GLib/GIO (estándar) |
| Arquitectura | Monolítica | Cliente-servidor (D-Bus) |

GVFS introdujo un modelo cliente-servidor: cada aplicación se comunica via D-Bus con un demonio GVFS que monta los sistemas remotos. Los sistemas de archivos remotos (SFTP, SMB, FTP, WebDAV) se montan como carpetas FUSE, lo que los hace accesibles desde cualquier aplicación, no solo las de GNOME.

## Enlaces externos

- [Documentación archivada de GnomeVFS](https://web.archive.org/web/20070619031151/http://developer.gnome.org/doc/API/2.0/gnome-vfs-2.0/)

## Ver también

- [[GNOME]] — entorno de escritorio
- [[Filesystem Hierarchy Standard]] — sistema de archivos estándar
- [[Proc y Sys]] — otros sistemas de archivos virtuales

#programa #gnome
