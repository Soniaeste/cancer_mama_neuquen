# ============================================================
# Proyecto: Cáncer de mama - Neuquén
# Script: 02_limpieza_AP.R
# Objetivo: limpiar y normalizar las Áreas Programáticas
#           y la información espacial
# ============================================================


# ------------------------------------------------------------
# 1. Importación de los datos
# ------------------------------------------------------------

source("R/01_importacion.R")


# ------------------------------------------------------------
# 2. Creación de la base de trabajo
# ------------------------------------------------------------

base_limpia <- base_original |>
  mutate(
    ID = as.integer(ID),
    id_efector = as.integer(id_efector),
    Año = as.integer(Año)
  )


# ------------------------------------------------------------
# 3. Normalización de nombres de Áreas Programáticas
# ------------------------------------------------------------

base_limpia <- base_limpia |>
  mutate(
    AP = case_when(
      AP == "El Chocon" ~ "El Chocón",
      AP == "El Huecu" ~ "El Huecú",
      AP == "Junin de los Andes" ~ "Junín de los Andes",
      AP == "las Ovejas" ~ "Las Ovejas",
      AP == "Loncopue" ~ "Loncopué",
      AP == "Neuquen" ~ "Neuquén",
      AP == "Picun Leufú" ~ "Picún Leufú",
      AP == "Piedra del Aguila" ~ "Piedra del Águila",
      AP == "Rincon de los Sauces" ~ "Rincón de los Sauces",
      TRUE ~ AP
    )
  )


# ------------------------------------------------------------
# 4. Tabla de atributos de los establecimientos
# ------------------------------------------------------------

establecimientos_tabla <- establecimientos_salud |>
  st_drop_geometry() |>
  as_tibble()


# ------------------------------------------------------------
# 5. Equivalencias entre las AP de la base estadística
#    y las AP de la capa espacial
# ------------------------------------------------------------

equivalencias_ap <- tibble(
  
  AP = c(
    "Aluminé",
    "Andacollo",
    "Añelo",
    "Bajada del Agrio",
    "Buta Ranquil",
    "Centenario",
    "Chos Malal",
    "Cutral Co Plaza Huincul",
    "El Chocón",
    "El Cholar",
    "El Huecú",
    "Junín de los Andes",
    "Las Coloradas",
    "Las Lajas",
    "Las Ovejas",
    "Loncopué",
    "Mariano Moreno",
    "Neuquén",
    "Picún Leufú",
    "Piedra del Águila",
    "Plottier",
    "Rincón de los Sauces",
    "Senillosa",
    "SMA",
    "SPCH",
    "Tricao Malal",
    "Villa La Angostura",
    "Zapala"
  ),
  
  ap_espacial = c(
    "ALUMINE",
    "ANDACOLLO",
    "AÑELO",
    "B DEL AGRIO",
    "BUTA RANQUIL",
    "CENTENARIO",
    "CHOS MALAL",
    "CUTRAL CO-P HUINCUL",
    "CHOCON",
    "EL CHOLAR",
    "EL HUECU",
    "J DE LOS ANDES",
    "LAS COLORADAS",
    "LAS LAJAS",
    "LAS OVEJAS",
    "LONCOPUE",
    "M MORENO",
    "CAPITAL",
    "P LEUFU",
    "P DEL AGUILA",
    "PLOTTIER",
    "R DE LOS SAUCES",
    "SENILLOSA",
    "SAN M DE LOS ANDES",
    "S P DEL CH",
    "TRICAO MALAL",
    "V LA ANGOSTURA",
    "ZAPALA"
  )
)


# ------------------------------------------------------------
# 6. Incorporación de la clave espacial a la base estadística
# ------------------------------------------------------------

base_limpia <- base_limpia |>
  left_join(
    equivalencias_ap,
    by = "AP"
  )


# ------------------------------------------------------------
# 7. Incorporación del nombre normalizado de AP
#    a los establecimientos de salud
# ------------------------------------------------------------

establecimientos_limpios <- establecimientos_salud |>
  left_join(
    equivalencias_ap,
    by = c("ap_limpia" = "ap_espacial")
  )


# ------------------------------------------------------------
# 8. Cantidad de establecimientos por AP
# ------------------------------------------------------------

establecimientos_por_ap <- establecimientos_limpios |>
  st_drop_geometry() |>
  as_tibble() |>
  count(AP, sort = TRUE)


# ------------------------------------------------------------
# 9. Homogeneización del sistema de coordenadas
# ------------------------------------------------------------

crs_trabajo <- st_crs(establecimientos_limpios)

neuquen_departamentos_limpios <- neuquen_departamentos |>
  st_transform(crs_trabajo)

neuquen_provincia_limpia <- neuquen_provincia |>
  st_transform(crs_trabajo)
  