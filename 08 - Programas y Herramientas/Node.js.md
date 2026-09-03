---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: alta
---

# Node.js y npm

## Qué es

**Node.js** es un entorno de ejecución de JavaScript del lado del servidor, construido sobre el motor V8 de Chrome. **npm** (Node Package Manager) es su gestor de paquetes oficial, y existen alternativas como yarn y pnpm.

## Instalación de Node.js

```bash
# Desde repos del sistema (versión estable, puede estar desactualizada)
sudo apt install nodejs npm          # Debian/Ubuntu
sudo pacman -S nodejs npm            # Arch
sudo dnf install nodejs npm          # Fedora

# ⚠️ Los repos suelen tener versiones antiguas. Mejor usar nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install --lts                    # instalar la última LTS
nvm use --lts                        # usar la LTS
nvm ls                               # listar versiones instaladas

# Ver versiones
node --version                       # v22.x
npm --version                        # 10.x
```

## npm (Node Package Manager)

### Comandos básicos

```bash
npm init                              # crear package.json
npm install paquete                   # instalar como dependencia
npm install -g paquete                # instalar global
npm install --save-dev paquete        # dependencia de desarrollo
npm uninstall paquete                 # desinstalar
npm update                            # actualizar dependencias
npm run script                        # ejecutar script del package.json
npm outdated                          # ver paquetes desactualizados
npm audit                             # auditoría de seguridad
```

### Dónde se instalan los paquetes

```bash
ls ~/node_modules/                    # dependencias del proyecto local
npm list -g --depth=0                 # paquetes globales
npm root -g                           # ruta global: /usr/lib/node_modules/
```

## Alternativas a npm

### yarn — más rápido, determinista

```bash
sudo npm install -g yarn
yarn add paquete                      # equivalente a npm install
yarn install                          # instalar dependencias del yarn.lock
```

### pnpm — más rápido, usa hard links (ahorra espacio)

```bash
sudo npm install -g pnpm
pnpm install                          # instalar dependencias
pnpm add paquete                      # añadir dependencia
```

## Buenas prácticas

1. **Usa `nvm` para Node.js** — los repos del sistema suelen tener versiones antiguas.
2. **Commitea el lockfile** (`package-lock.json` o `yarn.lock`) para builds reproducibles.
3. **No commitees `node_modules/`** — añádelo a `.gitignore`.

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| `Error: EACCES: permission denied` al instalar global | Permisos sobre el `prefix` global | Usar NVM o reinstalar node_modules con usuario correcto, no `sudo npm` |
| `node: not found` tras activar versión | PATH sin el binario | `nvm use` o recargar perfil (`source ~/.bashrc`) |
| `npm install` lento o ENOENT | Caché corrupta / sin red | `npm cache clean --force` y revisar proxy/registry |
| Dependencia no instalada (módulo roto) | Version mismatches en `package.json` | `rm -rf node_modules package-lock.json && npm install` |
| Heap out of memory en build | Límite default de Node bajo | `NODE_OPTIONS="--max-old-space-size=4096"` |

## Ver también

- [[Cargo]] — gestor de paquetes de Rust
- [[pip]] — gestor de paquetes de Python
- [[Go]] — gestor de módulos de Go
- [[Gem]] — gestor de paquetes de Ruby
- [[Gestores de Paquetes]] — gestores del sistema (apt, pacman, dnf)

## Enlaces externos

- [nvm](https://github.com/nvm-sh/nvm) — gestor de versiones de Node.js
- [npm](https://www.npmjs.com/) — registro oficial de paquetes
- [yarn](https://yarnpkg.com/) — alternativa a npm
- [pnpm](https://pnpm.io/) — gestor rápido con hard links

#programa #desarrollo
