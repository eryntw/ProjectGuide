style_gt <- function(df,
                     caption       = NULL,
                     style         = c("compact", "scrollable", "scrollable_freeze"),
                     wrap_col      = NULL,
                     wrap_width    = "20em",
                     sticky_cols   = 1,
                     scroll_height = "500px") {
  
  style <- match.arg(style)
  
  # ---- Base gt table ----
  tbl <- gt::gt(df) %>%
    gt::tab_options(
      table.font.size        = 12,
      row.striping.include_table_body = TRUE,
      column_labels.font.weight = "bold",
      heading.align = "left"
    )
  
  # ---- Caption (outside scroll box, auto-numbered by bookdown) ----
  if (!is.null(caption)) {
    tbl <- tbl %>%
      gt::tab_caption(gt::html(paste0("<div style='text-align: left;'>",
                                  caption,
                                  "</div>")))  
  }
  
  # ---- Optional column wrapping ----
  if (!is.null(wrap_col)) {
    tbl <- tbl %>%
      gt::cols_width(wrap_col ~ gt::px(wrap_width))
  }
  
  # ---- Style-specific options ----
  tbl <- switch(style,
                compact = tbl %>%
                  gt::tab_options(
                    table.width          = gt::pct(60),
                    data_row.padding     = gt::px(4)
                  ),
                
                scrollable = tbl %>%
                  gt::tab_options(
                    container.height     = scroll_height,
                    container.overflow.y = "auto",
                    container.overflow.x = "auto",
                    data_row.padding     = gt::px(4)
                  ),
                
                scrollable_freeze = tbl %>%
                  gt::tab_options(
                    container.height     = scroll_height,
                    container.overflow.y = "auto",
                    container.overflow.x = "auto",
                    data_row.padding     = gt::px(4)
                  ) %>%
                  gt::tab_style(
                    style = gt::cell_styles(
                      gt::cell_borders(sides = "right", color = "#dddddd", weight = gt::px(2))
                    ),
                    locations = gt::cells_body(columns = sticky_cols)
                  )
  )
  
  # ---- Render to HTML ----
  # html_str <- gt::as_raw_html(tbl, inline_css = TRUE)
  # 
  # htmltools::HTML(
  #   paste0(
  #     '<div class="gt-wrapper" style="text-align:left;">',
  #     html_str,
  #     '</div>'
  #   )
  # )
  return(tbl)
}