# ============================================================
# Proyecto: Cáncer de mama - Neuquén
# Script: 04_exportacion.R
# Objetivo: guardar los datos procesados
# ============================================================


# ------------------------------------------------------------
# 1. Ejecutar controles previos
# ------------------------------------------------------------

source("R/03_controles.R")


# ------------------------------------------------------------
# 2. Guardar base estadística limpia
# ------------------------------------------------------------

write.csv(
  base_limpia,
  "datos/procesados/base_cancer_mama_limpia.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)


# ------------------------------------------------------------
# 3. Guardar equivalencias de Áreas Programáticas
# ------------------------------------------------------------

write.csv(
  equivalencias_ap,
  "datos/procesados/equivalencias_ap.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)


# ------------------------------------------------------------
# 4. Guardar resumen de establecimientos por AP
# ------------------------------------------------------------

write.csv(
  establecimientos_por_ap,
  "datos/procesados/establecimientos_por_ap.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)


# ------------------------------------------------------------
# 5. Guardar capas espaciales procesadas
# ------------------------------------------------------------

archivo_gpkg_procesado <-
  "datos/procesados/cancer_neuquen_procesado.gpkg"

if (file.exists(archivo_gpkg_procesado)) {
  file.remove(archivo_gpkg_procesado)
}

st_write(
  establecimientos_limpios,
  archivo_gpkg_procesado,
  layer = "establecimientos_salud",
  quiet = TRUE
)

st_write(
  neuquen_departamentos_limpios,
  archivo_gpkg_procesado,
  layer = "neuquen_departamentos",
  append = TRUE,
  quiet = TRUE
)

st_write(
  neuquen_provincia_limpia,
  archivo_gpkg_procesado,
  layer = "neuquen_provincia",
  append = TRUE,
  quiet = TRUE
)


# ------------------------------------------------------------
# 6. Control de archivos generados
# ------------------------------------------------------------

list.files("datos/procesados")