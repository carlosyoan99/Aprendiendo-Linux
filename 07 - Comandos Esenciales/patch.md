---
fecha_creacion: 2026-07-24
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: comando
prioridad: media
---

# patch

> Aplica parches a archivos de texto. Un parche es un archivo de diferencias generado por `diff -u` que describe cómo modificar un archivo original para convertirlo en una versión modificada.

## Sintaxis

```bash
patch [opciones] < archivo.patch
patch -i archivo.patch
patch -pN archivo < archivo.patch
```

## Descripción

`patch` toma un archivo de diferencias (generado con `diff -u`) y lo aplica sobre los archivos originales para producir las versiones modificadas. Es la herramienta histórica para distribuir cambios de código fuente antes de Git, y sigue siendo útil para parches rápidos sin necesidad de un repo.

**Flujo típico:**
```bash
# 1. Alguien genera un parche
diff -u original.c modificado.c > cambios.patch

# 2. Tú aplicas el parche
patch < cambios.patch
```

## Opciones frecuentes

| Flag | Efecto | Ejemplo |
|---|---|---|
| `-i archivo` | Leer parche de archivo (en vez de stdin) | `patch -i cambios.patch` |
| `-pN` | Nivel de "strip" de directorios en las rutas del parche | `patch -p1 < cambios.patch` |
| `-R` | Revertir parche (deshacer cambios) | `patch -R < cambios.patch` |
| `-b` | Crear backup del archivo original (.orig) | `patch -b < cambios.patch` |
| `--dry-run` | Simular sin modificar archivos | `patch --dry-run < cambios.patch` |
| `-s` | Silencioso (solo errores) | `patch -s < cambios.patch` |
| `-r archivo` | Guardar rechazos (hunks que no se pudieron aplicar) | `patch -r rechazos.patch < cambios.patch` |
| `-E` | Eliminar archivos vacíos tras aplicar parche | `patch -E < cambios.patch` |

## Formato de parche (diff -u)

```diff
--- original.txt        2026-07-24 12:00:00
+++ modificado.txt      2026-07-24 12:30:00
@@ -1,5 +1,6 @@
 línea A
 línea B
-línea a eliminar
+línea agregada
+otra línea nueva
 línea C
 línea D
```

## Ejemplos

```bash
# 1. Generar parche
diff -u config.conf.old config.conf > config.patch

# 2. Aplicar parche (desde el directorio donde está el archivo)
cd /etc/ssh/
sudo patch < sshd_config.patch

# 3. Aplicar con -p1 (cuando el parche tiene rutas con directorio)
# Si el parche dice: --- a/etc/ssh/sshd_config
#                  +++ b/etc/ssh/sshd_config
# -p1 quita "a/" y "b/", aplicando sobre sshd_config
patch -p1 < cambios.patch

# 4. Simular antes de aplicar (VERIFICAR SIEMPRE)
patch --dry-run < cambios.patch

# 5. Revertir un parche
patch -R < cambios.patch

# 6. Backup automático (guarda .orig)
patch -b < cambios.patch
# Crea config.conf.orig con el contenido original

# 7. Aplicar solo si es seguro
patch --dry-run < cambios.patch && patch < cambios.patch
```

## Casos de uso reales

| Escenario | Comandos |
|---|---|
| **Aplicar parche de seguridad** sin recompilar desde Git | `wget URL/security.patch && patch -p1 < security.patch` |
| **Modificar código fuente de un paquete** antes de compilar | `diff -u original.c parcheado.c > fix.patch` y distribuir |
| **Revertir cambio rápido** cuando no hay Git | `patch -R < cambios.patch` |
| **Distribuir hotfix** a varios servidores | `scp fix.patch server: && ssh server "patch -p1 < fix.patch"` |

## Combinaciones comunes

```bash
# Generar y aplicar en un paso (de dos directorios)
diff -urN dir1/ dir2/ | patch -p0

# Aplicar parche recursivo (múltiples archivos)
patch -p1 < cambios_recursivos.patch

# Ver qué archivos modificaría un parche (sin aplicarlo)
grep '^+++' cambios.patch | sed 's/^+++ //'
```

## Troubleshooting / Errores comunes

| Error | Causa | Solución |
|---|---|---|
| `patch: **** malformed patch at line X` | El archivo .patch está corrupto o mal formateado | Revisar el parche, asegurar que termina con salto de línea |
| `Hunk #1 FAILED at 1.` | El contexto del archivo original no coincide con el esperado por el parche | El archivo ya fue modificado. Usar `--dry-run` primero. `patch -l` (ignorar whitespace) |
| `patch: Can't find file to patch at line X` | La ruta del parche no coincide con los archivos locales | Usar `-pN` correcto (probar `-p0`, `-p1`) |
| `1 out of 1 hunk FAILED` | El parche no se puede aplicar (versión incorrecta) | Verificar que tienes la versión correcta del archivo original |
| `patch: **** can't create temporary file` | Problema de permisos o espacio en `/tmp` | Verificar `df -h /tmp` y permisos |

## Notas y advertencias

- **Siempre usar `--dry-run` primero**: un parche mal aplicado puede dejar el proyecto en un estado inconsistente.
- **Backup automático**: `patch -b` crea archivos `.orig` por si necesitas revertir manualmente.
- **Git diff también genera parches**: `git diff > cambios.patch` produce parches que `patch` puede aplicar con `-p1`.
- **Git apply vs patch**: `git apply cambios.patch` es más seguro dentro de un repo Git (respeta staged changes).
- **`-p0` vs `-p1`**: `-p0` usa la ruta exacta del parche. `-p1` quita el primer componente de la ruta (útil para parches de Git donde las rutas son `a/path b/path`).

## Enlaces externos

- [Wikipedia — patch (Unix)](https://en.wikipedia.org/wiki/Patch_(Unix))
- [GNU Diffutils — patch manual](https://www.gnu.org/software/diffutils/manual/diffutils.html#patch)
- [Linux man page — patch(1)](https://man.archlinux.org/man/patch.1)

## Ver también

- [[diff]] — generar parches con `diff -u`
- [[Git]] — control de versiones (git apply, git format-patch)
- [[sed]] — edición directa de archivos (alternativa para cambios simples)
- [[Cheat Sheet - Comandos Esenciales]]

#comando #diffutils
