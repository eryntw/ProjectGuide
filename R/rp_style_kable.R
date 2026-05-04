
# Helper: hoist caption outside scroll box
hoist_caption <- function(html_str) {
  cap_match <- regmatches(html_str, regexpr(
    '<caption[^>]*>.*?</caption>', html_str, perl = TRUE
  ))
  if (length(cap_match) == 0) return(html_str)
  
  html_str  <- sub('<caption[^>]*>.*?</caption>', '', html_str, perl = TRUE)
  cap_clean <- sub('<caption[^>]*>',
                   '<p class="kable-caption" style="text-align:left; margin-bottom:4px; font-size:12px;">',
                   cap_match)
  cap_clean <- sub('</caption>', '</p>', cap_clean)
  paste0(cap_clean, html_str)
}

style_kable <- function(kbl,
                        style = c("compact", 
                                  "scrollable",
                                  "scrollable_freeze"),
                        wrap_col = NULL,
                        wrap_width = "20em",
                        sticky_cols = 1,
                        scroll_height = "500px") {
  
  style <- match.arg(style)
  
  # -------------------------
  # Style 1: compact
  # -------------------------
  
  if (style == "compact") {
    
    kbl <- kbl %>%
      kableExtra::kable_styling(
        position = "center",
        full_width = FALSE,
        font_size = 12,
        bootstrap_options = c("striped", "condensed")
      )
  }
  
  # -------------------------
  # Style 3: scrollable (dashboard-style)
  # -------------------------
  
  if (style == "scrollable") {
    kbl <- kbl %>%
      kableExtra::kable_styling(
      bootstrap_options = c("striped", "hover", "condensed"),
      full_width = FALSE,
      font_size = 12
    ) %>%
      kableExtra::scroll_box(width = "100%", 
                             height = scroll_height)
  }
  
  # -------------------------
  # Style 2: scrollable_freeze (dashboard-style)
  # -------------------------
  
  if (style == "scrollable_freeze") {
    
    kbl <- kbl %>%
      kableExtra::kable_styling(
        position = "left",
        bootstrap_options = c("striped", "hover", "condensed"),
        full_width = TRUE,
        font_size = 12
      )
    
    # sticky columns (optional)
    if (!is.null(sticky_cols)) {
      kbl <- kbl %>%
        kableExtra::column_spec(
          sticky_cols,
          extra_css = "position: sticky; background-color: white; left: 0; z-index: 10;"
        )
    }
    
    # scroll box wrapper
    kbl <- kbl %>%
      kableExtra::scroll_box(
        width = "100%",
        height = scroll_height,
        fixed_thead = TRUE
      )
  }
  
  # -------------------------
  # Optional column wrapping (applies to all styles)
  # -------------------------
  if (!is.null(wrap_col)) {
    kbl <- kbl %>%
      kableExtra::column_spec(wrap_col, width = wrap_width)
  }
  
  # -------------------------
  # Wrap in self-contained div with left-aligned caption
  # prevents HTML bleed in knit_child() context
  # -------------------------
  # html_out <- paste0(
  #   '<style>caption{text-align:left!important;}</style>',
  #   '<div class="kable-wrapper">',
  #   as.character(kbl),
  #   '</div>'
  # )
  # htmltools::HTML(html_out)
  html_out <- as.character(kbl) %>%
    hoist_caption() %>%
    paste0('<style>caption{text-align:left!important;}</style><div class="kable-wrapper">',
           ., 
           '</div>')
  
  structure(html_out, class = "knitr_kable", format = "html")
  
}