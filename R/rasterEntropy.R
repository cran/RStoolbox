#' Multi-layer Pixel Entropy
#' 
#' Shannon entropy is calculated for each pixel based on it's layer values.
#' To be used with categorical / integer valued rasters.
#' 
#' Entropy is calculated as -sum(p log(p)); p being the class frequency per pixel.
#' 
#' @param img SpatRaster
#' @param ... additional arguments passed to writeRaster
#' @return
#' SpatRaster "entropy"
#' @export 
#' @examples
#' re <- rasterEntropy(rlogo)
#' ggR(re, geom_raster = TRUE)
rasterEntropy <- function(img, ...){
	img <- .toTerra(img)
    if(nlyr(img) <= 1)
      stop("img must have at least two layers")
    out <- app(img, fun = entropyCpp, ...)
    out <- .updateLayerNames(out, "entropy")
    out
}


