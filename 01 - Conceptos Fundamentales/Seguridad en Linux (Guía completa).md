---
fecha_creacion: 2026-07-20
fecha_modificacion: 2026-07-20
estado: resuelto
categoria: concepto
prioridad: alta
---

# Seguridad en Linux (Guía completa)

> Guía de ciberseguridad para recién llegados a Linux. Cubre desde la filosofía de seguridad hasta configuración práctica de firewall, SSH, cifrado, monitoreo y backups.

---

## Prólogo: ¿Por qué esta guía y para quién es?

Has dado el salto a Linux. Bienvenido al club de los que prefieren libertad, control y terminales negras con letras verdes. Pero seguro que, entre carpeta y carpeta, te ha asaltado una duda incómoda: *"¿Y si me hackean? ¿Esto es realmente seguro?"*

La realidad es que Linux es como un coche deportivo sin airbags. Es potente, rápido y te da control total sobre el motor. Pero si conduces sin cinturón y con los ojos cerrados, el accidente no es culpa del coche.

Esta guía no va a convertirte en un hacker con gafas de sol por la noche. Tampoco vamos a hablar de exploits avanzados ni de ingeniería inversa. **Esto es una guía de supervivencia.** Está escrita para el usuario que viene de Windows, que sabe lo que es un antivirus, pero que nunca ha tenido que preocuparse por los permisos de un archivo.

Aquí aprenderás a ponerle candado a tu nueva casa antes de que los amigos de lo ajeno se den cuenta de que has dejado la puerta abierta. Lo haremos con calma, con ejemplos prácticos y, sobre todo, sin asustarte. Porque la seguridad no es un destino, es una rutina. Y vamos a construir la tuya desde el primer minuto.

---

## Introducción: Tu primer Linux, bienvenido pero con precaución

**Escuchaste que Linux es invulnerable. Mentira.**

Ese mito ha dejado más sistemas comprometidos que cualquier virus de Windows. La seguridad en Linux no viene de serie; se construye. Y el problema no suele ser el sistema en sí, sino la silla que hay entre el teclado y la pantalla.

**¿Qué vas a obtener exactamente al terminar de leer esto?**

- **Mentalidad de defensa:** vas a entender por qué hacer las cosas "bien" te ahorra dolores de cabeza mañana.
- **Control total:** sabrás exactamente quién puede hacer qué en tu ordenador (y cómo evitar que el sistema haga lo que no debe).
- **Pasos concretos:** no teoría vacía. Vas a tocar la terminal, vas a configurar firewalls y vas a cifrar cosas. Todo explicado paso a paso.

---

## Capítulo 1: Filosofía de la seguridad en Linux

Si llevas un par de días en Linux, seguro que has oído eso de *"no uses root"*. Y probablemente has pensado: *"¿Por qué no voy a usar el administrador si me da todos los permisos?"*. Pues porque tener todos los permisos es justo el problema.

Imagina que trabajas en una oficina y tienes una llave maestra que abre todas las puertas, incluida la caja fuerte de los sueldos. Es muy cómoda. Pero si la pierdes o alguien te la roba, el desastre está servido. **Esa llave maestra es el usuario `root`.**

Linux está construido sobre tres pilares fundamentales en seguridad:

### 1. El principio de privilegio mínimo

*"Solo dale a cada persona (o programa) los permisos que necesita para hacer su trabajo, y ni uno más."*

Tu usuario normal no necesita instalar software todo el tiempo. Tu navegador no necesita leer tus archivos de contraseñas. Y tu reproductor de música no necesita acceso a tu disco duro entero.

Cuando ejecutas algo con `sudo`, le estás diciendo al sistema: *"Confío en esto, déjame hacerlo aunque sea peligroso."* Por eso, la regla de oro es: **Si no sabes para qué sirve exactamente ese `sudo`, no lo ejecutes.**

### 2. La defensa en profundidad

Los sistemas Linux se protegen por capas. Si falla una, aún tienes las otras:

