#' ---
#' title: "Spatial analysis"
#' output: github_document
#' ---
#'
#' ## Learning objectives
#' - able to load and write geospatial data
#' - able to plot geospatial data
#' - familiar with spatial filtering, joins etc
#' 

#' ## Data
#' We'll be using digital vector boundaries of the UK's local authority districts and blue plaque point data  
#'

#' ## Setup

library(tidyverse)
library(sf)
library(tmap)

#' 
#' ## Read data 
#' Local authority Districts
#' Source: ONS Open Geography Portal
#' URL: https://geoportal.statistics.gov.uk/datasets/ons::local-authority-districts-december-2021-gb-bgc-1

#' Load GeoJSON / ESRI Shapefile
sf <- st_read("data/Local_Authority_Districts_(December_2021)_GB_BGC.geojson")

#' ## Inspect data 
glimpse(sf) 
plot(sf$geometry)

#' ## Export data  
#' e.g. export to GeoJSON file format
# st_write(sf, "data/Local_Authority_Districts_(December_2021)_GB_BGC.geojson")

#' ## Change coordinate reference system (CRS)
st_crs(sf)
sf_crs <- st_transform(sf, crs = 27700) # projected CRS
st_crs(sf_crs)

#' ## Edit attribute data
#' 
sf_crs <- select(sf_crs, AREACD = LAD21CD, AREANM = LAD21NM)

#' ## Filter features 
#' 
ew <- sf_crs %>% 
  filter(!str_detect(AREACD, "^S"))
plot(st_geometry(ew))

#' ## Dissolve features 
#' 
s <- sf_crs %>% 
  filter(str_detect(AREACD, "^S")) %>% 
  st_union()
plot(st_geometry(s))

#' ## Buffer features
#' 
m <- sf_crs %>% 
  filter(AREANM == "Manchester")
buffer <- st_buffer(m, 1000) # 1km also minus
plot(m$geometry)
plot(buffer$geometry, add = T, border = "red")

#' ## Simplify features
#' 
#' Douglas-Peucker algorithm
m_simp = st_simplify(m, dTolerance = 500)  # 500 m
plot(m$geometry)
plot(m_simp$geometry, add = T, border = "red")

#' Visvalingam algorithm
library(rmapshaper)
m_simp <- ms_simplify(m, keep = 0.1, keep_shapes = TRUE) # keep 10% of vertices
plot(m$geometry)
plot(m_simp$geometry, add = T, border = "red")

#' ## Centroids
#' Geographic centroid
hackney <- filter(sf_crs, AREANM == "Hackney")
hackney_centroid <- st_centroid(hackney)
plot(hackney$geometry)
plot(hackney_centroid$geometry, add = T, col = "red")

scilly <- filter(sf_crs, AREANM == "Isles of Scilly")
scilly_centroid <- st_centroid(scilly)
plot(scilly$geometry)
plot(scilly_centroid$geometry, add = T, col = "red")

#' Point on surface operations
scilly_pos <- st_point_on_surface(scilly)
plot(scilly$geometry)
plot(scilly_pos$geometry, add = T, col = "red")

#' ## Point in polygon  
#' 
#' Blue plaques
#' Source: http://openplaques.org
#' Licence: Public Domain Dedication and License 1.0
plaques <- read_csv("data/openplaques/open-plaques-gb-2021-05-14.csv") %>% 
  filter(colour == "blue" & !is.na(latitude)) %>% 
  st_as_sf(crs = 4326, coords = c("longitude", "latitude")) %>% 
  st_transform(27700)

cardiff <- sf_crs %>% 
  filter(AREANM == "Cardiff")
cardiff_plaques <- st_filter(plaques, cardiff)
plot(cardiff$geometry)
plot(cardiff_plaques$geometry, add = T, col = "grey")

#' ## Polygons in polygons
#' Covered by y
s_lad <- sf_crs %>% 
  st_filter(y = s, .predicate = st_within)
plot(s_lad$geometry)

#' Touch the edge of y
s_lad <- sf_crs %>%  
  st_filter(y = s, .predicate = st_intersects)
plot(s_lad$geometry, col = ifelse(str_detect(s_lad$AREACD, "^E"), "red", NA))

#' ## Further resources
#' - Lovelace, R., Nowosad, J., & Muenchow, J. (2023). [Geocomputation with R](https://geocompr.robinlovelace.net/index.html). 2nd edition.
#' - ONS Geography. (2021). [Introduction to GIS in R](https://onsgeo.github.io/geospatial-training/docs/intro_to_gis_in_r). Online course.
#'