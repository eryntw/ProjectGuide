#' Plot summary statistics for a single raster
#'
#' This function generates a summary plot for a SpatRaster object.
#'
#' - For categorical (factor) rasters: bar plot of total area (km²) per category
#' - For continuous rasters: boxplot of raster values
#'
#' @param r A SpatRaster object (single-layer recommended)
#' @param area_threshold Numeric. Minimum area (km²) to include categories (default = 10)
#' @param wrap_width Integer. Character width for wrapping long labels (default = 20)
#'
#' @return A ggplot object
#' @export
#'
#' @examples
#' plot_raster_summary_single(r)
plot_raster_summary <- function(r, area_threshold = 10, wrap_width = 20) {
  
  # Load required packages
  requireNamespace("terra")
  requireNamespace("ggplot2")
  requireNamespace("dplyr")
  requireNamespace("stringr")
  
  # safe raster name
  r_name <- tryCatch(terra::names(r)[1], error = function(e) "Raster")
  
  if (all(terra::is.factor(r))) {
    
    # --- CATEGORICAL RASTER ---
    df <- r |>
      terra::cellSize(unit = "km") |>
      terra::zonal(r, fun = "sum") |>
      as.data.frame() |>
      stats::setNames(c("value", "area")) |>
      dplyr::filter(area > area_threshold) |>
      dplyr::arrange(dplyr::desc(area)) |>
      dplyr::mutate(value = factor(value, levels = value))
    
    p <- ggplot2::ggplot(df, ggplot2::aes(x = value, y = area)) +
      ggplot2::geom_col() +
      ggplot2::theme_minimal() +
      ggplot2::labs(
        title = paste0("Categorical raster: ", r_name),
        x = "Major Vegetation",
        y = "Area (km²)"
      ) +
      ggplot2::scale_x_discrete(
        labels = \(x) stringr::str_wrap(x, width = wrap_width)
      ) +
      ggplot2::theme(
        axis.text.x = ggplot2::element_text(angle = 90, hjust = 1, vjust = 0.5)
      )
    
  } else {
    
    # --- CONTINUOUS RASTER ---
    df <- r %>% as_tibble() %>% setNames("value")
    
    p <- ggplot2::ggplot(df, ggplot2::aes(x = "", y = value)) +
      ggplot2::geom_boxplot() +
      ggplot2::theme_minimal() +
      ggplot2::labs(
        title = paste0("Continuous raster: ", r_name),
        x = NULL,
        y = "Values"
      ) +
      ggplot2::theme(
        axis.text.x  = ggplot2::element_blank(),
        axis.ticks.x = ggplot2::element_blank(),
        panel.grid.major.x = ggplot2::element_blank()
      )
  }
  
  return(p)
}
