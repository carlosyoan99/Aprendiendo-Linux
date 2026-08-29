---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-08-29
estado: resuelto
categoria: programa
prioridad: baja
licencia: Apache-2.0
alternativas: [[Zed]], [[Helix]], [[Editores de código (VSCode Codium Zed Helix Antigravity)]]
---

# Lapce

> Editor nativo escrito en Rust con renderizado por GPU y plugins en WebAssembly: alternativa a VS Code sin Electron.

## Qué es

**Lapce** es un editor de código **nativo** escrito en **Rust** con renderizado por **GPU** (basado en las librerías Druid/Floem). Su objetivo es ofrecer una experiencia similar a la de **VS Code** pero sin el coste de **Electron**, logrando una interfaz fluida y de baja latencia. Destaca por su **sistema de plugins en WebAssembly (WASM)**, un modo Vim competente y la integración de **LSP** para autocompletado, diagnósticos e ir a definición.

## Instalación

```bash
# Arch
sudo pacman -S lapce

# Binario desde GitHub
curl -fsSL https://github.com/lapce/lapce/releases/latest/download/lapce-linux-amd64.tar.gz | tar xzf -
./lapce
```

## Configuración básica

- Configuración en `~/.config/lapce/` (ajustes, temas y extensiones).
- La detección de **LSP** es automática por lenguaje.
- Extensiones (WASM) desde el gestor integrado de Lapce.

## Atajos útiles

| Atajo | Efecto |
|---|---|
| `Ctrl+Shift+P` | Paleta de comandos |
| `Ctrl+P` | Ir a archivo |
| `Ctrl+Shift+F` | Buscar en proyecto |
| `Ctrl+Space` | Autocompletar |
| `Ctrl+Alt+S` | Dividir editor |
| `Ctrl+W` | Cerrar pestaña |

## Uso avanzado

```bash
# Abrir Lapce con un directorio
lapce .

# Abrir archivos concretos
lapce src/main.rs src/lib.rs
```

- El **modo Vim** es competente y compatible con los atajos modales básicos.
- Los **plugins WASM** permiten extender el editor sin compilar extensiones nativas.
- Soporta **múltiples paneles** y vistas divididas sin fricción.

## Comparativa con alternativas

| Aspecto | Lapce | Zed | VS Code |
|---|---|---|---|
| **Motor** | Rust + Floem | Rust + GPUI | Electron |
| **Plugins** | WASM | Extensiones | JS/Node |
| **Velocidad** | Alta | Muy alta | Media |
| **Modo Vim** | Integrado | Integrado | Extensión |

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| El panel de plugins no carga | Red / sandbox WASM | Revisar conexión y permisos de la caché de Lapce |
| El LSP no da diagnósticos | Falta el servidor de lenguaje | Instalar el binario del LSP del lenguaje |

## Notas y advertencias

- Lapce es **código abierto** (Apache-2.0) y madura rápidamente, aunque su ecosistema de extensiones aún es pequeño frente a VS Code.
- Es una buena opción para equipos modestos que quieren velocidad sin sacrificar familiaridad con VS Code.

## Enlaces externos

- [Web oficial](https://lapce.dev/)
- [GitHub](https://github.com/lapce/lapce)
- [Documentación](https://docs.lapce.dev/)

## Ver también

- [[Editores de código (VSCode Codium Zed Helix Antigravity)]] — índice comparativo
- [[Editores de Texto]] — índice + comparativa
- [[Zed]] — alternativa nativa en Rust (GPU-accelerated)
- [[Helix]] — editor modal en Rust

#programa #editores
