---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: programa
prioridad: baja
---

# Antigravity

## Qué es

Antigravity es un editor de código moderno y rápido, con interfaz gráfica nativa y **LLM integrado** para asistencia de IA en el propio editor. Está diseñado para ser liviano (~20 MB de RAM) y ofrecer una experiencia de edición moderna sin depender de Electron.

## Instalación

```bash
# Linux (desde la web oficial, binario)
curl -fsSL https://antigravity.sh/install | sh

# Arch / AUR (si disponible)
yay -S antigravity

# macOS
brew install --cask antigravity
```

> **Nota:** Antigravity es un proyecto relativamente nuevo. Consulta la web oficial para opciones de instalación actualizadas.

## Características clave

- **LLM integrado** — asistente de IA nativo sin necesidad de extensiones externas (similar a Cursor pero más ligero)
- **Rápido y ligero** — ~20 MB de consumo RAM, arranque en milisegundos
- **LSP integrado** — autocompletado, diagnósticos en tiempo real, go-to-definition
- **Interfaz moderna** — renderizado GPU-acelerado con WebGPU
- **Vim mode básico** — soporte parcial de atajos y modos Vim
- **Git integrado** — diff inline, blame, staging desde el editor

## Atajos principales

| Atajo | Acción |
|---|---|
| `Ctrl+P` | Paleta de comandos |
| `Ctrl+Shift+P` | Buscar archivos |
| `Ctrl+Space` | Completar con IA |
| `F12` | Ir a definición (LSP) |
| `Ctrl+K Ctrl+I` | Mostrar hover documentation |
| `Ctrl+Shift+L` | Seleccionar todas las ocurrencias |

## Configuración

La configuración se encuentra en `~/.config/antigravity/`. El archivo principal es `settings.json`:

```json
{
  "theme": "dark",
  "font_size": 14,
  "tab_size": 2,
  "ai_enabled": true,
  "ai_model": "default"
}
```

Los LSP servers se configuran por lenguaje en la sección `lsp` del mismo archivo.

## Ventajas

- Sin Electron: nativo, consume menos RAM que VS Code
- IA integrada sin configuración de APIs externas
- Arranque inmediato, ideal para ediciones rápidas
- Renderizado GPU fluido en pantallas HiDPI

## Desventajas

- Proyecto joven, ecosistema de plugins aún pequeño
- Sin soporte de temas en versiones iniciales
- Vim mode en desarrollo (falta parte de la navegación avanzada)
- Menos extensiones disponibles que VS Code o Zed

## Antigravity vs Zed vs Lapce

| Aspecto | Antigravity | Zed | Lapce |
|---|---|---|---|
| Lenguaje | C++ | Rust | Rust |
| IA integrada | Sí (LLM) | Sí (arranque) | Sí (extensions) |
| Vim mode | Parcial | Sí | Sí |
| Extensibilidad | Baja (nueva) | Media | Alta (plugins WASM) |
| Consumo RAM | ~20 MB | ~80 MB | ~60 MB |
| Plataformas | Linux, macOS, Windows | Linux, macOS, Windows | Linux, macOS, Windows |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No inicia en Wayland | Compatibilidad limitada | Probar con `--x11` o usar XWayland |
| IA no responde | Servicio no disponible | Verificar conexión y configuración de `ai_enabled` |
| LSP no carga | Server no instalado | Instalar el LSP server para el lenguaje (clangd, rust-analyzer, etc.) |

## Ver también

- [[Editores de código (VSCode Codium Zed Helix Antigravity)]] — índice + comparativa
- [[Editores de Texto]] — índice + comparativa
- [[Zed]] — alternativa con IA integrada

## Enlaces externos

- [Web oficial](https://antigravity.sh/)
- [GitHub](https://github.com/antigravity/antigravity)

#programa #editores
