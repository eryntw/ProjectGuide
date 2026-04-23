library(targets)
library(tarchetypes)
tar_source()

# tars -------
tars <- yaml::read_yaml("_targets.yaml")

# tar options --------
tar_option_set(packages = yaml::read_yaml("settings/packages.yaml")$packages)

# targets --------
tar_plan(
  ## dependencies -------
  
  ## render --------
  
  ### html --------
  
  tar_target(report_html_directory,
             fs::dir_create(fs::path(tars$report$store, "compiled_html")) # the directory needs to exist or format = "file" on render_with_deps will fail
  ),
  
  tar_target(report,
             envTargets::render_with_deps(input_directory = "report",
                                          deps = file_deps |> unlist() |> unname(),
                                          output_dir = fs::path("..", report_html_directory) # extra dots as run from inside /report
             ),
             format = "file"
  )
)
