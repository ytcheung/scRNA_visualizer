plotListFeature <- list() #For plot1
plotListFeature2 <- list() #For plot2 

updateSelectizeInput(session, "geneExpPlot2.genes", choices = sort(gene_info[[COL_GENE_NAME]]), server = TRUE)

observeEvent(input$vizGeneExpPlot1,{
  withProgress(message = "Processing , please wait",{
    color <- "Dark2"
    pointSize <- 1.75
    
    dim1 <- input$geneExpPlot1.dims[1]
    dim2 <-  tail(input$geneExpPlot1.dims, n=1)
    groups <- sce[[input$geneExpPlot1.group]]
    plotType <- input$geneExpPlot1.type
    plotData <- reducedDim.results[[plotType]]
    plotName <- paste0(plotType,dim1,dim2)
    
    plotListFeature[[plotName]] <<- plotScatter(paste0(plotType," ",dim1),paste0(plotType," ",dim2),
                                                plotData[,dim1],plotData[,dim2],NULL,NULL,input$geneExpPlot1.group,groups,
                                                "",pointSize,color)
    
    output$geneExpPlot1 <- renderPlot({
      plotListFeature[[plotName]]
    })
    
    output$geneExpPlot2 <- renderUI({})
    plotListFeature2 <<- list() 
  })
})

geneExpPlot2_ranges <- reactiveValues(x = NULL, y = NULL)

observeEvent(input$vizGeneExpPlot2,{
  withProgress(message = "Processing , please wait",{

    gene_list <- searchGenes(gene_info,input$geneExpPlot2.genes,COL_GENE_ID,COL_GENE_NAME)
      
    if(nrow(gene_list)==0){
      output$geneExpPlot2 <- renderUI({ 
        span("Genes not found", style="color:red")
      })
      return()
    }
    
    pointSize <- 2
    
    dim1 <- input$geneExpPlot1.dims[1]
    dim2 <-  tail(input$geneExpPlot1.dims, n=1)
    groups <- if(input$geneExpPlot2.group == "NULL") NULL else {sce[[input$geneExpPlot2.group]]}
    plotType <- input$geneExpPlot1.type
    plotData <- reducedDim.results[[plotType]][,c(dim1,dim2)]
    
    plotListFeature2 <<- list() 
    lapply(1:nrow(gene_list), function(i) {
      plotName <- paste0(plotType,dim1,dim2,"_",gene_list$Gene.Name[i],"_",gene_list$Gene.ID[i])
      plotListFeature2[[plotName]] <<- plotScatterFeatures(plotData,exp.matrix[row.names(gene_list)[i],], gene_list$Gene.Name[i],
                                                          groups, input$geneExpPlot2.group, paste0(plotType,dim1), 
                                                          paste0(plotType,dim2), pointSize)
    })
    
    output$geneExpPlot2 <- renderUI({
      lapply(1:nrow(gene_list), function(i) {
        output[[paste0("p",i)]] <- renderPlot({
          plotListFeature2[[i]] <<- plotListFeature2[[i]]+coord_cartesian(xlim = geneExpPlot2_ranges$x, ylim = geneExpPlot2_ranges$y)
          plotListFeature2[[i]]
        })
        
        box(title = tags$a(href=paste0(ENSEMBL_LINK,gene_list$Gene.ID[i]), paste0("Plot2 - ", gene_list$Gene.ID[i])), 
            plotOutput(paste0("p",i))
        )
      })
    })
  })
})

# When a double-click happens, check if there's a brush on the plot.
# If so, zoom to the brush bounds; if not, reset the zoom.
observe({
  brush <- input$geneExpPlot1_brush
  if (!is.null(brush)) {
    geneExpPlot2_ranges$x <- c(brush$xmin, brush$xmax)
    geneExpPlot2_ranges$y <- c(brush$ymin, brush$ymax)
  } else {
    geneExpPlot2_ranges$x <- NULL
    geneExpPlot2_ranges$y <- NULL
  }
})

observeEvent(input$geneExpPlot1.type,{
  updateSliderInput(session, "geneExpPlot1.dims", label = "Dimension",  min = 1, max = min(ncol(reducedDim.results[[input$geneExpPlot1.type]]),4))
})

# observeEvent(input$geneExpPlot2.type,{
#   updateSliderInput(session, "geneExpPlot2.dims", label = "Dimension",  min = 1, max = min(ncol(reducedDim.results[[input$geneExpPlot2.type]]),4))
# })

output$downloadFeaturePlots = downloadHandler(
  filename = function() {
      'Feature_Plots.zip'
  },
  content = function(fname) {
      combined_list <- list()
      combined_list <- append(combined_list, plotListFeature)
      combined_list <- append(combined_list, plotListFeature2)
    
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

