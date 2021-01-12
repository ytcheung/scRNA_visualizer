server <- function(input, output, session) {
    
    #if(COLOR_DISCARDED)
    #  qc_reasons <- readRDS("data/qc_reasons.rds")
    
    #sce_raw <- readRDS("data/sce_raw.rds")
    sce <- readRDS("data/sce.rds")
    
    #Expression matrix for Feature Plots, Heatmap and Expression Violin Plots
    #"Normalised values", "Raw Counts" or "Integrated Values" can be used
    exp.matrix <- sce[[COL_EXPRESSION]]
    
    de <- readRDS("data/de.rds")
    de_marker <<- readRDS("data/de_marker.rds") 
    
    #List of dim reduction results. key = reduction type 
    reducedDim.results <- sce[[COL_REDUCED_DIMS]]
    
    gene_info <- readRDS("data/gene_info.rds") #row names must be the same as the row names of expression matrix
    #gene_info <- gene_info[row.names(gene_info) %in% row.names(exp.matrix),]
    
    if(USE_MANUAL_COLOUR)
        anno_colour <- readRDS("data/anno_colour.rds")
    
    source("plotFunctions.R")
    source("commonFunctions.R")
    
    #source("server-qc.R",local = TRUE)
    #source("server-pca.R",local = TRUE)
    source("server-feature-plot.R",local = TRUE)
    source("server-exp-distr.R",local = TRUE)
    source("server-de-marker.R",local = TRUE)
    source("server-de.R",local = TRUE)
    
    GotoTab <- function(name){
        shinyjs::show(selector = paste0("a[data-value=\"",name,"\"]"))
        
        shinyjs::runjs("window.scrollTo(0, 0)")
    }
}