- **Capa 1:** Contraseña fuerte y segura.
- **Capa 2:** Permisos de archivos (quién puede leer/escribir).
- **Capa 3:** Firewall (quién puede entrar desde fuera).
- **Capa 4:** Actualizaciones de seguridad.

### 3. Actualizar no es opcional

En Linux, la mayoría de las actualizaciones de seguridad se aplican en segundos y no requieren reiniciar (salvo actualizaciones de kernel).

**Dato:** La mayoría de los ataques exitosos a servidores Linux ocurren porque el administrador no aplicó un parche que llevaba meses disponible. Los atacantes no son genios; son personas que leen los boletines de seguridad y buscan máquinas descuidadas.

### Ejercicios

```bash
whoami                     # ¿quién eres?
id                         # tu UID (1000 = normal, 0 = root)
cat /etc/shadow            # "Permission denied" (sin sudo)
sudo cat /etc/shadow       # con sudo SÍ ves la DB de contraseñas
```

---

## Capítulo 2: Instalación limpia y primeras decisiones

### Elegir la distribución

Para un novato que se preocupa por la seguridad:

- **[[Ubuntu]] LTS**: el estándar. Soporte 5 años, actualizaciones constantes.
- **[[Linux Mint]]**: basado en Ubuntu, escritorio similar a Windows.

### Lo que NO hay que hacer

- ❌ Copiar y pegar comandos con `sudo` que no entiendes
- ❌ Añadir PPAs externos a la ligera — cada uno es una vía de acceso
- ❌ Descargar ISOs de sitios no oficiales

### Lo que SÍ hay que hacer nada más instalar

```bash
# 1. Actualizar todo
sudo apt update && sudo apt upgrade -y

# 2. Activar firewall
sudo ufw enable
sudo ufw status verbose
```

### Ejercicios

```bash
lsb_release -a                            # ¿versión LTS?
sudo ufw enable && sudo ufw status verbose # activar firewall
passwd                                     # cambiar contraseña
ls /etc/apt/sources.list.d/               # repositorios externos
```

**Ver también:** [[Proceso de Instalacion General]], [[Post-Instalacion Checklist]], [[Firewall]]

---

## Capítulo 3: Contraseñas y autenticación

### Frases de paso

Una contraseña como `P@ssw0rd` se descifra en minutos. Una frase como `mi-perro-se-llama-chispa` (26 caracteres) tardaría siglos. **La longitud es tu mejor amiga.**

### Gestores de contraseñas

| Programa | Descripción | Instalación |
|---|---|---|
| **KeePassXC** | Local, gratuito, código abierto | `sudo apt install keepassxc` |
| **Bitwarden** | Nube + extensión navegador | `snap install bitwarden` |

### Autenticación de dos factores (2FA)

```bash
sudo apt install libpam-google-authenticator -y
google-authenticator
# Responde: y, y, n, n, y
```

Escanea el QR con **Google Authenticator** o **Aegis** (open source). Guarda los códigos de recuperación en tu gestor de contraseñas.

**Integrar con login:**

```bash
sudo nano /etc/pam.d/common-auth
# Añadir: auth required pam_google_authenticator.so
```

> **⚠️** Prueba con una sesión abierta que no cierres. Para un novato, recomiendo 2FA solo en SSH, no en el escritorio diario.

### Ejercicios

```bash
sudo apt install keepassxc -y            # instalar gestor
# Configurar 2FA (bajo tu responsabilidad)
passwd                                    # cambiar contraseña
sudo passwd --expire nombre_usuario       # forzar cambio en otro usuario
```

**Ver también:** [[Gestión de usuarios avanzada (PAM chage skel chsh)]], [[SSH]]

---

## Capítulo 4: Usuarios, grupos y permisos

Linux no es como Windows, donde a menudo todo vale con tal de que tengas la sesión abierta. Aquí cada archivo, carpeta y proceso tiene un dueño y una lista de invitados.

### La trinidad: r, w, x

- **r (read):** ¿puedes ver el contenido?
- **w (write):** ¿puedes modificar o borrar?
- **x (execute):** ¿puedes ejecutarlo?

