---
fecha_creacion: 2026-08-29
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: GPL-2.0
alternativas: [[Falkon]], [[Firefox]], [[Chromium]], [[Navegadores Web]]
---

# Konqueror

> Navegador web y gestor de archivos de KDE, clásico y ligero basado en KHTML/WebKit.

## Qué es

**Konqueror** es el navegador web multifunción de KDE desde finales de los 90. Además de navegar web, funciona como **gestor de archivos** (como Dolphin) y visor de documentos. Su motor original fue **KHTML** (base de la que Apple derivó WebKit), aunque en KDE 5/6 puede usar **Qt WebEngine (Blink)**. Es ligero y muy integrado con el escritorio Plasma.

## Instalación

```bash
# Debian/Ubuntu
sudo apt install konqueror

# Arch
sudo pacman -S konqueror

# Fedora
sudo dnf install konqueror

# Flatpak
flatpak install flathub org.kde.konqueror
```

## Configuración básica

- Puede usar KHTML o Qt WebEngine (Blink) como motor (ajustable según build de la distro).
- Como gestor de archivos hereda las URLs estilo `file:///`, `ftp://`, `webdav://`.
- Barra de direcciones omnipresente tipo "kiosco" que acepta rutas y URLs.

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `F9` | Panel lateral (navegación) |
| `Ctrl+T` | Nueva pestaña |
| `Ctrl+F` | Buscar en página |
| `F10` | Menú (modo kiosko) |

## Uso avanzado

```bash
# URL/buscador desde la barra
konqueror https://example.com

# Uso como gestor de archivos
konqueror file:///home/user/proyectos
```

## Comparativa con alternativas

| Aspecto | Konqueror | Falkon | Dolphin |
|---|---|---|---|
| **Rol** | Navegador + archivos | Navegador | Gestor de archivos |
| **Motor** | KHTML/Blink | Blink | — |
| **Integración KDE** | Muy alta | Alta | Muy alta |
| **Ligereza** | Alta | Alta | Alta |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| Sitios modernos se rompen | KHTML desactualizado | Cambiar a motor WebEngine o usar [[Firefox]] |
| No carga como gestor de archivos | Abierto en modo web | Poner `file:///` en la barra de direcciones |

## Notas y advertencias

- Su uso como navegador moderno está algo en desuso frente a [[Falkon]] o [[Firefox]], pero sigue siendo excelente como gestor de archivos integrado.
- La experiencia varía según el motor que compile la distro.

## Enlaces externos

- [Konqueror — sitio oficial](https://konqueror.org/)
- [Wikipedia — Konqueror](https://en.wikipedia.org/wiki/Konqueror)
- [Arch Wiki — Konqueror](https://wiki.archlinux.org/title/Konqueror)

## Ver también

- [[Falkon]] — navegador Qt WebEngine ligero
- [[Firefox]] — alternativa Gecko
- [[Navegadores Web]] — índice comparativo

#programa #navegador
