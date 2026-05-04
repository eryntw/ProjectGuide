# Helper: hoist caption outside scroll box
hoist_caption <- function(html_str) {
  cap_match <- regmatches(html_str, regexpr(
    '<caption[^>]*>.*?</caption>', html_str, perl = TRUE
  ))
  if (length(cap_match) == 0) return(html_str)
  
  # Remove caption from inside scroll div
  html_str <- sub('<caption[^>]*>.*?</caption>', '', html_str, perl = TRUE)
  
  # Extract inner HTML only (everything between caption tags)
  inner <- sub('<caption[^>]*>(.*?)</caption>', '\\1', cap_match, perl = TRUE)
  
  # Wrap inner content in a styled paragraph, preserving the bookdown span
  cap_p <- paste0(
    '<p class="kable-caption" style="text-align:left; margin-bottom:4px; font-size:12px;">',
    trimws(inner),
    '</p>'
  )
  
  paste0(cap_p, html_str)
}

style_kable <- function(kbl,
                        style       = c("compact", "scrollable", "scrollable_freeze"),
                        wrap_col    = NULL,
                        wrap_width  = "20em",
                        sticky_cols = 1,
                        scroll_height = "500px") {
  
  style <- match.arg(style)
  
  # ---- Base styling per style ----
  kbl <- switch(style,
                compact = kbl %>%
                  kableExtra::kable_styling(
                    position          = "center",
                    full_width        = FALSE,
                    font_size         = 12,
                    bootstrap_options = c("striped", "condensed")
                  ),
                
                scrollable = kbl %>%
                  kableExtra::kable_styling(
                    bootstrap_options = c("striped", "hover", "condensed"),
                    full_width        = FALSE,
                    font_size         = 12
                  ) %>%
                  kableExtra::scroll_box(width = "100%", height = scroll_height),
                
                scrollable_freeze = {
                  k <- kbl %>%
                    kableExtra::kable_styling(
                      position          = "left",
                      bootstrap_options = c("striped", "hover", "condensed"),
                      full_width        = TRUE,
                      font_size         = 12
                    )
                  if (!is.null(sticky_cols)) {
                    k <- k %>%
                      kableExtra::column_spec(
                        sticky_cols,
                        extra_css = "position: sticky; background-color: white; left: 0; z-index: 10;"
                      )
                  }
                  k %>% kableExtra::scroll_box(width = "100%", height = scroll_height, fixed_thead = TRUE)
                }
  )
  
  # ---- Optional column wrapping ----
  if (!is.null(wrap_col)) {
    kbl <- kbl %>%
      kableExtra::column_spec(wrap_col, width = wrap_width)
  }
  
  # ---- Finalise HTML: hoist caption + wrap in div ----
  html_out <- as.character(kbl) %>%
    hoist_caption() %>%
    paste0('<style>caption{text-align:left!important;}</style><div class="kable-wrapper">',
           ., 
           '</div>')
  
  structure(html_out, class = "knitr_kable", format = "html")
}