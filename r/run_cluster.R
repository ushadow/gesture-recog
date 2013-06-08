source('r/cluster.R')

args <- commandArgs(trailingOnly = T)
input.file <- args[1]
output.file <- args[2]
Cluster(input.file, output.file)
