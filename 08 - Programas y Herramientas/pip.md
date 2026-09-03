---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: alta
---

# pip (Python)

## Qué es

**pip** es el gestor de paquetes oficial de Python. Instala paquetes desde [PyPI](https://pypi.org/) (Python Package Index). Existen alternativas modernas como **poetry**, **pipx** y **uv** que mejoran la experiencia.

## ⚠️ Regla de oro: no uses pip con sudo

```bash
# ❌ PELIGROSO — puede romper paquetes del sistema
sudo pip install paquete

# ✅ Seguro — instala para tu usuario
pip install --user paquete

# ✅ Seguro — instala dentro de un entorno virtual
python3 -m venv .venv
source .venv/bin/activate
pip install paquete

# ✅ Seguro — usa pipx para herramientas globales
pipx install paquete
```

## Instalación

```bash
sudo apt install python3-pip          # Debian/Ubuntu
sudo pacman -S python-pip             # Arch
sudo dnf install python3-pip          # Fedora
```

## Comandos básicos

```bash
pip install paquete                   # instalar paquete
pip install paquete==1.2.3            # instalar versión específica
pip install --upgrade paquete         # actualizar
pip uninstall paquete                 # desinstalar
pip list                              # listar paquetes instalados
pip list --outdated                   # paquetes desactualizados
pip show paquete                      # información del paquete
pip freeze > requirements.txt         # exportar dependencias actuales
pip install -r requirements.txt       # instalar desde archivo
```

## pyenv — gestionar versiones de Python

```bash
# Instalar pyenv
curl https://pyenv.run | bash
echo 'export PYTHON_BUILD_ARIA2_OPTS="-x 10 -k 1M"' >> ~/.bashrc

# Usar pyenv
pyenv install --list                  # versiones disponibles
pyenv install 3.12.5                  # instalar versión específica
pyenv global 3.12.5                   # establecer versión global
pyenv local 3.10.14                   # establecer versión local (proyecto)
pyenv versions                        # versiones instaladas
```

## Entornos virtuales (venv)

Siempre usa entornos virtuales para aislar dependencias de cada proyecto:

```bash
# Crear entorno virtual
python3 -m venv .venv                 # crear en carpeta .venv
source .venv/bin/activate             # activar (bash/zsh)
source .venv/bin/activate.fish        # activar (fish)

# Una vez activado, pip instala dentro del venv
pip install flask

# Salir del venv
deactivate

# Alternativas más modernas:
# - poetry: pip install poetry; poetry new proyecto; poetry add flask
# - pipx: instala herramientas Python de forma aislada (ver abajo)
# - uv: gestor ultrarápido en Rust (pip install uv)
```

## pipx — instalar herramientas Python como comandos

Instala herramientas Python de forma aislada (como `cargo install`):

```bash
sudo apt install pipx                 # Debian/Ubuntu
pip install --user pipx               # o con pip

# Instalar herramientas como comandos globales
pipx install black                    # formateador de código
pipx install ruff                     # linter rápido
pipx install poetry                   # gestor de proyectos
pipx install httpie                   # HTTP client (alternativa a curl)
pipx install cookiecutter             # generador de proyectos
```

## Alternativas modernas

| Herramienta | Descripción | Instalación |
|---|---|---|
| **poetry** | Gestor de proyectos completo (deps + empaquetado + venv) | `pipx install poetry` |
| **uv** | Gestor ultrarápido en Rust, 10-100x más rápido que pip | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |
| **pipx** | Instala herramientas Python de forma aislada | `sudo apt install pipx` |

## Buenas prácticas

1. **No uses `sudo pip install`** — puede romper paquetes del sistema. Usa `--user`, `venv` o `pipx`.
2. **Usa entornos virtuales** (venv, poetry, conda) para aislar proyectos.
3. **Usa `pip freeze > requirements.txt`** para congelar dependencias.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `Externally-managed-environment` (Debian 12+/Ubuntu 23.10+) | PIP del sistema bloqueado | Usar venv: `python -m venv .venv && . .venv/bin/activate` |
| `Permission denied` al instalar global | No se debe usar sudo pip | Crear/activar venv en vez de `sudo pip install` |
| `WARNING: Package would be ignored` para versiones | Paquete ya instalado con distinto gestor | Detectar con `pip show`; usar venv limpio |
| `timeout`/descarga fallida | Red/red de espejos | `pip install --index-url https://pypi.org/simple` o mirror local |
| `ModuleNotFoundError` pese a instalar | Instalaste en otro entorno | Verificar `which python`/`which pip` dentro del venv |
| Wheel compilada deja errores (build de C) | Faltan build-deps | Instalar `build-essential`/`python3-dev` |

## Ver también

- [[Python en Linux]] — gestión completa de Python en Linux
- [[Node.js]] — gestor de paquetes de JavaScript
- [[Cargo]] — gestor de paquetes de Rust
- [[Go]] — gestor de módulos de Go
- [[Gem]] — gestor de paquetes de Ruby
- [[Gestores de Paquetes]] — gestores del sistema (apt, pacman, dnf)

## Enlaces externos

- [PyPI](https://pypi.org/) — registro de paquetes Python
- [pip docs](https://pip.pypa.io/) — documentación oficial
- [Poetry](https://python-poetry.org/) — gestión de proyectos
- [uv](https://github.com/astral-sh/uv) — gestor ultrarápido

#programa #python #desarrollo
