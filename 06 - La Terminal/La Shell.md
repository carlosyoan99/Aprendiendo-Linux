---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: terminal
prioridad: alta
---

# La Terminal y la Shell

## Definición

Aunque a menudo se usan indistintamente, **terminal** y **shell** son cosas distintas:

| Concepto | Qué es | Ejemplos |
|---|---|---|
| **Terminal / emulador de terminal** | Programa que abre una ventana para interactuar con la shell | GNOME Terminal, Konsole, Alacritty, Kitty, foot |
| **Shell** | Intérprete de comandos que procesa lo que escribes | `bash`, `zsh`, `fish` |
| **TTY** | Terminal física o virtual (Ctrl+Alt+F1-F6) | `/dev/tty1`, `/dev/ttyS0` |

```bash
echo $SHELL          # qué shell tienes por defecto
echo $TERM           # qué tipo de terminal estás usando (xterm-256color, alacritty, etc.)
tty                  # qué terminal virtual estás usando
```

## Cómo funciona una sesión típica

1. Abres un emulador de terminal (ej. GNOME Terminal).
2. El emulador inicia una **shell** (ej. `bash`).
3. La shell te muestra un **prompt** (`usuario@host:~$ `) y espera comandos.
4. Escribes un comando → la shell lo ejecuta → muestra la salida → vuelve al prompt.

## Tipos de shell

| Tipo | Cuándo se usa | Archivo de config que ejecuta |
|---|---|---|
| **Interactiva de login** | Primer inicio de sesión (TTY, SSH) | `.profile`, `.bash_profile` |
| **Interactiva no-login** | Abrir terminal desde el DE | `.bashrc` (bash) o `.zshrc` (zsh) |
| **No interactiva** | Scripts, `ssh comando`, `bash -c` | Ninguno (hereda entorno) |

```bash
bash --login          # forzar shell de login
bash -c 'echo hola'   # ejecutar comando en shell no interactiva
```

## Atajos de teclado universales (readline)

Estos atajos funcionan en bash, zsh (y en muchos prompts de programas como `python`, `irb`, `psql`):

| Atajo | Acción |
|---|---|
| `Ctrl + C` | Interrumpir / cancelar el comando actual |
| `Ctrl + D` | EOF — cerrar shell o terminar entrada |
| `Ctrl + Z` | Suspender proceso (lo envía a background, lo recuperas con `fg`) |
| `Ctrl + L` | Limpiar pantalla (como `clear`) |
| `Ctrl + A` | Ir al principio de la línea |
| `Ctrl + E` | Ir al final de la línea |
| `Ctrl + U` | Borrar desde el cursor hasta el inicio |
| `Ctrl + K` | Borrar desde el cursor hasta el final |
| `Ctrl + W` | Borrar la palabra anterior |
| `Ctrl + R` | Búsqueda inversa en el historial (`reverse-i-search`) |
| `↑ / ↓` | Navegar por el historial de comandos |
| `Tab` | Autocompletar comandos, rutas y opciones |
| `Alt + .` | Insertar el último argumento del comando anterior |
| `Alt + Backspace` | Borrar palabra hacia atrás |

## Globbing (expansión de patrones en archivos)

La shell expande los patrones `*`, `?`, `[]` antes de ejecutar el comando:

```bash
# *  → cualquier cadena (incluyendo vacío)
ls *.txt                              # todos los .txt del directorio
ls ~/Documentos/*.pdf                 # todos los PDFs en Documentos
cp *.jpg ~/fotos/                     # copiar todos los JPGs a fotos

# ?  → un solo carácter cualquiera
ls archivo.???                        # archivo.txt, archivo.pdf, archivo.doc

# [] → un carácter del conjunto
ls archivo[0-9].txt                   # archivo0.txt ... archivo9.txt
ls [abc]*.md                          # archivos .md que empiecen con a, b o c

# {} → expansión de llaves (genera combinaciones)
mkdir -p proyecto/{src,docs,tests}    # crea proyecto/src, proyecto/docs, proyecto/tests
touch backup-{2024,2025,2026}-{01..12}.tar  # 36 archivos
echo {A..Z}                           # A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
echo archivo{1..10..2}.txt            # archivo1.txt archivo3.txt archivo5.txt archivo7.txt archivo9.txt
```

## Redirecciones básicas

