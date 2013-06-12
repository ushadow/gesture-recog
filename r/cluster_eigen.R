library(mclust)
library(plyr)

# Clusters the data with different number of features.
#
# ARGS
# data  - each row is a data point.
#
# Return:
# A list of mclust model.
Cluster <- function(data, num.features, G = 1 : 20, modelNames = c('VVV')) {
  lapply(num.features, Cluster1, data = data, G = G, modelNames = modelNames)
}

Cluster1 <- function(data, num.features, G, modelNames) {
  # G: An integer vector specifying the numbers of mixture components (clusters) for which the BIC 
  # is to be calculated. The default is G=1:9. 
  mclust <- Mclust(data[, 1 : num.features], G = G, modelNames = modelNames)
}

# Plot loglik or BIC with different number of features chosen.
PlotFeatureComp <- function(num.features, clusters) {
  loglik <- sapply(clusters, function(x) { x$loglik })
  bic <- sapply(clusters, function(x) { x$bic })
  ylim <- c(min(loglik, bic), max(loglik, bic))
  print(ylim)
  linecols <- c('red', 'blue') 
  pch <- 21 : 22
  plot(num.features, loglik, ylim = ylim, type = 'o', col = linecols[1],
       ylab = 'loglik / bic', xlab = 'number of features',  pch = pch[1]);
  lines(num.features, bic, ylim = ylim, type = 'o', col = linecols[2],
        pch = pch[2]) 
  legend('bottomright', legend = c('loglik', 'bic'), col = linecols, lty = 1,
         pch = pch)
}

PlotBicVsComponent <- function(num.components, cluster) {
  modelName <- cluster$modelName
  plot(num.components, cluster$BIC[, modelName], type = 'o',
       xlab = "number of clusters", ylab = 'BIC')
  title <- sprintf("Model name = %s", modelName) 
  title(title)
}

SaveClassification <- function(clusters, filename) {
  classes <- ldply(clusters, function(x) { x$classification })
  write.csv(classes, filename, row.names = FALSE)
}

PlotClassifcation <- function(cluster, ylab) {
  data <- eval.parent(cluster$call$data)
  classification <- cluster$classification
  ylim <- c(min(data), max(data)) 
  xlim <- c(min(classification), max(classification))
  plot(1, type = 'n', ylim = ylim, xlim = xlim, ylab = ylab, xlab = 'class')
  nclass <- cluster$G
  col <- palette()[1 : nclass]
  sapply(1 : nclass, PlotOneClass, classification = classification, data = data,
         col = col)
  title('classification')
}

PlotOneClass <- function(class.label, classification, data, col) {
  class.data <- data[classification == class.label]
  points(rep(class.label, length(class.data)), class.data, col =
         col[class.label])
}

PlotMcluster <- function(cluster, prefix) {
  what <- c('BIC', 'classification', 'uncertainty', 'density')
  sapply(what, PlotMcluster1, cluster = cluster, prefix = prefix)
}

PlotMcluster1 <- function(what, cluster, prefix) {
  png(paste(prefix, '-', what, '.png', sep = ''));
  plot(cluster, what = what)
  dev.off()
}

AveCov <- function(cov) {
  dim <- dim(cov)
  mean <- apply(cov, 3, function(x) { mean(diag(x)) })
  mean(mean)
}

# ARGS
# nfet: number of features to consider.
SaveClusterMean <- function(prefix, nfold, G, nfet, modelNames) {
  sapply(1 : nfold, SaveClusterMean1, G = G, nfet = nfet, prefix = prefix, 
         modelNames = modelNames)
}

SaveClusterMean1 <- function(fold, G, nfet, prefix, modelNames) {
  input.filename <- paste(prefix, fold, sep = '-')
  input.filename <- paste(input.filename, '.csv', sep = '')
  data <- read.table(input.filename, sep = ',')
  num.row <- nrow(data)
  data <- data[,  1 : nfet]
  cluster <- Mclust(data, G, modelNames = modelNames)
  # Last index of '-'.
  last.index <- regexpr("\\-[^\\-]*$", prefix)
  prefix <- substr(prefix, 0, last.index - 1)
  output.filename <- paste(prefix, nfet, fold, 'mean', G, 
                           sep = '-')
  output.filename <- paste(output.filename, '.csv', sep = '')
  print(output.filename)
  write.csv(cluster$parameters[[3]], output.filename, row.names = FALSE)
}
