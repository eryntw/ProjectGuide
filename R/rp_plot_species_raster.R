#' Plot species distribution from two raster stacks (USG vs BP)
#'
#' @description
#' Extracts a species layer from two SpatRaster objects and plots them side-by-side
#' using ggplot2 + tidyterra + patchwork.
#'
#' @param species Character species name (underscores allowed)
#' @param rast_A SpatRaster for USG
#' @param rast_B SpatRaster for BP
#' @param name_A Label for first raster (default "USG")
#' @param name_B Label for second raster (default "BP")
#'
#' @return patchwork plot
#' @export
plot_species_raster <- function(sp_name,
                                rast_A,
                                rast_B,
                                name_A = "USG",
                                name_B = "BP") {
  
  library(ggplot2)
  library(terra)
  library(tidyterra)
  library(patchwork)
  
  # ---- extract layers safely ----
  r_usg <- rast_A[[sp_name]]
  r_bp  <- rast_B[[sp_name]]
  
  if (is.null(r_usg) && is.null(r_bp)) {
    stop(paste0("Species '", species, "' not found in either raster stack."))
  }
  
  # =========================================================
  # 1. USG plot
  # =========================================================
  
  p_usg <- NULL
  if (!is.null(r_usg)) {
    p_usg <- ggplot() +
      tidyterra::geom_spatraster(data = r_usg) +
      ggplot2::scale_fill_viridis_c(na.value = "transparent") +
      ggplot2::ggtitle(name_A) +
      ggplot2::theme_void()
  } else {
    p_usg <- ggplot() + ggplot2::theme_void() +
      ggplot2::ggtitle(paste(sp_name, "not predicted in", name_A))
  }
  
  # =========================================================
  # 2. BP plot
  # =========================================================
  
  p_bp <- NULL
  if (!is.null(r_bp)) {
    p_bp <- ggplot() +
      tidyterra::geom_spatraster(data = r_bp) +
      ggplot2::scale_fill_viridis_c(na.value = "transparent") +
      ggplot2::ggtitle(name_B) +
      ggplot2::theme_void()
  } else {
    p_bp <- ggplot() + ggplot2::theme_void() +
      ggplot2::ggtitle(paste0(sp_name, "not predicted in", name_B))
  }
  
  # =========================================================
  # 3. COMBINE
  # =========================================================
  
  (p_usg | p_bp) +
    patchwork::plot_layout(guides = 'collect')
}
