library(elevatr)
library(rayshader)
library(terra)
library(sf)
library(rgl)
library(ggplot2)
library(hexbin)  
library(ggspatial)
library(ggthemes)
library(prettymapr)

golden_gate_bbox <- data.frame(
  x = c(-122.54, -122.44), 
  y = c(37.78, 37.85)       
)
golden_gate_sf <- st_as_sf(golden_gate_bbox , coords = c("x", "y"), crs = 4326)

golden_gate_dem <- get_elev_raster(locations = golden_gate_sf, z = 12, src = "aws")  

golden_gate_raster <- terra::rast(golden_gate_dem)  
golden_gate_raster <- raster::raster(golden_gate_raster)  
golden_gate_matrix <- raster_to_matrix(golden_gate_raster)

golden_gate_df <- as.data.frame(as.table(golden_gate_matrix))
colnames(golden_gate_df) <- c("x", "y", "elevation")

pp <- ggplot(golden_gate_df, aes(x = as.numeric(x), y = as.numeric(y), z = elevation)) +
  stat_summary_hex(bins = 20, size = 0.5, fun = mean, color = "black") +  
  scale_fill_viridis_c(option = "C")

par(mfrow = c(1, 1))
plot_gg(pp, width = 5, height = 4, scale = 300, multicore = TRUE, windowsize = c(1200, 960),
        fov = 70, zoom = 0.4, theta = 330, phi = 40)

render_camera(fov = 70, zoom = 0.5, theta = 0, phi = 35)
Sys.sleep(0.3)
render_snapshot(clear = TRUE)


golden_gate_bbox <- data.frame(
  x = c(-122.54, -122.44),
  y = c(37.78, 37.85)       
)

# 创建 bbox polygon
bbox_polygon <- st_as_sfc(st_bbox(c(
  xmin = golden_gate_bbox$x[1],
  xmax = golden_gate_bbox$x[2],
  ymin = golden_gate_bbox$y[1],
  ymax = golden_gate_bbox$y[2]
), crs = 4326))

big_bbox <- st_as_sfc(st_bbox(c(
  xmin = golden_gate_bbox$x[1] - 0.02,
  xmax = golden_gate_bbox$x[2] + 0.02,
  ymin = golden_gate_bbox$y[1] - 0.02,
  ymax = golden_gate_bbox$y[2] + 0.02
), crs = 4326))



ggplot() +
  geom_sf(data = big_bbox, fill = "grey98", color = NA) +
  annotation_map_tile(type = "osm", zoom = 13) +  
  geom_sf(data = bbox_polygon, fill = NA, color = "red", size = 1) +
  annotation_scale(location = "bl", width_hint = 0.4) +
  annotation_north_arrow(location = "tr", which_north = "true",
                         style = north_arrow_fancy_orienteering) +
  coord_sf(expand = FALSE) +
  theme_map() +
  ggtitle("Golden Gate BBox Highlight")





