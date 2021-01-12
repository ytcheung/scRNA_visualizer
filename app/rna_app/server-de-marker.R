plotDEMarker <- list()
plotDEMarker_pdf_height <- 0

#updateSelectizeInput(session, "deMarkerPlot.genes", choices = sort(unique(de_marker[[COL_DE_GENE_NAME]])), server = TRUE)

observeEvent(input$vizDeMarkerPlot,{
  withProgress(message = "Processing , please wait",{
    
    show <- FALSE
    plot <- NA
    #plotDE <<- list()
    plotDEMarker <<- list()
    plotName <- "Marker_Heatmap"
    
    #output$dePlot_UI <- renderUI({})
    output$deMarkerPlot_UI <- renderUI({})
    
    #if(!exists("de_marker"))
    #  de_marker <<- readRDS("data/de_marker.rds") 
    de_list <- copy(de_marker)
    
    exp <- sce[[COL_EXPRESSION_DE]]
    
    cluster_cell_method <- switch((input$deMarkerPlot.clusterCell != "FALSE")+1, NULL, input$deMarkerPlot.clusterCell)
    cluster_gene_method <- NULL #switch((input$deMarkerPlot.clusterGene != "FALSE")+1, NULL, input$deMarkerPlot.clusterGene)
    
    #Filter up/down regulated genes
    #if (input$deMarkerPlot_geneData == "up"){
    #  de_list <- de_list %>% filter(!!rlang::sym(COL_DE_LOG_FC) > 0)
    #  plotName <- paste0(plotName,"_Upregulated")
    #}
    #if (input$deMarkerPlot_geneData == "down"){
    #  de_list <- de_list %>% filter(!!rlang::sym(COL_DE_LOG_FC) < 0)
    #  plotName <- paste0(plotName,"_Downregulated")
    #}
    
    #Filter by p value and logFoldChange
    p_val <- input$deMarkerPlot.pvalue
    
    print("Before p-val:")
    print("- de_list:")
    print(head(de_list))
    print("- de_marker:")
    print(head(de_marker))
    print(tracemem(de_list) == tracemem(de_marker))
    
    de_list <- de_list[de_list[[COL_DE_P_VAL]] < p_val,]
    
    #if (input$deMarkerPlot.foldChangeSymbol == ">")
      de_list <- de_list <- de_list[abs(de_list[[COL_DE_LOG_FC]]) > input$deMarkerPlot.foldChange,]
    #else
    #  de_list <- de_list %>% filter(abs(!!rlang::sym(COL_DE_LOG_FC)) < input$deMarkerPlot.foldChange)
    
    #Subset
    subsetType <- input$deMarkerPlot_subsetType
    if(subsetType != "NULL" && length(input$deMarkerPlot.subset) != 0){
      # Remove records in de list
      #if(subsetType == COL_CLUSTER){
         #de_list <- de_list %>% filter(!!rlang::sym(COL_DE_CLUSTER) %in% input$deMarkerPlot.subset)
      #}
      
      exp <- exp.matrix[,sce[[input$deMarkerPlot_subsetType]] %in% input$deMarkerPlot.subset]
    }
    
    #Sort rows
    de_list <- de_list[order(de_list[[COL_DE_CLUSTER]],-abs(de_list[[COL_DE_LOG_FC]])),]
    
    # if (input$deMarkerPlot.orderBy == COL_DE_LOG_FC)
    #   de_list <- de_list[order(-abs(de_list[[input$deMarkerPlot.orderBy]])),] #Sort by absolute value
    # else
    #   de_list <- de_list[order(de_list[[input$deMarkerPlot.orderBy]]),]
    
    #Remove duplicates after sorting
    #de_list <- de_list[!duplicated(de_list[[COL_DE_GENE_NAME]]),]
    
    #if (input$deMarkerPlot_geneData == "custom"){
    #  gene_list <- searchGenes(gene_info,input$deMarkerPlot.genes)
    #  de_list <- de_list[de_list[[COL_DE_GENE_NAME]] %in% row.names(gene_list),]
    #  gene_list <- gene_list[de_list[[COL_DE_GENE_NAME]],]
    #  
    #  plotName <- paste0(plotName,"_Selected_Markers")
    #} else {
      if(input$deMarkerPlot_FilterGeneCount == "Yes"){
        #de_list <- de_list %>% group_by(!!rlang::sym(COL_DE_CLUSTER)) %>% filter(row_number()<=input$deMarkerPlot.geneCount)
        de_list <- Reduce(rbind,by(de_list, de_list[[COL_DE_CLUSTER]], head, n=input$deMarkerPlot.geneCount))
      } 
      gene_list <- gene_info[de_list[[COL_DE_GENE_NAME]],]
    #}
    
    #de_list$Ensembl.ID <- gene_list[[COL_GENE_ID]] #Note: genes order in both lists must be the same
    
    if(nrow(gene_list)<2){
      showNotification("Marker not found.", type="error")
      return()
    }
    
    #annogenes <- as.data.frame(list("Annotation"=gene_list[[COL_GENE_ANNO]], "Cluster"=de_list[[COL_DE_CLUSTER]]))
    annogenes <- as.data.frame(list("MarkerCluster"=de_list[[COL_DE_CLUSTER]]))
    row.names(annogenes) <- row.names(gene_list)
    
    # Save clustering and groupings to data frame
    groups <- data.frame(group1 = as.factor(sce[[MARKER_DEFAULT_GROUP]]), row.names = sce[[COL_CELL_NAME]], N = sce[[COL_CELL_NAME]])
    #if(input$deMarkerPlot.group2 != "NULL")
    #  groups[["group2"]] <- as.factor(sce[[input$deMarkerPlot.group2]])
    groups <- groups[colnames(exp),] #In case if there is any subset filtered
    
    #Sort columns
    if (is.null(cluster_cell_method))
      exp <- exp[,order(groups$group1)]
    
    annotation_color <- list()
    if(USE_MANUAL_COLOUR){
      # No. of colors mush match the annotation count
      annotation_color <- list(
        MarkerCluster = anno_colour[[COL_CLUSTER]][names(anno_colour[[COL_CLUSTER]]) %in% de_list[[COL_DE_CLUSTER]]]
      )
      annotation_color[[MARKER_DEFAULT_GROUP]] = anno_colour[[MARKER_DEFAULT_GROUP]][names(anno_colour[[MARKER_DEFAULT_GROUP]]) %in% groups$group1]
    }
      
    plot <- DrawHeatmap(groups, annogenes, exp[gene_list[[COL_GENE_NAME]],], show, cluster_cell_method, cluster_gene_method, 
                        MARKER_DEFAULT_GROUP, "", annotation_color) #input$deMarkerPlot.group1, input$deMarkerPlot.group2)
    
    plotDEMarker <<- list()
    plotDEMarker[[plotName]] <<- plot
    
    output$deMarkerPlot1 <- renderPlot({
      plot
    })
    
    output$deMarkerTable <- DT::renderDataTable({
      my_table <- copy(de_list)
      if (length(COL_DE_MARKER_DT_HIDE)>0)
        my_table[,COL_DE_MARKER_DT_HIDE] <- NULL
      #my_table$Ensembl.ID <- createLink(my_table$Ensembl.ID,ENSEMBL_LINK,my_table$Ensembl.ID)
      my_table$Gene <- createLink(my_table$Gene,ENSEMBL_LINK,my_table$Gene)
      setcolorder(my_table, c(COL_DE_GENE_NAME, COL_DE_CLUSTER))
      my_table <- my_table %>% mutate_if(is.numeric, signif, 2)
      return(my_table)
    }, escape = FALSE,server = FALSE,extensions = c("Buttons"), options = list(dom = 'Bfrtip',
                   buttons = c('copy', 'csv', 'excel')), rownames= FALSE)
  
    #Set plot height
    gtable_h <- convertHeight(gtable_height(plot$gtable),"inches",valueOnly = TRUE)
    legend_row <- length(unique(groups$group1)) + length(unique(groups$group2))
    legend_row <- legend_row + length(unique(annogenes$Annotation)) + length(unique(annogenes$MarkerCluster)) 
    h <- max(gtable_h, legend_row/2 + 1.5)
    
    plotDEMarker_pdf_height <<- h + 0.5
    plot_height <- h * 70 + 150
     
    output$deMarkerPlot_UI <- renderUI({
      tabBox(
        title = "", width = 12,
        tabPanel("Heatmap", plotOutput("deMarkerPlot1",height = plot_height)),
        tabPanel("Data", DT::dataTableOutput("deMarkerTable"))
      )
    })
  })
})

observeEvent(input$deMarkerPlot_subsetType,{
  group <- input$deMarkerPlot_subsetType
  if (group != "NULL"){
    withProgress(message = "Processing , please wait",{
    updateSelectizeInput(session, "deMarkerPlot.subset", choices = sort(unique(sce[[group]])))
    })
  }
})

output$downloadDEMarkerHeatmap = downloadHandler(
  filename = function() {
      paste0(names(plotDEMarker)[1], ".pdf")
  }, 
  content = function(fname) {
    p <- plotDEMarker[[1]]
    
    stopifnot(!missing(p))
    stopifnot(!missing(fname))
    pdf(fname, width=12,height = plotDEMarker_pdf_height)
    grid::grid.newpage()
    grid::grid.draw(p$gtable)
    dev.off()
  }
)