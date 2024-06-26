% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/radCor.R
\name{radCor}
\alias{radCor}
\title{Radiometric Calibration and Correction}
\usage{
radCor(
  img,
  metaData,
  method = "apref",
  bandSet = "full",
  hazeValues,
  hazeBands,
  atmosphere,
  darkProp = 0.01,
  clamp = TRUE,
  verbose
)
}
\arguments{
\item{img}{SpatRaster}

\item{metaData}{object of class ImageMetaData or a path to the meta data (MTL) file.}

\item{method}{Radiometric conversion/correction method to be used. There are currently four methods available (see Details):
"rad", "apref", "sdos", "dos", "costz".}

\item{bandSet}{Numeric or character. original Landsat band numbers or names in the form of ("B1", "B2" etc). If set to 'full' all bands in the solar (optical) region will be processed.}

\item{hazeValues}{Numeric. Either a vector with dark DNs per \code{hazeBand} (method = 'sdos'); possibly estimated using \link{estimateHaze}. 
Or the 'starting haze value' (DN) for the relative scattering models in \code{method = 'dos' or 'costz'}. If not provided, hazeValues will be estimated in an automated fashion for all \code{hazeBands}. 
Argument only applies to methods 'sdos', 'dos' and 'costz'.}

\item{hazeBands}{Character or integer. Bands corresponding to \code{hazeValues} (method = 'sdos') or band to select starting haze value from ('dos' or 'costz').}

\item{atmosphere}{Character. Atmospheric characteristics. Will be estimated if not expicilty provided. Must be one of \code{"veryClear", "clear", "moderate", "hazy"} or \code{"veryHazy"}.}

\item{darkProp}{Numeric. Estimated proportion of dark pixels in the scene. Used only for automatic guessing of hazeValues (typically one would choose 1 or 2\%).}

\item{clamp}{Logical. Enforce valid value range. By default reflectance will be forced to stay within [0,1] and radiance >= 0 by replacing invalid values with the correspinding boundary, e.g. -0.1 will become 0.}

\item{verbose}{Logical. Print status information.}
}
\value{
SpatRaster with top-of-atmosphere radiance (\eqn{W/(m^2 * srad * \mu m)}), at-satellite brightness temperature (K),
top-of-atmosphere reflectance (unitless) corrected for the sun angle or at-surface reflectance (unitless).
}
\description{
Implements several different methods for radiometric calibration and correction of Landsat data.
You can either specify a metadata file, or supply all neccesary values manually. 
With proper parametrization apref and sdos should work for other sensors as well.
}
\details{
The atmospheric correction methods (sdos, dos and costz) apply to the optical (solar) region of the spectrum and do not affect the thermal band.

Dark object subtraction approaches rely on the estimation of atmospheric haze based on *dark* pixels. Dark pixels are assumed to have zero reflectance, hence the name.
It is then assumed further that any radiation originating from such *dark* pixels is due to atmospheric haze and 
not the reflectance of the surface itself.

The folloiwing \code{methods} are available:  
\tabular{ll}{
rad   \tab Radiance \cr
apref \tab Apparent reflectance (top-of-atmosphere reflectance) \cr
dos   \tab Dark object subtratction following Chavez (1989) \cr
costz \tab Dark object subtraction following Chavez (1996) \cr
sdos  \tab Simple dark object subtraction. Classical DOS, Lhaze must be estimated for each band separately. 
}

If either "dos" or "costz"  are selected, radCor will use the atmospheric haze decay model described by Chavez (1989).
Depending on the \code{atmosphere} the following coefficients are used:
\tabular{ll}{
veryClear \tab \eqn{\lambda^{-4.0}} \cr
clear     \tab \eqn{\lambda^{-2.0}} \cr
moderate  \tab \eqn{\lambda^{-1.0}} \cr
hazy      \tab \eqn{\lambda^{-0.7}} \cr
veryHazy  \tab \eqn{\lambda^{-0.5}} 
}

For Landsat 8, no values for extra-terrestrial irradiation (esun) are provided by NASA. These are, however, neccessary for DOS-based approaches. 
Therefore, these values were derived from a standard reference spectrum published by Thuillier et al. (2003) using the Landsat 8 OLI spectral response functions

The implemented sun-earth distances neglect the earth's eccentricity. Instead we use a 100 year daily average (1979-2070).
}
\note{
This was originally a fork of randcorr() function in the landsat package. This version works on SpatRasters and hence is suitable for large rasters.
}
\examples{
library(terra)
## Import meta-data and bands based on MTL file
mtlFile  <- system.file("external/landsat/LT52240631988227CUB02_MTL.txt", package="RStoolbox")
metaData <- readMeta(mtlFile)
lsat_t <- stackMeta(mtlFile)


## Convert DN to top of atmosphere reflectance and brightness temperature
lsat_ref <- radCor(lsat_t, metaData = metaData, method = "apref")

## Correct DN to at-surface-reflecatance with DOS (Chavez decay model)
\donttest{lsat_sref <- radCor(lsat_t, metaData = metaData)}

## Correct DN to at-surface-reflecatance with simple DOS 
## Automatic haze estimation
hazeDN    <- estimateHaze(lsat_t, hazeBands = 1:4, darkProp = 0.01, plot = FALSE)
lsat_sref <- radCor(lsat_t, metaData = metaData, method = "sdos",
                     hazeValues = hazeDN, hazeBands = 1:4)
}
\references{
S. Goslee (2011): Analyzing Remote Sensing Data in R: The landsat Package. Journal of Statistical Software 43(4).

G. Thuillier et al. (2003)  THE SOLAR SPECTRAL IRRADIANCE FROM 200 TO 2400 nm AS MEASURED BY THE SOLSPEC SPECTROMETER FROM THE ATLAS AND EURECA MISSIONS. Solar Physics 214(1): 1-22 (
}
