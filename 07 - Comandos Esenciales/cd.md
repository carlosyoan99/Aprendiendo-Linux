---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: comando
prioridad: alta
---

# cd

## Sintaxis
```bash
cd [ruta]
```

## Descripción
Cambia el directorio de trabajo actual. Sin argumentos, lleva al `$HOME` del usuario.

## Opciones frecuentes

`cd` no tiene flags como tal, pero tiene accesos directos posicionales:

| Forma | Efecto |
|---|---|
| `cd` | Va a `$HOME` |
| `cd ~` | Va a `$HOME` |
| `cd -` | Va al directorio anterior (útil para alternar entre dos carpetas) |
| `cd ..` | Sube un nivel |
| `cd ../..` | Sube dos niveles |
| `cd /` | Va a la raíz del sistema |
| `cd !$` | Va al último argumento del comando anterior (solo Bash/Zsh) |

## Ejemplos
```bash
cd /var/log                # ir a logs del sistema
cd ~/Documentos            # ir a Documentos
cd -                       # volver al directorio anterior
cd ..                      # subir un nivel
cd ../../../               # subir tres niveles
cd ~/proyectos/src         # ruta absoluta desde home
cd proyectos/src           # ruta relativa (desde directorio actual)
```

## Casos de uso reales

### Alternar rápidamente entre dos directorios (trabajo típico)

```bash
cd /var/www/mi-proyecto
# ... trabajas ...
cd /etc/nginx
# ... editas config ...
cd -                             # vuelves a /var/www/mi-proyecto
```

### Ir al directorio de un proyecto guardado en variable

```bash
PROYECTO=~/proyectos/mi-app
cd "$PROYECTO"                   # navegar a proyecto

# O mejor, usar CDPATH para atajos:
export CDPATH=~/proyectos:~/Documentos
cd mi-app                        # funciona aunque no estés en ~/proyectos
```

### Navegar usando pushd/popd (pila de directorios)

```bash
pushd /var/log                   # guarda el actual y va a /var/log
pushd /etc                       # guarda /var/log y va a /etc
dirs -v                          # lista la pila con números
popd                             # vuelve a /var/log
popd                             # vuelve al original
```

## Combinaciones comunes con pipe

`cd` no se usa con pipe porque cambia el directorio del shell actual, y los pipes corren en subprocesos. Pero se puede usar con `&&` para encadenar:

```bash
cd ~/proyecto && ls -la && npm run dev   # navegar, listar y ejecutar
cd /tmp || { echo "No pude entrar a /tmp"; exit 1; }  # verificar si cd falla
```

## Alternativas modernas

| Comando clásico | Alternativa moderna | Ventaja |
|---|---|---|
| `cd` | `zoxide` (`z`) | Navegación fuzzy: `z pro` va al proyecto que más usas que contenga "pro" |
| `cd -` | `zoxide` con `z -` | Lo mismo + aprendizaje de patrones |
| `pushd`/`popd` | `zoxide` | No necesitas recordar rutas |

```bash
# Instalar zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
# Añadir a ~/.bashrc:
eval "$(zoxide init bash)"
# Uso:
z proyecto          # salta al directorio del proyecto
zi                  # modo interactivo con fuzzy finder
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `cd: no such file or directory` | La ruta no existe | Verificar con `ls -la` o usar tab completion |
| `cd: Permission denied` | No tienes permiso de ejecución en el directorio | Usar `chmod +x directorio` o `sudo cd` (no funciona) → `sudo -s` primero |
| `cd` no funciona en scripts | El script corre en un subshell | `cd` solo afecta al subshell. Usar funciones o `source script.sh` |
| `cd` no cambia al directorio esperado | Enlaces simbólicos | `cd -P` sigue symlinks al destino real; `cd -L` mantiene el symlink |

## Notas
- `cd` solo funciona con directorios, no con archivos.
- El directorio actual se puede ver con `pwd`.
- La variable `$OLDPWD` guarda el directorio anterior (lo que usa `cd -`).
- En Bash/Zsh, `CDPATH` permite definir rutas base de búsqueda para `cd`.

```bash
echo $OLDPWD               # ver el directorio anterior
pwd                        # ver el directorio actual
```## Enlaces externos

- [Wikipedia — cd (command)](https://en.wikipedia.org/wiki/Cd_(command))
- [GNU Bash manual — cd](https://www.gnu.org/software/bash/manual/html_node/Directory-Stack-Builtins.html)

## Ver también

- [[ls]] — listar contenido del directorio
- [[pwd]] — mostrar directorio actual
- [[La Shell]] — más sobre navegación en terminal

#comando