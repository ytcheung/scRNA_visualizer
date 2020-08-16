
observeEvent(input$vizDePlot,{
  withProgress(message = "Processing , please wait",{
    
    gene_list <- searchGenes(gene_info,input$dePlot.genes,"Gene.ID","Gene.Name")
    
    if(nrow(gene_list)==0)
      return()
    
    show <- FALSE
    cluster <- FALSE
    method1 <- "euclidean"
    method2 <- "correlation"
    
    # Annotate chosen markers and order them
    annogenes <- CategorizeMarkers(rownames(gene_list))
    
    # Save clustering and groupings to data frame
    groups <- data.frame(group1 = as.factor(sce[[input$dePlot.group1]]), group2=as.factor(sce[[input$dePlot.group2]]), 
                         row.names = colnames(sce), N = colnames(sce))

    plot <- DrawHeatmap(groups, annogenes, exp.matrix[row.names(gene_list),], ChosenMarkers, show, method1, cluster)
    
    output$dePlot1 <- renderPlot({
      plot
    })
  })
})