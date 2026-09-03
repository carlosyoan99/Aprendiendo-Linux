---
fecha_creacion: 2026-07-18
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: distribucion
prioridad: media
gestor_paquetes: nix
base: independiente
---

# NixOS

## Filosofía / público objetivo

NixOS es radicalmente distinta a cualquier otra distro: **todo el sistema** (paquetes, servicios, configuración de red, usuarios, DE/WM) se define declarativamente usando el lenguaje **Nix**. No instalas paquetes "en vivo" — editas la configuración y reconstruyes el sistema. El resultado es un sistema **reproducible**, con **rollback instantáneo** y **aislamiento total de dependencias**.

> Si usas NixOS, esta nota es para ti. Si usas Nix sobre otra distro (Nix package manager), aplica todo excepto `nixos-rebuild`.

---

## Conceptos fundamentales

| Concepto | Qué es |
|---|---|
| **Nix** | Lenguaje puramente funcional para definir paquetes y configuraciones |
| **Nixpkgs** | El repositorio de paquetes más grande del mundo (>100.000 paquetes) |
| **NixOS** | Distro Linux completa definida en Nix |
| **/nix/store** | Almacén de paquetes: cada paquete vive en `/nix/store/hash-nombre` |
| **Generación** | Cada `nixos-rebuild switch` crea una generación nueva (con rollback) |
| **Flake** | Formato moderno de proyecto Nix (desde 2023) — reemplaza `configuration.nix` |

---

## Ejemplo moderno con flakes (recomendado)

El método clásico (`/etc/nixos/configuration.nix`) sigue funcionando, pero **flakes** es el estándar moderno desde 2023. Un flake es un proyecto Nix autocontenido con su propio `flake.nix` y `flake.lock` (similar a `package.json` + `package-lock.json`).

```bash
# ── flake.nix (configuración del sistema) ─────────────────
# Archivo: ~/nixos-config/flake.nix
#
# {
#   description = "Configuración NixOS moderna";
#   inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
#     nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
#     home-manager.url = "github:nix-community/home-manager";
#     home-manager.inputs.nixpkgs.follows = "nixpkgs";
#   };
#   outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }: {
#     nixosConfigurations.carlos-laptop = nixpkgs.lib.nixosSystem {
#       system = "x86_64-linux";
#       modules = [
#         ({ pkgs, ... }: {
#           boot.loader.systemd-boot.enable = true;
#           boot.loader.efi.canTouchEfiVariables = true;
#           networking.hostName = "carlos-laptop";
#           networking.networkmanager.enable = true;
#           environment.systemPackages = with pkgs; [ git vim htop firefox ];
#           services.openssh.enable = true;
#           users.users.carlos = {
#             isNormalUser = true;
#             extraGroups = [ "wheel" "networkmanager" "docker" ];
#           };
#         })
#         home-manager.nixosModules.home-manager {
#           home-manager.users.carlos = { pkgs, ... }: {
#             home.stateVersion = "24.11";
#             home.username = "carlos";
#             home.homeDirectory = "/home/carlos";
#             programs.bash = {
#               enable = true;
#               initExtra = ''
#                 alias ll='ls -la'
#                 alias gs='git status'
#                 export EDITOR=vim
#               '';
#             };
#             programs.git = {
#               enable = true;
#               userName = "Carlos";
#               userEmail = "carlos@email.com";
#             };
#             home.packages = with pkgs; [
#               ripgrep fd jq tree
#               spotify discord
#             ];
#           };
#         }
#       ];
#     };
#   };
# }

# ── comandos para aplicar el flake ──
sudo nixos-rebuild switch --flake ~/nixos-config#carlos-laptop   # aplicar
sudo nixos-rebuild test --flake ~/nixos-config#carlos-laptop    # probar sin guardar
sudo nixos-rebuild list-generations                             # ver generaciones
sudo nixos-rebuild switch --rollback                             # deshacer cambios
```

### ¿Por qué flakes?

