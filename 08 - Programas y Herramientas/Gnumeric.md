---
fecha_creacion: 2026-07-26
fecha_modificacion: 2026-09-02
estado: resuelto
categoria: programa
prioridad: baja
---

# Gnumeric

Hoja de cálculo ligera y rápida, parte del proyecto GNOME. Se complementa con [[AbiWord]] como alternativa ultraligera a LibreOffice Calc.

## Instalación

```bash
sudo apt install gnumeric             # Debian/Ubuntu
sudo pacman -S gnumeric              # Arch
sudo dnf install gnumeric            # Fedora
```

## Primeros pasos

```bash
gnumeric                            # Abrir interfaz gráfica
gnumeric datos.csv                  # Abrir archivo CSV
gnumeric hoja.xlsx                  # Abrir libro de Excel
gnumeric --embed                    # Incrustar en ventana GTK padre
```

Gnumeric tiene un excelente motor de importación CSV con detección automática de separadores, codificación y tipos de columna.

## Formatos compatibles

| Formato | Lectura | Escritura |
|---|---|---|
| .xlsx | ✅ | ✅ |
| .ods (ODF) | ✅ | ✅ |
| .xls (Excel 97) | ✅ | ❌ |
| .csv | ✅ | ✅ |
| .tsv | ✅ | ✅ |
| .html | ✅ | ✅ |
| .psv | ✅ | ✅ |
| .dif | ✅ | ✅ |
| .slk (SYLK) | ✅ | ✅ |

## Características

- **Muy ligero**: ~5 MB de instalación, arranque instantáneo
- **Alto rendimiento**: abre y procesa archivos CSV con millones de filas sin despeinarse
- **Motor de cálculo**: muy preciso, compatible con ~600 funciones (incluyendo estadísticas financieras, ingeniería, fecha/hora)
- **Importación CSV avanzada**: detección automática de separador, comillas, encoding
- **Gráficos**: integrados básicos (barras, líneas, tarta, dispersión, área)
- **Análisis estadístico**: regresión, ANOVA, pruebas t, chi-cuadrado y más
- **Análisis financiero**: VAN, TIR, amortización, tablas de préstamos

## Uso avanzado

```bash
# Convertir CSV a XLSX desde línea de comandos
gnumeric --import=csv datos.csv --export=xlsx datos.xlsx

# Procesar CSV grande con filtro de columnas
gnumeric --import=csv datos.csv --export=csv filtrado.csv -columns="A,B,D"
```

Dentro de la aplicación, las funciones estadísticas más usadas:

| Función | Uso |
|---|---|
| `=MEDIA()` | Promedio aritmético |
| `=DESVEST()` | Desviación estándar |
| `=VAR()` | Varianza |
| `=COVARIANZA()` | Covarianza entre dos rangos |
| `=REGRESION()` | Regresión lineal |
| `=PRUEBA.T()` | Prueba t de Student |

## Ventajas

- Inigualable para procesar CSV grandes (más rápido que Excel o Calc)
- Consume ~25 MB de RAM frente a ~200 MB de LibreOffice Calc
- Ideal para hardware antiguo o limitado (RPi, netbooks)
- Catálogo de funciones estadísticas/financieras más completo que AbiWord

## Desventajas

- Sin soporte de tablas dinámicas (pivot tables)
- Sin macros ni scripts (VB, Python)
- Sin control de versiones ni colaboración
- Interfaz muy básica, sin cinta de opciones

## Gnumeric vs LibreOffice Calc vs Excel

| Aspecto | Gnumeric | LibreOffice Calc | Excel |
|---|---|---|---|
| Peso | ~5 MB | ~500 MB (suite) | ~3 GB |
| Funciones | ~600 | ~500 | ~500 |
| Macros | No | Basic / Python | VBA |
| Rendimiento CSV | Excelente | Bueno | Bueno |
| Código abierto | Sí | Sí | No |

## Troubleshooting

| Problema | Causa | Solución |
|---|---|---|
| No abre .xlsx | Falta plugin | Instalar `libgsf` o usar `gnumeric-plugins` |
| Gráficos no se ven | Versión GTK incompatible | Actualizar GTK o gnumeric |
| CSV con encoding mal | Caracteres no UTF-8 | Re-importar forzando encoding |

## Ver también

- [[AbiWord]] — procesador de textos ligero
- [[LibreOffice]] — suite completa
- [[Suite de Oficina]] — índice + comparativa

## Enlaces externos

- [Sitio oficial](http://gnumeric.org/)
- [Wikipedia — Gnumeric](https://en.wikipedia.org/wiki/Gnumeric)

#programa #ofimatica
