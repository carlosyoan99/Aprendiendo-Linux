---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: media
licencia: GPL-3.0
alternativas: [[Lapce]], [[Helix]], [[Editores de código (VSCode Codium Zed Helix Antigravity)]]
---

# Zed

> Editor de código moderno en Rust con renderizado por GPU: velocidad extrema y colaboración en tiempo real.

## Qué es

**Zed** es un editor de código de nueva generación creado por los fundadores de **Atom** (GitHub). Está escrito en **Rust** con un motor de renderizado por GPU llamado **GPUI**, lo que le da una latencia mínima y una interfaz extremadamente fluida incluso en proyectos grandes. Su enfoque va más allá del editor clásico, incorporando **colaboración en tiempo real** (canales, llamadas y edición compartida) y un **asistente de IA integrado** (Zed AI).

## Instalación

```bash
# Binario desde la web
curl -f https://zed.dev/install.sh | sh

# Arch (AUR)
yay -S zed-editor

# Nix
nix-shell -p zed
```

> Solo disponible para **Linux y macOS** (sin soporte oficial de Windows).

## Configuración básica

- Configuración global en `~/.config/zed/settings.json`.
- Los ajustes de **lenguaje** y **LSP** parten de valores por defecto sensatos (LSP integrado sin configuración extra).
- Temas y extensiones desde el panel de comandos (`Ctrl+Shift+P`).

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `Ctrl+Shift+P` | Paleta de comandos |
| `Ctrl+P` | Ir a archivo |
| `Ctrl+Shift+F` | Buscar en proyecto |
| `Ctrl+Space` | Autocompletar |
| `Ctrl+Shift+L` | Seleccionar todas las ocurrencias |
| `Ctrl+B` | Alternar barra lateral |

## Uso avanzado

```bash
# Abrir Zed con un directorio
zed . 

# Abrir un archivo o directorio concreto
zed ruta/al/archivo.rs
```

- Soporta **modo Vim** (modal) y múltiples **múltiples cursores**.
- La colaboración (`zed` abriendo un *channel*) permite editar en tiempo real con otros usuarios.
- Zed AI integra autocompletado y un chat con modelos de lenguaje local (configurable).

## Comparativa con alternativas

| Aspecto | Zed | Lapce | VS Code |
|---|---|---|---|
| **Motor** | Rust + GPUI | Rust + Floem | Electron |
| **Velocidad** | Muy alta | Alta | Media |
| **Colaboración** | Nativa | No | Extensiones |
| **Extensiones** | Creciente | WASM | Muy amplias |

## Limitaciones

- Solo Linux y macOS (sin Windows).
- Relativamente joven; menos extensiones que VS Code.
- Sin soporte oficial para distros no-x86_64.

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| El LSP no arranca | Falta el servidor de lenguaje | Instalar el binario del LSP correspondiente (p.ej. `rust-analyzer`) y reiniciar Zed |
| Rendimiento GPU en VM | Sin aceleración gráfica | Reducir la configuración gráfica o usar fallback software |

## Notas y advertencias

- Zed prioriza **velocidad y colaboración**; para un ecosistema maduro de extensiones sigue siendo referencia [[Editores de código (VSCode Codium Zed Helix Antigravity)|VSCode Codium]] (Electron).
- El proyecto es de **código abierto** (GPL-3.0) aunque el servicio de IA es opcional.

## Enlaces externos

- [Web oficial](https://zed.dev/)
- [GitHub](https://github.com/zed-industries/zed)
- [Documentación](https://zed.dev/docs)
- [Arch Wiki — Zed](https://wiki.archlinux.org/title/Zed_(editor))

## Ver también

- [[Editores de código (VSCode Codium Zed Helix Antigravity)]] — índice comparativo
- [[Editores de Texto]] — índice + comparativa
- [[Helix]] — alternativa modal en Rust
- [[Lapce]] — editor nativo en Rust

#programa #editores
