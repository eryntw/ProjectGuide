
library(targets)
library(tarchetypes)

# tars -------
tars <- yaml::read_yaml("_targets.yaml")

# tar options --------
tar_option_set(packages = yaml::read_yaml("settings/packages.yaml")$packages)

# targets --------
list(
  ## dependencies -------
  
  ## render --------
  tar_target(report,
             envTargets::render_with_deps(input_directory = "report"
                                          , clean_out_dir = FALSE
                                          , remove_main = FALSE
                                          , clean_up = FALSE)
  )
)
