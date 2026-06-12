# Errors on download

    Code
      a <- bde_hlp_download("https://www.invented_test_url.com", tmp, TRUE)
    Message
      i Downloading file from <https://www.invented_test_url.com>.
      ! Download failed, trying again.
      ! URL <https://www.invented_test_url.com> is not reachable. If this looks like a bug, please open an issue.

---

    Code
      b <- bde_hlp_download("https://ropenspain.github.io/tidyBdE/sitemap.xml", tmp2,
        verbose = TRUE)
    Message
      i Downloading file from <https://ropenspain.github.io/tidyBdE/sitemap.xml>.

# Messages

    Code
      df <- bde_hlp_return_null()
    Message
      i BdE resources are unavailable. Returning an empty tibble.

---

    Code
      df2 <- bde_hlp_return_null("An example message.")
    Message
      i An example message.

