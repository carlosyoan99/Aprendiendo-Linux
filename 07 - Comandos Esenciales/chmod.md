---
fecha_creacion: 2026-07-18
estado: resuelto
categoria: comando
prioridad: alta
---

# chmod

## Sintaxis
```
chmod [opciones] permisos archivo...
```

## Descripción
Cambia los permisos de lectura (r), escritura (w) y ejecución (x) de archivos y directorios. Soporta dos modos: **octal** (números) y **simbólico** (letras). Es el comando que resuelve "Permission denied" cuando el problema no es de propietario.

## Modo simbólico
```
Referencias: u (dueño/user), g (grupo), o (otros/others), a (todos/all)
Operadores:  + (añadir), - (quitar), = (igualar/poner exactamente)
Permisos:    r (leer), w (escribir), x (ejecutar)
```

## Opciones frecuentes
| Flag | Efecto |
|------|--------|
| `-R` | Recursivo — cambia permisos en todo un árbol de directorios |
| `-v` | Verboso |
| `-c` | Reporta solo los cambios realizados (`--changes`) |
| `--reference=archivo` | Copia los permisos de otro archivo |

## Tabla de permisos (notación octal)

| Número | Binario | Permisos |
|--------|---------|----------|
| 0 | 000 | `---` |
| 1 | 001 | `--x` |
| 2 | 010 | `-w-` |
| 3 | 011 | `-wx` |
| 4 | 100 | `r--` |
| 5 | 101 | `r-x` |
| 6 | 110 | `rw-` |
| 7 | 111 | `rwx` |

```bash
# Cálculo: 755 = dueño(7=rwx) + grupo(5=r-x) + otros(5=r-x)
```

## Ejemplos
```bash
# Octal (común)
chmod 755 script.sh               # dueño:rwx, grupo:rx, otros:rx (típico para scripts)
chmod 644 documento.txt           # dueño:rw, grupo:r, otros:r (típico para archivos)
chmod 700 privado/                # solo dueño puede entrar/leer

# Simbólico (más legible)
chmod +x script.sh                # añadir ejecución a todos
chmod u+x script.sh               # añadir ejecución solo al dueño
chmod go-w archivo.txt            # quitar escritura a grupo y otros
chmod a=rw archivo.txt            # poner lectura+escritura a todos
chmod -R g+w directorio/          # añadir escritura al grupo recursivamente

# Con referencia
chmod --reference=modelo.txt destino.txt   # copiar permisos de modelo
```

## Notas y advertencias
- Para cambiar permisos de un archivo necesitas ser el **propietario** o **root**. No puedes cambiar permisos de archivos que no te pertenecen aunque tengas permisos de lectura.
- `chmod +x` es lo mínimo para que un script sea ejecutable (`./script.sh`).
- En directorios, `x` significa **poder entrar** (no ejecutar). Sin `x` en un directorio, no puedes `cd` a él ni listar su contenido aunque tengas `r`.
- El combo `chmod 600` para claves SSH (`~/.ssh/id_ed25519`) es obligatorio — SSH rechaza claves con permisos demasiado abiertos.
- `chmod -R` en directorios grandes puede tardar. Usarlo con cuidado.

## Ver también
- [[chown]]
- [[Permisos y Propietarios]]
- [[Cheat Sheet - Comandos Esenciales]]
- [[SSH]]

## Enlaces externos

- [Wikipedia — chmod](https://en.wikipedia.org/wiki/Chmod)
- [GNU Coreutils — chmod manual](https://www.gnu.org/software/coreutils/manual/html_node/chmod-invocation.html)

#comando
