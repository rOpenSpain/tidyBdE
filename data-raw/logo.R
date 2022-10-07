library(tidyverse)
library(hexSticker)
library(showtext)
library(tidyBdE)

# IE <- bde_catalog_search("(.*)PIB(.*)Tasa interanual", catalog = "IE")

PIB_ESP <-
  bde_series_full_load("BE0201.csv") %>%
  select(c("Date", "BE_2_1.21"))

PIB_selected <- bde_series_full_load("IE0201.csv") %>%
  select(c("Date", paste0("IE_2_1.", 5:7)))



bde_col_names <- unique(c(names(PIB_ESP), names(PIB_selected)))

PIB_merge <- PIB_ESP %>%
  inner_join(PIB_selected) %>%
  drop_na() %>%
  pivot_longer(cols = bde_col_names[bde_col_names != "Date"]) %>%
  filter(Date > "2000-01-01" & Date <= "2018-12-31") %>%
  mutate(PIB_perc = value)


g <- ggplot(PIB_merge, aes(x = Date, y = PIB_perc)) +
  geom_hline(yintercept = 0, colour = "black") +
  geom_line(aes(color = name, linetype = name), size = 0.5) +
  scale_linetype_manual(values = c(rep("solid", 3), "dashed")) +
  bde_scale_color_vivid() +
  theme_tidybde() +
  theme(
    legend.position = "none",
    line = element_line(size = 0.2)
  ) +
  theme_transparent()


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
  s_width = 1.83,
  s_height = 1,
  p_size = 30,
  s_x = 1.01,
  s_y = 0.75,
)
