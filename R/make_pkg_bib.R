#' Create BibEntry citations for project dependencies
#'
#' This function extracts package dependencies (via renv),
#' retrieves their citation information, and converts them
#' into a single RefManageR BibEntry object.
#'
#' @param pkgs Optional character vector of package names.
#'   If NULL (default), packages are extracted from renv::dependencies().
#'
#' @param include_null Logical. If FALSE (default), packages without
#'   citation info are dropped.
#'
#' @return A RefManageR BibEntry object containing all package citations.
#'
#' @details
#' - Uses utils::citation() to retrieve package citations
#' - Converts to BibEntry using RefManageR::as.BibEntry()
#' - Safely handles packages without citation metadata
#'
#' @examples
#' \dontrun{
#' bib <- make_pkg_bib()
#' RefManageR::WriteBib(bib, file = "packages.bib")
#' }
#'
#' @export

make_pkg_bib <- function(pkgs = NULL, include_null = FALSE) {
  
  # ---- Step 1: Get package list ----
  if (is.null(pkgs)) {
    pkgs <- unique(renv::dependencies()$Package)
  }
  
  # ---- Step 2: Extract citations ----
  bib_list <- purrr::map(pkgs, function(pkg) {
    
    cit <- tryCatch(
      utils::citation(pkg),
      error = function(e) NULL
    )
    
    if (!is.null(cit)) {
      RefManageR::as.BibEntry(cit)
    } else {
      if (include_null) return(NULL)
      NULL
    }
    
  })
  
  # ---- Step 3: Remove NULL entries ----
  bib_list <- bib_list[!vapply(bib_list, is.null, logical(1))]
  
  # ---- Step 4: Combine into one BibEntry ----
  if (length(bib_list) == 0) {
    return(NULL)
  }
  
  bib_combined <- do.call(c, bib_list)
  
  return(bib_combined)
}