---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: alta
---

# pwd

> Muestra la ruta absoluta del directorio de trabajo actual. Esencial para orientarse en la terminal y para scripting que necesita rutas completas.

## Sintaxis

```bash
pwd [opciones]
```

## Descripción

`pwd` (print working directory) imprime la ruta completa (absoluta) del directorio donde te encuentras actualmente en la terminal. Es uno de los comandos más básicos y se usa constantemente en scripts y diagnóstico.

La información también está disponible en la variable de entorno `$PWD`.

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-L` | Ruta lógica (respeta symlinks, por defecto) | `pwd -L` |
| `-P` | Ruta física (resuelve symlinks al directorio real) | `pwd -P` |

## Formato de salida

```bash
/home/carlos/Documentos/Proyectos/Aprendiendo Linux
```

Ruta absoluta, sin barra al final (excepto para `/`).

## Ejemplos

```bash
# Uso básico
pwd
# /home/carlos/proyectos

# Diferencia entre -L y -P con symlinks
ln -s /tmp /home/carlos/enlace
cd /home/carlos/enlace
pwd -L    # /home/carlos/enlace   (lógico: el symlink)
pwd -P    # /tmp                  (físico: el destino real)

# En scripts: guardar ruta actual antes de cd
DIR_ORIGINAL=$(pwd)
cd /tmp
# ... trabajar en /tmp ...
cd "$DIR_ORIGINAL"     # volver al directorio original

# Verificar que el directorio actual existe (en scripts)
if [[ "$(pwd)" == "/" ]]; then
    echo "CUIDADO: estás en la raíz"
fi
```

## Casos de uso reales

| Escenario | Comando |
|---|---|
| **Saber dónde estás** después de varios `cd` | `pwd` |
| **Guardar ubicación** en script para volver después | `DIR=$(pwd)` |
| **Verificar ruta real** cuando hay symlinks | `pwd -P` |
| **Mostrar ruta en el prompt** | La variable `$PWD` suele estar en `$PS1` |
| **Diagnosticar** por qué un comando no encuentra archivos | `pwd; ls -la` |

## Combinaciones comunes con pipe

```bash
# Agregar pwd a la salida de otro comando
echo "Ejecutando desde: $(pwd)"

# Verificar que estás en el directorio correcto antes de ejecutar
[[ "$(pwd)" == "$HOME" ]] && echo "Estás en home" || echo "Estás en $(pwd)"
```

## Alternativas modernas

| Comando | Alternativa |
|---|---|
| `pwd` | `echo "$PWD"` — más rápido (no crea subproceso) |

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `pwd: error retrieving current directory` | El directorio actual fue eliminado desde otro proceso | `cd /tmp` para salir del directorio huérfano |
| `pwd: Permission denied` | No tienes permiso de lectura en algún padre del path | Usar `pwd -P` o `cd /` y navegar de nuevo |
| `$PWD` no coincide con `pwd` | La variable $PWD no se actualizó (raro) | Usar `pwd` (lee del sistema de archivos, no de la variable) |

## Notas

- `pwd` es un **builtin de la shell** (rápido) y también un **binario en `/bin/pwd`** (versión GNU). Casi siempre se usa el builtin.
- La variable de entorno `$PWD` la actualiza automáticamente la shell al hacer `cd`.
- `$OLDPWD` guarda el directorio anterior (lo usa `cd -`).
- En scripts, es buena práctica guardar `$(pwd)` al inicio para poder volver.

## Enlaces externos

- [Wikipedia — pwd](https://en.wikipedia.org/wiki/Pwd)
- [GNU Coreutils — pwd manual](https://www.gnu.org/software/coreutils/manual/html_node/pwd-invocation.html)
- [Linux man page — pwd(1)](https://man.archlinux.org/man/pwd.1)

## Ver también

- [[cd]] — cambiar de directorio
- [[ls]] — listar contenido del directorio
- [[La Shell]] — más sobre navegación y prompt
- [[Cheat Sheet - Comandos Esenciales]]

#comando #coreutils
