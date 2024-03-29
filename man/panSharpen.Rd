% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/panSharpen.R
\name{panSharpen}
\alias{panSharpen}
\title{Pan Sharpen Imagery / Image Fusion}
\usage{
panSharpen(img, pan, r, g, b, pc = 1, method = "brovey", norm = TRUE)
}
\arguments{
\item{img}{RasterLayer or SpatRaster. Coarse resolution multispectral image}

\item{pan}{RasterLayer or SpatRaster. High resolution image, typically panchromatic.}

\item{r}{Character or Integer. Red band in \code{img}. Only relevant if \code{method!='pca'}}

\item{g}{Character or Integer. Green band in \code{img}. Only relevant if \code{method!='pca'}}

\item{b}{Character or Integer. Blue band in \code{img}. Only relevant if \code{method!='pca'}}

\item{pc}{Integer. Only relevant if \code{method = 'pca'}. Which principal component to replace. Usually this should be the first component (default). Only if the first component is dominated by something else than brightness it might be worth a try to use the second component.}

\item{method}{Character. Choose method from c("pca", "ihs", "brovey").}

\item{norm}{Logical.  Rescale pan image to match the 1st PC component. Only relevant if \code{method = 'pca'}. If \code{TRUE} only min and max are matched to the 1st PC. If \code{FALSE} pan will be histogram matched to the 1st PC.}
}
\value{
pan-sharpened SpatRaster
}
\description{
provides different methods for pan sharpening a coarse resolution (typically multispectral) image with 
a higher reolution panchromatic image. Values of the pan-chromatic and multispectral images must be of the same scale, (e.g. from 0:1, or all DNs from 0:255)
}
\details{
Pan sharpening options:
\itemize{ 
 \item{\code{method='pca'}: Performs a pca using \link{rasterPCA}. The first component is then swapped for the pan band an the PCA is rotated backwards.}
 \item{\code{method='ihs'}: Performs a color space transform to Intensity-Hue-Saturation space, swaps intensity for the histogram matched pan and does the backwards transformation.}
    \item{\code{method='brovey'}: Performs Brovey reweighting. Pan and img must be at the same value scale (e.g. 0:1, or 0:255) otherwise you'll end up with psychodelic colors.}
}
}
\examples{
library(terra)
library(ggplot2)

## Fake panchromatic image (30m resolution covering
## the visible range (integral from blue to red))
pan       <- sum(lsat[[1:3]])
ggR(pan, stretch = "lin") 

## Fake coarse resolution image (150m spatial resolution)
lowResImg <- aggregate(lsat, 5)


## Brovey pan sharpening
lowResImg_pan <- panSharpen(lowResImg, pan, r = 3, g = 2, b = 1, method = "brovey")
lowResImg_pan
## Plot 
ggRGB(lowResImg, stretch = "lin") + ggtitle("Original")
ggRGB(lowResImg_pan, stretch="lin") + ggtitle("Pansharpened (Brovey)")
    
}
