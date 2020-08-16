
observeEvent(input$vizExpDistrPlot,{
  withProgress(message = "Processing , please wait",{
    
    gene_list <- searchGenes(gene_info,input$expDistrPlot.genes,"Gene.ID","Gene.Name")
    
    if(nrow(gene_list)==0)
      return()

    color <- "Dark2"
    pointSize <- 1.5
    if(input$expDistrPlot.colourBy == "NULL") {
      colourBy <- groups <- NULL 
    } else {
      colourBy <- input$expDistrPlot.colourBy
      groups <- sce[[colourBy]]
    }
    
    plotlist <- lapply(1:nrow(gene_list), function(i) {
      plotVln(input$expDistrPlot.groupBy,"Expression(logcounts)",sce[[input$expDistrPlot.groupBy]],exp.matrix[row.names(gene_list)[i],],NULL,NULL,colourBy,groups,"",pointSize,color,"")
      
      #plotExpression(sce, rownames(gene_list), x = input$expDistrPlot.groupBy, colour_by = colourBy, point_size= 2)
    })

    output[[input$expDistrPlot.id]] <- renderUI({
      lapply(1:nrow(gene_list), function(i) {
        box(title = paste0(gene_list$Gene.Name[i],"(",gene_list$Gene.ID[i],")") , width = 12,
            renderPlot(plotlist[[i]])
        )
      })
    })
  })
})