```bash
ls -l
# -rw-r--r-- 1 juan juan 1024 jul 20 10:00 texto.txt
#  ^^^  ^^^  ^^^
#  dueño grupo otros
```

### El peligro del `chmod 777`

`777` da todos los permisos a todo el mundo. **No lo hagas.**

| Tipo | Permiso recomendado |
|---|---|
| Archivos normales | `644` |
| Carpetas y scripts | `755` |
| Archivos privados | `600` / `700` |

### Comandos prácticos

```bash
chmod 700 script.sh        # solo tú, todo
chmod 644 config.conf      # tú escribes, otros leen
chmod u+x archivo          # añade ejecución al dueño
sudo chown usuario:grupo archivo.txt
sudo groupadd proyecto
sudo usermod -aG proyecto juan
```

### umask — permisos por defecto

```bash
umask 022                   # default: archivos 644, carpetas 755
umask 077                   # modo paranoico: solo tú
```

### Ejercicios

```bash
ls -la ~                    # identificar permisos
chmod 700 ~/privado         # carpeta privada
sudo groupadd prueba && sudo chown :prueba archivo
```

**Ver también:** [[Permisos y Propietarios]], [[ACLs]], [[chmod]], [[chown]], [[adduser]]

---

## Capítulo 5: Firewall con UFW

El firewall es tu portero: decide quién puede llamar a tu puerta.

### Activar

```bash
sudo ufw enable
```

### Reglas comunes

```bash
sudo ufw allow ssh                     # puerto 22
sudo ufw allow 80/tcp                  # HTTP
sudo ufw allow 443/tcp                 # HTTPS
sudo ufw deny 22/tcp                   # denegar puerto
sudo ufw status verbose                # ver estado
sudo ufw status numbered               # reglas numeradas
sudo ufw delete 2                      # borrar regla nº2
sudo ufw allow from 192.168.1.100      # IP específica
sudo ufw limit ssh                     # limitar intentos (anti-fuerza bruta)
```

### Interfaz gráfica

```bash
sudo apt install gufw
```

**Ver también:** [[Firewall]], [[nftables]]

---

## Capítulo 6: SSH seguro

SSH te permite acceder remotamente a tu equipo, pero es una de las puertas más atacadas.

### Instalación

```bash
sudo apt install openssh-server -y
sudo systemctl status ssh
```

### Configuración endurecida (`/etc/ssh/sshd_config`)

```ini
Port 2222                     # cambiar puerto (reduce ruido automático)
PermitRootLogin no            # ❌ nunca permitir root
PasswordAuthentication no     # solo claves (tras configurarlas)
AllowUsers juan maria         # solo estos usuarios
ClientAliveInterval 300       # timeout de inactividad
LogLevel VERBOSE              # logs detallados
```

### Autenticación por clave pública

```bash
ssh-keygen -t ed25519 -C "tu@email.com"
ssh-copy-id -p 2222 usuario@servidor
```

### Probar

```bash
ssh -p 2222 usuario@ip
sudo ufw allow 2222/tcp
```

### Monitorear intentos

```bash
sudo tail -f /var/log/auth.log
```

### Fail2ban — anti fuerza bruta

```bash
sudo apt install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
# editar jail.local: [sshd] enabled = true
sudo systemctl restart fail2ban
sudo fail2ban-client status sshd
```

**Ver también:** [[SSH]], [[fail2ban]]

---

## Capítulo 7: Actualizaciones

### Comandos base

```bash
sudo apt update              # actualiza catálogo
sudo apt upgrade -y          # instala actualizaciones
sudo apt list --upgradable   # qué se puede actualizar
```

### Actualizaciones automáticas de seguridad

**Un matiz importante:** `sudo apt upgrade` instala **todas** las actualizaciones disponibles (seguridad y funcionalidades), no solo las de seguridad. Para un usuario de escritorio, ejecutar `upgrade` completo una vez a la semana es seguro y más simple que separar ambos tipos manualmente. Pero si quieres automatizar **solo** parches de seguridad, ahí entra la siguiente herramienta:

