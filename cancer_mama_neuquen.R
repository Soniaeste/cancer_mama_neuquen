# ============================================================
# Proyecto: Cáncer de mama - Neuquén
# Script: 01_importacion.R
# Objetivo: importar los datos originales del proyecto
# ============================================================

# ------------------------------------------------------------
# 1. Paquetes
# ------------------------------------------------------------

library(sf)
library(dplyr)
library(readxl)


# ------------------------------------------------------------
# 2. Carpetas del proyecto
# ------------------------------------------------------------

dir.create(
  "datos/originales",
  recursive = TRUE,
  showWarnings = FALSE
)

dir.create(
  "datos/procesados",
  recursive = TRUE,
  showWarnings = FALSE
)


# ------------------------------------------------------------
# 3. Copiar fuentes originales al proyecto
#    Solo se copian si todavía no existen
# ------------------------------------------------------------

if (!file.exists("datos/originales/BASE 1.xlsx")) {
  
  file.copy(
    from = "../BASE 1.xlsx",
    to   = "datos/originales/BASE 1.xlsx"
  )
}

if (!file.exists("datos/originales/cancer_neuquen.gpkg")) {
  
  file.copy(
    from = "../cancer_neuquen.gpkg",
    to   = "datos/originales/cancer_neuquen.gpkg"
  )
}


# ------------------------------------------------------------
# 4. Rutas
# ------------------------------------------------------------

archivo_excel <- "datos/originales/BASE 1.xlsx"
archivo_gpkg  <- "datos/originales/cancer_neuquen.gpkg"


# ------------------------------------------------------------
# 5. Control de existencia de archivos
# ------------------------------------------------------------

stopifnot(
  file.exists(archivo_excel),
  file.exists(archivo_gpkg)
)


# ------------------------------------------------------------
# 6. Capas disponibles en el GeoPackage
# ------------------------------------------------------------

capas <- st_layers(archivo_gpkg)

capas


# ------------------------------------------------------------
# 7. Importación de las capas espaciales
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
# 8. Hojas disponibles en la base Excel
# ------------------------------------------------------------

hojas_excel <- excel_sheets(archivo_excel)

hojas_excel

# ------------------------------------------------------------
# 9. Importación de la base tabular
# ------------------------------------------------------------

base_original <- read_excel(
  archivo_excel,
  sheet = "BASE"
)

referencia_original <- read_excel(
  archivo_excel,
  sheet = "REFERENCIA",
  col_names = FALSE
)

names(referencia_original) <- c(
  "variable",
  "descripcion"
)

# ------------------------------------------------------------
# 10. Controles iniciales de la base
# ------------------------------------------------------------

dim(base_original)
names(base_original)

dim(referencia_original)
names(referencia_original)

head(base_original)

head(referencia_original)

glimpse(base_original)

glimpse(referencia_original)


# ============================================================
# Proyecto: Cáncer de mama - Neuquén
# Script: 02_limpieza_AP.R
# Objetivo: diagnóstico y limpieza por Área Programática
# ============================================================

library(dplyr)
library(sf)


# ------------------------------------------------------------
# 1. Estructura temporal
# ------------------------------------------------------------

sort(unique(base_original$Año))

base_original |>
  count(Año)


# ------------------------------------------------------------
# 2. Zonas sanitarias
# ------------------------------------------------------------

sort(unique(base_original$ZS))

base_original |>
  count(ZS)


# ------------------------------------------------------------
# 3. Áreas Programáticas
# ------------------------------------------------------------

sort(unique(base_original$AP))

n_distinct(base_original$AP)

base_original |>
  count(AP) |>
  arrange(AP)


# ------------------------------------------------------------
# 4. Relación entre ZS y AP
# ------------------------------------------------------------

base_original |>
  distinct(ZS, AP) |>
  arrange(ZS, AP)


# ------------------------------------------------------------
# 5. Efectores
# ------------------------------------------------------------

n_distinct(base_original$id_efector)

base_original |>
  distinct(id_efector, ZS, AP) |>
  arrange(id_efector)


# ------------------------------------------------------------
# 6. Valores faltantes
# ------------------------------------------------------------

colSums(is.na(base_original))


