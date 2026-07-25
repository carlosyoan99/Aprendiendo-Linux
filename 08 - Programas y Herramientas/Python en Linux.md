---
fecha_creacion: 2026-07-19
estado: resuelto
categoria: programa
prioridad: alta
---

# Python en Linux

## Qué es

Python es uno de los lenguajes más importantes en el ecosistema Linux. Viene **preinstalado** en prácticamente todas las distribuciones — es parte esencial del sistema. Muchas herramientas del sistema (Gestor de Paquetes, actualizaciones, configuration tools) están escritas en Python.

Esta nota cubre la gestión de Python en Linux: versiones, entornos virtuales, gestores de paquetes y buenas prácticas para no romper el sistema.

## ⚠️ Regla de oro: NO tocar el Python del sistema

```bash
# El Python del sistema (/usr/bin/python3) es USADO POR EL SISTEMA:
# - apt (gestor de paquetes Debian)
# - dnf/yum (gestor de paquetes Fedora/RHEL)
# - pacman (utiliza Python para algunos scripts)
# - GNOME Software, Update Manager, etc.

# Si modificas el Python del sistema:
# ❌ pip install --upgrade pip        # puede romper paquetes del SO
# ❌ sudo pip install paquete          # contamina el Python del sistema
# ❌ rm -rf /usr/lib/python3.x/        # destruye el sistema

# Lo correcto es usar Python aislado del sistema:
# ✅ python3 -m venv .venv
# ✅ pip install --user
# ✅ pipx
# ✅ pyenv
# ✅ Docker / contenedores
```

## Versiones de Python

```bash
# Ver Python instalado
python3 --version                    # Python 3.x del sistema
python --version                     # puede ser Python 2 (obsoleto) o Python 3

# Python 2 vs Python 3
# Python 2 murió el 1 de enero de 2020
# Muchas distros ya no incluyen python2
# Si lo necesitas: sudo apt install python2

# Ver todos los Python instalados
which python3                        # /usr/bin/python3
ls /usr/bin/python*                  # python3, python3.10, python3.11, python3.12
```

## pyenv — gestionar múltiples versiones

**pyenv** permite tener varias versiones de Python instaladas y cambiarlas por proyecto:

```bash
# Instalación
curl https://pyenv.run | bash

# Añadir al ~/.bashrc:
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# Comandos
pyenv install --list                 # todas las versiones disponibles
pyenv install 3.12.5                 # instalar versión específica
pyenv install 3.11.9                 # instalar otra versión
pyenv versions                       # versiones instaladas
pyenv global 3.12.5                  # versión global por defecto
pyenv local 3.11.9                   # versión para el proyecto actual
pyenv shell 3.10.14                  # versión para la shell actual
```

## pip — gestor de paquetes

```bash
# pip para Python 3
pip3 --version                       # o pip si solo tienes Python 3

# Comandos básicos
pip3 install paquete                 # instalar en el entorno activo
pip3 install paquete==1.2.3         # versión específica
pip3 install 'paquete>=1.2'         # rango de versiones
pip3 install --upgrade paquete      # actualizar
pip3 uninstall paquete               # desinstalar
pip3 list                           # paquetes instalados
pip3 list --outdated                # paquetes desactualizados
pip3 show paquete                   # información del paquete

# ⚠️ NO uses pip con sudo
# sudo pip install → peligroso, puede romper el sistema
# Alternativas seguras:
pip3 install --user paquete         # instala en ~/.local
python3 -m pip install paquete     # usa el pip del Python actual
```

## pipx — instalar herramientas Python como comandos

**pipx** instala herramientas Python (como black, poetry, httpie) de forma aislada, cada una en su propio entorno virtual:

```bash
# Instalación
sudo apt install pipx                # Debian/Ubuntu
sudo pacman -S python-pipx          # Arch
sudo dnf install pipx               # Fedora

# Comandos
pipx install black                  # instala black como comando global
pipx install poetry                 # gestor de proyectos Python
pipx install httpie                 # HTTP client
pipx install ruff                   # linter ultrarápido
pipx install cookiecutter           # generador de proyectos
pipx list                           # lista de herramientas instaladas
pipx upgrade-all                    # actualizar todas las herramientas
pipx uninstall black                # desinstalar

# Ejecutar sin instalar (útil para probar)
pipx run black --help                # ejecuta black temporalmente
```

## Entornos virtuales (venv)

Los entornos virtuales aíslan las dependencias de cada proyecto:

