server <- function(input, output, session) {
    
    if(COLOR_DISCARDED)
      qc_reasons <- readRDS("data/qc_reasons.rds")
    
    sce_raw <- readRDS("data/sce_raw.rds")
    sce <- readRDS("data/sce.rds")
    gene_info <- readRDS("data/gene_info.rds") #row names must be the same as the row names of expression matrix and sce object
    gene_info <- gene_info[row.names(gene_info) %in% row.names(sce),]
    de <- readRDS("data/de.rds") #Marker genes data, has info like logFC and p value
    
    #Dataframe for Feature Plots, Heatmap and Expression Violin Plots
    #"Normalised" values are used here, change this if you need to use "Raw Counts" or "Integrated Values"
    exp.matrix <- sce@assays@data@listData[["logcounts"]]
    
    #List of dim reduction results. key = reduction type, e.g. reducedDim.df$PCA = PCA results 
    reducedDim.results <- reducedDims(sce) 
    
    source("plotFunctions.R")
    source("commonFunctions.R")
    
    source("server-qc.R",local = TRUE)
    source("server-pca.R",local = TRUE)
    source("server-gene-exp.R",local = TRUE)
    source("server-exp-distr.R",local = TRUE)
    source("server-de.R",local = TRUE)
    
    GotoTab <- function(name){
        
        shinyjs::show(selector = paste0("a[data-value=\"",name,"\"]"))
        
        shinyjs::runjs("window.scrollTo(0, 0)")
    }
}