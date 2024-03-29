% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rescaleImage.R
\name{rescaleImage}
\alias{rescaleImage}
\title{Linear Image Rescaling}
\usage{
rescaleImage(x, y, xmin, xmax, ymin, ymax, forceMinMax = FALSE, ...)
}
\arguments{
\item{x}{patRaster or numeric vector. Image to normalise.}

\item{y}{SpatRaster or numeric vector. Reference image. Optional. Used to extract min and max values if ymin or ymax are missing.}

\item{xmin}{Numeric. Min value of x. Either a single value or one value per layer in x. If xmin is not provided it will be extracted from x.}

\item{xmax}{Numeric. Max value of x. Either a single value or one value per layer in x. If xmax is not provided it will be extracted from x.}

\item{ymin}{Numeric. Min value of y. Either a single value or one value per layer in x. If ymin is not provided it will be extracted from y.}

\item{ymax}{Numeric. Max value of y. Either a single value or one value per layer in x. If ymax is not provided it will be extracted from y.}

\item{forceMinMax}{Logical. Forces update of min and max data slots in x or y.}

\item{...}{additional arguments passed to \code{\link[terra:writeRaster]{terra::writeRaster()}}}
}
\value{
Returns a SpatRaster of the same dimensions as the input raster \code{x} but shifted and stretched to the new limits.
}
\description{
performs linear shifts of value ranges either to match min/max of another image (\code{y})
or to any other min and max value (\code{ymin} and \code{ymax}).
}
\details{
Providing \code{xmin} and \code{xmax} values manually can be useful if the raster contains a variable of a known, fixed value range,
e.g. NDVI from -1 to 1 but the actual pixel values don't encompass this entire range.
By providing \code{xmin = -1} and \code{xmax = 1} the values can be rescaled to any other range,
e.g. 1 to 100 while comparability to other rescaled NDVI scenes is retained.
}
\examples{
lsat2 <- lsat - 1000
lsat2

## Rescale lsat2 to match original lsat value range
lsat2_rescaled <- rescaleImage(lsat2, lsat)
lsat2_rescaled

## Rescale lsat to value range [0,1]
lsat2_unity <- rescaleImage(lsat2, ymin = 0, ymax = 1)
lsat2_unity
}
\seealso{
\link[=histMatch]{histMatch}
}
