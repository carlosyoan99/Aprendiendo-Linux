---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: indice
prioridad: alta
---

# Día a Día en CLI

Prioridad 1 — Fundación y Supervivencia Diaria

Este mapa organiza los comandos y conceptos que usas **cada día**. Domina esto y resolverás el 80% de tus tareas en terminal.

---

## 🧭 Navegación del sistema

| Objetivo | Comando | Nota |
|---|---|---|
| ¿Dónde estoy? | `pwd` | — |
| ¿Qué hay aquí? | `ls -la` | [[ls]] |
| Ir a otro lado | `cd ~`, `cd ..`, `cd -` | [[cd]] |
| ¿Cuánto espacio queda? | `df -h` | — |
| ¿Qué pesa cada cosa? | `du -sh *` | — |

### Jerarquía del sistema (FHS)

| Ruta | Para qué se usa |
|---|---|
| `/` | Raíz del sistema, todo cuelga de aquí |
| `/etc/` | Configuración global (siempre en texto plano) |
| `/var/log/` | Logs del sistema (primer lugar al troubleshootear) |
| `/home/tu/` | Tus archivos personales, dotfiles, proyectos |
| `/tmp/` | Archivos temporales (se borran al reiniciar) |
| `/usr/bin/` | Ejecutables de programas instalados |

> Ver [[Filesystem Hierarchy Standard]] para la guía completa.

---

## 📁 Manipulación de archivos

| Tarea | Comando | Flag crítico |
|---|---|---|
| Copiar archivo | `cp origen destino` | `-r` para directorios, `-a` para preservar todo |
| Mover/renombrar | `mv origen destino` | — |
| Eliminar | `rm archivo` | ⚠️ `-rf` para eliminar directorios (¡peligroso!) |
| Crear carpeta | `mkdir nombre` | ✅ `-p` para crear padres intermedios |
| Crear archivo vacío | `touch archivo` | — |
| Crear enlace | `ln -s original enlace` | `-s` para simbólico (sin `-s` = hard link) |

> Ver las notas individuales: [[cp]] · [[mv]] · [[rm]] · [[mkdir]] · [[Touch y History]] · [[ln]]

### Peligros de `rm -rf`

```bash
# ⚠️ Este comando NO tiene vuelta atrás:
rm -rf /          # BORRA TODO EL SISTEMA
rm -rf ~          # BORRA TODO TU HOME
rm -rf /tmp/*     # puede borrar cosas importantes si otros procesos las usan

# Siempre verificar antes de ejecutar:
ls -la            # ¿esto es lo que quiero borrar?
pwd               # ¿estoy en el directorio correcto?
```

---

## 🔍 Búsqueda y exploración

| Tarea | Comando | Cuándo usarlo |
|---|---|---|
| Buscar archivos | `find ~ -name "*.md"` | Búsqueda precisa, en tiempo real |
| Buscar rápido | `locate .bashrc` | Búsqueda instantánea (base de datos) |
| Buscar texto en archivos | `grep "error" /var/log/*.log` | Encontrar palabras dentro de archivos |
| ¿Dónde está este ejecutable? | `which firefox` | Localizar un programa en el PATH |
| ¿Qué es este comando? | `type -a ls` | Ver si es builtin, alias, o externo |

> Ver: [[find]] — [[locate]] — [[grep]] — [[which]] — [[type]]

### grep básico

```bash
grep "texto" archivo              # buscar en un archivo
grep -ri "error" /var/log/       # recursivo + ignorar mayúsculas (el más usado)
grep -v "excluir" archivo         # invertir: líneas que NO contengan
grep -c "patrón" archivo          # contar coincidencias
comando | grep "algo"             # filtrar salida de otro comando
```

---

## ⚙️ Gestión de procesos

| Tarea | Comando | Señal |
|---|---|---|
| Ver procesos | `ps aux` | — |
| Monitor en vivo | `top` o `htop` | — |
| Terminar proceso | `kill <PID>` | SIGTERM (15) — permite limpieza |
| Forzar terminación | `kill -9 <PID>` | SIGKILL (9) — mata inmediato |
| Matar por nombre | `pkill firefox` | — |
| Buscar PID | `pgrep ssh` | — |

