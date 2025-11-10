library(sf)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)
library(devtools)
library(osmdata)

russia <- ne_countries(scale = "medium", country = "Russia", returnclass = "sf")
russia_geom <- st_geometry(russia)
plot(russia_geom, col = "grey80", border = "black")


# Load railways (Natural Earth)
rail <- st_read("ne_10m_railroads.shp")
rail_ru <- st_crop(rail, st_bbox(russia))

ggplot() +
  geom_sf(data = rail_ru, color = "black", size = 0.2) +
  geom_sf(data = russia, fill = NA, color = "grey60", size = 0.1) +
  coord_sf(xlim = c(30, 180), ylim = c(40, 80)) +
  theme_void() +
  theme(panel.background = element_rect(fill = "white"))