# ------------------------------------------------------------
# 7. Duplicados AP-año
# ------------------------------------------------------------

base_original |>
  count(AP, Año) |>
  filter(n > 1)


# ------------------------------------------------------------
# 8. Completitud temporal de cada AP
# ------------------------------------------------------------

base_original |>
  count(AP) |>
  arrange(n, AP)

# ------------------------------------------------------------
# 9. Creación de la base de trabajo
# ------------------------------------------------------------

base_limpia <- base_original |>
  mutate(
    ID = as.integer(ID),
    id_efector = as.integer(id_efector),
    Año = as.integer(Año)
  )

#  --------------------------------------------
# 10. Normalización de la base de las AP
#  -----------------------------------------

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

sort(unique(base_limpia$AP))

# ------------------------------------------------------------
# 11. Controles posteriores a la normalización
# ------------------------------------------------------------

n_distinct(base_limpia$AP)

base_limpia |>
  count(AP, Año) |>
  filter(n > 1)

base_limpia |>
  distinct(id_efector, ZS, AP) |>
  arrange(ZS, AP)


# ------------------------------------------------------------
# 12. Tabla de atributos de establecimientos
# ------------------------------------------------------------

establecimientos_tabla <- establecimientos_salud |>
  st_drop_geometry() |>
  as_tibble()
# ------------------------------------------------------------
# 13. Áreas Programáticas en la capa espacial
# ------------------------------------------------------------

establecimientos_tabla |>
  distinct(ap_limpia) |>
  arrange(ap_limpia) |>
  print(n = Inf)

sort(unique(establecimientos_tabla$ap_limpia))

# ------------------------------------------------------------
# 14. Tabla de equivalencias entre AP
#     Base estadística <-> capa espacial
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
# 15. Incorporación de la equivalencia espacial
# ------------------------------------------------------------

base_limpia <- base_limpia |>
  left_join(
    equivalencias_ap,
    by = "AP"
  )

base_limpia |>
  select(id_efector, ZS, AP, ap_espacial) |>
  distinct() |>
  arrange(ZS, AP) |>
  print(n = Inf)

base_limpia |>
  filter(is.na(ap_espacial))

anti_join(
  establecimientos_tabla |>
    distinct(ap_limpia),
  equivalencias_ap,
  by = c("ap_limpia" = "ap_espacial")
)

# ------------------------------------------------------------
# 16. Normalización de las AP en establecimientos de salud
# ------------------------------------------------------------

establecimientos_limpios <- establecimientos_salud |>
  left_join(
    equivalencias_ap,
    by = c("ap_limpia" = "ap_espacial")
  )

dim(establecimientos_limpios)
establecimientos_limpios |>
  filter(is.na(AP))

n_distinct(establecimientos_limpios$AP)

# Total de establecimientos
nrow(establecimientos_limpios)

# ------------------------------------------------------------
# 17. Cantidad de establecimientos por AP
# ------------------------------------------------------------

establecimientos_por_ap <- establecimientos_limpios |>
  st_drop_geometry() |>
  as_tibble() |>
  count(AP, sort = TRUE)

establecimientos_por_ap |>
  print(n = Inf)

nrow(establecimientos_por_ap)

# ------------------------------------------------------------
# 18. Control de establecimientos por AP
# ------------------------------------------------------------

nrow(establecimientos_por_ap)
# dio: 28

sum(establecimientos_por_ap$n)
# dio: 233, okk

# ------------------------------------------------------------
# 19. Homogeneización del sistema de coordenadas
# ------------------------------------------------------------

crs_trabajo <- st_crs(establecimientos_limpios)

neuquen_departamentos_limpios <- neuquen_departamentos |>
  st_transform(crs_trabajo)

neuquen_provincia_limpia <- neuquen_provincia |>
  st_transform(crs_trabajo)

st_crs(establecimientos_limpios)$Name
st_crs(neuquen_departamentos_limpios)$Name
st_crs(neuquen_provincia_limpia)$Name

#queda todo proyectado en POSGAR 94 /ARG 2

crs_trabajo <- st_crs(establecimientos_limpios)


#voy a crear carpetas para cada cosa

file.create(
  "R/01_importacion.R",
  "R/02_limpieza_AP.R",
  "R/03_controles.R"
)

