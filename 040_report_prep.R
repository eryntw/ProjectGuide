library(targets)
library(geotargets)
library(tarchetypes)
library(crew)


# tars -------
tars <- yaml::read_yaml("_targets.yaml")

# from other scripts ---------

# targets --------
list(
  
  ### repo link -------
  tar_target(repo_link, 
             gsub("\\.git$", "", usethis::git_remotes()$origin)
  ),
  
  ### bib style --------
  tarchetypes::tar_download(bib_style,
                            urls = "https://raw.githubusercontent.com/citation-style-language/styles/master/emu-austral-ornithology.csl",
                            paths = here::here("report", "bib_style.csl")
  ),
  
  ### reference ------
  tarchetypes::tar_file_read(dew_reference, 
                             fs::path("common/dew_refs.bib"),
                             fs::file_copy(!!.x,
                                           here::here("report", "dew_refs.bib"),
                                           overwrite = TRUE)
  ),
  
  ### reference ------
  tarchetypes::tar_file_read(style_docx, 
                             fs::path("common/Styles.docx"),
                             fs::file_copy(!!.x,
                                           here::here("report", "Styles.docx"),
                                           overwrite = TRUE)
  ),
  
  ### packages bib -------
  tarchetypes::tar_file_read(packages_bib,
                             here::here("settings", "packages.yaml"),
                             knitr::write_bib(c(yaml::read_yaml(!!.x)$packages),
                                              file = here::here("report", "packages.bib"),
                                              tweak = TRUE)
  ),
  
  ## yamls --------
  tar_target(bookdown_yaml,
             envTargets::prepare_bookdown_yaml(),
             format = "file")
)
