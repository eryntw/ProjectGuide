#' Get Thresholded SDM Raster Paths for Species
#'
#' Retrieves paths to thresholded SDM raster files (`*_thresh.tif`) for a set
#' of species from a standard SDM directory structure.
#'
#' Species names are taken from a provided vector (e.g., COIN `uCode` values),
#' converted from underscore-separated format (e.g., `"Genus_species"`)
#' to space-separated format (`"Genus species"`), and optionally adjusted
#' using `replace_taxa()` to match folder naming conventions.
#'
#' @param species A character vector of species names (e.g., `uCode` values
#'   using underscores).
#' @param base_dir Character. Base directory containing the `sdm_fine`
#'   folder with species SDM outputs.
#'
#' @return A named list where each element contains the file path(s) to
#'   thresholded raster(s) for a species. List names correspond to the
#'   original `species` vector.
#'
#' @details
#' The function assumes the following directory structure:
#'
#' \preformatted{
#' base_dir/
#'   sdm_fine/
#'     Genus species/
#'       predictions/
#'         P10Y/
#'           *_thresh.tif
#' }
#'
#' Species names are converted from `"Genus_species"` to `"Genus species"`
#' and optionally standardised using `replace_taxa()` with
#' `direction = "reverse"` to match folder names.
#'
#' @examples
#' \dontrun{
#' species <- unique(birdcoin$Data$Aggregated$uCode)
#'
#' birdtif <- get_species_sdm_tifs(
#'   species = species,
#'   base_dir = "../../../dev/out/.../sdm"
#' )
#' }
#'
#' @importFrom purrr map
#' @export
get_species_sdm_tifs <- function(species, base_dir) {
  
  # Convert species names to folder format
  species_folders <- gsub("_", " ", species)
  species_folders <- replace_taxa(species_folders, direction = "reverse")
  
  # Retrieve raster paths
  birdtif <- purrr::map(
    species_folders,
    \(sp) list.files(
      file.path(base_dir, "sdm_fine", sp, "predictions", "P10Y"),
      pattern = "_thresh.*\\.tif$",
      full.names = TRUE
    )
  )
  
  # Preserve original species names
  names(birdtif) <- species
  
  return(birdtif)
}