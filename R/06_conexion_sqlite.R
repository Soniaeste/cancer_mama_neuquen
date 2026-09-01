# ============================================================
# Proyecto: Cáncer de mama - Neuquén
# Script: 06_conexion_sqlite.R
# Objetivo: conectarse a la base SQLite
# ============================================================

library(DBI)
library(RSQLite)

archivo_sqlite <- "datos/procesados/cancer_mama_neuquen.sqlite"

con <- dbConnect(
  SQLite(),
  archivo_sqlite
)

# Ver tablas disponibles
dbListTables(con)

dbGetQuery(
  con,
  "
  SELECT *
  FROM base_cancer
  LIMIT 10;
  "
)

dbGetQuery(
  con,
  "
  SELECT COUNT(*) AS total_registros
  FROM base_cancer;
  "
)

dbGetQuery(
  con,
  "
  SELECT DISTINCT AP
  FROM base_cancer
  ORDER BY AP;
  "
)

dbGetQuery(
  con,
  "
  SELECT
      Año,
      COUNT(*) AS registros
  FROM base_cancer
  GROUP BY Año
  ORDER BY Año;
  "
)

# ------------------------------------------------------------
# Función para ejecutar archivos SQL
# ------------------------------------------------------------

ejecutar_sql <- function(archivo) {
  
  consulta <- paste(
    readLines(
      archivo,
      encoding = "UTF-8"
    ),
    collapse = "\n"
  )
  
  dbGetQuery(
    con,
    consulta
  )
}