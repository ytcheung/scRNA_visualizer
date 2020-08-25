plotDE <- list()
plotDE_pdf_height <- 10

observeEvent(input$vizDePlot,{
  withProgress(message = "Processing , please wait",{
    
    show <- FALSE
    cluster <- {if (input$dePlot.cluster == "TRUE") TRUE else FALSE}
    method1 <- "euclidean"
    method2 <- "correlation"
    plotName <- "DE_Heatmap"
    
    markers <- list()
    de_list <- de
    
    #Filter up/down regulated genes
    if (input$dePlot_geneData == "up"){
      de_list <- de_list[de_list[[COL_DE_LOG_FC]] > 0,]
      plotName <- paste0(plotName,"_Upregulated")
    }
    if (input$dePlot_geneData == "down"){
      de_list <- de_list[de_list[[COL_DE_LOG_FC]] < 0,]
      plotName <- paste0(plotName,"_Downregulated")
    }
    
    #Sorting
    if (input$dePlot.orderBy == COL_DE_LOG_FC && input$dePlot_geneData != "down")
      de_list <- de_list[order(-de_list[[input$dePlot.orderBy]]),]
    else
      de_list <- de_list[order(de_list[[input$dePlot.orderBy]]),]
    
    #Remove duplicates after sorting
    de_list <- de_list[!duplicated(de_list[[COL_DE_GENE_NAME]]),]
    
    if (input$dePlot_geneData == "custom"){
      gene_list <- searchGenes(gene_info,input$dePlot.genes,COL_GENE_ID,COL_GENE_NAME)
      de_list <- de_list[de_list[[COL_DE_GENE_NAME]] %in% row.names(gene_list),]
      
      plotName <- paste0(plotName,"_Selected_Markers")
    } else {
      count <- min(nrow(de_list),input$dePlot.geneCount)
      de_list <- de_list[1:count,]
      gene_list <- gene_info[de_list[[COL_DE_GENE_NAME]],]
      
      plotName <- paste0(plotName,"_Top",length(count))
    }
    
    markers <- de_list[[COL_DE_GENE_NAME]]
    gene_list <- gene_list[de_list[[COL_DE_GENE_NAME]],]
    de_list$Ensembl.ID <- gene_list[[COL_GENE_ID]]
    
    if(length(markers)<2)
      return()
    
    annogenes <- as.data.frame(list("Gene.Name"=row.names(gene_list[markers,]),"Annotation"=gene_list[markers,][[COL_GENE_ANNO]]))
    
    # Save clustering and groupings to data frame
    groups <- data.frame(group1 = as.factor(sce[[input$dePlot.group1]]), group2=as.factor(sce[[input$dePlot.group2]]), 
                         row.names = colnames(sce), N = colnames(sce))

    plot <- DrawHeatmap(groups, annogenes, exp.matrix[markers,], show, method1, cluster, input$dePlot.group1, input$dePlot.group2)
    
    plotDE <<- list()
    plotDE[[plotName]] <<- plot
    
    output$dePlot1 <- renderPlot({
      plot
    })
    
    output$deTable <- DT::renderDataTable({
      my_table <- de_list
      my_table$Ensembl.ID <- createLink(my_table$Ensembl.ID,ENSEMBL_LINK,my_table$Ensembl.ID)
      return(my_table)
    }, escape = FALSE,server = FALSE,extensions = c("Buttons"), options = list(dom = 'Bfrtip',
                   buttons = c('copy', 'csv', 'excel')))
    
    #Set plot height according to the number of genes
    plot_height <- 600
    plotDE_pdf_height <- 7
    if(length(markers)>40){
      plot_height <- 1000
      plotDE_pdf_height <<-13
    }
    if(length(markers)>80){
      plot_height <- 1500
      plotDE_pdf_height <<-16
    }
     
    output$dePlot_UI <- renderUI({
      tabBox(
        title = "", width = 12,
        tabPanel("Heatmap", plotOutput("dePlot1",height = plot_height)),
        tabPanel("Data", DT::dataTableOutput("deTable"))
      )
    })
  })
})

output$downloadDEHeatmap = downloadHandler(
  filename = function() {
      paste0(names(plotDE)[1], ".pdf")
  }, 
  content = function(fname) {
    p <- plotDE[[1]]
    
    stopifnot(!missing(p))
    stopifnot(!missing(fname))
    pdf(fname, width=12,height = plotDE_pdf_height)
    grid::grid.newpage()
    grid::grid.draw(p$gtable)
    dev.off()
  }
)