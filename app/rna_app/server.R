server <- function(input, output, session) {
    
    qc_reasons <- readRDS("data/qc_reasons.rds")
    gene_info <- readRDS("data/gene_info.rds")
    sce_raw <- readRDS("data/sce_raw.rds")
    sce <- readRDS("data/sce.rds")
    
    exp.matrix <- sce@assays@data@listData[["logcounts"]]
    
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