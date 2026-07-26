---
fecha_creacion: 2026-07-25
fecha_modificacion: 2026-07-25
estado: resuelto
categoria: programa
prioridad: baja
---

# gdebi

> Instalador de paquetes .deb que resuelve dependencias automáticamente. Alternativa ligera a synaptic para instalar paquetes .deb descargados.

## Sintaxis

```bash
gdebi [opciones] [paquete.deb]
```

## Descripción

`gdebi` instala paquetes .deb locales resolviendo dependencias desde los repositorios configurados. A diferencia de `dpkg` (que no resuelve dependencias) y `apt` (que descarga de repos), gdebi combina ambos: instala un .deb local y busca las dependencias faltantes en los repos.

## Opciones

| Opción | Descripción |
|---|---|
| `-n, --non-interactive` | Sin prompts (para scripts) |
| `-q, --quiet` | Modo silencioso |
| `--configure` | Solo configurar paquetes pendientes |
| `--remove` | Eliminar paquete |

## Ejemplos

### Instalar un .deb descargado
```bash
sudo gdebi chrome-stable.deb
# Resuelve dependencias automáticamente
```

### Instalar sin interacción (scripts)
```bash
sudo gdebi -n paquete.deb
```

### Verificar si un .deb se puede instalar
```bash
gdebi --check paquete.deb
```

## Formato de salida

```
Reading package lists...
Building dependency tree...
Reading state information...

 chrome-stable
 Google Chrome Browser

 Do you want to install the software package? [y/N]: y
 Selecting previously unselected package chrome-stable.
 Unpacking chrome-stable ...
 Setting up chrome-stable ...
```

## Casos de uso

### Instalar Chrome/VSCode/Zoom
```bash
# Descargar .deb desde sitio oficial
wget -O chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# Instalar con resolución de dependencias
sudo gdebi chrome.deb
```

### Comparación con dpkg
```bash
# dpkg solo instala, no resuelve dependencias
sudo dpkg -i paquete.deb
sudo apt-get install -f            # reparar dependencias después

# gdebi hace ambas cosas en un solo paso
sudo gdebi paquete.deb
```

## Combinaciones pipe

```bash
# Verificar múltiples .deb
for f in *.deb; do gdebi --check "$f"; done
```

## Alternativas

| Herramienta | Cuándo usarla |
|---|---|
| **gdebi** | Instalar .deb local con dependencias |
| **dpkg -i** | Solo instalar, sin dependencias |
| **apt install ./f.deb** | Alternativa moderna (recomendada) |
| **Eddy** | Instalador .deb gráfico (elementary OS) |

## Ver también

- [[apt]] — gestor de paquetes principal
- [[dpkg]] — gestor de bajo nivel para .deb
- [[Gestores de Paquetes]] — comparativa de gestores
- [[Gestores de Paquetes]] — formatos de paquetes

## Enlaces externos

- [GitHub — gdebi](https://github.com/mvo5/gdebi)
- [man gdebi(1)](https://manpages.ubuntu.com/manpages/focal/man1/gdebi.1.html)
- [Ubuntu Wiki — gdebi](https://help.ubuntu.com/community/InstallingSoftware)

#programa #paquetes
