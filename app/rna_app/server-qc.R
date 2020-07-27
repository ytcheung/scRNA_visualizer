output$rawDataHisto <- renderUI({
  # If missing input, return to avoid error later in function
  if(is.null(cow_sce))
    return()
  
  plt1 <- renderPlot({
    hist(cow_sce$total/1e6, xlab="Library sizes(millions)", main="",breaks=50, col="grey80", ylab="Number of cells")
  })
  
  plt2 <- renderPlot({
    hist(cow_sce$detected, xlab="Number of expressed genes", main="",breaks=50, col="grey80", ylab="Number of cells")
  })
  
  plt3 <- renderPlot({
    hist(cow_sce$subsets_mito_percent, xlab="Mito %", main="",breaks=50, col="grey80", ylab="Number of cells")
  })
 
  box(
    title = "Histograms", width = 4,
    tabBox(
      width = 12,
      tabPanel("Lib Size", plt1),
      tabPanel("Features Count",  plt2),
      tabPanel("Mito %",  plt3)
    )
  )
})

#output$filteredDataHisto <- renderUI({
#  # If missing input, return to avoid error later in function
#  if(is.null(cow_sce_filtered))
#    return()
#  
#  plt1 <- renderPlot({
#    hist(cow_sce_filtered$total/1e6, xlab="Library sizes(millions)", main="",breaks=50, col="grey80", ylab="Number of cells")
#  })
#  
#  plt2 <- renderPlot({
#    hist(cow_sce_filtered$detected, xlab="Number of expressed genes", main="",breaks=50, col="grey80", ylab="Number of cells")
#  })
#  
#  plt3 <- renderPlot({
#    hist(cow_sce_filtered$subsets_mito_percent, xlab="Mito %", main="",breaks=50, col="grey80", ylab="Number of cells")
#  })
#  
#  box(
#    title = "Histograms (After Filtering)", width = 6,
#    tabBox(
#      width = 12,
#      tabPanel("Library Size", plt1),
#      tabPanel("Features Count",  plt2),
#      tabPanel("Mitochondria %",  plt3)
#    )
#  )
#})

output$rawDataVlnPlot <- renderUI({
  # If missing input, return to avoid error later in function
  if(is.null(cow_sce))
    return()
  
  plt1 <- renderPlot({
    plotColData(cow_sce, x="Experiment", y="total", colour_by=I(qc_reasons@listData[["low_lib_size"]])) + scale_y_log10()
  })
  
  plt2 <- renderPlot({
    plotColData(cow_sce, x="Experiment", y="detected", colour_by=I(qc_reasons@listData[["low_n_features"]])) + scale_y_log10()
  })
  
  plt3 <- renderPlot({
    plotColData(cow_sce, x="Experiment", y="percent.mito", colour_by=I(qc_reasons@listData[["high_subsets_mito_percent"]]))
  })
  
  box(
    title = "VlnPLot (Raw)", width = 4,
    tabBox(
      width = 12,
      tabPanel("Library Size", plt1),
      tabPanel("Features Count",  plt2),
      tabPanel("Mito %",  plt3)
    )
  )
})

output$filteredDataVlnPlot <- renderUI({
  # If missing input, return to avoid error later in function
  if(is.null(cow_sce_filtered))
    return()
  
  plt1 <- renderPlot({
    plotColData(cow_sce_filtered, x="Experiment", y="total") + scale_y_log10()
  })
  
  plt2 <- renderPlot({
    plotColData(cow_sce_filtered, x="Experiment", y="detected") + scale_y_log10()
  })
  
  plt3 <- renderPlot({
    plotColData(cow_sce_filtered, x="Experiment", y="percent.mito")
  })
  
  box(
    title = "VlnPLot (Filtered)", width = 4,
    tabBox(
      width = 12,
      tabPanel("Library Size", plt1),
      tabPanel("Features Count",  plt2),
      tabPanel("Mito %",  plt3)
    )
  )
})

output$rawDataScatter <- renderUI({
  # If missing input, return to avoid error later in function
  if(is.null(cow_sce))
    return()
  
  plt1 <- renderPlot({
    plotColData(cow_sce, x="nCount_RNA", y="nFeature_RNA", colour_by="Experiment")
  })
  
  plt2 <- renderPlot({
    plotColData(cow_sce, x="nFeature_RNA", y="percent.mito", colour_by="Experiment") 
  })
  
  plt3 <- renderPlot({
    plotColData(cow_sce, x="nCount_RNA", y="percent.mito", colour_by="Experiment")
  })
  
  box(
    title = "Scatter (Raw)", width = 6,
    tabBox(
      width = 12,
      tabPanel("Feature/Count", plt1),
      tabPanel("Mito %/Feature",  plt2),
      tabPanel("Mito %/Count",  plt3)
    )
  )
})

output$filteredDataScatter <- renderUI({
  # If missing input, return to avoid error later in function
  if(is.null(cow_sce_filtered))
    return()
  
  plt1 <- renderPlot({
    plotColData(cow_sce_filtered, x="nCount_RNA", y="nFeature_RNA", colour_by="Experiment")
  })
  
  plt2 <- renderPlot({
    plotColData(cow_sce_filtered, x="nFeature_RNA", y="percent.mito", colour_by="Experiment") 
  })
  
  plt3 <- renderPlot({
    plotColData(cow_sce_filtered, x="nCount_RNA", y="percent.mito", colour_by="Experiment")
  })
  
  box(
    title = "Scatter (Filtered)", width = 6,
    tabBox(
      width = 12,
      tabPanel("Feature/Count", plt1),
      tabPanel("Mito %/Feature",  plt2),
      tabPanel("Mito %/Count",  plt3)
    )
  )
})
