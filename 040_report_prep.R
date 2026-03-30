library(targets)
library(geotargets)
library(tarchetypes)
library(crew)
library(dplyr)
tar_source()

# tars -------
tars <- yaml::read_yaml("_targets.yaml")

# from other scripts ---------

# targets --------
tar_plan(
  
  ### repo link -------
  tar_target(repo_link, 
             gsub("\\.git$", "", usethis::git_remotes()$origin)
  ),
  
  ### reference bib ------
  tarchetypes::tar_file_read(dew_reference, 
                             fs::path("common/dew_refs.bib"),
                             RefManageR::ReadBib(!!.x, check = "error")
  ),
  
  tarchetypes::tar_file_read(reference, 
                             fs::path("common/refs.bib"),
                             RefManageR::ReadBib(!!.x, check = "error")
  ),
  
  ### packages bib -------
  pkg_bib = make_pkg_bib(),
  
  ## merge bibs -------
  tar_target(
    all_bib,
    reference %>% 
      merge(dew_reference, "all") %>% 
      merge(pkg_bib, "all") %>% 
      RefManageR::WriteBib(file = "report/all_refs.bib")
  ),
  
  ### bib style --------
  tarchetypes::tar_download(bib_style,
                            urls = "https://raw.githubusercontent.com/citation-style-language/styles/master/emu-austral-ornithology.csl",
                            paths = here::here("report", "bib_style.csl")
  ),
  
  ### render style ------
  tarchetypes::tar_file_read(style_docx, 
                             fs::path("common/Styles.docx"),
                             fs::file_copy(!!.x,
                                           here::here("report", "Styles.docx"),
                                           overwrite = TRUE)
  ),
  ## yamls --------
  tar_target(bookdown_yaml,
             envTargets::prepare_bookdown_yaml(),
             format = "file")
)
