# needed for function
library(raster)
library(sf)
library(rmapshaper)

#' Get country maps
#'
#'Import maps of countries from the \href{https://gadm.org}{gadm} database and compress to a chosen file size. File size is reduced by a) reducing the number of points in the polygon(s) and b) removing islands smaller than a chosen size.
#'
#' @param cntry iso country code, use raster::getData('ISO3') to see codes
#' @param kp proportion of original points to keep
#' @param min_area min area (km^2) of polygons to keep
#' @param pth file path where downloaded map should be saved

#' @return a SpatialPolygon
#'
#' @import rmapshaper
#' @importFrom sf st_as_sf
#' @importFrom raster getData
#'
#' @examples
#' \dontrun{
#' nz_small <- fun_get_map(cntry = "NZ", kp = 0.03, min_area = 0.001)
#' }
#' @export
fun_get_map <- function(cntry = "NZ", kp = 0.03, min_area = 0.001, pth = ''){
  print("this will take a few seconds...")
  mp <- raster::getData("GADM", country = cntry, level = 1, path = pth)
  mp1 <- sf::st_as_sf(mp)
  mp2 <- rmapshaper::ms_simplify(input = mp1, keep = kp)
  mp3 <- rmapshaper::ms_filter_islands(mp2, min_area = min_area * 1000000)
  mp4 <- mp3[c("NAME_0", "NAME_1", "ENGTYPE_1", "geometry")]
  return(mp4)
}
