---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: media
---

# Gem (Ruby)

## Qué es

**Gem** es el gestor de paquetes oficial de **Ruby**. Los paquetes se llaman **gemas** y se publican en [rubygems.org](https://rubygems.org/). **Bundler** complementa a Gem gestionando dependencias por proyecto mediante un `Gemfile`.

## Instalación

```bash
# Ruby + Gem + Bundler
sudo apt install ruby ruby-dev ruby-bundler   # Debian/Ubuntu
sudo pacman -S ruby                           # Arch
sudo dnf install ruby ruby-devel              # Fedora

ruby --version                           # Ruby 3.3.x
gem --version                            # Gem 3.5.x
```

## Comandos de Gem

```bash
gem list                                 # paquetes instalados
gem list --local                         # solo locales
gem install paquete                      # instalar gema
gem install paquete -v 1.2.3            # instalar versión específica
gem uninstall paquete                    # desinstalar
gem update paquete                       # actualizar
gem update --system                      # actualizar gem mismo
gem search texto                         # buscar gemas
gem environment                          # información del entorno
```

## Bundler

Gestor de dependencias de Ruby:

```bash
sudo gem install bundler

# En un proyecto:
# Crear Gemfile:
# source 'https://rubygems.org'
# gem 'rails'
# gem 'pg'

bundle install                           # instalar dependencias del Gemfile
bundle exec comando                      # ejecutar comando con las gemas del proyecto
bundle update                            # actualizar gemas
bundle outdated                          # gemas desactualizadas
```

## Buenas prácticas

1. **Usa Bundler** para proyectos — define dependencias en `Gemfile` y usa `bundle exec`.
2. **Commitea `Gemfile.lock`** para builds reproducibles.
3. **Usa `gem install --user-install`** si no quieres usar sudo.

## Ver también

- [[Node.js]] — gestor de paquetes de JavaScript
- [[Cargo]] — gestor de paquetes de Rust
- [[pip]] — gestor de paquetes de Python
- [[Go]] — gestor de módulos de Go
- [[Gestores de Paquetes]] — gestores del sistema (apt, pacman, dnf)

## Enlaces externos

- [rubygems.org](https://rubygems.org/) — registro de gemas Ruby
- [Bundler](https://bundler.io/) — gestor de dependencias

#programa #desarrollo
