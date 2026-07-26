---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-07-26
estado: resuelto
categoria: programa
prioridad: baja
---

# GNOME Terminal

Terminal por defecto del entorno [[GNOME]]. Es la terminal más común en distribuciones como [[Ubuntu]], [[Fedora]] Workstation y [[Debian]] con GNOME.

## Instalación

```bash
sudo apt install gnome-terminal      # Debian/Ubuntu
sudo pacman -S gnome-terminal        # Arch
sudo dnf install gnome-terminal      # Fedora
```

## Características

- Pestañas nativas
- Perfiles de configuración (colores, fuente, transparencia)
- Soporte 256 colores y True Color
- Integración con el tema GTK de GNOME
- Consumo de RAM moderado (~25 MB)

## Configuración

La configuración se realiza desde la interfaz gráfica: **Preferencias → Perfil**. No hay un archivo de configuración directo editable a mano, aunque los perfiles se almacenan en `dconf`:

```bash
# Ver/exportar perfil
dconf dump /org/gnome/terminal/legacy/profiles:/
```

## Transparencia

Se puede configurar desde Preferencias → Perfil → Fondo → Transparencia (no es translúcida nativa, sino que usa el fondo del escritorio).

## Ver también

- [[GNOME]] — entorno de escritorio asociado
- [[Emuladores de Terminal]] — índice + comparativa
- [[Konsole]] — alternativa en KDE
- [[Xfce Terminal]] — alternativa ligera

## Enlaces externos

- [GNOME Terminal — GNOME Wiki](https://wiki.gnome.org/Apps/Terminal)
- [Wikipedia — GNOME Terminal](https://en.wikipedia.org/wiki/GNOME_Terminal)

#programa #terminal
