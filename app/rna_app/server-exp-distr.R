plotListExpDistr <- list()
plotListExpDistr[["expDistrPlot1"]] <- list()
plotListExpDistr[["expDistrPlot2"]] <- list()

updateSelectizeInput(session, "expDistrPlot.genes", choices = sort(gene_info[[COL_GENE_NAME]]), server = TRUE)

observeEvent(input$vizExpDistrPlot,{
  withProgress(message = "Processing , please wait",{
    
    gene_list <- searchGenes(gene_info,input$expDistrPlot.genes,COL_GENE_ID,COL_GENE_NAME)
    
    if(nrow(gene_list)==0)
      return()

    color <- "Dark2"
    pointSize <- 1.5
    plotName_prefix <- paste0("Vln_",input$expDistrPlot.groupBy,"_")
    if(input$expDistrPlot.colourBy == "NULL") {
      colourBy <- groups <- NULL 
    } else {
      colourBy <- input$expDistrPlot.colourBy
      groups <- sce[[colourBy]]
      plotName_prefix <- paste0(plotName_prefix,colourBy,"_")
    }
    
    plotList <- list()
    lapply(1:nrow(gene_list), function(i) {
      plotName <- paste0(plotName_prefix,gene_list$Gene.Name[i],"_",gene_list$Gene.ID[i])
      plotList[[plotName]] <<- plotVln(input$expDistrPlot.groupBy,"Expression(logcounts)",sce[[input$expDistrPlot.groupBy]],
                                exp.matrix[row.names(gene_list)[i],],NULL,NULL,colourBy,groups,"",pointSize,color)
    })
    plotListExpDistr[[input$expDistrPlot.id]] <<- plotList
    
    output[[input$expDistrPlot.id]] <- renderUI({
      lapply(1:nrow(gene_list), function(i) {
        box(title = tags$a(href=paste0(ENSEMBL_LINK,gene_list$Gene.ID[i]), paste0(gene_list$Gene.Name[i],"(",gene_list$Gene.ID[i],")"))  , width = 12,
          renderPlot(plotList[[i]])
        )
      })
    })
  })
})

output$downloadExpDistr = downloadHandler(
  filename = function() {
    'Expression_Distribution.zip'
  },
  content = function(fname) {
    combined_list <- list()
    combined_list <- append(combined_list, plotListExpDistr[["expDistrPlot1"]])
    combined_list <- append(combined_list, plotListExpDistr[["expDistrPlot2"]])
    
    fs <- c()
    setwd(tempdir())
    
    foreach(key=names(combined_list), val=combined_list, .packages = c("foreach")) %do% {
      path <- paste0(key, ".pdf")
      fs <- c(fs, path)
      ggsave(plot = val, dpi = 600, filename = path, useDingbats=FALSE, width=8, height=6)
    }
    
    zip::zipr(zipfile=fname, files=fs)
  }
)