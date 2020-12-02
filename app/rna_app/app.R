check.packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  #sapply(pkg, library, character.only = TRUE) <- doesn't work on shinyapps.io, so put all library() calls in ui.R
}

packages<-c("shiny","shinydashboard", "shinyjs","ggplot2","RColorBrewer","V8",
            "pheatmap","zip","foreach","DT","dplyr","gtable","grid","data.table")

check.packages(packages)

#if (!requireNamespace("BiocManager", quietly = TRUE)){
#  install.packages("BiocManager")
#  if (!requireNamespace("SingleCellExperiment", quietly = TRUE))
#    BiocManager::install("SingleCellExperiment")
#}

##if (!("ComplexHeatmap" %in% installed.packages()[, "Package"])){
# if (!requireNamespace("ComplexHeatmap", quietly = TRUE)){
#   if (!requireNamespace("devtools", quietly = TRUE))
#     install.packages("devtools")
#   
#   library(devtools)
#   install_github("jokergoo/ComplexHeatmap") #Install latest version from github
# }

shiny::runApp("~/Uppsala University/HT 20/Degree Project/R/scRNA_visualizer/app/rna_app")

#library(rsconnect)
#deployApp("~/Uppsala University/HT 20/Degree Project/R/scRNA_visualizer/app/rna_app")