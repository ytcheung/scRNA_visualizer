server <- function(input, output, session) {
    
    qc_reasons <- readRDS("~/KI - Science Park/ki_summer/app/rna_app/data/qc_reasons.rds")
    
    #cow <- readRDS("~/KI - Science Park/ki_summer/app/rna_app/data/cow.rds")
    #cow_filtered <- readRDS("~/KI - Science Park/ki_summer/app/rna_app/data/cow_filtered.rds")
    
    cow_sce <- readRDS("~/KI - Science Park/ki_summer/app/rna_app/data/cow_sce.rds")
    cow_sce_filtered <- readRDS("~/KI - Science Park/ki_summer/app/rna_app/data/cow_sce_filtered.rds")
    
    source("server-qc.R",local = TRUE)
    
    GotoTab <- function(name){
        
        shinyjs::show(selector = paste0("a[data-value=\"",name,"\"]"))
        
        shinyjs::runjs("window.scrollTo(0, 0)")
    }
}