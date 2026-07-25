---
fecha_creacion: 2026-07-23
estado: resuelto
categoria: programa
prioridad: media
---

# Ansible

> Ansible es una herramienta de **gestión de configuración, automatización de TI y orquestación** que permite administrar cientos de servidores sin instalar agentes en ellos. Se conecta por SSH, ejecuta comandos y aplica configuraciones de forma declarativa. Complementa a Docker/Kubernetes en el stack DevOps.

## Definición

Ansible automatiza tareas repetitivas: instalar paquetes, copiar archivos de configuración, reiniciar servicios, desplegar aplicaciones, y mantener el estado deseado de los servidores. Es **declarativo**: describes *cómo quieres que sea el sistema* (no los pasos para llegar), y Ansible se encarga de alcanzar ese estado.

**Sin agentes**: a diferencia de Puppet/Chef/Salt, Ansible no necesita un software instalado en los nodos gestionados. Solo necesita SSH y Python 3 (que ya viene en toda distro moderna).

```
┌──────────────────────────────────────────────────┐
│                  Nodo de control                   │
│   (donde instalas Ansible, ejecutas comandos)      │
│                        │                           │
│     ┌──────────────────┼──────────────────┐        │
│     ▼                  ▼                  ▼        │
│  ┌──────┐          ┌──────┐          ┌──────┐     │
│  │ Host │   SSH    │ Host │   SSH    │ Host │     │
│  │   1  │ ◄─────── │   2  │ ◄─────── │   3  │     │
│  └──────┘          └──────┘          └──────┘     │
│            (sin agentes instalados)                │
└──────────────────────────────────────────────────┘
```

## Instalación

```bash
# Nodo de control (tu máquina local o un servidor de gestión)
sudo apt install ansible                    # Debian/Ubuntu
sudo pacman -S ansible                      # Arch
sudo dnf install ansible                    # Fedora

# Verificar
ansible --version
# ansible [core 2.16.0]
```

## Conceptos clave

| Concepto | Qué es | Ejemplo |
|---|---|---|
| **Inventory** | Lista de servidores a gestionar | `servidor1 ansible_host=192.168.1.10` |
| **Playbook** | Archivo YAML con la configuración deseada | `instalar-nginx.yml` |
| **Module** | Comando atómico que ejecuta Ansible (hay cientos) | `apt:`, `copy:`, `service:`, `template:` |
| **Task** | Una llamada a un módulo con sus parámetros | `- name: Install nginx\n  apt: name=nginx state=present` |
| **Role** | Conjunto reutilizable de tasks, templates, variables | `nginx/` (tasks, handlers, templates, vars) |
| **Handler** | Task que solo se ejecuta si otra task notifica un cambio | `- name: restart nginx` |
| **Fact** | Información del host recopilada automáticamente | `ansible_facts['os_family']` |

## Inventory

```ini
# /etc/ansible/hosts  o  ~/proyecto/inventory.ini

[webservers]
web1 ansible_host=192.168.1.10 ansible_user=admin
web2 ansible_host=192.168.1.11 ansible_user=admin

[database]
db1 ansible_host=192.168.1.20 ansible_user=admin
db2 ansible_host=192.168.1.21 ansible_user=admin

[production:children]    # grupo de grupos
webservers
database

[all:vars]               # variables para todos los hosts
ansible_python_interpreter=/usr/bin/python3
```

```yaml
# Formato YAML (preferido moderno)
# inventory.yml
all:
  hosts:
    localhost:
      ansible_connection: local
  children:
    webservers:
      hosts:
        web1:
          ansible_host: 192.168.1.10
        web2:
          ansible_host: 192.168.1.11
    database:
      hosts:
        db1:
          ansible_host: 192.168.1.20
```

## Primeros comandos (ad-hoc)

```bash
# Probar conexión (ping de Ansible — no ICMP, verifica SSH + Python)
ansible all -i inventory.ini -m ping

# Ejecutar un comando en todos los servidores
ansible all -i inventory.ini -m shell -a "uptime"

# Ver facts de un host
ansible localhost -m setup

# Instalar un paquete en webservers
ansible webservers -i inventory.ini -m apt -a "name=nginx state=present" --become

# Copiar un archivo
ansible webservers -i inventory.ini -m copy -a "src=./index.html dest=/var/www/html/index.html" --become
```

## Playbooks (el corazón de Ansible)

### Ejemplo 1: Instalar y configurar nginx

```yaml
# nginx-playbook.yml
---
- name: Configurar servidor web
  hosts: webservers
  become: yes                        # ejecutar como root (sudo)
  vars:
    http_port: 80
    server_name: midominio.com

  tasks:
    - name: Instalar nginx
      apt:
        name: nginx
        state: present
        update_cache: yes

    - name: Copiar configuración de nginx
      template:
        src: templates/nginx.conf.j2
        dest: /etc/nginx/sites-available/default
      notify: restart nginx           # notifica al handler si el archivo cambió

    - name: Asegurar que nginx esté corriendo
      service:
        name: nginx
        state: started
        enabled: yes

  handlers:                          # se ejecutan solo si son notificados
    - name: restart nginx
      service:
        name: nginx
        state: restarted
```

### Ejemplo 2: Hardening básico de servidor

