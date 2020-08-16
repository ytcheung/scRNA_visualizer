check.packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

packages<-c("shiny", "shinydashboard", "shinyjs", "V8","RColorBrewer","ggplot2","gdata","pheatmap")
check.packages(packages)

shiny::runApp("~/KI - Science Park/ki_summer/app/rna_app/")