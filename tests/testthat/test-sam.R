context("spectral angle mapper")

lsat_t <- lsat
lsat_t[1] <- NA
lsat_t[2, 1] <- NA
pts <- data.frame(x = c(624720, 627480), y = c(-414690, -411090))
endmembers <- extract(lsat_t, pts)
rownames(endmembers) <- c("water", "vegetation")

test_that("returns correct classes and deals with NA",{
            expect_is(ls <- sam(lsat_t, endmembers, angles = TRUE), "SpatRaster")
            expect_equal(names(ls), c("water_sa", "vegetation_sa"))
            expect_true(all(is.na(ls[1])))
            expect_true(all(is.na(ls[1,1])))
            expect_is(ls <- sam(lsat_t, endmembers, angles = FALSE), "SpatRaster")
            expect_equal(names(ls), "class")
            expect_true(is.na(ls[1]))
            expect_true(is.na(ls[2,1]))
            
        }
)

sem_mat <- endmembers[1,,drop=FALSE]
sem_vec <- endmembers[1,]
sem_df  <- as.data.frame(endmembers)

test_that("endmember class", {
            expect_is(ls <- sam(lsat_t, sem_mat, angles = TRUE), "SpatRaster")
            expect_equal(nlyr(ls), 1)
            expect_is(ls <- sam(lsat_t, sem_vec, angles = TRUE), "SpatRaster")
            expect_is(ls <- sam(lsat_t, sem_df, angles = TRUE), "SpatRaster")
            expect_equal(nlyr(ls), 2)
            expect_is(ls <- sam(lsat_t, sem_df, angles = FALSE), "SpatRaster")
            expect_error(ls <- sam(lsat_t, sem_vec, angles = FALSE), "only one class")
        })
