---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
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
brew install ruby                              # macOS

ruby --version                           # Ruby 3.3.x
gem --version                            # Gem 3.5.x
```

## Comandos de Gem

```bash
gem list                                 # paquetes instalados
gem list --local                         # solo locales
gem install paquete                      # instalar gema
gem install paquete -v 1.2.3            # instalar versión específica
gem install paquete --no-document        # sin docs (rápido)
gem uninstall paquete                    # desinstalar
gem update paquete                       # actualizar
gem update --system                      # actualizar gem mismo
gem search texto                         # buscar gemas
gem environment                          # información del entorno
gem environment gemdir                   # directorio de gemas instaladas
gem which gema                           # ruta del archivo principal
gem contents gema                        # archivos de la gema
gem dependency gema                      # dependencias de una gema
gem cleanup                              # eliminar versiones antiguas
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
bundle exec rspec                        # ejecutar tests con el entorno del proyecto
bundle exec rails server                 # iniciar servidor Rails
bundle info gema                         # info de una gema del proyecto
bundle show gema                         # ruta de una gema instalada
```

## Buenas prácticas

1. **Usa Bundler** para proyectos — define dependencias en `Gemfile` y usa `bundle exec`.
2. **Commitea `Gemfile.lock`** para builds reproducibles.
3. **Usa `gem install --user-install`** si no quieres usar sudo.
4. **Evita `sudo gem install`** — instala en el directorio del sistema y puede causar conflictos.

## Gem vs Bundler vs rbenv vs rvm

| Aspecto | Gem | Bundler | rbenv | rvm |
|---|---|---|---|---|
| Tipo | Gestor de paquetes | Dependencias por proyecto | Gestor de versiones Ruby | Gestor de versiones Ruby |
| Archivo | `Gemfile` | `Gemfile` | `.ruby-version` | `.ruby-version` |
| Instalación global | Sí | No (por proyecto) | No (gestiona versiones) | No (gestiona versiones) |
| Ideal | Instalar gemas sueltas | Proyectos con dependencias | Múltiples versiones Ruby | Múltiples versiones Ruby |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `Gem::Ext::BuildError` al instalar | Falta `ruby-dev` o compilador | `sudo apt install ruby-dev build-essential` |
| Versión de gem antigua | Gem no actualizado | `gem update --system` |
| Bundler no encuentra gema | Gemfile mal configurado | Verificar `source` en `Gemfile` |
| Conflicto de versiones | Múltiples versiones instaladas | `gem cleanup` o `bundle exec` |

## Comparativa con alternativas

| Aspecto | Gem | npm | pip | Cargo | go |
|---|---|---|---|---|---|
| **Lenguaje** | Ruby | JavaScript | Python | Rust | Go |
| **Lockfile** | ✅ `Gemfile.lock` (Bundler) | ✅ `package-lock.json` | ⚠️ `pip-compile` o `poetry.lock` | ✅ `Cargo.lock` | ✅ `go.sum` |
| **Bundler** | ✅ Gestor de deps Ruby estándar | ✅ npm/pnpm/yarn | ⚠️ pip-tools/poetry/uv | ✅ Cargo (integrado) | ✅ go mod |
| **Velocidad** | Lenta (Ruby) | Media | Lenta (Python) | Muy rápida (Rust) | Muy rápida (Go) |
| **Binarios** | ❌ Interpretado | ❌ Interpretado | ❌ Interpretado | ✅ Compilado | ✅ Compilado |
| **Uso típico** | Ruby on Rails, scripts | Web full-stack, APIs | ML, scripting, web | Sistemas, web, CLI | CLI, microservicios |

> **Nota:** Gem/Bundler es el estándar de facto para Ruby. Rails funciona mejor con Bundler + `bundle exec`.

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
