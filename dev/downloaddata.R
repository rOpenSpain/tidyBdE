a <- bde_catalog_load(cache_dir = "./dev/testall")


b <- bde_catalog_search("Francia(.*)PIB", cache_dir = "./dev/testall")

plot(bde_ind_cpi_var())
plot(bde_ind_euribor_12m_daily())
plot(bde_ind_euribor_12m_monthly())
plot(bde_ind_unemployment_rate())

iconv(c("España","Añaoú"), to= "ASCII//TRANSLIT")


devtools::check()


