
observeEvent(input$vizGeneExpPlot1,{
  withProgress(message = "Processing , please wait",{
    color <- "Dark2"
    pointSize <- 1.75
    
    dim1 <- input$geneExpPlot1.dims[1]
    dim2 <-  tail(input$geneExpPlot1.dims, n=1)
    groups <- sce[[input$geneExpPlot1.group]]
    plotType <- input$geneExpPlot1.type
    plotData <- reducedDim(sce, plotType)
    
    plot <- plotScatter(paste0(plotType," ",dim1),paste0(plotType," ",dim2),
                        plotData[,dim1],plotData[,dim2],NULL,NULL,input$geneExpPlot1.group,groups,
                        "",pointSize,color,paste0(plotType,dim1,dim2))
    
    output$geneExpPlot1 <- renderPlot({
      plot
    })
  })
})

geneExpPlot2_ranges <- reactiveValues(x = NULL, y = NULL)

observeEvent(input$vizGeneExpPlot2,{
  withProgress(message = "Processing , please wait",{
    
    gene_list <- searchGenes(gene_info,input$geneExpPlot2.genes,"Gene.ID","Gene.Name")
  
    if(nrow(gene_list)==0){
      output$geneExpPlot2 <- renderUI({ 
        span("Genes not found", style="color:red")
      })
      return()
    }
  
    pointSize <- 2
    
    dim1 <- input$geneExpPlot2.dims[1]
    dim2 <-  tail(input$geneExpPlot2.dims, n=1)
    groups <- if(input$geneExpPlot2.group == "NULL") NULL else {sce[[input$geneExpPlot2.group]]}
    plotType <- input$geneExpPlot2.type
    plotData <- reducedDim(sce, plotType)[,c(dim1,dim2)]
    
    plotlist <- lapply(1:nrow(gene_list), function(i) {
      plotScatterFeatures(plotData,exp.matrix[row.names(gene_list)[i],], gene_list$Gene.ID[i], groups, input$geneExpPlot2.group, paste0(plotType,dim1), paste0(plotType,dim2), pointSize, paste0(plotType,dim1,dim2))
    
      #plotReducedDim(sce,dimred = input$geneExpPlot2.type, colour_by = rownames(gene_list)[j], ncomponents = input$geneExpPlot2.dims, by_exprs_values = "logcounts") +
      #    ggtitle(label = gene_list$Gene.Name[j])
    })
    
    output$geneExpPlot2 <- renderUI({
      lapply(1:nrow(gene_list), function(i) {
        output[[paste0("p",i)]] <- renderPlot({
          plotlist[[i]]+coord_cartesian(xlim = geneExpPlot2_ranges$x, ylim = geneExpPlot2_ranges$y)
        })
        
        box(title = paste0("Plot2 - ", gene_list$Gene.Name[i]), 
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
  updateSliderInput(session, "geneExpPlot1.dims", label = "Dimension",  min = 1, max = min(ncol(reducedDim(sce,input$geneExpPlot1.type)),4))
})

observeEvent(input$geneExpPlot2.type,{
  updateSliderInput(session, "geneExpPlot2.dims", label = "Dimension",  min = 1, max = min(ncol(reducedDim(sce,input$geneExpPlot2.type)),4))
})
