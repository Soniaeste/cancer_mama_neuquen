# ============================================================
# Proyecto: Cáncer de mama - Neuquén
# Script: 01_importacion.R
# Objetivo: importar las fuentes originales del proyecto
# ============================================================


# ------------------------------------------------------------
# 1. Paquetes
# ------------------------------------------------------------

library(sf)
library(dplyr)
library(readxl)


# ------------------------------------------------------------
# 2. Rutas de los datos originales
# ------------------------------------------------------------

archivo_excel <- "datos/originales/BASE 1.xlsx"
archivo_gpkg  <- "datos/originales/cancer_neuquen.gpkg"


# ------------------------------------------------------------
# 3. Control de existencia de los archivos
# ------------------------------------------------------------

stopifnot(
  file.exists(archivo_excel),
  file.exists(archivo_gpkg)
)


# ------------------------------------------------------------
# 4. Capas disponibles en el GeoPackage
# ------------------------------------------------------------

capas <- st_layers(archivo_gpkg)

capas


# ------------------------------------------------------------
# 5. Importación de las capas espaciales
# ------------------------------------------------------------

establecimientos_salud <- st_read(
  archivo_gpkg,
  layer = "establecimientos_salud",
  quiet = TRUE
)

neuquen_departamentos <- st_read(
  archivo_gpkg,
  layer = "neuquen_departamentos",
  quiet = TRUE
)

neuquen_provincia <- st_read(
  archivo_gpkg,
  layer = "neuquen_provincia",
  quiet = TRUE
)


# ------------------------------------------------------------
# 6. Hojas disponibles en el archivo Excel
# ------------------------------------------------------------

hojas_excel <- excel_sheets(archivo_excel)

hojas_excel


# ------------------------------------------------------------
# 7. Importación de la base estadística
# ------------------------------------------------------------

base_original <- read_excel(
  archivo_excel,
  sheet = "BASE"
)


# ------------------------------------------------------------
# 8. Importación de la hoja de referencia
# ------------------------------------------------------------

referencia_original <- read_excel(
  archivo_excel,
  sheet = "REFERENCIA",
  col_names = c("variable", "descripcion")
)


# ------------------------------------------------------------
# 9. Controles básicos de importación
# ------------------------------------------------------------

dim(base_original)

dim(referencia_original)

dim(establecimientos_salud)

dim(neuquen_departamentos)

dim(neuquen_provincia)


# ------------------------------------------------------------
# 10. Control de creación de objetos
# ------------------------------------------------------------

stopifnot(
  exists("base_original"),
  exists("referencia_original"),
  exists("establecimientos_salud"),
  exists("neuquen_departamentos"),
  exists("neuquen_provincia")
)
