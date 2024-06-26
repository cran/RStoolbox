#' Principal Component Analysis for Rasters
#' 
#' Calculates R-mode PCA for SpatRasters and returns a SpatRaster with multiple layers of PCA scores.
#' 
#' Internally rasterPCA relies on the use of \link[stats]{princomp} (R-mode PCA). If nSamples is given the PCA will be calculated
#' based on a random sample of pixels and then predicted for the full raster. If nSamples is NULL then the covariance matrix will be calculated
#' first and will then be used to calculate princomp and predict the full raster. The latter is more precise, since it considers all pixels,
#' however, it may be slower than calculating the PCA only on a subset of pixels. 
#' 
#' Pixels with missing values in one or more bands will be set to NA. The built-in check for such pixels can lead to a slow-down of rasterPCA.
#' However, if you make sure or know beforehand that all pixels have either only valid values or only NAs throughout all layers you can disable this check
#' by setting maskCheck=FALSE which speeds up the computation.
#' 
#' Standardised PCA (SPCA) can be useful if imagery or bands of different dynamic ranges are combined. SPC uses the correlation matrix instead of the covariance matrix, which
#' has the same effect as using normalised bands of unit variance. 
#' 
#' @param img SpatRaster.
#' @param nSamples Integer or NULL. Number of pixels to sample for PCA fitting. If NULL, all pixels will be used.
#' @param nComp Integer. Number of PCA components to return.
#' @param spca Logical. If \code{TRUE}, perform standardized PCA. Corresponds to centered and scaled input image. This is usually beneficial for equal weighting of all layers. (\code{FALSE} by default)
#' @param maskCheck Logical. Masks all pixels which have at least one NA (default TRUE is reccomended but introduces a slow-down, see Details when it is wise to disable maskCheck). 
#' Takes effect only if nSamples is NULL.
#' @param ... further arguments to be passed to \link[terra]{writeRaster}, e.g. filename.
#' @return Returns a named list containing the PCA model object ($model) and a SpatRaster with the principal component layers ($object).
#' @export 
#' @examples
#' library(ggplot2)
#' library(reshape2)
#' ggRGB(rlogo, 1,2,3)
#' 
#' ## Run PCA
#' set.seed(25)
#' rpc <- rasterPCA(rlogo)
#' rpc
#' 
#' ## Model parameters:
#' summary(rpc$model)
#' loadings(rpc$model)
#' 
#' ggRGB(rpc$map,1,2,3, stretch="lin", q=0)
#' if(require(gridExtra)){
#'   plots <- lapply(1:3, function(x) ggR(rpc$map, x, geom_raster = TRUE))
#'   grid.arrange(plots[[1]],plots[[2]], plots[[3]], ncol=2)
#' }
rasterPCA <- function(img, nSamples = NULL, nComp = nlyr(img), spca = FALSE,  maskCheck = TRUE, ...){
    img <- .toTerra(img)

    if(nlyr(img) <= 1) stop("Need at least two layers to calculate PCA.")
    ellip <- list(...)
    
    ## Deprecate norm, as it has the same effect as spca
    if("norm" %in% names(ellip)) {
        warning("Argument 'norm' has been deprecated. Use argument 'spca' instead.\nFormer 'norm=TRUE' corresponds to 'spca=TRUE'.", call. = FALSE)
        ellip[["norm"]] <- NULL
    }
    
    if(nComp > nlyr(img)) nComp <- nlyr(img)
    
    if(!is.null(nSamples)){
        trainData <- terra::spatSample(img, size = nSamples, na.rm = TRUE)
        if(nrow(trainData) < nlyr(img)) stop("nSamples too small or img contains a layer with NAs only")
        model <- stats::princomp(trainData, scores = FALSE, cor = spca)
    } else {
        if(maskCheck) {
            totalMask <- !sum(terra::app(img, is.na))

            if(sum(terra::values(totalMask)) == 0) stop("img contains either a layer with NAs only or no single pixel with valid values across all layers")
            img <- terra::mask(img, totalMask , maskvalue = 0) ## NA areas must be masked from all layers, otherwise the covariance matrix is not non-negative definite
        }
        covMat <- cov.wt(as.data.frame(img))
        model <- stats::princomp(cor = spca, covmat = covMat)
        model$center <- covMat$center
        model$n.obs  <- ncell(any(!is.na(img)))

        if(spca) {
            ## Calculate scale as population sd like in in princomp
            S <- diag(covMat$cov)
            model$scale <- sqrt(S * (model$n.obs-1)/model$n.obs)
        }
    }
    ## Predict
    out   <- .paraRasterFun(img, terra::predict, args = list(model = model, na.rm = TRUE, index = 1:nComp), wrArgs = ellip)

    names(out) <- paste0("PC", 1:nComp)
    structure(list(call = match.call(), model = model, map = out), class = c("rasterPCA", "RStoolbox"))

}
