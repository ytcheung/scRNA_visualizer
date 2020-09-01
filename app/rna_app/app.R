check.packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

packages<-c("shiny", "shinydashboard", "shinyjs", "V8","RColorBrewer","ggplot2","gdata",
            "pheatmap","zip","foreach","DT","dplyr","gtable","grid","data.table")

#If the dataset is SCE
if (!requireNamespace("BiocManager", quietly = TRUE)){
  install.packages("BiocManager")
  if (!requireNamespace("SingleCellExperiment", quietly = TRUE))
    BiocManager::install("SingleCellExperiment")
  
  library(SingleCellExperiment)
}

check.packages(packages)

##if (!("ComplexHeatmap" %in% installed.packages()[, "Package"])){
# if (!requireNamespace("ComplexHeatmap", quietly = TRUE)){
#   if (!requireNamespace("devtools", quietly = TRUE))
#     install.packages("devtools")
#   
#   library(devtools)
#   install_github("jokergoo/ComplexHeatmap") #Install latest version from github
# }

shiny::runApp("~/KI - Science Park/ki_summer/app/rna_app/")