| Símbolo | Función | Ejemplo |
|---|---|---|
| `>` | Redirigir stdout a archivo (sobrescribe) | `echo "hola" > salida.txt` |
| `>>` | Redirigir stdout a archivo (añade) | `echo "más" >> salida.txt` |
| `2>` | Redirigir stderr a archivo | `comando 2> error.log` |
| `2>&1` | Redirigir stderr a stdout | `comando > salida.log 2>&1` |
| `&>` | Redirigir stdout+stderr a archivo (bash 4+) | `comando &> todo.log` |
| `<` | Usar archivo como stdin | `sort < lista.txt` |
| `<<<` | Here string (string como stdin) | `grep error <<< "esto es un error"` |
| `\|` | Pipe: stdout de un comando → stdin del siguiente | `ls \| grep .txt` |

```bash
# Combinaciones útiles
comando > /dev/null 2>&1              # descartar toda la salida
comando 2>&1 | tee log.txt            # ver salida en pantalla y guardarla
comando |& tee log.txt                # bash 4+: equivalente al anterior
```

## Expansión de variables

```bash
# Variables simples
NOMBRE="Carlos"
echo $NOMBRE                          # Carlos
echo ${NOMBRE}                        # Carlos (forma explícita)

# Expansión con texto adyacente
echo ${NOMBRE}_2026                   # Carlos_2026
echo $NOMBRE_2026                     # ERROR: busca la variable NOMBRE_2026, que no existe

# Valores por defecto
echo ${EDITOR:-nano}                  # usa $EDITOR si existe, sino "nano"
echo ${EDITOR:=nano}                  # igual, pero asigna el valor si no existe

# Subcadena
echo ${NOMBRE:0:3}                    # Car (primeros 3 caracteres)
echo ${NOMBRE: -3}                    # los (últimos 3 caracteres)

# Sustitución
echo ${NOMBRE/Carlos/Pedro}           # Pedro (reemplazar primera ocurrencia)
echo ${NOMBRE//a/@}                   # C@rlos (reemplazar todas las ocurrencias)

# Longitud
echo ${#NOMBRE}                       # 6

# Mayúsculas/minúsculas
echo ${NOMBRE^^}                      # CARLOS (todo mayúsculas)
echo ${NOMBRE,,}                      # carlos (todo minúsculas)
```

## Variables de la shell

```bash
$?               # código de salida del último comando (0 = éxito)
$$               # PID de la shell actual
$!               # PID del último proceso en background
$USER            # tu nombre de usuario
$HOSTNAME        # nombre del equipo
$HOME            # ruta a tu directorio personal
$PATH            # lista de directorios donde buscar ejecutables
$PWD             # directorio actual (equivalente a pwd)
$OLDPWD          # directorio anterior (cd - lo usa)
$_               # último argumento del comando anterior
$0               # nombre del script o shell actual
$1, $2, ...      # argumentos del script (en scripting)
$#               # número de argumentos
```

Ver [[Variables de Entorno y PATH]] para más detalle.

## El prompt

El texto que ves antes de escribir se puede personalizar:

```bash
# bash: ~/.bashrc
# Formato: \u (usuario), \h (host), \w (ruta), \$ (# para root, $ para usuario)
PS1='\u@\h:\w\$ '                     # usuario@host:/ruta$
PS1='\[\e[32m\]\u@\h\[\e[00m\]:\[\e[34m\]\w\[\e[00m\]\$ '
# verde: usuario@host, azul: ruta actual

# zsh: temas con Oh My Zsh (ver [[Shells (bash zsh fish)]])
```

## Ventajas de la terminal sobre la GUI

- **Rapidez**: un comando reemplaza 5 clics (ej. `grep -rn "error" *.log`).
- **Remoto**: `ssh servidor` te da el mismo entorno estés donde estés.
- **Automatizable**: todo lo que haces en terminal se puede poner en un script.
- **Precisión**: los comandos son deterministas y repetibles, sin riesgo de hacer clic donde no toca.
- **Mínimos recursos**: una terminal consume ~10-50 MB RAM, un DE completo ~1-2 GB.

## Enlaces externos

- [Wikipedia — Shell de Unix](https://en.wikipedia.org/wiki/Unix_shell)
- [Wikipedia — Terminal (informática)](https://es.wikipedia.org/wiki/Terminal_(inform%C3%A1tica))
- [GNU Bash manual](https://www.gnu.org/software/bash/manual/)

## Ver también

- [[Shells (bash zsh fish)]] — comparativa de shells
- [[Emuladores de Terminal]] — opciones de emuladores
- [[Variables de Entorno y PATH]]
- [[Cheat Sheet - Comandos Esenciales]]
- [[Que es Linux]]
- [[bash-avanzado]] — scripting avanzado

#terminal #shell
