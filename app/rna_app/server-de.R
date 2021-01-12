plotDE <- list()
plotDE_pdf_height <- 0

#updateSelectizeInput(session, "dePlot.genes", choices = sort(unique(de[[COL_DE_GENE_NAME]])), server = TRUE)

observeEvent(input$vizDePlot,{
  withProgress(message = "Processing , please wait",{
    
    show <- FALSE
    plot <- NA
    plotDE <<- list()
    #plotDEMarker <<- list() 
    plotName <- "DE_Heatmap"
    
    output$dePlot_UI <- renderUI({})
    #output$deMarkerPlot_UI <- renderUI({})
    
    #if(!exists("de"))
    #  de <<- readRDS("data/de.rds")
    de_list <- copy(de)
    exp <- sce[[COL_EXPRESSION_DE]]
    
    cluster_cell_method <- NULL #switch((input$dePlot.clusterCell != "FALSE")+1, NULL, input$dePlot.clusterCell)
    cluster_gene_method <- switch((input$dePlot.clusterGene != "FALSE")+1, NULL, input$dePlot.clusterGene)
    
    #Filter up/down regulated genes
    if (input$dePlot_geneData == "up"){
      de_list <- de_list[de_list[[COL_DE_LOG_FC]] > 0,] #de_list %>% filter(!!rlang::sym(COL_DE_LOG_FC) > 0)
      plotName <- paste0(plotName,"_Upregulated")
    }
    if (input$dePlot_geneData == "down"){
      de_list <- de_list[de_list[[COL_DE_LOG_FC]] < 0,] #de_list %>% filter(!!rlang::sym(COL_DE_LOG_FC) < 0)
      plotName <- paste0(plotName,"_Downregulated")
    }
    
    #Filter by p value and logFoldChange
    de_list <- de_list[de_list[[COL_DE_P_VAL]] < input$deplot.pvalue,]
    
    #if (input$deplot.foldChangeSymbol == ">")
      de_list <- de_list[abs(de_list[[COL_DE_LOG_FC]]) > input$deplot.foldChange,]
    #else
    #  de_list <- de_list %>% filter(abs(!!rlang::sym(COL_DE_LOG_FC)) < input$deplot.foldChange)
    
    #Subset
    #subsetType <- input$dePlot_subsetType
    #if(subsetType != "NULL" && length(input$dePlot.subset) != 0){
    #  # Remove records in de list
    #  if(subsetType == COL_CLUSTER){
    #    de_list <- de_list %>% filter(!!rlang::sym(COL_DE_CLUSTER) %in% input$dePlot.subset)
    #  }
    #  
    #  exp <- exp.matrix[,sce[[input$dePlot_subsetType]] %in% input$dePlot.subset]
    #}
    
    #de_list <- de_list %>% filter(!!rlang::sym(DE_GROUP1_COL_NAME) %in% input$dePlot.group1)
    #de_list <- de_list %>% filter(!!rlang::sym(DE_GROUP2_COL_NAME) %in% input$dePlot.group2)
    de_list <- de_list[de_list[[DE_GROUP1_COL_NAME]] %in% input$dePlot.group1, ]
    de_list <- de_list[de_list[[DE_GROUP2_COL_NAME]] %in% input$dePlot.group2, ]
    #Filter Cells
    grp2_options <- unlist(strsplit(input$dePlot.group2,"_"))
    exp <- exp[,sce[[DE_GROUP1_COL_NAME]] %in% unlist(DE_GROUP1_MAPPING[[input$dePlot.group1]]) 
                & sce[[DE_GROUP2_COL_NAME]] %in% grp2_options]
    
    #Sort rows
    de_list <- de_list[order(de_list[[COL_DE_CLUSTER]],decreasing = TRUE),]
    # if (input$dePlot.orderBy == COL_DE_LOG_FC)
    #   de_list <- de_list[order(-abs(de_list[[input$dePlot.orderBy]])),] #Sort by absolute value
    # else
    #   de_list <- de_list[order(de_list[[input$dePlot.orderBy]]),]
    
    #Remove duplicates after sorting
    #de_list <- de_list[!duplicated(de_list[[COL_DE_GENE_NAME]]),]
    
    #if (input$dePlot_geneData == "custom"){
    #  gene_list <- searchGenes(gene_info,input$dePlot.genes)
    #  de_list <- de_list[de_list[[COL_DE_GENE_NAME]] %in% row.names(gene_list),]
    #  gene_list <- gene_list[de_list[[COL_DE_GENE_NAME]],]
    #  
    #  plotName <- paste0(plotName,"_Selected_Markers")
    #} else {
      #de_list <- de_list %>% group_by(!!rlang::sym(COL_DE_CLUSTER)) %>% filter(row_number()<=input$dePlot.geneCount)
      gene_list <- gene_info[de_list[[COL_DE_GENE_NAME]],]
    #}
    
    #de_list$Ensembl.ID <- gene_list[[COL_GENE_ID]] #Note: genes order in both lists must be the same
    
    if(nrow(gene_list)<2){
      showNotification("Gene not found.", type="error")
      return()
    }
    
    #annogenes <- as.data.frame(list("Annotation"=gene_list[[COL_GENE_ANNO]], "Cluster"=de_list[[COL_DE_CLUSTER]]))
    #annogenes <- as.data.frame(list("MarkerCluster"=de_list[[COL_DE_CLUSTER]]))
    #row.names(annogenes) <- row.names(gene_list)
    annogenes <- NA
    
    # Save clustering and groupings to data frame
    groups <- data.frame(group1 = as.factor(sce[[MARKER_DEFAULT_GROUP]]), row.names = sce[[COL_CELL_NAME]], N = sce[[COL_CELL_NAME]])
    groups <- groups[colnames(exp),] #In case if there is any subset filtered
    
    #Sort columns
    if (is.null(cluster_cell_method))
      exp <- exp[,order(groups$group1)]
    
    annotation_color <- list()
    if(USE_MANUAL_COLOUR){
      # No. of colors mush match the annotation count
      annotation_color <- list(
        #MarkerCluster = anno_colour[[COL_CLUSTER]][names(anno_colour[[COL_CLUSTER]]) %in% de_list[[COL_DE_CLUSTER]]]
      )
      annotation_color[[MARKER_DEFAULT_GROUP]] = anno_colour[[MARKER_DEFAULT_GROUP]][names(anno_colour[[MARKER_DEFAULT_GROUP]]) %in% groups$group1]
    }
    
    plot <- DrawHeatmap(groups, annogenes, exp[gene_list[[COL_GENE_NAME]],], show, cluster_cell_method, cluster_gene_method, 
                        MARKER_DEFAULT_GROUP, "", annotation_color)
    
    plotDE <<- list()
    plotDE[[plotName]] <<- plot
    
    output$dePlot1 <- renderPlot({
      plot
    })
    
    output$deTable <- DT::renderDataTable({
      my_table <- copy(de_list)
      if (length(COL_DE_DT_HIDE)>0)
        my_table[,COL_DE_DT_HIDE] <- NULL
      #my_table$Ensembl.ID <- createLink(my_table$Ensembl.ID,ENSEMBL_LINK,my_table$Ensembl.ID)
      my_table$Gene <- createLink(my_table$Gene,ENSEMBL_LINK,my_table$Gene)
      setcolorder(my_table, c(COL_DE_GENE_NAME))
      my_table <- my_table %>% mutate_if(is.numeric, signif, 2)
      return(my_table)
    }, escape = FALSE,server = FALSE,extensions = c("Buttons"), options = list(dom = 'Bfrtip',
                   buttons = c('copy', 'csv', 'excel')), rownames= FALSE)
  
    #Set plot height
    gtable_h <- convertHeight(gtable_height(plot$gtable),"inches",valueOnly = TRUE)
    legend_row <- length(unique(groups$group1)) #+ length(unique(groups$group2))
    #legend_row <- legend_row + length(unique(annogenes$Annotation)) + length(unique(annogenes$MarkerCluster)) 
    h <- max(gtable_h, legend_row/2 + 1.5)
    
    plotDE_pdf_height <<- h + 0.5
    plot_height <- h * 70 + 150
     
    output$dePlot_UI <- renderUI({
      tabBox(
        title = "", width = 12,
        tabPanel("Heatmap", plotOutput("dePlot1",height = plot_height)),
        tabPanel("Data", DT::dataTableOutput("deTable"))
      )
    })
  })
})

observeEvent(input$dePlot_subsetType,{
  group <- input$dePlot_subsetType
  if (group != "NULL"){
    withProgress(message = "Processing , please wait",{
    updateSelectizeInput(session, "dePlot.subset", choices = sort(unique(sce[[group]])))
    })
  }
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