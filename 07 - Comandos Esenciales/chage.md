---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-27
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

## Salida de `chage -l`

```bash
$ sudo chage -l carlos
Last password change                                    : jul 27, 2026
Password expires                                        : oct 25, 2026
Password inactive                                       : nov 24, 2026
Account expires                                         : never
Minimum number of days between password change          : 7
Maximum number of days between password change          : 90
Number of days of warning before password expires       : 14
```

## Relación con /etc/shadow

El comando `chage` modifica los campos del archivo `/etc/shadow`:

```bash
# /etc/shadow
# usuario:contraseña:último_cambio:mín:máx:aviso:inactividad:expiracion:reservado
carlos:$y$j9T$...:19998:7:90:14:30::
```

| Campo | Posición | Corresponde a |
|---|---|---|
| `último_cambio` | 3 | Días desde 1970-01-01 del último cambio (`-d`) |
| `mín` | 4 | Días mínimos entre cambios (`-m`) |
| `máx` | 5 | Días máximos entre cambios (`-M`) |
| `aviso` | 6 | Días de aviso (`-W`) |
| `inactividad` | 7 | Días de inactividad tras expirar (`-I`) |
| `expiracion` | 8 | Días desde 1970-01-01 de expiración de cuenta (`-E`) |

## Auditoría de caducidad (script)

```bash
# Script para listar cuentas con contraseña próxima a expirar
for user in $(awk -F: '$3 >= 1000 {print $1}' /etc/passwd); do
  expires=$(chage -l "$user" | grep "Password expires" | awk -F: '{print $2}')
  echo "$user: $expires"
done | column -t -s ':'

# Cuentas que expiran en los próximos 7 días
warn_if_expiring() {
  for user in $(who | awk '{print $1}' | sort -u); do
    if ! passwd -S "$user" | grep -q "P"; then
      echo "⚠️  $user: contraseña no configurada o caducada"
    fi
  done
}
```

## Casos de uso

| Escenario | Comando |
|---|---|
| Forzar cambio de contraseña en próximo login | `sudo chage -d 0 usuario` |
| Crear cuenta temporal (expira en 30 días) | `sudo useradd -e $(date +%F -d '+30 days') tempuser` |
| Auditoría semanal de caducidad | `for u in $(who \| awk '{print $1}'); do chage -l "$u" \| grep "Password expires"; done` |
| Bloquear cuenta inactiva tras 90 días sin cambio | `sudo chage -I 90 -M 90 usuario` |
| Cuenta de servicio sin caducidad | `sudo chage -M -1 usuario` (deshabilitar expiración) |
| Sin aviso de expiración | `sudo chage -W 0 usuario` |

## Archivo de configuración global

```bash
# /etc/login.defs
PASS_MAX_DAYS   99999    # días máximo entre cambios
PASS_MIN_DAYS   0        # días mínimo entre cambios
PASS_WARN_AGE   7        # días de aviso
```

> Los valores de `/etc/login.defs` aplican a usuarios **nuevos** creados con `useradd`. Para usuarios existentes, usar `chage` directamente.

## Ver también

- [[PAM]] — módulos de autenticación (pam_pwquality, pam_faillock)
- [[passwd]] — cambiar contraseña
- [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — índice

## Enlaces externos

- [Wikipedia — chage](https://en.wikipedia.org/wiki/Chage)
- [man7 — chage](https://man7.org/linux/man-pages/man1/chage.1.html)

#comando #usuarios