```yaml
# hardening-playbook.yml
---
- name: Hardening básico de servidor
  hosts: all
  become: yes

  tasks:
    - name: Desactivar login root por SSH
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: '^PermitRootLogin'
        line: 'PermitRootLogin no'
      notify: restart ssh

    - name: Asegurar permisos de /etc/shadow
      file:
        path: /etc/shadow
        owner: root
        group: shadow
        mode: '0640'

    - name: Instalar fail2ban
      apt:
        name: fail2ban
        state: present

    - name: Configurar firewall básico (ufw)
      ufw:
        rule: allow
        port: '{{ item }}'
        proto: tcp
      loop:
        - '22'     # SSH
        - '80'     # HTTP
        - '443'    # HTTPS

  handlers:
    - name: restart ssh
      service:
        name: sshd
        state: restarted
```

## Roles (reutilización)

Un rol organiza playbooks en estructura de directorios estándar:

```
roles/
├── nginx/
│   ├── tasks/
│   │   └── main.yml          # las tareas del rol
│   ├── handlers/
│   │   └── main.yml          # handlers
│   ├── templates/
│   │   └── nginx.conf.j2     # plantillas Jinja2
│   ├── files/
│   │   └── index.html        # archivos estáticos
│   ├── vars/
│   │   └── main.yml          # variables del rol
│   ├── defaults/
│   │   └── main.yml          # valores por defecto (baja prioridad)
│   ├── meta/
│   │   └── main.yml          # dependencias del rol
│   └── README.md
```

```yaml
# playbook que usa roles
---
- name: Aplicar configuración completa
  hosts: all
  roles:
    - common                   # configuración base
    - nginx                    # servidor web
    - postgresql               # base de datos
```

## Ansible Galaxy (roles compartidos)

```bash
# Buscar roles en la comunidad
ansible-galaxy search nginx

# Instalar un rol desde Galaxy
ansible-galaxy install geerlingguy.nginx

# Listar roles instalados
ansible-galaxy list

# Crear estructura de rol nuevo
ansible-galaxy init mi-rol
```

## Módulos más usados

| Módulo | Función | Ejemplo |
|---|---|---|
| `apt` / `dnf` / `pacman` | Gestión de paquetes | `apt: name=nginx state=latest` |
| `copy` | Copiar archivo local al host | `copy: src=./app.conf dest=/etc/app/app.conf` |
| `template` | Copiar archivo con variables Jinja2 | `template: src=config.j2 dest=/etc/app/config` |
| `service` / `systemd` | Gestión de servicios | `service: name=nginx state=started enabled=yes` |
| `file` | Archivos y directorios, permisos | `file: path=/data state=directory mode=0755` |
| `lineinfile` | Editar línea específica en archivo | `lineinfile: path=/etc/ssh/sshd_config regexp='^Port' line='Port 2222'` |
| `user` | Gestión de usuarios | `user: name=deploy state=present groups=sudo` |
| `ufw` / `firewalld` | Configuración de firewall | `ufw: rule=allow port=443 proto=tcp` |
| `command` / `shell` | Ejecutar cualquier comando | `shell: uptime` |
| `docker_container` | Gestión de contenedores Docker | `docker_container: name=web image=nginx:latest state=started` |
| `git` | Clonar repositorios | `git: repo=https://github.com/user/repo.git dest=/opt/app` |
| `debug` | Imprimir valores (debugging) | `debug: msg="La IP es {{ ansible_default_ipv4.address }}"` |
| `wait_for` | Esperar a que un puerto esté abierto | `wait_for: port=80 host=localhost timeout=30` |

## Ansible + Docker / Kubernetes

Ansible no reemplaza a Docker/Kubernetes — los complementa:

```yaml
# Construir imagen Docker y desplegar con Ansible
- name: Desplegar con Docker Compose
  hosts: webservers
  tasks:
    - name: Clonar repositorio
      git:
        repo: https://github.com/org/mi-app.git
        dest: /opt/mi-app

    - name: Construir y levantar con Compose
      docker_compose:
        project_src: /opt/mi-app
        build: yes
        state: present
```

```yaml
# Ejemplo: desplegar en Kubernetes con Ansible
- name: Desplegar en Kubernetes
  hosts: localhost
  tasks:
    - name: Aplicar manifiesto Kubernetes
      kubernetes.core.k8s:
        state: present
        src: deployment.yml
        namespace: production
```

## Buenas prácticas

- **Playbooks idempotentes**: ejecutar dos veces debe dar el mismo resultado (los módulos de Ansible están diseñados para ser idempotentes)
- **Usar roles** para reutilizar configuraciones entre proyectos
- **Variables en `group_vars/` y `host_vars/`**, no hardcodeadas en los playbooks
- **Cifrar secretos con `ansible-vault`**: `ansible-vault encrypt group_vars/all/vault.yml`
- **Probar en staging** antes de ejecutar en producción (usar `--check` para dry-run)
- **Versionar playbooks y roles en Git** (`ansible-galaxy init` crea estructura de repo)
- **Usar tags** para ejecutar subsets de tareas: `ansible-playbook playbook.yml --tags "nginx,config"`

## Ver también

- [[Docker]] — orquestación de contenedores (complementario a Ansible)
- [[Kubernetes]] — orquestación a gran escala
- [[SSH]] — Ansible se conecta por SSH, necesita claves configuradas
- [[Backups (borg restic duplicity rsync)]] — automatizar backups con Ansible
- [[Monitorización (Prometheus node_exporter)]] — desplegar monitoreo con Ansible

## Enlaces externos

- [Wikipedia — Ansible](https://en.wikipedia.org/wiki/Ansible_(software))
- [Sitio oficial — Ansible](https://www.ansible.com/)
- [GitHub — ansible/ansible](https://github.com/ansible/ansible)
- [Documentación — docs.ansible.com](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/)

#programa #devops