```bash
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

Esto instala automáticamente, cada día, **solo las actualizaciones del repositorio de seguridad** — sin que tengas que hacer nada. Puedes revisar el detalle en `/etc/apt/apt.conf.d/50unattended-upgrades`. Es la herramienta que sí sabe distinguir entre parches de seguridad y el resto.

### Rutina recomendada

1. Activa `unattended-upgrades` para parches automáticos
2. Una vez a la semana: `sudo apt update && sudo apt upgrade -y`
3. Reiniciar tras actualización de kernel
4. Snap y Flatpak se actualizan solos

```bash
snap refresh                  # actualizar snaps manualmente
flatpak update                # actualizar flatpaks
```

**Ver también:** [[apt]], [[Gestores de Paquetes]]

---

## Capítulo 8: Antivirus y antimalware

"Linux no tiene virus" es un mito. Existen, aunque son menos comunes.

### ¿Instalo antivirus?

Para un usuario de escritorio cuidadoso, no es estrictamente necesario. Considéralo si compartes archivos con usuarios de Windows o administras un servidor.

### ClamAV

```bash
sudo apt install clamav clamav-daemon clamtk -y
sudo freshclam                          # actualizar firmas
clamscan -r --bell -i ~/               # escanear home
```

### Rootkits

```bash
sudo apt install chkrootkit rkhunter
sudo chkrootkit
sudo rkhunter --check
```

### El mejor antivirus

No ejecutar comandos que no entiendes, no instalar de fuentes desconocidas, no abrir enlaces sospechosos. Eso cubre el 99% de las amenazas para un escritorio Linux.

**Ver también:** [[Malware en Linux]]

---

## Capítulo 9: Cifrado

### Cifrado de disco completo (LUKS)

Si al instalar marcaste "Cifrar el disco", ya tienes el mejor blindaje. Si no, toca reinstalar o cifrar archivos sueltos.

### Cifrar USB/partición con LUKS

⚠️ **Borra todos los datos del dispositivo.**

```bash
sudo apt install cryptsetup -y
sudo cryptsetup luksFormat /dev/sdb1
sudo cryptsetup open /dev/sdb1 mi_usb
sudo mkfs.ext4 /dev/mapper/mi_usb
sudo mount /dev/mapper/mi_usb /mnt
# ... usar ...
sudo umount /mnt
sudo cryptsetup close mi_usb
```

### Cifrado de archivos con GPG

```bash
gpg -c secreto.txt                           # cifrar (pide contraseña)
gpg -d secreto.txt.gpg > recuperado.txt      # descifrar
```

### Cifrado de carpetas

```bash
sudo apt install encfs -y
encfs ~/cifrado ~/visible                   # modo paranoico (p)
fusermount -u ~/visible                     # cerrar
```

> **Nota:** EncFS tiene debilidades de seguridad conocidas desde 2014 (fugas de metadatos). Para documentos realmente sensibles, considera **gocryptfs** o **VeraCrypt**.

### Regla de oro

El cifrado no tiene botón de "olvidé mi contraseña". Si pierdes la clave de LUKS o GPG, tus datos desaparecen para siempre.

**Ver también:** [[Cifrado (LUKS dm-crypt GPG)]]

---

## Capítulo 10: Navegación segura y privacidad

### Configuración mínima del navegador

- **Firefox**: *Preferencias > Privacidad > Protección contra rastreo* → Estricto
- **Cookies**: borrar al cerrar el navegador
- **HTTPS-only**: activar modo forzado (nativo en Firefox y Chrome)

### Extensiones recomendadas

| Extensión | Propósito |
|---|---|
| **uBlock Origin** | Bloqueo de anuncios, rastreadores y scripts maliciosos |
| **Privacy Badger** | (EFF) Aprende y bloquea rastreadores automáticamente |
| **Bitwarden** | Gestor de contraseñas en el navegador |

### VPN

Usa VPN en Wi-Fi públicas. Recomendadas: **Mullvad**, **ProtonVPN**, **IVPN**.

```bash
curl ifconfig.me          # ver IP antes y después de conectar VPN
```

### Tor

```bash
sudo apt install torbrowser-launcher -y
```

**Ver también:** [[Firefox]], [[Navegadores Web]]

---

## Capítulo 11: Monitoreo básico

### htop

```bash
sudo apt install htop -y && htop
```

Vigila procesos que consuman CPU al 100% sin motivo.

### Conexiones de red

```bash
ss -tulpn              # puertos escuchando
ss -tupn | grep ESTAB  # conexiones activas
```

### Logs

```bash
sudo tail -f /var/log/auth.log           # intentos de login
journalctl -xe                            # últimas entradas
journalctl --since "1 hour ago" -u ssh    # logs de SSH
```

### Rutina recomendada

1. Diario: vistazo a `htop`
2. Semanal: `ss -tulpn`
3. Ante lentitud: `journalctl -xe`
4. Sospecha: revisar `auth.log`

**Ver también:** [[htop btop]], [[ss]], [[journalctl]], [[fail2ban]], [[auditd]]

---

## Capítulo 12: Copias de seguridad

La copia de seguridad no es "por si acaso"; es el plan definitivo.

### Estrategia 3-2-1

- **3 copias** de tus datos
- **2 soportes diferentes** (disco externo + nube)
- **1 copia fuera de casa**

### Timeshift (copias del sistema)

```bash
sudo apt install timeshift -y
sudo timeshift-gtk
```

Configura: tipo RSYNC, ubicación externa, diaria + semanal.

### Deja Dup (archivos personales)

```bash
sudo apt install deja-dup -y
```

Configura: ubicación (disco externo / nube), carpetas a incluir, automático diario.

### rsync (manual)

```bash
rsync -avh --delete /home/tu_usuario/ /media/disco_externo/backup/
```

### Lo más importante

Prueba la restauración. Un backup que nunca se ha restaurado es un backup en el que no puedes confiar.

**Ver también:** [[Backups (borg restic duplicity rsync)]], [[timeshift]]

---

## Capítulo 13: Errores comunes del novato

1. **`rm -rf /`** — borra el disco entero. Usa `rm -ri` para ir con cuidado.
2. **Software de fuentes no oficiales** — usa `apt` o Snap/Flatpak.
3. **Misma contraseña en todos lados** — gestor de contraseñas.
4. **SSH con puerto 22 y root permitido** — cambiar puerto, PermitRootLogin no, claves, Fail2ban.
5. **Ignorar actualizaciones** — unattended-upgrades + revisión semanal.
6. **Copiar y pegar comandos sin entenderlos** — desconfía de `curl | bash`.
7. **No hacer backups** — Timeshift + Deja Dup.
8. **No bloquear la pantalla** — `Super + L`.
9. **Montar particiones Windows con permisos de escritura** — usa `ro` si solo lees.
10. **Confiar en que "Linux es seguro por defecto"** — no lo es. Tú lo configuras.

---

## Anexo A: Checklist de seguridad

**Sistema:**
- [ ] Distribución LTS instalada
- [ ] Cifrado de disco activado
- [ ] Usuario normal (no root)
- [ ] Contraseña: frase larga (mínimo 15 caracteres)

**Actualizaciones:**
- [ ] `sudo apt update && sudo apt upgrade -y` ejecutado
- [ ] `unattended-upgrades` activado
- [ ] Revisión semanal manual programada

**Firewall:**
- [ ] `sudo ufw enable` → active
- [ ] Solo los puertos necesarios abiertos

**SSH (si aplica):**
- [ ] Puerto cambiado (ej. 2222)
- [ ] `PermitRootLogin no`
- [ ] Autenticación por clave pública
- [ ] Fail2ban activo

**Permisos:**
- [ ] Grupos correctos asignados
- [ ] Permisos: 700 carpetas personales, 644 archivos

**Navegación:**
- [ ] Modo HTTPS-only activado
- [ ] uBlock Origin + Privacy Badger
- [ ] Gestor de contraseñas configurado

**Cifrado:**
- [ ] Archivos sensibles cifrados (GPG)
- [ ] USBs cifrados (LUKS)

**Copias de seguridad:**
- [ ] Timeshift configurado
- [ ] Deja Dup configurado
- [ ] Restauración probada

---

## Anexo B: Guía rápida de comandos

```bash
# Actualizaciones
sudo apt update && sudo apt upgrade -y
sudo apt autoremove

