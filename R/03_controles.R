# ============================================================
# Proyecto: Cáncer de mama - Neuquén
# Script: 03_controles.R
# Objetivo: controlar la consistencia de los datos procesados
# ============================================================


# ------------------------------------------------------------
# 1. Ejecutar importación y limpieza
# ------------------------------------------------------------

source("R/02_limpieza_AP.R")


# ------------------------------------------------------------
# 2. Dimensiones de la base estadística
# ------------------------------------------------------------

stopifnot(
  nrow(base_limpia) == 224,
  n_distinct(base_limpia$AP) == 28,
  n_distinct(base_limpia$Año) == 8
)


# ------------------------------------------------------------
# 3. Período temporal
# ------------------------------------------------------------

stopifnot(
  identical(
    sort(unique(base_limpia$Año)),
    2010:2017
  )
)


# ------------------------------------------------------------
# 4. Valores faltantes
# ------------------------------------------------------------

faltantes <- colSums(is.na(base_limpia))

faltantes

stopifnot(
  all(faltantes == 0)
)


# ------------------------------------------------------------
# 5. Duplicados AP-año
# ------------------------------------------------------------

duplicados_ap_anio <- base_limpia |>
  count(AP, Año) |>
  filter(n > 1)

duplicados_ap_anio

stopifnot(
  nrow(duplicados_ap_anio) == 0
)


# ------------------------------------------------------------
# 6. Completitud temporal por AP
# ------------------------------------------------------------

control_ap <- base_limpia |>
  count(AP)

stopifnot(
  nrow(control_ap) == 28,
  all(control_ap$n == 8)
)


# ------------------------------------------------------------
# 7. Relación efector - zona sanitaria - AP
# ------------------------------------------------------------

control_efectores <- base_limpia |>
  distinct(id_efector, ZS, AP)

stopifnot(
  nrow(control_efectores) == 28,
  n_distinct(control_efectores$id_efector) == 28,
  n_distinct(control_efectores$AP) == 28
)


# ------------------------------------------------------------
# 8. Tabla de equivalencias territoriales
# ------------------------------------------------------------

stopifnot(
  nrow(equivalencias_ap) == 28,
  n_distinct(equivalencias_ap$AP) == 28,
  n_distinct(equivalencias_ap$ap_espacial) == 28
)

stopifnot(
  all(!is.na(base_limpia$ap_espacial)),
  all(!is.na(establecimientos_limpios$AP))
)


# ------------------------------------------------------------
# 9. Establecimientos de salud
# ------------------------------------------------------------

stopifnot(
  nrow(establecimientos_limpios) == 233,
  n_distinct(establecimientos_limpios$AP) == 28,
  nrow(establecimientos_por_ap) == 28,
  sum(establecimientos_por_ap$n) == 233
)


# ------------------------------------------------------------
# 10. Sistema de referencia espacial
# ------------------------------------------------------------

stopifnot(
  st_crs(establecimientos_limpios) ==
    st_crs(neuquen_departamentos_limpios),
  
  st_crs(establecimientos_limpios) ==
    st_crs(neuquen_provincia_limpia)
)


# ------------------------------------------------------------
# 11. Validez de las geometrías
# ------------------------------------------------------------

validez_establecimientos <-
  st_is_valid(establecimientos_limpios)

validez_departamentos <-
  st_is_valid(neuquen_departamentos_limpios)

validez_provincia <-
  st_is_valid(neuquen_provincia_limpia)

table(validez_establecimientos)
table(validez_departamentos)
table(validez_provincia)

stopifnot(
  all(validez_establecimientos),
  all(validez_departamentos),
  all(validez_provincia)
)


# ------------------------------------------------------------
# 12. Establecimientos dentro de la provincia de Neuquén
# ------------------------------------------------------------

dentro_provincia <- lengths(
  st_intersects(
    establecimientos_limpios,
    neuquen_provincia_limpia
  )
) > 0

table(dentro_provincia)

establecimientos_fuera <- establecimientos_limpios[
  !dentro_provincia,
]

nrow(establecimientos_fuera)


# ------------------------------------------------------------
# 13. Resumen de los controles
# ------------------------------------------------------------

cat(
  "\n",
  "============================================\n",
  "CONTROLES FINALIZADOS\n",
  "============================================\n",
  "Base estadística:", nrow(base_limpia), "registros\n",
  "Áreas Programáticas:", n_distinct(base_limpia$AP), "\n",
  "Años:", n_distinct(base_limpia$Año), "\n",
  "Establecimientos:", nrow(establecimientos_limpios), "\n",
  "Establecimientos fuera de Neuquén:",
  nrow(establecimientos_fuera), "\n",
  "============================================\n"
)