#' RStoolbox: A Collection of Remote Sensing Tools
#' 
#' The RStoolbox package provides a set of functions which simplify performing standard remote sensing tasks in R.
#' 
#' @section Data Import and Export:
#'  
#' \itemize{
#'  \item \code{\link{readMeta}}:  import Landsat metadata from MTL or XML files
#'  \item \code{\link{stackMeta}}: load Landsat bands based on metadata
#'  \item \code{\link{readSLI} & \link{writeSLI}}: read and write ENVI spectral libraries
#'  \item \code{\link{saveRSTBX} & \link{readRSTBX}}: save and re-import RStoolbox classification objects (model and map)
#' \item \code{\link{readEE}}: import and tidy EarthExplorer search results
#' }
#' 
#' @section Data Pre-Processing:
#' 
#' \itemize{
#'  \item \code{\link{radCor}}: radiometric conversions and corrections. Primarily, yet not exclusively, intended for Landsat data processing. DN to radiance to reflectance conversion as well as DOS approaches
#'  \item \code{\link{topCor}}: topographic illumination correction
#'  \item \code{\link{cloudMask} & \link{cloudShadowMask}}: mask clouds and cloud shadows in Landsat or other imagery which comes with a thermal band
#'  \item \code{\link{classifyQA}}: extract layers from Landsat 8 QA bands, e.g. cloud confidence
#'  \item \code{\link{rescaleImage}}: rescale image to match min/max from another image or a specified min/max range
#'     \item \code{\link{normImage}}: normalize imagery by centering and scaling
#'  \item \code{\link{histMatch}}: matches the histograms of two scenes
#'  \item \code{\link{coregisterImages}}: co-register images based on mutual information
#'  \item \code{\link{panSharpen}}: sharpen a coarse resolution image with a high resolution image (typically panchromatic)
#' }
#' 
#'@section Data Analysis:
#' 
#' \itemize{
#' \item \code{\link{spectralIndices}}: calculate a set of predefined multispectral indices like NDVI
#' \item \code{\link{tasseledCap}}: tasseled cap transformation
#' \item \code{\link{sam}}: spectral angle mapper
#' \item \code{\link{rasterPCA}}: principal components transform for raster data
#' \item \code{\link{rasterCVA}}: change vector analysis
#' \item \code{\link{unsuperClass}}: unsupervised classification
#' \item \code{\link{superClass}}: supervised classification
#' \item \code{\link{fCover}}: fractional cover of coarse resolution imagery based on high resolution classification
#' }
#' 
#' @section Data Display:
#' 
#' \itemize{
#' \item \code{\link{ggR}}: single raster layer plotting with ggplot2
#' \item \code{\link{ggRGB}}: efficient plotting of remote sensing imagery in RGB with ggplot2
#' }
#'
#' @import sf terra
#' @importFrom exactextractr exact_extract
#' @importFrom lifecycle is_present deprecate_warn deprecated
#' @importFrom ggplot2 aes aes_string annotation_raster coord_equal fortify geom_raster geom_blank ggplot scale_fill_discrete scale_fill_gradientn scale_fill_identity facet_wrap
#' @importFrom caret confusionMatrix train trainControl postResample createDataPartition createFolds getTrainPerf
#' @importFrom reshape2 melt
#' @importFrom tidyr pivot_wider complete
#' @importFrom dplyr mutate group_by summarize filter
#' @importFrom XML xmlParse xmlToList
#' @importFrom stats coefficients cov.wt lm ecdf approxfun knots kmeans complete.cases loadings cov cor setNames
#' @importFrom graphics par abline
#' @importFrom methods as show
#' @importFrom utils read.csv read.delim read.table str write.table data capture.output
#' @importFrom grDevices hsv
#' @useDynLib RStoolbox
#' @importFrom Rcpp sourceCpp
#' @docType package
#' @name RStoolbox
NULL

#' Rlogo as SpatRaster
#'
#' Tiny example of raster data used to run examples.
#'
#' @usage rlogo
#' @docType data
#' @keywords datasets
#' @name rlogo
#' @examples
#' ggRGB(rlogo,r = 1,g = 2,b = 3)
NULL

#' SRTM Digital Elevation Model
#'
#' DEM for the Landsat example area taken from SRTM v3 tile: s04_w050_1arc_v3.tif
#'
#' @usage srtm
#' @docType data
#' @keywords datasets
#' @name srtm
#' @examples
#' ggR(srtm)
NULL

#' Landsat 5TM Example Data
#'
#' Subset of Landsat 5 TM Scene: LT52240631988227CUB02
#' Contains all seven bands in DN format.
#'
#' @usage lsat
#' @docType data
#' @keywords datasets
#' @name lsat
#' @examples
#' ggRGB(lsat, stretch = "lin")
NULL
