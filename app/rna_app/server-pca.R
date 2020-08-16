
observeEvent(input$vizPlot,{
  withProgress(message = "Processing , please wait",{
    color <- "Dark2"
    pointSize <- 1.75
    
    dim1 <- input$plot.dims[1]
    dim2 <-  tail(input$plot.dims, n=1)
    plotType <- input$plot.type
    groups <- sce[[input$plot.group]]
    plot_data <- reducedDim(sce, plotType)
    
    plot <- plotScatter(paste0(plotType," ",dim1),paste0(plotType," ",dim2),
                        plot_data[,dim1],plot_data[,dim2],NULL,NULL,input$plot.group,groups,"",pointSize,color,paste0(plotType,dim1,dim2))
    
    output[[input$plot.id]] <- renderPlot({
      plot
    })
  })
})


observeEvent(input$plot.type,{
    updateSliderInput(session, "plot.dims", label = "Dimension",  min = 1, max = min(ncol(reducedDim(sce,input$plot.type)),4))
})
