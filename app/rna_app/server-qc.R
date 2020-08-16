output$rawDataHisto <- renderUI({
  if(is.null(sce_raw))
    return()
  
  plot_output_list <- list(
    tabPanel("Lib Size", renderPlot({
      hist(sce_raw$total/1e6, xlab="Library size(millions)", main="",breaks=50, col="grey80", ylab="No. of cells")
      abline(v="0.7",col="red")
    })),
    tabPanel("Features Count",  renderPlot({
      hist(sce_raw$detected, xlab="No. of expressed genes", main="",breaks=50, col="grey80", ylab="No. of cells")
    })),
    tabPanel("MT %",renderPlot({
      hist(sce_raw$subsets_mito_percent, xlab="MT %", main="",breaks=50, col="grey80", ylab="No. of cells")
      abline(v="20",col="red")
    }))
  )
  
  do.call(tabBox, args = c(width = 12, plot_output_list))
})

#output$downloadPlot <- downloadHandler(
#  filename = function(){"test"},
#  content = function(file){
#    ggsave(file, plot = g, dpi = 600, useDingbats=FALSE, width = 9, height=8)
#  }
#)

output$rawDataVlnPlot <- renderUI({
  if(is.null(sce_raw))
    return()
  
  color <- "Dark2"
  pointSize <- 2
  
  plot_output_list <- list(
    tabPanel("Lib Size", renderPlot({
      plotVln("Experiment","Library Size",sce_raw$Experiment,sce_raw$total,NULL,"log10","Drop",I(qc_reasons@listData[["low_lib_size"]]),"",pointSize,color,"Exp_LibSize")
    })),
    tabPanel("Features Count",  renderPlot({
      plotVln("Experiment","Features",sce_raw$Experiment,sce_raw$detected,NULL,"log10","Drop",I(qc_reasons@listData[["low_n_features"]]),"",pointSize,color,"Exp_Features")
    })),
    tabPanel("MT %",renderPlot({
      plotVln("Experiment","MT %",sce_raw$Experiment,sce_raw$percent.mito,NULL,NULL,"Drop",I(qc_reasons@listData[["high_subsets_mito_percent"]]),"",pointSize,color,"Exp_MtRatio")
    }))
  )
  
  do.call(tabBox, args = c(width = 12, plot_output_list))
})

#output$filteredDataVlnPlot <- renderUI({
#  if(is.null(sce))
#    return()
#  
#  plot_output_list <- list(
#    tabPanel("Lib Size", plt1 <- renderPlot({
#      plotColData(sce, x="Experiment", y="total") + scale_y_log10()
#    })),
#    tabPanel("Features Count",  renderPlot({
#      plotColData(sce, x="Experiment", y="detected") + scale_y_log10()
#    })),
#    tabPanel("MT %",renderPlot({
#      plotColData(sce, x="Experiment", y="percent.mito")
#    }))
#  )
#  
#  do.call(tabBox, args = c(width = 12, plot_output_list))
#})

output$rawDataScatter <- renderUI({
  if(is.null(sce_raw))
    return()
  
  color <- "Dark2"
  pointSize <- 1.75
  
  plot_output_list <- list(
    tabPanel("Feature/Count", plt1 <- renderPlot({
      plotScatter("Library Size","Features",sce_raw$nCount_RNA,sce_raw$nFeature_RNA,"log10",NULL,"Experiment",sce_raw$Experiment,"",pointSize,color,"Raw_Feature_LibSize")
    })),
    tabPanel("MT%/Feature",  renderPlot({
      plotScatter("Features","MT%",sce_raw$nFeature_RNA,sce_raw$percent.mito,NULL,NULL,"Experiment",sce_raw$Experiment,"",pointSize,color,"Raw_MtRatio_Feature")
    })),
    tabPanel("MT%/Count",renderPlot({
      plotScatter("Library Size","MT%",sce_raw$nCount_RNA,sce_raw$percent.mito,"log10",NULL,"Experiment",sce_raw$Experiment,"",pointSize,color,"Raw_MtRatio_LibSize")
    }))
  )
  
  do.call(tabBox, args = c(width = 12, plot_output_list))
})

output$filteredDataScatter <- renderUI({
  if(is.null(sce))
    return()
  
  color <- "Dark2"
  pointSize <- 1.75
  
  plot_output_list <- list(
    tabPanel("Feature/Count", plt1 <- renderPlot({
      plotScatter("Library Size","Features",sce$nCount_RNA,sce$nFeature_RNA,"log10",NULL,"Experiment",sce$Experiment,"",pointSize,color,"FT_Feature_LibSize")
    })),
    tabPanel("MT%/Feature",  renderPlot({
      plotScatter("Features","MT%",sce$nFeature_RNA,sce$percent.mito,NULL,NULL,"Experiment",sce$Experiment,"",pointSize,color,"FT_MtRatio_Feature")
    })),
    tabPanel("MT%/Count",renderPlot({
      plotScatter("Library Size","MT%",sce$nCount_RNA,sce$percent.mito,"log10",NULL,"Experiment",sce$Experiment,"",pointSize,color,"FT_MtRatio_LibSize")
    }))
  )
  
  do.call(tabBox, args = c(width = 12, plot_output_list))
})