> Ver [[Procesos y Senales]] para más señales y estados.

### Jerarquía de señales

```
SIGTERM (15) → Intenta terminar limpiamente (el proceso decide)
SIGKILL (9)  → Mata inmediatamente (el proceso no puede ignorarlo)
SIGHUP  (1)  → Recargar configuración (útil para daemons)
SIGINT  (2)  = Ctrl+C → Interrumpir el proceso actual en la terminal
```

```bash
# Orden recomendado para matar un proceso:
kill <PID>           # 1. Intentar SIGTERM
sleep 3              # esperar 3 segundos
kill -9 <PID>        # 2. Si no responde, forzar SIGKILL
```

---

## 🔐 Permisos y propiedad

| Tarea | Comando | Ejemplo |
|---|---|---|
| Cambiar permisos | `chmod 755 script.sh` | Permisos numéricos (dueño:rwx, grupo:rx, otros:rx) |
| Añadir ejecución | `chmod +x script.sh` | Modo simbólico |
| Cambiar dueño | `chown usuario:grupo archivo` | Dueño y grupo |
| Ver permisos | `ls -l archivo` | — |
| Permisos por defecto | `umask 022` | Archivos nuevos: 755 (dirs) / 644 (files) |
| Sticky bit | `chmod +t /tmp` | Solo el dueño puede eliminar sus archivos |
| SUID | `chmod u+s programa` | Ejecutar con permisos del dueño |

### Permisos numéricos rápidos

| Número | Permisos | Uso típico |
|---|---|---|
| `777` | rwxrwxrwx | Archivos públicos (⚠️ inseguro) |
| `755` | rwxr-xr-x | Scripts, ejecutables |
| `700` | rwx------ | Scripts personales (solo tú) |
| `644` | rw-r--r-- | Archivos de texto normales |
| `600` | rw------- | Claves SSH, archivos sensibles |
| `400` | r-------- | Claves SSH privadas |

> Ver [[Permisos y Propietarios]] para sticky bit, SUID, ACLs y atributos extendidos.

---

## 📦 Gestor de paquetes (apt)

```bash
# Rutina diaria
sudo apt update           # actualizar lista de paquetes
sudo apt upgrade          # actualizar paquetes instalados

# Instalar y eliminar
sudo apt install htop     # instalar
sudo apt remove htop      # eliminar (deja config)
sudo apt purge htop       # eliminar todo (incluyendo config)
sudo apt autoremove       # limpiar dependencias huérfanas

# Buscar
apt search "editor"       # buscar paquetes
apt show vim              # información de un paquete
```

> Ver [[apt]] para comandos completos y troubleshooting.

---

## 🌐 Red básica

| Tarea | Comando |
|---|---|
| ¿Cuál es mi IP? | `ip -4 a` |
| ¿Está funcionando la red? | `ping -c 4 8.8.8.8` |
| ¿Qué puertos están abiertos? | `sudo ss -tulpn` |
| ¿Cuál es mi gateway? | `ip route \| grep default` |
| Descargar un archivo | `wget https://ejemplo.com/archivo` |
| Probar una API/web | `curl -I https://ejemplo.com` |

> Ver: [[ip]] — [[ss]] — [[ping]] — [[curl]] — [[wget]]

---

## 🔧 Resolución de problemas (checklist)

Cuando algo no funciona, sigue este orden:

```
1. ¿El comando existe?       → which comando
2. ¿Tengo permisos?         → ls -l /ruta ; whoami
3. ¿Hay espacio en disco?   → df -h
4. ¿El proceso está vivo?   → ps aux | grep nombre
5. ¿El puerto está abierto? → sudo ss -tulpn | grep :PUERTO
6. ¿Hay conectividad?       → ping -c 4 8.8.8.8
7. ¿Hay logs?               → journalctl -xe   o   tail -f /var/log/syslog
```

---

## 📋 Ver también

- [[Cheat Sheet - Comandos Esenciales]] — referencia rápida de todos los comandos
- [[Filesystem Hierarchy Standard]] — dónde va cada cosa
- [[La Shell]] — fundamentos de la terminal
- [[Rutas de Aprendizaje]] — prioridades del vault
- [[MoC - Linux]] — índice completo del vault

#indice #cli #prioridad1
