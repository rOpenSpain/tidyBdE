# Messages

    Code
      names(s)
    Output
       [1] "Nombre_de_la_serie"                            
       [2] "Numero_secuencial"                             
       [3] "Alias_de_la_serie"                             
       [4] "Nombre_del_archivo_con_los_valores_de_la_serie"
       [5] "Descripcion_de_la_serie"                       
       [6] "Tipo_de_variable"                              
       [7] "Codigo_de_unidades"                            
       [8] "Exponente"                                     
       [9] "Numero_de_decimales"                           
      [10] "Descripcion_de_unidades_y_exponente"           
      [11] "Frecuencia_de_la_serie"                        
      [12] "Fecha_de_la_primera_observacion"               
      [13] "Fecha_de_la_ultima_observacion"                
      [14] "Numero_de_observaciones"                       
      [15] "Titulo_de_la_serie"                            
      [16] "Fuente"                                        
      [17] "Notas"                                         

# Fully Deprecation of Series

    Code
      bde_catalog_update("IE", cache_dir = dir)
    Condition
      Error:
      ! `catalog` must be "ALL", "BE", "SI", "TC", "TI", or "PB", not "IE".

---

    Code
      bde_catalog_update("CF", cache_dir = dir)
    Condition
      Error:
      ! `catalog` must be "ALL", "BE", "SI", "TC", "TI", or "PB", not "CF".

# No results

    Code
      bde_catalog_search("GDP", catalog = "TI")
    Condition
      Error in `bde_catalog_search()`:
      ! No matches found for `pattern` "GDP".

# No results with malformed catalog data

    Code
      bde_catalog_search("TC", catalog = "TC")
    Message
      ! Catalog data does not inherit from <tbl_df>. Try downloading it again with `bde_catalog_update()`.

# Catalogs load cached files and parse search results offline

    Code
      catalog <- bde_catalog_load("TC", cache_dir = dir, verbose = TRUE)
    Message
      v Using cache directory '<tempdir>'.
      v Using cached catalog "TC".
      i Parsing date columns.

---

    Code
      bde_catalog_search("not-found", catalog = "TC", cache_dir = dir)
    Condition
      Error in `bde_catalog_search()`:
      ! No matches found for `pattern` "not-found".

# Catalogs report unavailable updates offline

    Code
      res <- bde_catalog_update("TC", cache_dir = dir, verbose = TRUE)
    Message
      i BdE resources are unavailable. Returning an empty <tbl_df>.

---

    Code
      catalog <- bde_catalog_load("TC", cache_dir = dir, verbose = TRUE)
    Message
      v Created cache directory '<tempdir>'.
      i Downloading catalog "TC".
      i BdE resources are unavailable. Returning an empty <tbl_df>.
      ! Catalog "TC" is not available for download.
      ! Could not load 1 catalog: "TC".
      i Parsing date columns.

# Catalog search returns an empty tibble when catalog data is empty

    Code
      empty <- bde_catalog_search("anything")
    Message
      i BdE resources are unavailable. Returning an empty <tbl_df>.

# Catalog update reports verbose update plans

    Code
      bde_catalog_update("TC", cache_dir = dir, verbose = TRUE)
    Message
      v Created cache directory '<tempdir>'.
      i Updating 1 catalog file: "TC".

