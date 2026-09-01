# ============================================================
# Proyecto: Cáncer de mama - Neuquén
# Script: 05_crear_sqlite.R
# Objetivo: crear la base SQLite para análisis con SQL
# ============================================================


# ------------------------------------------------------------
# 1. Paquetes
# ------------------------------------------------------------

library(DBI)
library(RSQLite)
library(sf)
library(dplyr)


# ------------------------------------------------------------
# 2. Ejecutar limpieza y controles previos
# ------------------------------------------------------------

source("R/03_controles.R")


# ------------------------------------------------------------
# 3. Ruta de la base SQLite
# ------------------------------------------------------------

archivo_sqlite <- "datos/procesados/cancer_mama_neuquen.sqlite"


# ------------------------------------------------------------
# 4. Crear / reemplazar la base SQLite
# ------------------------------------------------------------

if (file.exists(archivo_sqlite)) {
  file.remove(archivo_sqlite)
}

con <- dbConnect(
  SQLite(),
  archivo_sqlite
)


# ------------------------------------------------------------
# 5. Preparar tabla de establecimientos
#    La geometría se conserva aparte en el GeoPackage.
#    Aquí incorporamos coordenadas para consultas tabulares.
# ------------------------------------------------------------

coordenadas <- st_coordinates(establecimientos_limpios)

establecimientos_sql <- establecimientos_limpios |>
  st_drop_geometry() |>
  as_tibble() |>
  mutate(
    x = coordenadas[, "X"],
    y = coordenadas[, "Y"]
  )


# ------------------------------------------------------------
# 6. Escribir tablas en SQLite
# ------------------------------------------------------------

dbWriteTable(
  con,
  "base_cancer",
  base_limpia,
  overwrite = TRUE
)

dbWriteTable(
  con,
  "referencias",
  referencia_original,
  overwrite = TRUE
)

dbWriteTable(
  con,
  "equivalencias_ap",
  equivalencias_ap,
  overwrite = TRUE
)

dbWriteTable(
  con,
  "establecimientos",
  establecimientos_sql,
  overwrite = TRUE
)

dbWriteTable(
  con,
  "establecimientos_por_ap",
  establecimientos_por_ap,
  overwrite = TRUE
)


# ------------------------------------------------------------
# 7. Control de tablas creadas
# ------------------------------------------------------------

dbListTables(con)


# ------------------------------------------------------------
# 8. Controles básicos desde SQL
# ------------------------------------------------------------

dbGetQuery(
  con,
  "
  SELECT COUNT(*) AS registros
  FROM base_cancer;
  "
)

dbGetQuery(
  con,
  "
  SELECT COUNT(DISTINCT AP) AS areas_programaticas
  FROM base_cancer;
  "
)

dbGetQuery(
  con,
  "
  SELECT MIN(Año) AS anio_inicial,
         MAX(Año) AS anio_final
  FROM base_cancer;
  "
)

dbGetQuery(
  con,
  "
  SELECT COUNT(*) AS establecimientos
  FROM establecimientos;
  "
)


# ------------------------------------------------------------
# 9. Cerrar conexión
# ------------------------------------------------------------

dbDisconnect(con)