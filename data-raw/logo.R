library(tidyverse)
library(hexSticker)
library(showtext)
library(tidyBdE)

plotseries <- bde_ind_gdp_var("GDP YoY", out_format = "long") %>%
  bind_rows(
    bde_ind_unemployment_rate("Unemployment Rate", out_format = "long")
  ) %>%
  drop_na() %>%
  filter(Date >= "2010-01-01")

g <- ggplot(plotseries, aes(x = Date, y = serie_value)) +
  geom_line(aes(color = serie_name), linewidth = 0.25, show.legend = FALSE) +
  theme_minimal() +
  labs(x = "", y = "") +
  scale_color_bde_d(palette = "bde_vivid_pal") # Custom palette on the package

# font_add_google("Roboto", "roboto")
showtext_auto()


sticker(
  g,
  package = "tidyBdE",
  filename = "man/figures/logo.png",
  p_y = 1.43,
  p_family = "roboto",
  p_fontface = "bold",
  p_color = "#993300",
  h_fill = "grey95",
  h_color = "#993300",
  s_width = 1.6,
  s_height = 1,
  p_size = 30,
  s_x = .95,
  s_y = 0.7,
)

pkgdown::build_favicons(overwrite = TRUE)
