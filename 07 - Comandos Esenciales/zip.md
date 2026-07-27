---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: comando
prioridad: media
---

# zip / unzip

## Sintaxis
```
zip [opciones] archivo.zip archivos...
unzip [opciones] archivo.zip
```

## Descripción
Empaqueta y comprime archivos en formato ZIP. Es el formato más universal (compatible con Windows y macOS sin herramientas extra). `zip` comprime, `unzip` extrae.

## Opciones frecuentes de zip

| Flag | Efecto |
|------|--------|
| `-r` | Recursivo (necesario para directorios) |
| `-q` | Modo silencioso |
| `-9` | Máxima compresión (más lento) |
| `-d` | Eliminar archivos dentro del ZIP sin extraer todo |
| `-e` | Cifrar con contraseña |
| `-m` | Mover: comprime y borra los originales |

## Opciones frecuentes de unzip

| Flag | Efecto |
|------|--------|
| `-l` | Listar contenido sin extraer |
| `-d directorio` | Extraer en un directorio específico |
| `-o` | Sobrescribir archivos sin preguntar |
| `-q` | Modo silencioso |

## Ejemplos

```bash
# Comprimir
zip -r proyecto.zip proyecto/             # comprimir directorio recursivamente
zip -r -9 backup.zip datos/               # máxima compresión
zip -e secreto.zip documento.txt          # con contraseña
zip fotos.zip *.jpg                       # comprimir todos los JPG

# Extraer
unzip proyecto.zip                        # extraer en el directorio actual
unzip proyecto.zip -d /tmp/               # extraer en /tmp
unzip -l proyecto.zip                     # listar contenido sin extraer
unzip -o proyecto.zip                     # sobrescribir sin preguntar

# Modificar ZIP sin extraer
zip -d proyecto.zip archivo-temp.txt      # eliminar archivo del ZIP
zip -m proyecto.zip viejo.log             # comprimir y borrar original
```

## tar vs zip

| Característica | tar + gzip | zip |
|---|---|---|
| Formato nativo en Linux | ✅ Sí | ❌ No (pero instalado en toda distro) |
| Compatibilidad Windows | ❌ Requiere 7zip/WinRAR | ✅ Nativo |
| Preserva permisos | ✅ Sí | ❌ No |
| Compresión incluida | Separada (flags -z, -j, -J) | ✅ Integrada |
| Estándar en servidores | ✅ Sí | ❌ Casi nunca |

## Notas y advertencias
- Siempre usar `-r` para comprimir directorios, sino `zip` los salta sin aviso.
- ZIP no preserva permisos de ejecución ni propietarios de Linux. Para backups de sistemas usar `tar`.
- `unzip` puede no venir preinstalado en distros mínimas: `sudo apt install unzip` / `sudo pacman -S unzip`.

## Ver también
- [[tar]]
- [[Cheat Sheet - Comandos Esenciales]]

## Enlaces externos

- [Wikipedia — Zip (file format)](https://en.wikipedia.org/wiki/Zip_(file_format))
- [Info-ZIP official](http://www.info-zip.org/)

#comando
