---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: programa
prioridad: baja
---

# st (Simple Terminal)

Terminal minimalista del proyecto **suckless** (~2.000 líneas de código C), de los mismos desarrolladores de [[DWM]] y [[suckless|dmenu]]. La filosofía suckless es mantener el código pequeño, limpio y sin dependencias innecesarias.

## Instalación

```bash
# Desde los repos (versión empaquetada)
sudo pacman -S st           # Arch
sudo apt install st         # Debian/Ubuntu (puede llamarse `suckless-tools`)

# Compilar desde fuente (recomendado para aplicar parches)
git clone https://git.suckless.org/st
cd st
# Editar config.h a gusto
sudo make clean install
```

## Configuración

La configuración se hace modificando `config.h` **antes** de compilar. No hay archivo de configuración en runtime:

```c
// config.h — opciones principales
static const char *font[]        = { "monospace:size=12" };
static const int colorscheme[]   = { ... }; // paleta de colores
static const int borderpx        = 2;       // borde de la ventana
static const int scrollback      = 2000;    // líneas de scroll
```

Tras modificar, recompilar:

```bash
sudo make clean install
```

## Parches útiles

La terminal se personaliza aplicando parches (patches) sobre el código fuente antes de compilar:

```bash
# Ejemplo: aplicar parche de opacidad (alpha)
wget https://st.suckless.org/patches/alpha/st-alpha-0.9.diff
patch < st-alpha-0.9.diff
sudo make clean install
```

| Parche | Efecto |
|---|---|
| **alpha** | Transparencia/opacidad |
| **scrollback** | Desplazamiento hacia atrás (mouse/touch) |
| **ligatures** | Ligaduras tipográficas (Fira Code, etc.) |
| **anysize** | Redimensionado suave con la ventana |
| **font2** | Fuente alternativa (fallback) |
| **clipboard** | Sincronización con portapapeles primario |
| **urlselect** | Seleccionar URLs con teclado |
| **bold-is-not-bright** | Negrita sin brillo (colores separados) |

## Características

- **Extremadamente minimalista**: ~5 MB de RAM en reposo
- **Sin pestañas**: usa un multiplexor externo ([[tmux]]) para múltiples sesiones
- **Sin config en runtime**: todo se define en `config.h` y se recompila
- **Se personaliza con parches**: comunidad activa de parches oficiales
- **Fuentes bitmap y TrueType**: soporte básico

## Uso avanzado

```bash
# Abrir st como terminal por defecto en DWM
# En config.h de DWM:
static const char *termcmd[]  = { "st", NULL };

# Abrir con diferentes fuentes
st -f "monospace:size=14"

# Abrir con título específico
st -t "Mi terminal"

# Copiar/pegar (requiere parche clipboard)
# Seleccionar texto → copia automáticamente al portapapeles primario
```

## Ventajas

- Filosofía UNIX: hace una cosa y la hace bien
- Código auditable (~2k líneas C)
- Sin dependencias: ni Pango, ni Cairo, ni bibliotecas de fontconfig complejas
- Consumo de RAM mínimo (< 5 MB)

## Desventajas

- **Requiere recompilar** para cambiar cualquier ajuste
- Sin aceleración GPU (no hay scroll suave, ni ligaduras sin parche)
- Sin soporte nativo de Unicode sin parches adicionales
- Curva de aprendizaje para aplicar parches (necesitas entender diff/patch)

## st vs Alacritty vs Kitty vs foot

| Aspecto | st | Alacritty | Kitty | foot |
|---|---|---|---|---|
| Lenguaje | C | Rust | C/C++ | C |
| Configuración | Re-compilar | YAML | Config file | INI |
| GPU acelerada | No | Sí | Sí | Sí |
| Parches | Sí | No | No | No |
| Consumo RAM | ~5 MB | ~30 MB | ~50 MB | ~20 MB |
| Ideal | Filosofía suckless | Rendimiento | Funcionalidad | Wayland minimalista |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| Fuente no se ve bien | Fontconfig no configura | Revisar `fc-list` y ajustar `font[]` en `config.h` |
| Sin scroll con ratón | Falta parche scrollback | Aplicar parche `scrollback` y recompilar |
| No copia al portapapeles | Falta parche clipboard | Aplicar parche `clipboard` y recompilar |
| Caracteres raros (CJK) | Sin soporte Unicode completo | Usar fuente que soporte CJK o parche `font2` |

## Ver también

- [[DWM]] — WM del mismo proyecto
- [[suckless]] — filosofía y ecosistema
- [[Emuladores de Terminal]] — índice + comparativa
- [[tmux]] — multiplexor para usar con st
- [[Compilación desde Código Fuente]] — cómo compilar e instalar desde fuente

## Enlaces externos

- [Sitio oficial](https://st.suckless.org/)
- [Repositorio git](https://git.suckless.org/st/)
- [Parches disponibles](https://st.suckless.org/patches/)

#programa #terminal
