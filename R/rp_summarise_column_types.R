#' Summarise column data types and example values
#'
#' This function generates a concise summary of each column in a data frame,
#' including the column name, data type, number of unique values, and a short
#' example of values. Numeric columns are summarised by their range, while
#' character and factor columns display a subset of unique values.
#'
#' @param df A data frame.
#' @param n_example Number of example values to display for non-numeric columns (default = 5).
#' @param digits Number of decimal places for numeric ranges (default = 2).
#' @param render Logical; if TRUE, renders a styled table with knitr/kableExtra. Default TRUE.
#' @param scroll_height Height for scrollable table (default = "400px"). Only used if render = TRUE.
#'
#' @return A data frame summarising column structure or a kable table.
#'
#' @examples
#' summarise_column_types(my_data)
#'
#' @export
summarise_column_types <- function(df, n_example = 5, digits = 2, render = TRUE, scroll_height = "400px") {
  
  summary_df <- data.frame(
    column = names(df),
    data_type = sapply(df, function(x) class(x)[1]),
    n_unique = sapply(df, function(x) length(unique(x))),
    example = sapply(df, function(x) {
      
      # Numeric columns: show range
      if (is.numeric(x)) {
        if (all(is.na(x))) {
          return("all NA")
        }
        paste0(
          "range: ",
          round(min(x, na.rm = TRUE), digits), "–",
          round(max(x, na.rm = TRUE), digits)
        )
        
        # Non-numeric columns: show example values
      } else {
        vals <- unique(x)
        vals <- vals[!is.na(vals)]
        if (length(vals) == 0) {
          return("all NA")
        }
        paste(head(vals, n_example), collapse = ", ")
      }
    }),
    stringsAsFactors = FALSE,
    row.names = NULL
  )
  
  if (render) {
    knitr::kable(summary_df) %>%
      kableExtra::kable_styling(
        bootstrap_options = c("striped", "hover"),
        full_width = FALSE
      ) %>%
      kableExtra::scroll_box(width = "100%", height = scroll_height)
  } else {
    return(summary_df)
  }
}