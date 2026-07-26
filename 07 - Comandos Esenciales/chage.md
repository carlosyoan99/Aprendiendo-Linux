---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: comando
prioridad: media
---

# chage — Caducidad de contraseñas

Gestiona la caducidad de contraseñas de usuarios del sistema. Forma parte del paquete `shadow`.

## Sintaxis

```
chage [opciones] usuario
```

## Opciones principales

| Opción | Descripción |
|---|---|
| `-l` | Listar información de caducidad |
| `-M días` | Máximo días entre cambios (expiración) |
| `-m días` | Mínimo días entre cambios |
| `-W días` | Días de aviso antes de expirar |
| `-I días` | Inactivar cuenta N días tras expirar |
| `-E YYYY-MM-DD` | Fecha de expiración de la cuenta |
| `-d 0` | Forzar cambio en el próximo login |

## Ejemplos

```bash
chage -l carlos                           # ver info de caducidad

sudo chage -M 90 carlos                   # expira en 90 días
sudo chage -m 7 carlos                    # mínimo 7 días entre cambios
sudo chage -W 14 carlos                   # avisar 14 días antes
sudo chage -I 30 carlos                   # inactivar 30 días tras expirar
sudo chage -E 2026-12-31 carlos           # cuenta expira el 31 dic 2026

sudo chage -d 0 carlos                    # forzar cambio en próximo login
```

## Archivo de configuración global

```bash
# /etc/login.defs
PASS_MAX_DAYS   99999    # días máximo entre cambios
PASS_MIN_DAYS   0        # días mínimo entre cambios
PASS_WARN_AGE   7        # días de aviso
```

## Ver también

- [[PAM]] — módulos de autenticación
- [[passwd]] — cambiar contraseña
- [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — índice

## Enlaces externos

- [Wikipedia — chage](https://en.wikipedia.org/wiki/Chage)
- [man7 — chage](https://man7.org/linux/man-pages/man1/chage.1.html)

#comando #usuarios