| Ventaja | Flakes | configuration.nix clásico |
|---|---|---|
| **Reproducibilidad garantizada** | `flake.lock` congela versiones de todas las dependencias | Depende del canal en el momento de rebuild |
| **Compartible** | Un solo directorio con `flake.nix` + `flake.lock` | Depende de `/etc/nixos/` completo |
| **Dependencias externas** | Se declaran en `inputs` (GitHub, GitLab, otros flakes) | No soportado nativamente |
| **CI/CD** | Fácil de integrar con GitHub Actions | Más complejo |
| **Múltiples máquinas** | Un flake puede gestionar varios equipos | Un archivo por máquina |

---

## Flakes en profundidad

### inputs y comandos

```bash
# ── inputs del flake (ejemplo para agregar a flake.nix) ──
# inputs = {
#   nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
#   nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
#   home-manager.url = "github:nix-community/home-manager/release-24.11";
#   home-manager.inputs.nixpkgs.follows = "nixpkgs";
#   nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
#   hyprland.url = "github:hyprwm/Hyprland";
# };

# ── comandos de flake ──
nix flake update                              # actualizar dependencias
nix flake lock --update-input home-manager     # actualizar solo un input
nix run nixpkgs#firefox                        # ejecutar sin instalar
nix shell nixpkgs#python311 nixpkgs#nodejs_20   # shell con paquetes
nix build .#nixosConfigurations.carlos-laptop.config.system.build.toplevel
```

---

## Home Manager (gestión de dotfiles)

Home Manager permite declarar la configuración de **usuario** (dotfiles, programas, servicios de usuario) de forma aislada de la configuración del sistema.

```bash
# Instalación sin flakes (modo clásico):
nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Con flakes: ya viste el ejemplo arriba (home-manager.nixosModules)
```

### home.nix completo

```bash
# ── home.nix (dotfiles de usuario) ──────────────────────
# { config, pkgs, ... }: {
#   home.stateVersion = "24.11";
#   home.username = "carlos";
#   home.homeDirectory = "/home/carlos";
#
#   programs.bash = {
#     enable = true;
#     initExtra = ''
#       alias ll='ls -la'
#       alias la='ls -A'
#     '';
#     historyControl = [ "ignoredups" "ignorespace" ];
#   };
#   programs.git = {
#     enable = true;
#     userName = "Carlos";
#     userEmail = "carlos@email.com";
#     extraConfig = { init.defaultBranch = "main"; pull.rebase = true; };
#   };
#   programs.vim = {
#     enable = true;
#     plugins = with pkgs.vimPlugins; [ vim-airride nerdtree ];
#     settings = { number = true; relativenumber = true; };
#   };
#   programs.tmux = { enable = true; shortcut = "a"; mouse = true; };
#   programs.htop = { enable = true; settings = { treeView = true; }; };
#   programs.ssh = {
#     enable = true;
#     matchBlocks = {
#       "servidor" = { hostname = "192.168.1.100"; user = "admin"; };
#     };
#   };
#
#   home.packages = with pkgs; [ ripgrep fd jq tree spotify discord flameshot ];
#   services.syncthing.enable = true;
#   services.blueman-applet.enable = true;
# }

# ── comandos home-manager ──
home-manager switch   # aplicar configuración de usuario
home-manager build    # test (construir sin aplicar)
```

---

## NixOS Containers

NixOS permite ejecutar contenedores ligeros (similares a Docker pero gestionados por el mismo Nix/NixOS) directamente desde la configuración del sistema:

