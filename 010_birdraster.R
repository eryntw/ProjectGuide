library(targets)
library(tarchetypes)
library(geotargets)
library(crew)
library(crew.cluster)

use_cores <- parallel::detectCores() - 2
tar_option_set(packages = yaml::read_yaml("settings/packages.yaml")$packages, 
               controller = crew_controller_local(workers = use_cores))


# tars -------
tars <- yaml::read_yaml("_targets.yaml")

# tar source -------
tar_source()
tar_source("../envBird/R")

# targets -------

## Read coins ------

birdcoin <- tar_read(coin_1, store = tars$envBird$birdcoin$store)

tar_plan(
  
  ## Get bird species subset and their vulnerability ------
  bird_sp = birdcoin$Data$Aggregated %>% 
    dplyr::select(uCode, Vulnerability) %>% 
    dplyr::mutate(uCode = gsub("_", " ", uCode)) %>% 
    replace_taxa(taxa_col = "uCode", direction = "reverse"),
  
  ## Get tif paths ------
  tif_stores = fs::dir_ls(dirname(tars$envPIA$setup$store)
                          , regexp = "final\\/objects\\/final$"
                          , recurse = TRUE),
  
  ## USG region ------
  # bird
  tarchetypes::tar_file_read(name = usg_bird, 
                             command = tif_stores[1], 
                             read = readRDS(!!.x) %>% 
                               dplyr::select(taxa, use, use_tif) %>% 
                               dplyr::inner_join(bird_sp, by = c("taxa" = "uCode"))  
  ),
  
  ## BP region ------
  # bird
  tarchetypes::tar_file_read(name = bp_bird, 
                             command = tif_stores[2], 
                             read = readRDS(!!.x) %>% 
                               dplyr::select(taxa, use, use_tif) %>% 
                               dplyr::inner_join(bird_sp, by = c("taxa" = "uCode"))  
  ),
  
  ## Vulnerability x Raster ------
  # usg
  usg_bird_rast = calculate_vulnerability_surface(usg_bird, agg_fun = "max"),
  
  # bp
  bp_bird_rast = calculate_vulnerability_surface(bp_bird, agg_fun = "max")
    
)