# Firewall
sudo ufw enable && sudo ufw status verbose
sudo ufw allow 2222/tcp
sudo ufw deny 22/tcp

# Permisos
chmod 700 archivo && chmod 644 archivo
chown usuario:grupo archivo

# SSH
ssh-keygen -t ed25519
ssh-copy-id -p 2222 usuario@ip
ssh -p 2222 usuario@ip

# Monitoreo
htop && ss -tulpn
sudo tail -f /var/log/auth.log
journalctl -xe
sudo fail2ban-client status sshd

# Cifrado
gpg -c archivo.txt
gpg -d archivo.gpg > original.txt
sudo cryptsetup luksFormat /dev/sdX
sudo cryptsetup open /dev/sdX nombre

# Backups
sudo timeshift --create
rsync -avh --delete /fuente/ /destino/

# Red
curl ifconfig.me
ping -c 4 google.com
```

---

## Ver también

- [[Firewall]] — cortafuegos con UFW y nftables
- [[SSH]] — acceso remoto seguro
- [[Permisos y Propietarios]] — chmod, chown, umask
- [[Cifrado (LUKS dm-crypt GPG)]] — cifrado de disco y archivos
- [[fail2ban]] — anti fuerza bruta
- [[Backups (borg restic duplicity rsync)]] — estrategias de backup
- [[Malware en Linux]] — virus, rootkits y cómo protegerse
- [[Gestión de usuarios avanzada (PAM chage skel chsh)]] — PAM, 2FA
- [[Proceso de Instalacion General]] — particionado y elección de SO
- [[Post-Instalacion Checklist]] — primeros pasos tras instalar
- [[Gestores de Paquetes]] — apt, snap, flatpak
- [[Navegadores Web]] — privacidad y extensiones
- [[timeshift]] — instantáneas del sistema

## Enlaces externos

- [Ubuntu Security Documentation](https://ubuntu.com/security)
- [Arch Linux Wiki — Security](https://wiki.archlinux.org/title/Security)
- [KeePassXC](https://keepassxc.org/)
- [Bitwarden](https://bitwarden.com/)
- [ClamAV](https://www.clamav.net/)
- [Fail2ban](https://www.fail2ban.org/)
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
- [Mozilla Observatory](https://observatory.mozilla.org/)

---

## Anexo C: Recursos recomendados para seguir aprendiendo

**Libros:**
- *"Linux Bible"* — Christopher Negus.
- *"The Linux Command Line"* — William Shotts (gratuito en línea).
- *"Cybersecurity – Attack and Defense Strategies"* — Yuri Diogenes.

**Documentación oficial:**
- [Ubuntu Security Documentation](https://ubuntu.com/security)
- [Arch Wiki — Security](https://wiki.archlinux.org/title/Security) (aplicable a cualquier distro)

**Comunidades:**
- r/linux4noobs, r/linuxquestions, Ask Ubuntu

**Herramientas para seguir explorando:**
- Wireshark (análisis de tráfico de red)
- VeraCrypt / gocryptfs (cifrado más moderno que EncFS)
- WireGuard / OpenVPN (montar tu propia VPN)

**Aprendizaje práctico:**
- [Linux Journey](https://linuxjourney.com/)
- [OverTheWire – Bandit](https://overthewire.org/wargames/bandit/) (juego de terminal para practicar seguridad)

---

*Esta guía ha sido escrita para ti, que has dado el salto a Linux y quieres sentirte seguro, no solo protegido. La seguridad no es un complemento, es una forma de usar el sistema. Ahora cierra esto, abre tu terminal, y sigue explorando.*

#concepto #seguridad