```bash
# Crear entorno virtual
cd mi-proyecto
python3 -m venv .venv               # crea carpeta .venv/ con Python aislado

# Activar
source .venv/bin/activate           # bash/zsh
source .venv/bin/activate.fish      # fish

# Una vez activado:
# - pip instala DENTRO del entorno, no en el sistema
# - el prompt cambia a (venv) $
pip install flask                   # se instala en .venv/lib/python3.x/site-packages/

# Desactivar
deactivate

# Es buena práctica añadir .venv/ al .gitignore
echo '.venv/' >> .gitignore

# Alternativas más modernas:
# - poetry (ver más abajo)
# - pipenv (pip + Pipfile)
# - conda (científico/datos)
```

## poetry — gestor de proyectos moderno

**Poetry** combina gestión de dependencias, empaquetado y entornos virtuales en una sola herramienta:

```bash
# Instalar
pipx install poetry

# Comandos
poetry new mi-proyecto              # crear nuevo proyecto
cd mi-proyecto
poetry add flask                    # añadir dependencia
poetry add --dev pytest             # dependencia de desarrollo
poetry install                      # instalar todas las dependencias
poetry shell                        # activar el entorno virtual
poetry run python script.py         # ejecutar en el entorno
poetry build                        # empaquetar
poetry publish                      # publicar en PyPI
```

### pyproject.toml (estándar moderno)

```toml
[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"

[tool.poetry]
name = "mi-proyecto"
version = "0.1.0"
description = "Un proyecto Python moderno"
authors = ["Tu Nombre <email@ejemplo.com>"]

[tool.poetry.dependencies]
python = "^3.11"
flask = "^3.0"
requests = "^2.31"

[tool.poetry.group.dev.dependencies]
pytest = "^8.0"
ruff = "^0.4"
```

## uv — el gestor más rápido

**uv** es un gestor de paquetes y proyectos Python escrito en Rust, del mismo creador que ruff. Es 10-100x más rápido que pip:

```bash
# Instalación
curl -LsSf https://astral.sh/uv/install.sh | sh

# O con pip
pipx install uv

# Comandos (compatibles con pip)
uv pip install flask                # 10x más rápido que pip
uv venv                             # crear entorno virtual (instantáneo)
uv pip install -r requirements.txt  # instalar desde requirements
uv pip compile requirements.in      # generar requirements.txt optimizado

# Gestión de proyectos
uv init mi-proyecto                 # inicializar proyecto
uv add flask                        # añadir dependencia
uv sync                             # sincronizar entorno
```

## Herramientas Python útiles

```bash
# Desarrollo
pipx install black                  # formateador de código (opinionated)
pipx install ruff                   # linter + formateador (Rust, rápido)
pipx install mypy                   # type checker estático
pipx install pytest                 # test runner
pipx install pre-commit             # hooks de git

# CLI y utilidades
pipx install httpie                 # curl con sintaxis amigable
pipx install yt-dlp                 # descargar videos de YouTube
pipx install cookiecutter           # generador de proyectos
pipx install rich-cli              # texto enriquecido en terminal

# Jupyter (análisis de datos)
pipx install jupyter                # notebooks interactivos
# Para kernels:
pipx install jupyterlab             # JupyterLab moderno
```

## Python científico / datos

```bash
# Instalar herramientas científicas
# No uses pip para esto — usa conda o mamba
# Conda gestiona también librerías no-Python (CUDA, BLAS, etc.)

# Miniconda (ligero)
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

# O mamba (más rápido que conda)
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba

# Paquetes científicos populares
conda install numpy pandas matplotlib scikit-learn jupyter
conda install pytorch torchvision cudatoolkit   # si tienes NVIDIA GPU
```

## Depuración con Python

```bash
# pdb — depurador integrado
python3 -m pdb script.py            # depurar script
# En el código:
import pdb; pdb.set_trace()         # breakpoint (Python 3.7+)

# ipdb — pdb con autocompletado
pipx install ipdb

# debugpy — depurador remoto (VS Code compatible)
pipx install debugpy
python3 -m debugpy --listen 5678 script.py
```

## Python en contenedores

```bash
# Dockerfile para Python (buenas prácticas)
# Usar imágenes oficiales y ligeras

FROM python:3.12-slim               # ~120 MB
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "app.py"]

# O usar distroless (Google):
# FROM gcr.io/distroless/python3-debian12
# ~30 MB
```

## Enlaces externos

- [Python.org](https://www.python.org/) — oficial
- [PyPI](https://pypi.org/) — Python Package Index
- [Real Python](https://realpython.com/) — tutoriales avanzados
- [pyenv GitHub](https://github.com/pyenv/pyenv)
- [Poetry](https://python-poetry.org/) — gestión de proyectos
- [uv](https://github.com/astral-sh/uv) — gestor ultrarápido

## Ver también

- [[Lenguajes y gestores (Node.js Cargo PIP Go Gem)]] — comparativa con otros gestores
- [[Desarrollo en Linux (gcc make gdb strace)]] — herramientas de desarrollo
- [[Contenedores]] — Python en Docker

#programa #python #desarrollo
