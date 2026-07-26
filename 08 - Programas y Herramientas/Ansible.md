---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: media
---

# Ansible

> Motor de automatización IT: configuración de servidores, despliegue de aplicaciones, orquestación. Agente-less (SSH), idempotente, YAML como lenguaje de definición.

## Qué es

Ansible es una herramienta de automatización IT que permite configurar servidores, desplegar aplicaciones y orquestar infraestructura. No requiere agentes instalados en los nodos objetivo (usa SSH). Los "playbooks" son archivos YAML que definen el estado deseado de los sistemas.

| Característica | Detalle |
|---|---|
| **Paradigma** | Agentless (solo SSH) |
| **Lenguaje** | YAML (playbooks) |
| **Idempotente** | Ejecutar múltiples veces = mismo resultado |
| **Módulos** | 2000+ (system, network, cloud, etc.) |
| **Inventario** | Archivos INI/YAML o dinámico |
| **Vault** | Cifrado de secretos integrado |

## Instalación

```bash
# pip (recomendado)
pip install ansible

# Arch Linux
sudo pacman -S ansible

# Debian/Ubuntu
sudo apt install ansible

# Verificar
ansible --version
```

## Conceptos clave

### Inventario

Define los hosts que Ansible gestiona:

```ini
# /etc/ansible/hosts (INI)
[webservers]
web1.example.com
web2.example.com

[dbservers]
db1.example.com

[all:vars]
ansible_user=deploy
ansible_ssh_private_key_file=~/.ssh/deploy_key
```

### Playbooks

Archivos YAML que definen tareas:

```yaml
# deploy-web.yml
---
- name: Configurar servidor web
  hosts: webservers
  become: yes
  
  vars:
    http_port: 80
    max_clients: 200
  
  tasks:
    - name: Instalar nginx
      apt:
        name: nginx
        state: present
        update_cache: yes
    
    - name: Copiar configuración
      template:
        src: templates/nginx.conf.j2
        dest: /etc/nginx/nginx.conf
      notify: Restart nginx
    
    - name: Asegurar que nginx está activo
      service:
        name: nginx
        state: started
        enabled: yes
  
  handlers:
    - name: Restart nginx
      service:
        name: nginx
        state: restarted
```

### Roles

Estructura reutilizable de playbooks:

```
roles/
└── nginx/
    ├── tasks/main.yml
    ├── handlers/main.yml
    ├── templates/nginx.conf.j2
    ├── files/
    ├── vars/main.yml
    └── defaults/main.yml
```

## Comandos esenciales

```bash
# Ejecutar playbook
ansible-playbook deploy-web.yml

# Ejecutar en hosts específicos
ansible-playbook deploy-web.yml --limit webservers

# Dry run (check mode)
ansible-playbook deploy-web.yml --check

# Ver diff de cambios
ansible-playbook deploy-web.yml --diff

# Ejecutar solo un tag
ansible-playbook deploy-web.yml --tags "install"

# Verificar conectividad
ansible all -m ping

# Comando ad-hoc
ansible webservers -m shell -a "uptime"
```

## Ansible Galaxy

Repositorio de roles y colecciones compartidas:

```bash
# Instalar un rol
ansible-galaxy install geerlingguy.nginx

# Instalar una colección
ansible-galaxy collection install community.general

# Buscar roles
ansible-galaxy search nginx
```

## Vault (secretos)

Cifrar variables sensibles:

```bash
# Cifrar un archivo
ansible-vault encrypt secrets.yml

# Descifrar para editar
ansible-vault edit secrets.yml

# Ejecutar playbook con vault
ansible-playbook site.yml --ask-vault-pass

# Vault password file
ansible-playbook site.yml --vault-password-file ~/.vault_pass
```

## Ansible vs otras herramientas

| Herramienta | Paradigma | Lenguaje | Agente |
|---|---|---|---|
| **Ansible** | Agentless, declarativo | YAML | No |
| **Puppet** | Agent, declarativo | DSL propietario | Sí |
| **Chef** | Agent, procedural | Ruby | Sí |
| **SaltStack** | Agent/Agentless | YAML/Python | Opcional |
| **Terraform** | Infraestructure as Code | HCL | No |

## Casos de uso

- **Configuración de servidores**: instalar paquetes, crear usuarios, configurar servicios.
- **Despliegue de aplicaciones**: copiar código, reiniciar servicios, configurar bases de datos.
- **Provisioning**: crear instancias en AWS/GCP/Azure con módulos cloud.
- **Cumplimiento**: verificar que servidores cumplen políticas de seguridad.
- **Orquestación**: ejecutar tareas en paralelo en múltiples hosts.

## Ver también

- [[Docker]]
- [[Docker Compose]]
- [[DevOps]]
- [[SSH]]

#devops #automatizacion #configuracion #infraestructura #yaml
