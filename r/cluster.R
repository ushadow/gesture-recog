library(mclust)
library(plotrix)

# Args:
# input.file: string of input file name. The data should be comma delimited and
#     the first column is the frame ID.
Cluster <- function(input.file, output.file) {
  data <- read.table(input.file, sep = ',')
  numcol <- ncol(data)
  descriptor.mclust <- Mclust(data[, 2 : numcol], G = 1:2)
  output <- data.frame(data[, 1], descriptor.mclust$classification)
  write.table(output, output.file, sep = ',', row.names = FALSE, col.names =
              FALSE)
}

PlotDescriptor <- function(descriptor) {
  kNumDepthDivs <- 5
  kNumSectors <- 8
  kNumRadDivs <- 5
  descriptor <- unlist(descriptor)
  max.value <- max(descriptor)
  m <- matrix(descriptor, kNumSectors * kNumRadDivs, kNumDepthDivs, TRUE)
  print(m)
  palette <- rev(heat.colors(kNumDepthDivs))
  for (r in (kNumRadDivs - 1) : 0){
    edges <- c()
    colors <- c()
    extends <- list()
    for (s in 0 : (kNumSectors - 1)) {
      # Row index. 
      rindex <- r * kNumSectors + s + 1
      if (all(m[rindex,] == 0)) { 
        color <- "#FFFFFFFF"
      } else {
        # Depth index.
        dindex <- which.max(m[rindex,])
        color <- palette[dindex]
        value <- m[rindex, dindex] / max.value
        color <- ChangeHSV(color, value)
      }
      print(color)
      colors <- c(colors, color)
      extends <- c(extends, list(r : (r + 1))) 
      edges <- c(edges, -pi + pi * 2 * s / kNumSectors) 
    } 
    edges <- c(edges, pi)
    add = TRUE 
    if (r == kNumRadDivs - 1) {
      add = FALSE
    }
    radial.pie(extends, sector.colors = colors, start = -pi, 
               show.grid.labels = FALSE, add = add)
  }
}

# Changes the alpha value of a color.
#
# Args:
#   color: a R color. 
#   alpha: between 0 - 255.
ChangeHSV <- function(color, value) {
  hsv.value <- rgb2hsv(col2rgb(color))
  hsv(hsv.value[1], value, hsv.value[3])
}