```bash
# ── configuración de contenedores NixOS ─────────────────
# { config, pkgs, ... }: {
#   containers.database = {
#     autoStart = true;
#     privateNetwork = true;
#     hostAddress = "10.0.0.1";
#     localAddress = "10.0.0.2";
#     config = { config, pkgs, ... }: {
#       services.postgresql = {
#         enable = true;
#         package = pkgs.postgresql_16;
#         enableTCPIP = true;
#         authentication = pkgs.lib.mkForce ''
#           local all all trust
#           host all all 10.0.0.0/24 trust
#         '';
#       };
#     };
#   };
#   containers.web = {
#     autoStart = true;
#     privateNetwork = true;
#     hostAddress = "10.0.0.3";
#     localAddress = "10.0.0.4";
#     config = { config, pkgs, ... }: {
#       services.nginx.enable = true;
#     };
#   };
# }

# ── comandos para gestionar contenedores ──
sudo nixos-container start database          # iniciar contenedor
sudo nixos-container stop database           # detener
sudo nixos-container status database         # estado
sudo nixos-container root-login database     # entrar como root
sudo nixos-container list                    # listar activos
sudo nixos-container update database         # actualizar sin reiniciar host
journalctl -u container@database.service     # logs del contenedor
```

### NixOS Containers vs Docker

| Aspecto | NixOS Containers | Docker |
|---|---|---|
| **Aislamiento** | systemd-nspawn | Namespaces + cgroups |
| **Declarativo** | ✅ Desde configuration.nix | ❌ Dockerfile/compose.yml aparte |
| **Rollback** | ✅ Como cualquier cambio NixOS | ❌ Hay que reconstruir imagen |
| **Imagen base** | Comparte /nix/store del host | Imagen independiente |
| **Caso de uso** | Servicios del sistema | Aplicaciones portables |
| **Portabilidad** | Solo NixOS | Cualquier Linux |

---

## Caché binaria

Una de las mayores ventajas de Nix es la **caché binaria**: no tienes que compilar todo desde fuente. Los paquetes precompilados se descargan de cachés públicas.

```bash
# Caché oficial de NixOS (incluida por defecto):
# https://cache.nixos.org
#   → Contiene ~99% de los paquetes de nixpkgs

# Verificar que la caché está configurada:
nix show-config | grep substituters
# substitutors = https://cache.nixos.org

# Ver desde dónde se descargó un paquete:
nix path-info --store $(nix eval nixpkgs#firefox.outPath)

# Forzar que NO use caché (compilar local):
nix build nixpkgs#firefox --option substituters ""

# Añadir cachés adicionales (ej: Cachix para proyectos propios):
# En configuration.nix:
nix.settings = {
  substituters = [
    "https://cache.nixos.org"
    "https://my-cache.cachix.org"
  ];
  trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "my-cache.cachix.org-1:xxxxx..."
  ];
};
```

### Cachix — Cachés privadas

