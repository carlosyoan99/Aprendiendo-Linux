---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: baja
---

# Antigravity

## Qué es

Antigravity es un editor de código moderno y rápido, con interfaz gráfica nativa y **LLM integrado** para asistencia de IA en el propio editor. Está diseñado para ser liviano (~20 MB de RAM) y ofrecer una experiencia de edición moderna sin depender de Electron.

```bash
# Instalación (descargar binario)
curl -fsSL https://antigravity.sh/install | sh
```

> **Nota:** Antigravity es un proyecto relativamente nuevo. Consulta la web oficial para opciones de instalación actualizadas.

## Características clave

- **LLM integrado** — asistente de IA nativo sin necesidad de extensiones externas (similar a Cursor pero más ligero)
- **Rápido y ligero** — ~20 MB de consumo RAM, arranque en milisegundos
- **LSP integrado** — autocompletado, diagnósticos en tiempo real, go-to-definition
- **Interfaz moderna** — renderizado GPU-accelerado con WebGPU
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

## Ventajas

- Sin Electron: nativo, consume menos RAM que VS Code
- IA integrada sin configuración de APIs externas
- Arranque inmediato, ideal para ediciones rápidas

## Desventajas

- Proyecto joven, ecosistema de plugins aún pequeño
- Sin soporte de temas en versiones iniciales
- Vim mode en desarrollo (falta parte de la navegación avanzada)

## Ver también

- [[Editores de código (VSCode Codium Zed Helix Antigravity)]] — índice + comparativa
- [[Editores de Texto]] — índice + comparativa
- [[Zed]] — alternativa con IA integrada

## Enlaces externos

- [Web oficial](https://antigravity.sh/)
- [GitHub](https://github.com/antigravity/antigravity)

#programa #editores
