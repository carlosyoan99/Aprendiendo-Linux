---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-27
estado: resuelto
categoria: comando
prioridad: baja
---

# chsh — Cambiar shell por defecto

Cada usuario tiene un shell por defecto definido en `/etc/passwd`. `chsh` permite cambiarlo sin editar el archivo manualmente.

## Sintaxis

```
chsh -s /ruta/al/shell [usuario]
```

Sin argumentos, `chsh` muestra un prompt interactivo para escribir la ruta del shell.

## Opciones

| Opción | Descripción |
|---|---|
| `-s RUTA` | Especificar el shell (requiere ruta absoluta) |
| `-l` | Listar shells disponibles (equivale a `cat /etc/shells`) |
| `-h` | Ayuda |
| `-u` | No usa (obsoleto) |

## Ejemplos

```bash
# Ver shells disponibles
cat /etc/shells
# /bin/bash
# /bin/zsh
# /bin/fish
# /usr/bin/fish

# Cambiar shell (usuario actual)
chsh -s /usr/bin/zsh

# Cambiar shell de otro usuario (solo root)
sudo chsh -s /usr/bin/fish maria

# Verificar
grep maria /etc/passwd
# maria:x:1001:1001::/home/maria:/usr/bin/fish

# Prompt interactivo
chsh
# Cambiando el shell para carlos.
# Contraseña:
# Nuevo valor: /usr/bin/zsh
```

## Validaciones de seguridad

```bash
# Si un shell no está en /etc/shells, chsh da error:
chsh -s /opt/custom-shell/bin/mybash
# chsh: "/opt/custom-shell/bin/mybash" is not listed in /etc/shells.
# chsh: /opt/custom-shell/bin/mybash is an invalid shell.

# Para permitir shells no listados (root):
sudo chsh -s /opt/custom-shell/bin/mybash  # root no tiene esta restricción

# Añadir un shell a /etc/shells:
echo "/opt/custom-shell/bin/mybash" | sudo tee -a /etc/shells
```

## Relación con /etc/passwd

```bash
# /etc/passwd (último campo = shell)
carlos:x:1000:1000:Carlos:/home/carlos:/bin/bash
maria:x:1001:1001:Maria,,,:/home/maria:/usr/bin/fish

# Editar manualmente (alternativa a chsh):
sudo usermod -s /usr/bin/zsh carlos
sudo vipw                          # editor seguro para /etc/passwd
```

## Casos de uso

| Escenario | Comando |
|---|---|
| Cambiar a zsh para el usuario actual | `chsh -s $(which zsh)` |
| Cambiar a fish para un usuario específico | `sudo chsh -s /usr/bin/fish maria` |
| Aplicar bash a todos los usuarios existentes | `for u in $(getent passwd \| awk -F: '$3 >= 1000 {print $1}'); do sudo chsh -s /bin/bash "$u"; done` |
| Verificar shell actual de un usuario | `getent passwd carlos \| cut -d: -f7` |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `chsh: Shell not changed` | Shell no existe o ruta incorrecta | Verificar ruta: `which zsh` o `ls /usr/bin/zsh` |
| `is an invalid shell` | Shell no listado en /etc/shells | Añadirlo o usar sudo |
| `You may not change the shell for` | Sin permisos | Usar `sudo` o pedir al admin |
| El cambio no se refleja | Sesión no reiniciada | Cerrar sesión y volver a entrar, o `exec $SHELL -l` |
| `user 'xxx' does not exist` | Usuario no existe | Verificar con `id usuario` |

## Ver también

- [[PAM]] — módulos de autenticación
- [[Shells (bash zsh fish)]] — shells disponibles
- [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — índice

## Enlaces externos

- [man7 — chsh](https://man7.org/linux/man-pages/man1/chsh.1.html)

#comando #usuarios