[Cachix](https://cachix.org/) permite tener tu propia caché binaria (pública o privada):

```bash
# Instalar cachix
nix profile install nixpkgs#cachix

# Autenticarse
cachix authtoken <TOKEN>

# Subir paquetes a tu caché
cachix push mi-caché $(nix build nixpkgs#firefox --json | jq -r '.[].outputs.out')

# Usar la caché en otros equipos
cachix use mi-caché    # agrega automáticamente a substitutors
```

### ¿Cuándo se compila desde fuente?

| Situación | Compila |
|---|---|
| Paquete en caché oficial | ❌ No — descarga binario |
| Paquete con override de opciones (ej: `enableFeature = true`) | ✅ Sí (nuevo hash en /nix/store) |
| Arquitectura no soportada en caché (ARM, RISC-V) | ✅ Sí |
| Paquete de un flake privado sin caché | ✅ Sí |
| `--option substituters \"\"` (forzar local) | ✅ Sí |
| Caché temporalmente caída | ✅ Sí (cae a compilación local) |

---

## Ejemplo completo: configuración reproducible moderna

Este es el punto de partida recomendado para cualquier instalación nueva de NixOS con flakes:

```bash
# ── estructura recomendada de proyecto ──
# ~/nixos-config/
# ├── flake.nix          # entrada principal
# ├── flake.lock         # versiones congeladas
# ├── hosts/laptop.nix   # config por equipo
# ├── modules/common.nix # config compartida
# └── secrets/           # (gestionado aparte)

# ── inicializar un flake nuevo ──
mkdir -p ~/nixos-config/hosts
cd ~/nixos-config
nix flake init             # genera flake.nix básico
git init && git add -A
nix flake lock             # genera flake.lock

# ── comandos diarios ──
sudo nixos-rebuild switch --flake ~/nixos-config#laptop    # aplicar cambios
nix flake update                                            # actualizar deps
nix store diff-closures /nix/var/nix/profiles/system-*-link # ver diferencias
```

---

## Comandos de diagnóstico

```bash
# Estado del sistema
nixos-version                        # versión de NixOS
sudo nixos-rebuild list-generations  # generaciones disponibles

# Información de paquetes
nix search nixpkgs firefox                  # buscar paquetes
nix derivation show nixpkgs#firefox           # mostrar derivación
nix eval nixpkgs#firefox.meta.description     # metadatos del paquete
nix path-info -Sh nixpkgs#firefox             # tamaño y store path
nix why-depends nixpkgs#firefox nixpkgs#libX11  # por qué depende

# Limpieza
sudo nix-collect-garbage             # eliminar generaciones viejas
sudo nix-collect-garbage -d          # eliminar todo excepto la actual
nix store gc                         # recolector de basura del store

# Tamaño del store
du -sh /nix/store                    # cuánto ocupa
nix path-info -Sh /run/current-system  # tamaño del sistema actual

# Ver qué paquetes consume más espacio
nix path-info -Sh /nix/store/* | sort -rh | head -10
```

---

## Por qué importa

NixOS es la distro más innovadora del ecosistema Linux actual. Su modelo declarativo, flakes, y home-manager ofrecen un nivel de reproducibilidad y gestión de configuraciones que ninguna otra distro iguala. La desventaja es la **curva de aprendizaje**: hay que pensar en Nix, no en bash.

**¿Merece la pena?** Si administras varios equipos (laptop + servidor + Raspberry Pi), si necesitas entornos de desarrollo reproducibles, o si simplemente te atrae la idea de que tu sistema esté versionado en Git y sea replicable en segundos, NixOS es para ti.

## Comparativa con otras distribuciones

| Aspecto | [[NixOS]] | [[Arch Linux]] | [[Debian]] | [[Fedora]] |
|---|---|---|---|---|
| **Modelo de config** | Declarativa (Nix/Scheme) | Imperativa (files del usuario) | Imperativa | Imperativa |
| **Reproducibilidad** | Total (nix store hashes) | Parcial | Parcial | Parcial |
| **Rollback** | Sí, atómico (generaciones) | No | No | No |
| **Gestor** | nix (+ flakes) | pacman | apt | dnf |
| **Base de paquetes** | nixpkgs (enorme) | AUR + repos | repos Debian | repos Fedora/RPM Fusion |

**En resumen**: NixOS es la revolución declarativa — definir el sistema en código y reproducirlo/rollback atómicamente es su ventaja única; Arch, Debian y Fedora son imperativas: se configuran "en vivo" y su coherencia depende del mantenimiento del admin.

## Ver también

- [[Arch Linux]] — enfoque minimalista imperativo
- [[Gestores de Paquetes]] — comparativa con apt, pacman, etc.
- [[Symlinks y Dotfiles]] — home-manager como alternativa a Stow/chezmoi
- [[Docker]] — NixOS containers como alternativa para servicios del sistema
- [[Git]] — gestionar la configuración con Git
- [[Procesos y Senales]] — gestión de servicios con systemd en NixOS

## Enlaces externos

- [NixOS — Página oficial](https://nixos.org/)
- [NixOS Wiki — Flakes](https://nixos.wiki/wiki/Flakes)
- [Home Manager — Manual](https://nix-community.github.io/home-manager/)
- [NixOS Containers](https://nixos.wiki/wiki/NixOS_Containers)
- [Cachix](https://cachix.org/)
- [Nix Pills — Tutorial](https://nixos.org/guides/nix-pills/)
- [NixOS Awesome — Lista de recursos](https://github.com/nix-community/awesome-nix)
- [Zero to Nix — Guía para empezar](https://zero-to-nix.com/)
- [Nixpkgs — Repositorio](https://github.com/NixOS/nixpkgs)

#distro
