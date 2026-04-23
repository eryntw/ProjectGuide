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
      full_width = FALSE
    ) %>%
      kableExtra::scroll_box(width = "100%", height = "500px")
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
  # Optional column wrapping (applies to both styles)
  # -------------------------
  if (!is.null(wrap_col)) {
    kbl <- kbl %>%
      kableExtra::column_spec(wrap_col, width = wrap_width)
  }
  
  return(kbl)
}