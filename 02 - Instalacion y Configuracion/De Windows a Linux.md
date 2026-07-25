---
fecha_creacion: 2026-07-19
fecha_modificacion: 2026-07-24
estado: resuelto
categoria: instalacion
prioridad: alta
---

# De Windows a Linux: Guía de supervivencia 2026

## Índice

| Sección                                                                         | Contenido                                                   |
| ------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| [[#Introducción: El fin de una era y tu nuevo comienzo]]                        | Motivación, contexto, qué esperar                           |
| [[#Capítulo 1: El motor bajo el capó: ¿Qué es Linux realmente?]]                | Kernel, GNU/Linux, seguridad, antivirus                     |
| [[#Capítulo 2: Tu nuevo hogar: Eligiendo la distribución ideal para ti]]        | Mint, Zorin, Ubuntu, Pop!_OS, Puppy Linux                   |
| [[#Capítulo 3: El Gran Salto: Preparación e Instalación]]                       | ISO, Live USB, BIOS/UEFI, Dual Boot, particiones            |
| [[#Capítulo 4: Primeros pasos en tierra firme: Configuración post-instalación]] | Drivers, códecs, apps, gaming, firewall, Timeshift          |
| [[#Capítulo 5: Perdiendo el miedo a la Terminal (El idioma de Linux)]]          | Shell, comandos básicos, pipes                              |
| [[#Capítulo 6: ¿Dónde están mis cosas? El sistema de archivos y permisos]]      | FHS, /home, /etc, /bin, permisos rwx                        |
| [[#Capítulo 7: Manual de Rescate: Qué hacer cuando algo no arranca]]            | GRUB, Kernel Panic, Timeshift recovery, volver a Windows    |
| [[#Capítulo 8: Los problemas más comunes de la primera semana]]                 | WiFi, sonido, touchpad, impresora, batería, Wine            |
| [[#📋 Checklist de Instalación: El Salto a Linux en 2026]]                      | Fases 1-4: preparación, BIOS, instalación, post-instalación |
| [[#🚀 Hoja de Trucos: Comandos de Supervivencia 2026]]                          | Referencia rápida de comandos esenciales                    |
| [[#Ver también]]                                                                | Notas relacionadas del vault                                |

## Introducción: El fin de una era y tu nuevo comienzo

¿Alguna vez has sentido que tu computadora ya no te pertenece? Publicidad en el menú de inicio, actualizaciones que se instalan cuando más prisa tienes y esa sensación constante de que tus datos están siendo succionados por una aspiradora invisible llamada telemetría. 

En 2026, la tecnología ha llegado a un punto crítico. Windows 11 ha dejado atrás a millones de computadoras perfectamente funcionales por requisitos de hardware arbitrarios. Pero aquí tienes un secreto: **tu PC todavía tiene mucho que dar**.

Este libro no es para "hackers" de película que viven en sótanos oscuros. Es para ti, que quieres navegar, trabajar, jugar y, sobre todo, recuperar el control de tu herramienta de trabajo diaria. Aquí aprenderás que Linux en 2026 es tan sencillo como cualquier otro sistema, pero con una diferencia vital: **tú mandas**. 

Al final de estas páginas, habrás pasado de la frustración de los pantallazos azules a la fluidez de un sistema que vuela, incluso en hardware que dabas por muerto. Bienvenido a tierra firme.

---

## Capítulo 1: El motor bajo el capó: ¿Qué es Linux realmente?

Para empezar con el pie derecho, debemos romper un mito: **Linux no es un sistema operativo completo**, al menos no técnicamente. 

### [[Kernel Linux|El Kernel]]: El jefe de tráfico
Imagina que tu computadora es una ciudad entera. Las aplicaciones (tu navegador, Spotify, el editor de texto) son los coches que circulan por ella. La memoria RAM es el aparcamiento y el procesador son las carreteras. 

En esta ciudad, **el [[Kernel Linux]] es el jefe de tráfico**. Su trabajo es invisible pero vital: decide quién pasa primero, dónde se estaciona cada aplicación y se asegura de que la ciudad no colapse. Sin él, el hardware (los edificios) y el software (los coches) no sabrían cómo hablar entre ellos.

### El matrimonio perfecto: [[GNU y Linux|GNU + Linux]]
Si Linux es el motor, ¿dónde está el volante, los pedales y los asientos? Ahí es donde entra **[[GNU y Linux|GNU]]**. A finales de los 80, un movimiento buscaba crear herramientas libres (compiladores, editores, terminales) para que los usuarios no dependieran de empresas cerradas. 

Cuando el motor de Linus Torvalds se unió a las herramientas de GNU, nació lo que hoy usamos: **GNU/Linux**. 
*   **Linux** gestiona los recursos físicos.
*   **GNU** te da las herramientas para interactuar con ellos.
*   **La Distribución (Distro)** es el "modelo de coche" (Toyota, Audi, Ford) que empaqueta todo para que sea bonito y funcional.

### ¿Por qué Linux es más seguro y eficiente por diseño?
A diferencia de Windows, donde el sistema es una caja negra cerrada, Linux es **código abierto**. Millones de personas en todo el mundo revisan el motor constantemente. Si hay un fallo o una brecha de seguridad, se detecta y se arregla en horas, no en meses.

Además, Linux no malgasta tus recursos. Mientras que Windows usa gran parte de tu potencia solo para mantenerse encendido y rastrearte, Linux se quita de enmedio para que todo el hardware se dedique a tus tareas.

**❓ Pregunta frecuente: ¿necesito instalar un antivirus?**
No, al menos no como estás acostumbrado en Windows. Linux es un blanco mucho menos atractivo para el [[Malware en Linux|malware]] (por su menor cuota de usuarios de escritorio, su modelo de permisos y la revisión constante del código abierto), así que un antivirus tradicional corriendo en segundo plano no es necesario para uso normal. La única excepción práctica: si compartes archivos frecuentemente con usuarios de Windows (por ejemplo, como servidor de archivos), puede convenirte instalar **ClamAV**, una herramienta gratuita que escanea archivos para evitar pasarles sin querer un virus a ellos — no porque tu Linux esté en riesgo.

**Idea clave:** Linux es libertad. No es solo software gratuito; es la garantía de que puedes estudiar, modificar y compartir tu sistema sin que nadie te pida permiso.

*En el próximo capítulo, te ayudaremos a elegir cuál de los cientos de "modelos de coches" (distribuciones) es el que mejor se adapta a tu estilo de conducción.*

---
## Capítulo 2: Tu nuevo hogar: Eligiendo la distribución ideal para ti

En el mundo Linux, no existe una única "versión". Existen las **distribuciones (o distros)**, que son diferentes sabores del sistema adaptados a distintos tipos de usuarios. Para un principiante en 2026, la clave no es buscar la más potente, sino la que haga que la transición desde Windows sea invisible.

### La regla del 90%
El **90% de los usuarios nuevos** tendrán una experiencia perfecta empezando con **Linux Mint** o **Ubuntu**. No necesitas explorar cientos de opciones; estas dos son los estándares de oro por su estabilidad y facilidad de uso.

### Las mejores opciones para 2026
Aquí tienes el "menú" recomendado para tu primer salto:

*   **[[Linux Mint]] (Cinnamon):** Es la apuesta más segura si vienes de Windows. Su interfaz es familiar, con un menú de inicio y una barra de tareas que funcionan exactamente como esperas.
*   **[[Zorin OS]]:** Diseñado específicamente como un **puente visual**. Al instalarlo, puedes elegir que se vea casi idéntico a Windows 11 o Windows clásico, eliminando la curva de aprendizaje visual.
*   **[[Ubuntu]]:** La distro más popular del mundo. Si buscas un tutorial en internet para cualquier problema, el 99% de las veces la solución estará escrita para Ubuntu.
*   **[[Pop OS|Pop!_OS]]:** Si usas tu computadora para **jugar o tienes una tarjeta de video NVIDIA**, esta es tu opción. Incluye los controladores (drivers) ya instalados de fábrica, algo que suele ser un dolor de cabeza en otros sistemas.

### ¿Tienes una PC muy vieja?
Si tu objetivo es revivir una computadora de hace 10 o 15 años que Windows ya no soporta, existen opciones "ultraligeras":
*   **Lubuntu:** Una versión minimalista de Ubuntu que consume poquísimos recursos.
*   **[[Puppy Linux]]:** Un "milagro" tecnológico que puede funcionar enteramente en la memoria RAM, ideal para equipos con 512MB-1GB de RAM.

**Aviso importante:** Ubuntu "de fábrica" (la edición estándar con GNOME) subió sus requisitos mínimos a 6 GB de RAM y 25 GB de disco con el lanzamiento de la versión 26.04 LTS en abril de 2026 — el primer aumento de RAM mínima desde 2019. Si tu PC tiene menos de eso, no descartes Linux: simplemente salta directo a Lubuntu, Xubuntu o Linux Mint XFCE, que siguen funcionando bien con mucho menos.

**Idea clave:** No te obsesiones con la elección perfecta. Linux te permite cambiar de "sabor" más adelante sin perder tus documentos.

---

## Capítulo 3: El Gran Salto: Preparación e Instalación

Instalar Linux en 2026 no requiere ser un experto en informática. El proceso se ha simplificado tanto que es similar a instalar una aplicación pesada.

### Antes de todo: haz una copia de seguridad
Esto no es opcional, sin importar si vas a borrar Windows por completo o a instalar en Dual Boot: los errores humanos (seleccionar el disco equivocado, una instalación interrumpida) pasan incluso a gente con experiencia.
*   **Qué respaldar:** tus carpetas de Documentos, Escritorio, Descargas, Imágenes y Videos. No olvides los "invisibles": marcadores del navegador (se exportan como archivo desde el menú del navegador) y contraseñas guardadas (usa el gestor de contraseñas de tu navegador para exportarlas, o mejor, empieza a usar uno dedicado como Bitwarden).
*   **Dónde respaldar:** un disco duro externo o pendrive que **no** vayas a usar como el Live USB, o una nube (OneDrive, Google Drive, Proton Drive). Para migraciones, lo más simple y seguro es copiar todo a un disco externo — no depende de tu conexión a internet y lo puedes verificar visualmente antes de continuar.
*   **Regla de oro:** si eliges "Borrar disco e instalar Linux" en el Paso 5, todo lo que había en el disco desaparece de forma permanente e irrecuperable. El Dual Boot es más seguro porque no toca la partición de Windows, pero un respaldo previo sigue siendo tu red de seguridad ante cualquier imprevisto.

### Paso 1: Conseguir la "llave" (La Imagen ISO)
Una **imagen ISO** es un archivo que contiene todo el sistema operativo empaquetado. Debes descargarla siempre desde el sitio oficial de la distribución que elegiste (ej. linuxmint.com o ubuntu.com). 
*   **Tip de experto:** Verifica el código **SHA256** de tu descarga para asegurarte de que el archivo no se corrompió y es seguro.
*   **Nota sobre el tamaño:** Las ISOs de escritorio actuales pesan entre 4 y 6.5 GB (más que hace unos años), así que asegúrate de tener espacio de sobra antes de descargar.

### Paso 2: Crear el "Live USB"
> Para una guía detallada con todas las herramientas y troubleshooting, ver [[Creacion de USB Booteable]].

No puedes simplemente copiar la ISO a un pendrive. Necesitas una herramienta que lo convierta en un disco de arranque. El tamaño de la ISO varía según la distro (Ubuntu ronda los 6.5 GB, Linux Mint unos 3 GB, Fedora Workstation unos 2.5 GB), así que revisa el peso del archivo que descargaste; un pendrive de **8 GB** cubre prácticamente cualquier caso actual.
*   **balenaEtcher:** La opción más sencilla si solo vas a grabar una ISO. Seleccionas el archivo, eliges tu USB y haces clic en "Flash".
*   **Ventoy:** Alternativa recomendada si crees que vas a probar varias distros. Se instala una sola vez en el pendrive y después solo arrastras los archivos ISO que quieras; el menú de arranque los detecta automáticamente sin tener que volver a grabar el USB cada vez.

### Paso 3: Configurar el "saludo inicial" (BIOS/UEFI)
Para que tu PC ignore Windows y arranque desde el USB, debes entrar a la configuración de la BIOS (presionando F2, F12 o Del al encender).
1.  **Cambia el orden de arranque:** Pon el USB como prioridad #1.
2.  **Secure Boot:** En algunas distros, podrías necesitar desactivar esta opción si el sistema no arranca.

### Paso 4: "Probar sin instalar" (La red de seguridad)
Esta es la mejor función de Linux. Al arrancar desde el USB, entrarás en un **modo de prueba (Live Mode)**. Aquí puedes conectarte a WiFi, navegar y verificar que tu sonido y pantalla funcionen correctamente **sin borrar nada de Windows**. Si todo te gusta, haz clic en el icono "Instalar" en el escritorio.

**Antes de darle a "Instalar", revisa esto:**
*   **Conecta el cargador si es una laptop.** El instalador puede negarse a continuar (o advertirte) si detecta batería baja.
*   **Conéctate a internet si puedes.** El instalador te ofrecerá descargar actualizaciones y drivers durante el proceso; aceptar esto te ahorra trabajo después. Si tu WiFi no aparece en el Live Mode, no te preocupes: en el próximo capítulo vemos exactamente cómo resolverlo.
*   **Revisa el idioma del teclado.** El instalador suele detectarlo solo, pero confírmalo escribiendo una "ñ" o una "@" en el campo de prueba; corregirlo ahora evita dolores de cabeza con las contraseñas más adelante.

### Paso 5: La instalación automática
El instalador te preguntará qué hacer con tu disco:
*   **Borrar disco e instalar Linux:** Elimina Windows y deja la PC como nueva solo con Linux.
*   **[[Dual Boot con Windows|Instalar junto a Windows (Dual Boot)]]:** Divide tu disco para que puedas elegir qué sistema usar cada vez que enciendas la PC.

**Antes de elegir [[Dual Boot con Windows|Dual Boot]], prepara el terreno desde Windows:** abre el "Administrador de discos", reduce (achica) la partición de Windows para dejar al menos 40-60 GB de espacio sin asignar para Linux (ver [[Particionado y Esquemas de Disco]]), y si tu disco tiene [[Dual Boot con Windows|BitLocker]] activado, desactívalo temporalmente. Instalar sobre un disco cifrado con BitLocker sin desactivarlo es una de las causas más comunes de que el dual boot falle o de que Windows deje de arrancar.

### ¿Qué es realmente el Dual Boot? (Y qué esperar después)
"Dual Boot" no mezcla los dos sistemas: instala Linux al lado de Windows, en su propio trozo de disco, sin tocar tus archivos ni tus programas de Windows. A partir de ese momento, cada vez que enciendas la PC, aparecerá una pantalla de texto llamada [[GRUB no arranca|GRUB]] preguntándote qué sistema quieres abrir hoy. Te mueves con las flechas del teclado, presionas Enter, y en unos segundos entras a Windows o a Linux con normalidad. Si no tocas nada, GRUB arranca el sistema por defecto (normalmente Linux) después de unos 10 segundos.

Dos cosas que conviene saber de antemano para no llevarte sustos:
*   **El acceso a archivos es de un solo sentido.** Linux puede leer y escribir tus discos de Windows sin problema gracias a `ntfs-3g`, que ya viene preinstalado y activo por defecto en la gran mayoría de distros modernas (no necesitas instalarlo aparte). Windows, en cambio, **no** puede leer las particiones de Linux (formato ext4) a menos que instales un programa extra. Si necesitas mover archivos entre los dos, hazlo con una carpeta o disco compartido en formato NTFS o guarda copias en la nube.
*   **El reloj puede aparecer desconfigurado.** Es normal que, al volver a Windows después de haber usado Linux, la hora aparezca mal (o al revés). Esto pasa porque Windows guarda el reloj del sistema en hora local, mientras que Linux por defecto lo guarda en UTC. Se arregla en segundos desde una terminal de Linux con: `timedatectl set-local-rtc 1 --adjust-system-clock`.

**Para los curiosos: ¿qué hace la instalación "automática" por debajo?** No necesitas saber esto para instalar Linux, pero ayuda a entender el sistema. El instalador crea al menos dos particiones: una para `/` (la raíz, donde vive el sistema) y otra de "swap" (memoria de intercambio, un respaldo en disco por si se llena la RAM). Los usuarios más avanzados suelen separar también `/home` en su propia partición, para poder reinstalar el sistema desde cero sin perder sus archivos personales. Si es tu primera vez, deja que el instalador decida por ti — la opción automática ya hace esto de forma sensata.

**¡No olvides marcar esta casilla!:** Durante la instalación, verás una opción que dice **"Instalar software de terceros para gráficos y WiFi" (ver [[Post-Instalacion Checklist]])**. Márcala siempre. Esto te ahorrará configurar drivers y códecs de video manualmente después.

---

## Capítulo 4: Primeros pasos en tierra firme: Configuración post-instalación

¡Felicidades! Ya tienes Linux funcionando. Pero antes de lanzarte a navegar o trabajar, hay algunos ajustes que convertirán una instalación básica en una estación de trabajo profesional y fluida. En 2026, la mayoría de las distribuciones como **Linux Mint** ya vienen listas para usar, incluyendo navegadores y suites de oficina. Sin embargo, siempre hay "toques finales" necesarios. No tienes que hacerlos todos el primer día — puedes volver a este capítulo como referencia.

### Antes de todo: conoce tu escritorio
Si nunca usaste Linux, este es tu primer minuto de orientación. Aunque cada distro se ve un poco distinta, casi todas comparten esta estructura:
*   **El menú de aplicaciones:** normalmente en la esquina inferior izquierda (igual que el botón de Inicio de Windows). Ahí están todos tus programas instalados, organizados por categoría.
*   **La barra de tareas o panel:** muestra las ventanas abiertas y, en la esquina opuesta al menú, un grupo de íconos pequeños llamado **"bandeja del sistema"**: volumen, batería, y el ícono de **red/WiFi**, donde haces clic para conectarte a una red o cambiar de una a otra (igual que en Windows).
*   **Configuración del sistema:** busca en el menú de aplicaciones algo llamado "Configuración", "Ajustes" o "Preferencias del Sistema". Ahí cambias el fondo de pantalla, la resolución de pantalla, el idioma del teclado, o conectas una impresora — todo con clics, sin necesidad de terminal.
*   **Las notificaciones:** aparecen igual que en Windows, generalmente en la esquina superior o inferior derecha, avisándote de actualizaciones disponibles o mensajes de aplicaciones.

Tómate cinco minutos para explorar estos cuatro puntos antes de seguir. El resto de este capítulo asume que ya sabes llegar al menú de aplicaciones y a Configuración.

### 1. La primera gran actualización
Aunque acabes de instalar el sistema, es probable que existan parches de seguridad recientes. 
*   **En Ubuntu/Mint:** Abre la terminal (no muerde, ya verás) y escribe: `sudo apt update && sudo apt upgrade -y`.
*   **En Fedora:** Usa `sudo dnf upgrade --refresh`.
Esto asegura que el corazón de tu sistema (el kernel) y tus aplicaciones estén al día.

### 2. Controladores (Drivers) y el caso [[NVIDIA no detecta|NVIDIA]]
Linux es famoso por detectar casi todo el hardware automáticamente, pero las tarjetas gráficas NVIDIA a veces necesitan un empujón extra para dar su máximo rendimiento en juegos o edición de video. 
*   No busques en páginas web raras. En Ubuntu o Mint, busca la aplicación **"Administrador de controladores"** y selecciona la versión "propietaria" recomendada. El sistema hará todo el trabajo pesado por ti.

### 3. Códecs: El lenguaje de la multimedia
Por temas de licencias, algunos formatos de video (como MP4) o música no vienen activos de fábrica en todas las distros. 
*   Si durante la instalación olvidaste marcar la casilla de "software de terceros", puedes arreglarlo fácilmente. **En Ubuntu:** `sudo apt install ubuntu-restricted-extras`. **En Linux Mint**, el paquete es distinto: `sudo apt install mint-meta-codecs` (o busca "Instalar códecs multimedia" en el menú, que hace lo mismo con un clic). Con esto, cualquier video que descargues funcionará a la primera.

### 4. Instalar aplicaciones: Tu nueva "Tienda"
Olvida ir a internet a descargar archivos `.exe`. En Linux, lo normal es abrir el **Centro de Software** de tu sistema, buscar el nombre del programa (Spotify, Discord, Zoom, Steam) y hacer clic en instalar. Es más seguro, rápido y todo se actualiza junto con el sistema.

Vas a encontrarte con varios "formatos" de aplicación, y para un principiante puede resultar confuso. Aquí la idea en simple:

*   **Paquetes nativos (.deb en Ubuntu/Mint):** Es el formato "de toda la vida" del sistema, el más ligero e integrado. La tienda los instala solos; si alguna vez descargas un archivo `.deb` manualmente (por ejemplo desde la web oficial de un programa), lo instalas con doble clic o, desde terminal, con `sudo apt install ./archivo.deb`.
*   **[[Snap y Flatpak|Flatpak]]:** Un formato universal que funciona igual en cualquier distro y aísla cada aplicación del resto del sistema (más seguro, aunque un poco más pesado en disco). Muchas distros ya lo traen listo, pero si el tuyo no tiene acceso a la tienda **Flathub** (la más grande del mundo Linux), actívala así:
    ```
    sudo apt install flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    ```
    (En Linux Mint, reinicia la sesión después y Flathub aparecerá directamente en el Centro de Software.)
*   **Snap:** El formato universal propio de Ubuntu, viene activado de fábrica en esa distro. Funciona parecido a Flatpak (aplicaciones aisladas y autoactualizables), pero su tienda es exclusiva de Canonical. No necesitas elegir entre Snap y Flatpak: pueden convivir sin problema, y la tienda de tu sistema ya te muestra cuál vas a instalar.
*   **[[AppImage]]:** Un solo archivo portátil que no se "instala" en el sistema tradicional: le das permiso de ejecución (clic derecho → Propiedades → Permitir ejecutar como programa) y lo abres directamente, como un `.exe` portable de Windows. Útil para programas que no están en ninguna tienda.

**Regla práctica para principiantes:** si el programa que buscas está en el Centro de Software, instálalo desde ahí sin pensar en el formato. Solo necesitas saber la diferencia el día que algo no aparezca en la tienda y tengas que buscar una alternativa.

**¿Y los PPA?** Son "repositorios" no oficiales de terceros que algunos programas piden añadir para poder actualizarse antes que la tienda oficial (`sudo add-apt-repository ppa:nombre/programa`). Funcionan bien, pero como no están verificados por tu distro, solo añade PPAs de fuentes que reconozcas — es la forma más común en que un principiante termina con software poco confiable en el sistema.

### 5. Gaming: Steam, Proton y compañía
> Para una guía completa de gaming en Linux, ver [[Videojuegos en Linux]].

Si migras para jugar, la buena noticia es que en 2026 la mayoría de los juegos de Windows corren en Linux sin que te des cuenta:
*   **Steam** trae integrado **Proton**, una capa de compatibilidad que traduce los juegos de Windows para que corran nativamente. Solo instala Steam desde tu tienda de software, activa "Compatibilidad con otros títulos" en sus ajustes, y juega como siempre.
*   **Lutris** y **Heroic Games Launcher** hacen lo mismo para juegos que no vienen de Steam (Epic Games Store, GOG, Battle.net). Se instalan igual, desde el Centro de Software o Flathub, y te guían para conectar tus otras cuentas.
*   Para saber si un juego específico funciona bien antes de comprarlo, busca su nombre en **ProtonDB**, una web comunitaria que califica la compatibilidad de miles de juegos.

### 6. Activa el cortafuegos ([[Firewall]])
Linux es seguro por diseño, pero activar el firewall es un hábito de dos comandos que no cuesta nada:
```
sudo ufw enable
sudo ufw status
```
Con esto, tu sistema bloquea por defecto las conexiones entrantes no solicitadas, igual que hace el Firewall de Windows.

### 7. SSD: verifica que el TRIM esté activo
Si tu PC tiene un disco SSD (la mayoría de las laptops modernas lo tienen), el sistema necesita "avisarle" periódicamente qué espacio ya no usa, para mantenerlo rápido con el tiempo. Casi todas las distros activan esto automáticamente, pero puedes confirmarlo con:
```
sudo fstrim -v /
```
Si el comando responde con algo como "X GiB trimmed", todo está en orden. No necesitas hacer nada más.

### 8. Tu red de seguridad: [[timeshift|Timeshift]]
Antes de empezar a tocar configuraciones avanzadas, configura **Timeshift**. Es una herramienta que crea "instantáneas" del sistema. Si mañana borras algo que no debías, simplemente abres Timeshift, eliges el punto de ayer y "viajas en el tiempo" para dejar la PC como si nada hubiera pasado.

---

## Capítulo 5: Perdiendo el miedo a la Terminal (El idioma de Linux)

Muchos usuarios nuevos ven la terminal y piensan en una pantalla de Matrix. La realidad es mucho más sencilla: la terminal es simplemente un **intérprete de comandos (Shell)** que recibe tus órdenes y las convierte en instrucciones para el sistema. Es, en esencia, un atajo para usuarios que valoran su tiempo.

### El "Prompt": Esperando tus órdenes
Cuando abres la terminal, verás un símbolo (normalmente `$` o `#`). Eso es el **prompt**, la señal de que el sistema está listo para escucharte.

### Comandos de supervivencia básica
Aquí tienes los "ladrillos" con los que construirás tu autonomía. Pruébalos sin miedo en tu carpeta personal:

*   **`pwd` (Print Working Directory):** Te dice exactamente en qué carpeta estás parado ahora mismo.
*   **`ls` (List):** Te muestra qué archivos y carpetas hay dentro de donde estás.
*   **`cd` (Change Directory):** Para moverte entre carpetas. Ejemplo: `cd Descargas`.
*   **`mkdir`:** Crea una carpeta nueva. Ejemplo: `mkdir Proyectos`.
*   **`cp` y `mv`:** Para copiar o mover/renombrar archivos.
*   **`sudo` (SuperUser Do):** El comando más importante. Es como decir "haz esto como administrador". Se usa para instalar programas o cambiar ajustes críticos del sistema.

### ¿Por qué usar texto en lugar de clics?
Imagina que quieres instalar un navegador. En la interfaz visual tienes que: abrir la tienda, esperar que cargue, buscar el nombre, hacer clic en instalar y poner tu clave.
En la terminal, solo escribes: `sudo apt install firefox` y presionas Enter. **Eso es todo.** 

### El poder de las Tuberías (Pipes)
Linux te permite conectar comandos. Si quieres ver todos tus archivos pero son demasiados, puedes usar el símbolo `|` (la tubería). 
Ejemplo: `ls /usr/bin | more`. Aquí, la lista de archivos pasa al comando `more`, que te permite verlos página por página cómodamente.

**Idea clave:** La terminal no es obligatoria para el 99% de las tareas diarias en 2026, pero conocerla te da un "superpoder": la capacidad de arreglar casi cualquier problema siguiendo una simple línea de texto de un tutorial.

---

## Capítulo 6: ¿Dónde están mis cosas? El sistema de archivos y permisos

Si vienes de Windows, tu primer instinto será buscar el "Disco Local C:". En Linux, eso no existe. Aquí, todo nace de un único punto de origen llamado **Raíz**, representado simplemente por una barra inclinada: `/`.

### La jerarquía para humanos
Linux sigue un estándar llamado **FHS** (Estándar de Jerarquía del Sistema de Archivos), lo que significa que, sin importar la distribución que uses, las carpetas suelen estar en el mismo lugar.

*   **`/home` (Tu refugio):** Es el equivalente a la carpeta "Usuarios" de Windows. Aquí dentro encontrarás una carpeta con tu nombre donde se guardan tus documentos, fotos y descargas. Lo mejor es que, si reinstalas el sistema, puedes mantener tu `/home` intacto.
*   **`/etc` (El panel de control):** Aquí residen los archivos de configuración de todo el sistema. Si quieres cambiar cómo se comporta un programa a nivel global, el archivo estará aquí.
*   **`/bin` y `/usr/bin` (Tus herramientas):** Contienen los programas ejecutables esenciales. Cuando escribes un comando en la terminal, el sistema lo busca aquí.
*   **`/media` y `/mnt` (Discos externos):** Aquí es donde "aparecen" tus pendrives, cámaras o discos duros externos cuando los conectas.

### El sistema de permisos: Tres llaves para cada puerta
En Linux, la seguridad es lo primero. Cada archivo o carpeta tiene tres tipos de permisos:
1.  **Lectura (r):** Ver el contenido.
2.  **Escritura (w):** Modificar o borrar.
3.  **Ejecución (x):** Correr un programa o entrar en una carpeta.

Estos permisos se aplican a tres niveles: al **Dueño** (tú), al **Grupo** y a **Otros**. Si alguna vez intentas abrir algo y recibes un "Permiso denegado", es porque Linux está protegiendo ese archivo de modificaciones accidentales. Para cambiar esto, usamos los comandos `chmod` (cambia permisos) y `chown` (cambia el dueño).

**Idea clave:** "Todo es un archivo" en Linux, incluso tu teclado o tu disco duro. Entender esto es la base para dominar el sistema.

---

## Capítulo 7: Manual de Rescate: Qué hacer cuando algo no arranca

Incluso en 2026, la tecnología puede fallar. Pero a diferencia de Windows, donde un error suele terminar en un formateo forzoso, en Linux casi todo se puede arreglar desde fuera.

### 1. El menú GRUB: Tu primera línea de defensa
Si el sistema no inicia, lo primero que verás es el **GRUB**, el gestor de arranque. 
*   **Truco de rescate:** Si una actualización de kernel (el motor) hizo que tu PC no arranque, selecciona "Opciones avanzadas" en el GRUB y elige un kernel anterior. ¡Magia! El sistema volverá a funcionar como ayer.

### 2. Reparar el arranque (GRUB roto)
A veces, Windows "pisa" el arranque de Linux tras una actualización. No entres en pánico: tus datos siguen ahí.
*   **Solución:** Inicia tu PC con el mismo Live USB que usaste para instalar. Usa una herramienta llamada **Boot-Repair**; con un solo clic, reconstruirá el menú de inicio y recuperará tu acceso a Linux.

### 3. Pantalla negra o Kernel Panic
*   **Kernel Panic:** Es el "error fatal" del sistema: normalmente el equipo se congela o muestra texto técnico en pantalla negra (no es una pantalla azul como en Windows). Suele deberse a drivers incompatibles o hardware fallando.
*   **Pantalla Negra:** Casi siempre es culpa de los drivers de video (NVIDIA). Una solución rápida es añadir la palabra `nomodeset` en las opciones de arranque del GRUB para iniciar con gráficos básicos y poder arreglar el driver.

### 4. Timeshift: Tu "Botón de Deshacer"
Como mencionamos en el Capítulo 4, **Timeshift** es vital. Si el sistema se rompe tanto que no puedes ni entrar, inicia desde un Live USB, abre Timeshift, selecciona una "foto" de tu sistema de hace tres días y restáurala. En 10 minutos, estarás trabajando como si nada hubiera pasado.

### 5. "Ya lo intenté, quiero volver solo a Windows"
No pasa nada — probar Linux no es un compromiso de por vida, y saber que puedes volver atrás sin miedo es parte de dar el salto con confianza. El proceso depende de cómo instalaste:

*   **Si instalaste con "Borrar disco":** simplemente reinstala Windows desde un USB de instalación de Windows (se descarga gratis desde el sitio oficial de Microsoft con la "Media Creation Tool"). Al no haber Dual Boot, no hay nada de Linux que limpiar.
*   **Si instalaste en Dual Boot:**
    1.  Arranca en Windows y abre el **"Administrador de discos"** (búscalo en el menú de inicio).
    2.  Haz clic derecho sobre la o las particiones de Linux (aparecerán como espacio "no reconocido" o "ext4", distintas a tus unidades con letra como C:) y selecciona **"Eliminar volumen"**.
    3.  Haz clic derecho sobre tu partición de Windows (C:) y elige **"Extender volumen"** para que recupere el espacio que ocupaba Linux.
    4.  Reinicia. Es posible que todavía veas el menú GRUB o que la PC no arranque, porque el gestor de arranque de Linux seguía siendo el que mandaba. Si pasa esto, entra a la BIOS/UEFI (F2/F12/Del) y, en la lista de dispositivos de arranque, selecciona **"Windows Boot Manager"** como opción principal.
    5.  Si aun así no arranca, inicia con un USB de instalación de Windows, elige **"Reparar el equipo" → "Solucionar problemas" → "Símbolo del sistema"**, y ejecuta estos tres comandos en orden: `bootrec /fixmbr`, `bootrec /fixboot`, `bootrec /rebuildbcd`. Reinicia y Windows debería arrancar directamente, como si Linux nunca hubiera estado ahí.

**Idea clave:** Nunca apagues la PC a la fuerza durante una actualización. Esa es la causa número uno de problemas de arranque. Si parece que se colgó, dale al menos 30 minutos más.

---

## Capítulo 8: Los problemas más comunes de la primera semana

La mayoría de los sustos de "esto no funciona" en Linux se repiten tanto entre usuarios nuevos que ya tienen solución conocida. Aquí tienes las más frecuentes, explicadas sin rodeos.

### 1. [[WiFi no conecta|El WiFi no aparece o se desconecta solo]]
Es, con diferencia, el problema número uno para quien recién migra. Casi siempre se debe a que el chip de tu tarjeta de red (comúnmente **Broadcom** o **Realtek**) necesita un "firmware" propietario que, por licencias, no viene preinstalado.
*   **Primero, diagnostica:** abre una terminal y escribe `lspci | grep -i network` (o `lspci | grep -i wireless`). Esto te dice la marca exacta de tu chip, que puedes buscar junto con tu distro (ej. "Realtek RTL8821CE Ubuntu").
*   **Mientras lo resuelves:** comparte internet desde tu celular por USB o activa el "punto de acceso" de tu teléfono; así puedes buscar la solución sin quedarte sin conexión.
*   **Solución más común:** ve a "Administrador de controladores" (igual que hiciste con NVIDIA en el Capítulo 4) y busca si aparece un driver adicional para tu tarjeta de red. Si no aparece ahí, suele bastar con instalar el paquete de firmware de tu distro, por ejemplo `sudo apt install linux-firmware` y reiniciar.
*   **Bluetooth no aparece:** normalmente comparte chip con el WiFi, así que arreglar uno suele arreglar el otro. Si sigue sin aparecer, revisa que no esté bloqueado con `rfkill list` y, si lo está, desbloquéalo con `sudo rfkill unblock all`.

### 2. [[Sin sonido|El sonido no funciona o se escucha mal]]
Desde hace unos años, la mayoría de las distros usan **[[PipeWire]]** para gestionar el audio. Casi siempre el problema es que el sistema eligió el dispositivo de salida equivocado (por ejemplo, un HDMI en vez de tus bocinas).
*   Abre la app **"Sonido"** de tu sistema (o instala `pavucontrol` para más control) y verifica que el dispositivo de salida correcto esté seleccionado y no silenciado.

### 3. El touchpad de la laptop no hace gestos o es muy sensible
Los gestos multitáctiles (dos dedos para hacer scroll, tres para cambiar de ventana) dependen del driver `libinput`. En la mayoría de los casos vienen activados de fábrica, pero puedes ajustar sensibilidad, "tap to click" o desactivar el touchpad mientras escribes desde **Configuración > Ratón y Touchpad**.

### 4. La impresora no aparece
Linux gestiona las impresoras con un sistema llamado [[Impresión (CUPS)|CUPS]], que suele detectar impresoras en red automáticamente. Si la tuya no aparece en **Configuración > Impresoras**, casi siempre basta con que esté encendida y en la misma red WiFi; en el peor de los casos, busca el nombre de tu impresora seguido de "linux driver" en internet.

### 5. La batería de la laptop se agota más rápido que en Windows
Es un reclamo real y frecuente, sobre todo justo después de instalar. La solución estándar es instalar **TLP**, una herramienta que ajusta automáticamente el consumo de energía del procesador y la pantalla: `sudo apt install tlp tlp-rdw` y listo, funciona en segundo plano sin configuración adicional.

### 6. "Necesito un programa de Windows que no tiene versión para Linux" (ver [[Wine]] y [[Bottles]])
Antes de resignarte, revisa estas tres opciones en orden:
*   **Busca una alternativa nativa** (por ejemplo, LibreOffice en vez de Microsoft Office, GIMP en vez de Photoshop). Suele ser la opción más estable.
*   **Prueba con [[Wine]] o [[Bottles]]:** son herramientas que "traducen" las llamadas de programas de Windows para que corran directamente en Linux. Funciona muy bien con software antiguo y muchos juegos, pero no con todo.
*   **Como último recurso, usa una [[Virtualización (KVM QEMU libvirt)|máquina virtual]]** con Windows dentro de Linux (por ejemplo, con VirtualBox) para esa única app que de verdad no tiene reemplazo.

### 7. No puedo acceder a mis archivos del disco de Windows
Si al abrir tu disco de Windows desde Linux te aparece como "solo lectura" o directamente no se monta, la causa casi siempre es que Windows no se apagó del todo, dejó el disco en un estado de "hibernación" por culpa del **Inicio Rápido** (por eso lo desactivamos en el checklist). Reinicia Windows por completo (no lo suspendas) una vez para liberar el disco correctamente.

### 8. Quiero ver las carpetas compartidas de otro equipo con Windows en mi red
Esto es distinto al punto anterior: aquí no hablamos del disco interno de tu PC, sino de otra computadora con Windows en tu misma red WiFi que tiene una carpeta compartida. Linux puede verla sin instalar nada extra:
1.  Abre tu **Gestor de Archivos** (Nautilus, Nemo, etc.) y busca en el panel izquierdo la sección **"Red"** o **"Otras ubicaciones"**.
2.  Ahí deberían aparecer los equipos de tu red que tengan carpetas compartidas, incluyendo PCs con Windows.
3.  Si no aparece sola, usa **"Conectar a servidor"** y escribe la dirección con el formato `smb://nombre-o-ip-del-equipo/carpeta`.

Si además quieres que **tu PC con Linux** comparta una carpeta para que la vean tus equipos Windows (no solo al revés), necesitas instalar el servicio Samba: `sudo apt install samba`. Configurarlo a fondo es un tema más avanzado — para la mayoría de los casos, con verlo desde Linux hacia Windows (los pasos de arriba) es suficiente.

**Idea clave:** Ninguno de estos problemas significa que "Linux no sirve" o que hiciste algo mal. Son fricciones conocidas, documentadas miles de veces por la comunidad, y casi siempre se resuelven con un comando o un clic una vez que sabes dónde mirar.

---

# 📋 Checklist de Instalación: El Salto a Linux en 2026

Sigue este listado paso a paso para asegurar una transición fluida y sin pérdida de datos. Recuerda que en 2026, con el fin del soporte de Windows 10, esta es la mejor forma de mantener tu PC segura y rápida.

### **Fase 1: Preparación (En Windows)**
- [ ] **Elegir la Distribución:** Si eres principiante, las opciones recomendadas para 2026 son **Linux Mint** (familiaridad), **Ubuntu** (soporte) o **Zorin OS** (puente visual).
- [ ] **Copia de Seguridad:** Haz un backup de tus archivos importantes en la nube o en un disco externo. Una instalación limpia borrará todo el disco (detalles en el Capítulo 3).
- [ ] **Descargar la ISO:** Baja el archivo siempre desde el sitio web oficial de la distro elegida.
- [ ] **Verificar el Hash SHA256:** Asegúrate de que la descarga sea íntegra y segura comparando el código publicado en la web oficial.
- [ ] **Crear el Live USB:** Usa herramientas sencillas como **balenaEtcher** o **Ventoy** para "quemar" la ISO en un pendrive de al menos 8 GB (las ISOs actuales ya no caben en 4 GB).
- [ ] **Desactivar "Inicio Rápido" en Windows:** Si planeas mantener Windows (Dual Boot), deshabilita esta opción en el Panel de Control para evitar bloqueos del disco.
- [ ] **Liberar espacio para Linux (solo Dual Boot):** Desde el "Administrador de discos" de Windows, reduce la partición para dejar 40-60 GB libres, y desactiva BitLocker si está activo.

### **Fase 2: Configuración del Hardware (BIOS/UEFI)**
- [ ] **Acceder al menú de arranque:** Reinicia y presiona la tecla de función de tu fabricante (F2, F12, Supr) antes de que cargue Windows.
- [ ] **Prioridad de Arranque:** Configura el USB como la primera opción en el orden de inicio (Boot Order).
- [ ] **Secure Boot:** Si la distribución no arranca, prueba desactivar el Secure Boot en la configuración de la UEFI.

### **Fase 3: El Proceso de Instalación**
- [ ] **Modo Live (Probar sin instalar):** Antes de hacer clic en instalar, verifica que el WiFi, el sonido y la resolución de pantalla funcionen correctamente (si el WiFi no aparece, revisa el Capítulo 8 antes de continuar).
- [ ] **Selección de Idioma y Teclado:** Configura tu idioma para evitar problemas con símbolos como la "ñ" o la "@".
- [ ] **Tipo de Instalación:** Selecciona "Borrar disco" (Limpia) o "Instalar junto a Windows" (Dual Boot) según tu preferencia.
- [ ] **Software de Terceros:** Marca SIEMPRE la casilla para instalar controladores propietarios (NVIDIA/WiFi) y códecs multimedia (MP3/MP4).
- [ ] **Crear Usuario:** Elige un nombre de usuario y una contraseña robusta. La necesitarás cada vez que quieras instalar programas o hacer cambios técnicos.

### **Fase 4: Post-Instalación (Tierra Firme)**
- [ ] **Retirar el USB:** Cuando el instalador termine, saca el pendrive y presiona Enter para reiniciar.
- [ ] **Actualización Inicial:** Abre la terminal y ejecuta `sudo apt update && sudo apt upgrade` para recibir los últimos parches de seguridad.
- [ ] **Configurar Timeshift:** Crea tu primera "instantánea" o punto de restauración para poder volver atrás si cometes un error configurando el sistema.
- [ ] **Instalar Drivers Adicionales:** Si tienes una tarjeta NVIDIA, ve al "Administrador de controladores" y activa la versión recomendada.
- [ ] **Instalar códecs multimedia:** `ubuntu-restricted-extras` en Ubuntu o `mint-meta-codecs` en Mint (ver Capítulo 4).
- [ ] **Activar Flatpak/Flathub:** Asegúrate de tener acceso a la tienda de aplicaciones más grande del mundo Linux (comandos en el Capítulo 4).
- [ ] **Activar el Firewall:** `sudo ufw enable` para bloquear conexiones entrantes no solicitadas por defecto.
- [ ] **Verificar TRIM (solo SSD):** `sudo fstrim -v /` para confirmar que tu disco se mantiene rápido con el tiempo.

---


# 🚀 Hoja de Trucos: Comandos de Supervivencia 2026

En Linux, la terminal no es una barrera, es una herramienta de precisión. Usa esta guía rápida para dominar las tareas más comunes desde el primer día.

### 📂 Navegación y Gestión de Archivos
*   **`pwd`**: Muestra la ruta completa de la carpeta donde estás ahora mismo.
*   **`ls -l`**: Lista archivos y carpetas mostrando permisos, dueño y tamaño.
*   **`cd [carpeta]`**: Cambia de directorio. `cd ..` te sube un nivel en la jerarquía.
*   **`mkdir [nombre]`**: Crea una carpeta nueva.
*   **`cp [origen] [destino]`**: Copia archivos o carpetas (usa `-r` para carpetas).
*   **`mv [archivo] [destino]`**: Mueve o renombra un archivo o directorio.
*   **`rm [archivo]`**: Elimina un archivo permanentemente. **¡Cuidado!** No hay papelera de reciclaje en la terminal.

### 🛠️ Administración y Seguridad
*   **`sudo [comando]`**: Ejecuta una orden con privilegios de administrador (SuperUser Do).
*   **`chmod [permisos] [archivo]`**: Cambia los permisos de lectura, escritura o ejecución.
*   **`chown [usuario]:[grupo] [archivo]`**: Cambia el dueño legítimo de un archivo o carpeta.
*   **`passwd`**: Te permite cambiar tu contraseña de usuario.

### 📦 Gestión de Aplicaciones (Debian/Ubuntu/Mint)
*   **`sudo apt update`**: Actualiza la lista de software disponible en los repositorios.
*   **`sudo apt upgrade`**: Instala las versiones más recientes de tus programas actuales.
*   **`sudo apt install [nombre]`**: Busca e instala una aplicación nueva automáticamente.
*   **`sudo apt remove [nombre]`**: Desinstala un programa del sistema.

### ⚙️ Monitoreo del Sistema y Procesos
*   **`top`** / **`htop`**: Muestra el uso de CPU y RAM por cada proceso en tiempo real.
*   **`ps aux`**: Lista todos los procesos que se están ejecutando en el sistema.
*   **`kill -9 [PID]`**: Fuerza el cierre de un programa que no responde.
*   **`df -h`**: Verifica el espacio libre en tus discos en formato legible (GB/MB).
*   **`free -h`**: Muestra cuánta memoria RAM tienes disponible.

### 🌐 Redes y Conectividad
*   **`ip a`**: Muestra tu dirección IP actual y el estado de tus interfaces de red.
*   **`ping [servidor]`**: Comprueba si tienes conexión a un sitio (ej. `ping google.com`).
*   **`ss -tulnp`**: Muestra los puertos de red que están "escuchando" conexiones.
*   **`nslookup [dominio]`**: Averigua la dirección IP vinculada a un nombre de dominio.

### 🔍 Ayuda y Registros (Logs)
*   **`man [comando]`**: Abre el manual de instrucciones detallado de cualquier comando.
*   **`journalctl -xe`**: Muestra los mensajes de error más recientes del sistema.
*   **`dmesg | tail`**: Muestra los últimos mensajes detectados por el Kernel (útil para hardware).

---

Has llegado al final de esta guía, pero este es solo el comienzo de tu verdadera autonomía digital. Cruzar el puente de Windows a Linux en 2026 no es solo un cambio de programas o de estética; es una declaración de principios sobre quién tiene el control real de tu computadora. 

A lo largo de estas páginas, has visto que Linux ya no es ese sistema oscuro reservado para expertos en sótanos. Es una herramienta moderna, estable y sumamente flexible que se adapta a lo que tú necesites, ya sea revivir una laptop de hace diez años o potenciar una estación de trabajo de última generación. 

En un mundo donde los sistemas tradicionales se vuelven cada vez más cerrados y vigilados, Linux te ofrece un refugio de privacidad y eficiencia. Has aprendido que no necesitas ser un programador para navegar con seguridad, gestionar tus archivos o incluso asomarte al poder de la terminal. 

**Tu hoja de ruta a partir de ahora es simple:**
1.  **No tengas miedo a romper cosas.** Gracias a herramientas como Timeshift y el modo Live USB, siempre tienes una red de seguridad para volver atrás si algo falla.
2.  **Explora a tu ritmo.** No hay prisa por dominar cada comando. Empieza usando tu navegador y tus apps diarias, y deja que la curiosidad te lleve al siguiente nivel.
3.  **Apóyate en la comunidad.** Si tienes un problema, recuerda que millones de usuarios ya pasaron por lo mismo y la solución está a un foro o un tutorial de distancia.

Tu vieja PC ya no está condenada a ser basura electrónica, y tu privacidad ya no está en venta. Tienes el motor, tienes el volante y ahora tienes el mapa. Es hora de conectar ese USB, reiniciar tu equipo y descubrir por qué, una vez que pruebas la libertad de Linux, es casi imposible mirar atrás. 

**¡Bienvenido al lado libre de la tecnología!**

---

## Ver también

- [[Proceso de Instalacion General]] — guía detallada con sistemas de archivos, swap, cifrado, kernels
- [[Post-Instalacion Checklist]] — lista completa de tareas post-instalación
- [[Creacion de USB Booteable]] — herramientas, persistencia, Secure Boot, troubleshooting
- [[Dual Boot con Windows]] — reparación de boot, BitLocker, NTFS nativo, reloj desincronizado
- [[Particionado y Esquemas de Disco]] — esquemas de particionado, LUKS, LVM
- [[Cifrado (LUKS dm-crypt GPG)]] — cifrado de disco completo y archivos
- [[Cheat Sheet - Comandos Esenciales]] — referencia rápida de comandos
- [[Solucion de Problemas - Recursos]] — metodología de troubleshooting
- [[GRUB no arranca]] — recuperación del gestor de arranque
- [[WiFi no conecta]] — solución de problemas de red
- [[Sin sonido]] — diagnóstico de audio
- [[NVIDIA no detecta]] — controladores propietarios
- [[Videojuegos en Linux]] — gaming, Steam, Proton, emulación
- [[Wine]] y [[Bottles]] — ejecutar programas de Windows en Linux
- [[timeshift]] — instantáneas del sistema y recuperación
- [[Firewall]] — ufw, firewalld, nftables, iptables
- [[Snap y Flatpak]] — formatos universales de paquetes
- [[AppImage]] — aplicaciones portátiles
- [[Virtualización (KVM QEMU libvirt)]] — máquinas virtuales en Linux
- [[Gestores de Paquetes]] — apt, dnf, pacman, y formatos portables

#instalacion #windows #migracion #guia