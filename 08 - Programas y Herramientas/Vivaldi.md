---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-03
estado: resuelto
categoria: programa
prioridad: baja
licencia: Propietaria (freeware)
alternativas: [[Chromium]], [[Brave]], [[Firefox]]
---

# Vivaldi

> Navegador basado en Chromium/Blink, creado por el cofundador de Opera, conocido por su altísima personalización.

## Qué es

**Vivaldi** es un navegador basado en Chromium/Blink creado por el equipo original de Opera (Jon von Tetzchner). Destaca por su **alta personalización**: pestañas apilables, paneles laterales, gestos del ratón, división de pantalla (tiling), comandos rápidos y un salvapantallas de nueva pestaña muy configurable. Es propietario (freeware), pero gratis.

## Instalación

```bash
# Debian/Ubuntu (repo oficial)
wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/vivaldi.gpg
echo "deb [signed-by=/usr/share/keyrings/vivaldi.gpg] https://repo.vivaldi.com/archive/deb/ stable main" | sudo tee /etc/apt/sources.list.d/vivaldi.list
sudo apt update && sudo apt install vivaldi-stable

# Arch / AUR
yay -S vivaldi

# Fedora (repo oficial)
sudo dnf config-manager --add-repo https://repo.vivaldi.com/archive/vivaldi-fedora.repo
sudo dnf install vivaldi-stable

# Flatpak
flatpak install flathub com.vivaldi.Vivaldi
```

## Configuración básica

- Ajustes muy completos en `vivaldi://settings`.
- **Comandos rápidos** (`F2` o `Ctrl+Space`): lanzar acciones, pestañas, marcadores.
- Pestañas apilables y con agrupación, paneles laterales configurables.
- **Temas**: apariencia clara/oscura, tema según el color de la web, fondos personalizados.
- **Gestos del ratón** y **rocker gestures** (botón derecho+izquierdo para retroceder) configurables en Ajustes → Ratón.

## Funciones destacadas

| Función | Qué hace | Dónde |
|---|---|---|
| **Tab stacking** | Agrupar pestañas en pilas (apilar/desapilar) | Botón derecho sobre pestaña |
| **Tab tiling** | Dividir la ventana en 2-4 vistas simultáneas | `Ctrl+Shift+L` o botón en barra |
| **Workspaces** | Espacios de trabajo separados (personal/trabajo) | Barra lateral o `Ctrl+Shift+W` |
| **Paneles** | Web panel, notas, marcadores, descargas, contactos | Barra lateral izquierda |
| **Notas** | Capturar texto/imagen con notas asociadas | `Ctrl+F2` |
| **Comandos rápidos** | Buscador de acciones/tabs/historial/marcadores | `F2` o `Ctrl+Space` |
| **Captura de pantalla** | Recortar página completa o región | Atajo configurable |
| **Correo y calendario** | Clientes integrados (Vivaldi Mail/Calendar) | Iconos de barra inferior |

## Comandos / atajos útiles

| Atajo | Efecto |
|---|---|
| `F2` | Comandos rápidos |
| `Ctrl+F2` | Notas |
| `Ctrl+Shift+L` | Dividir pantalla (tiling) |
| `Alt+→/←` | Navegar pestañas apiladas |
| `Ctrl+Shift+W` | Crear/entrar en workspace |
| `Ctrl+1..9` | Activar panel lateral 1..9 |
| `Ctrl+E` | Buscar en la barra de direcciones |
| `Ctrl+Shift+D` | Añadir página a marcadores |

## Uso avanzado

```bash
# lanzar Vivaldi con un perfil separado
vivaldi --user-data-dir=~/vivaldi-trabajo

# modo de navegación privada
vivaldi --incognito

# forzar aceleración por hardware
vivaldi --enable-gpu-rasterization

# en Wayland (si la sesión lo soporta)
vivaldi --ozone-platform-hint=auto
```

### Sincronización

**Vivaldi Sync** sincroniza marcadores, contraseñas, ajustes, historial y pestañas abiertas entre dispositivos, con **cifrado de extremo a extremo** (la contraseña de cifrado se puede fijar manualmente). Se configura en Ajustes → Sincronización con una cuenta Vivaldi.

### Privacidad

- Bloqueador de anuncios y rastreadores integrado (Ajustes → Privacidad → Rastreadores y anuncios).
- No vende datos; la telemetría es opcional y desactivable.
- La barra de direcciones puede usar el motor de búsqueda que elijas (DuckDuckGo, Startpage…).

## Comparativa con alternativas

| Aspecto | Vivaldi | Brave | Firefox | Opera |
|---|---|---|---|---|
| **Personalización** | Muy alta | Media | Media-alta | Media |
| **Motor** | Blink | Blink | Gecko | Blink |
| **Bloqueo integrado** | Manual | Integrado (agresivo) | uBlock opcional | Integrado (VPN) |
| **Licencia** | Propietaria | MPL-2.0 (opcional BAT) | MPL-2.0 | Propietaria |
| **Correo/Calendario** | Integrados | No | No | No |

**Cuándo elegir cada uno**: Vivaldi si valoras la productividad integrada (workspaces, tiling, notas, correo) y la personalización máxima; Brave si quieres bloqueo de anuncios agresivo por defecto; Firefox si priorizas software libre y extensiones; Chromium si quieres el Chromium puro sin capas propietarias.

## Troubleshooting / Problemas frecuentes

| Problema | Causa | Solución |
|---|---|---|
| Consumo de RAM alto | Muchas características activas | Desactivar animaciones/paneles no usados; usar menos workspaces |
| Sincronización limitada | Sin cuenta Vivaldi/Sync cifrado | Activar Vivaldi Sync desde ajustes (cifrado E2E) |
| Video 4K con tirones | Aceleración por hardware desactivada | Activar GPU en ajustes o `--enable-gpu-rasterization` |
| Pantalla en blanco en Wayland | Ozone/GPU conflictivo | Probar `--ozone-platform-hint=auto` o `--disable-gpu` |
| No guarda contraseñas | Vivaldi Sync sin cifrado configurado | Configurar clave de cifrado en Sincronización |
| Perfil corrupto tras caída | Archivos de sesión dañados | Lanzar con `--user-data-dir` nuevo o borrar `Default/Session` |

## Notas y advertencias

- Incluye Sync de Vivaldi, que requiere cuenta (con cifrado de dispositivo a dispositivo).
- No es open source completo: la lógica propietaria se une a Chromium.

## Enlaces externos

- [Vivaldi — sitio oficial](https://vivaldi.com/)
- [Wikipedia — Vivaldi (web browser)](https://en.wikipedia.org/wiki/Vivaldi_(web_browser))
- [Arch Wiki — Vivaldi](https://wiki.archlinux.org/title/Vivaldi)

## Ver también

- [[Chromium]] — base open source de Vivaldi
- [[Brave]] — alternativa Chromium con bloqueo de anuncios
- [[Navegadores Web]] — índice comparativo
- [[Atajos de teclado - Chromium]] — atajos de la base Chromium

#programa #navegador