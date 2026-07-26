---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: media
---

# Editores de Texto

## Qué es

En Linux, los archivos de configuración son archivos de texto plano. Saber usar al menos un editor de terminal es indispensable, porque no siempre tendrás un entorno gráfico disponible (servidores, sesiones SSH, TTY).

Esta nota sirve como **índice** de los editores de texto disponibles en Linux. Cada editor tiene su nota individual; aquí tienes una tabla comparativa para elegir el que mejor se adapte a ti.

## Tabla comparativa

| Editor | Filosofía | Nativo | Modo Vim | LSP | Consumo RAM | Ideal para |
|---|---|---|---|---|---|---|
| [[Nano]] | Minimalista, atajos visibles | ✅ | ❌ | ❌ | ~2 MB | Edits rápidos en terminal |
| [[Vim Neovim]] | Modal: editas con teclas, no menús | ✅ | ✅ | ✅ (nvim) | ~20 MB | Programación en terminal |
| [[Micro]] | Atajos tipo editor moderno | ✅ | ❌ | ❌ | ~5 MB | Edits en terminal con atajos familiares |
| [[Helix]] | Modal post-Vim (objeto → acción), Rust | ✅ | ✅ (propio) | ✅ | ~15 MB | Programación, fanáticos de Rust |
| [[Lapce]] | Alternativa nativa a VS Code, Rust | ✅ | ✅ | ✅ | ~30 MB | Programación, GPU-accelerated |
| [[Zed]] | GPU-accelerated, colaborativo | ✅ | ✅ | ✅ | ~50 MB | Programación, GPU-accelerated |
| [[Antigravity]] | Moderno, LLM integrado | ✅ | ⚠️ Básico | ✅ | ~50 MB | Programación con IA nativa |
| [[Geany]] | IDE ligero GTK | ✅ | ❌ | ⚠️ Básico | ~15 MB | Equipos lentos, programación simple |
| [[Kate]] | Editor avanzado KDE | ✅ | ❌ | ✅ | ~80 MB | KDE, programación ligera |
| [[Gedit]] | Editor simple GNOME | ✅ | ❌ | ❌ | ~10 MB | Edits rápidos en GUI |

> Para editores de código más pesados (VS Code, VSCodium, etc.), ver [[Editores de código (VSCode Codium Zed Helix Antigravity)]].

## Criterios de elección

- **Solo terminal + recursos mínimos**: [[Nano]] (universal), [[Micro]] (atajos familiares), [[Vim Neovim]] (máxima potencia)
- **Programación en terminal**: [[Vim Neovim]], [[Helix]]
- **Programación con GUI ligera**: [[Geany]], [[Kate]], [[Gedit]]
- **GPU-accelerated moderno**: [[Zed]], [[Lapce]]
- **IA integrada**: [[Antigravity]], [[Zed]] (Zed AI)

## Notas personales

-

## Ver también

- [[Editores de código (VSCode Codium Zed Helix Antigravity)]]
- [[La Shell]]
- [[Utilidades Base del Sistema]]
- [[Emuladores de Terminal]]
- [[Desarrollo en Linux (gcc make gdb strace)]]

## Enlaces externos

- [Wikipedia — Text editor](https://en.wikipedia.org/wiki/Text_editor)
- [Wikipedia — List of text editors](https://en.wikipedia.org/wiki/List_of_text_editors)
- [Wikipedia — Comparison of text editors](https://en.wikipedia.org/wiki/Comparison_of_text_editors)

#programa #editores
