library(targets)
library(terra)

## Inspect each raster in a stack
tar_load(usg_bird, store = tars$birdraster$store)

bird_stack <- terra::rast(usg_bird$use_tif)
par(mfrow = c(5, 5))
for (i in 1:nlyr(bird_stack)) {
  plot(bird_stack[[i]], 
       main = names(bird_stack)[i], 
       col = hcl.colors(100, "viridis"))
}