## code to prepare `bde_ind_db` dataset goes here

# Create data base with metadata of each of the indicators series
library(tidyverse)

bde_ind_db_init <- tribble(
  ~tidyBdE_fun, ~Numero_secuencial,
  "bde_ind_gdp_var", 4663788,
  "bde_ind_unemployment_rate", 4635980,
  "bde_ind_euribor_12m_monthly", 587853,
  "bde_ind_euribor_12m_daily", 905842,
  "bde_ind_cpi_var", 4144807,
  "bde_ind_ibex_monthly", 254433,
  "bde_ind_ibex_daily", 821340,
  "bde_ind_gdp_quarterly", 4663160,
  "bde_ind_population", 4637737
) |>
  mutate(Numero_secuencial = as.character(Numero_secuencial)) |>
  arrange(tidyBdE_fun)


# Add metadata
full_cat <- bde_catalog_load()
bde_cat <- full_cat |>
  select(
    Numero_secuencial,
    Descripcion_de_la_serie,
    Frecuencia_de_la_serie,
    Fecha_de_la_primera_observacion,
    Fecha_de_la_ultima_observacion,
    Fuente
  ) |>
  distinct()


bde_ind_db <- bde_ind_db_init |>
  left_join(bde_cat)


# Re-check on publications
inpub <- full_cat[
  full_cat$Numero_secuencial %in% bde_ind_db$Numero_secuencial,
]


# Alternative computation of CPI ----
cpi_alt <- bde_series_load(656547, series_label = "serie") |>
  mutate(
    lag12 = lag(serie, 12),
    Consumer_price_index_YoY = round(100 * (serie / lag12 - 1), digits = 1)
  ) |>
  select(Date, Consumer_price_index_YoY) |>
  drop_na(Consumer_price_index_YoY)


# Check
cpi_orig <- bde_ind_cpi_var() |>
  left_join(
    cpi_alt |>
      rename(alt = Consumer_price_index_YoY)
  ) |>
  mutate(dif = Consumer_price_index_YoY - alt)


usethis::use_data(bde_ind_db, overwrite = TRUE)
