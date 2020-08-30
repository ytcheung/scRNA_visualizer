plotListQC <- list() #For batch download (Note: key = plotname = filename)

output$rawDataHisto <- renderUI({
  if(is.null(sce_raw))
    return()
  
  #Use "<<-" instead of "<-" or "=" for updating global variables
  plotListQC[["Histo_Lib_Size"]] <<- plotHisto("Library size (millions)", sce_raw[[COL_LIBSIZE]], 1e6,"")
  plotListQC[["Histo_Features_Count"]] <<- plotHisto("No. of expressed genes", sce_raw[[COL_FEATURES_COUNT]], 1,"")
  plotListQC[["Histo_MT_Percent"]] <<- plotHisto("MT %", sce_raw[[COL_MT_PERCENT]], 1,"")
  
  plot_output_list <- list(
    tabPanel("Lib Size", renderPlot({
      print(plotListQC$Histo_Lib_Size)
    })),
    tabPanel("Features Count",  renderPlot({
      print(plotListQC$Histo_Features_Count)
    })),
    tabPanel("MT %",renderPlot({
      print(plotListQC$Histo_MT_Percent)
    }))
  )
  
  do.call(tabBox, args = c(width = 12, plot_output_list))
})

output$rawDataVlnPlot <- renderUI({
  if(is.null(sce_raw))
    return()
  
  color <- "Dark2"
  pointSize <- 2
  if (COLOR_DISCARDED){
    colorLibsize <- I(qc_reasons[[COL_DISCARD_LIBSIZE]])
    colorFeaturesCount <- I(qc_reasons[[COL_DISCARD_FEATURES_COUNT]])
    colorMTPercent <- I(qc_reasons[[COL_DISCARD_MT_PERCENT]])
  } else {
    colorLibsize <- NULL
    colorFeaturesCount <- NULL
    colorMTPercent <- NULL
  }
  
  plotListQC[["Vln_Lib_Size"]] <<- 
    plotVln(LABEL_BATCH,"Library Size",sce_raw[[COL_BATCH]],sce_raw[[COL_LIBSIZE]],NULL,"log10","Filtered",colorLibsize,"",pointSize,color)
  plotListQC[["Vln_Features_Count"]] <<-
    plotVln(LABEL_BATCH,"Features",sce_raw[[COL_BATCH]],sce_raw[[COL_FEATURES_COUNT]],NULL,"log10","Filtered",colorFeaturesCount,"",pointSize,color)
  plotListQC[["Vln_MT_Percent"]] <<-
    plotVln(LABEL_BATCH,"MT %",sce_raw[[COL_BATCH]],sce_raw[[COL_MT_PERCENT]],NULL,NULL,"Filtered",colorMTPercent,"",pointSize,color)
    
  plot_output_list <- list(
    tabPanel("Lib Size", renderPlot({
      print(plotListQC$Vln_Lib_Size)
    })),
    tabPanel("Features Count",  renderPlot({
      print(plotListQC$Vln_Features_Count)
    })),
    tabPanel("MT %",renderPlot({
      print(plotListQC$Vln_MT_Percent)
    }))
  )
  
  do.call(tabBox, args = c(width = 12, plot_output_list))
})

output$rawDataScatter <- renderUI({
  if(is.null(sce_raw))
    return()
  
  color <- "Dark2"
  pointSize <- 1.75
  
  plotListQC[["Scatter_Raw_Feature_LibSize"]] <<-
    plotScatter("Library Size","Features",sce_raw[[COL_LIBSIZE]],sce_raw[[COL_FEATURES_COUNT]],"log10",NULL,LABEL_BATCH,sce_raw[[COL_BATCH]],"",pointSize,color)
  plotListQC[["Scatter_Raw_MT_Feature"]] <<-
    plotScatter("Features","MT%",sce_raw[[COL_FEATURES_COUNT]],sce_raw[[COL_MT_PERCENT]],NULL,NULL,LABEL_BATCH,sce_raw[[COL_BATCH]],"",pointSize,color)
  plotListQC[["Scatter_Raw_MT_LibSize"]] <<-
    plotScatter("Library Size","MT%",sce_raw[[COL_LIBSIZE]],sce_raw[[COL_MT_PERCENT]],"log10",NULL,LABEL_BATCH,sce_raw[[COL_BATCH]],"",pointSize,color)
  
  plot_output_list <- list(
    tabPanel("Feature/Count", plt1 <- renderPlot({
      print(plotListQC$Scatter_Raw_Feature_LibSize)
    })),
    tabPanel("MT%/Feature",  renderPlot({
      print(plotListQC$Scatter_Raw_MT_Feature)
    })),
    tabPanel("MT%/Count",renderPlot({
      print(plotListQC$Scatter_Raw_MT_LibSize)
    }))
  )
  
  do.call(tabBox, args = c(width = 12, plot_output_list))
})

output$filteredDataScatter <- renderUI({
  if(is.null(sce))
    return()
  
  color <- "Dark2"
  pointSize <- 1.75
  
  plotListQC[["Scatter_Feature_LibSize"]] <<-
    plotScatter("Library Size","Features",sce[[COL_LIBSIZE]],sce[[COL_FEATURES_COUNT]],"log10",NULL,LABEL_BATCH,sce[[COL_BATCH]],"",pointSize,color)
  plotListQC[["Scatter_MT_Feature"]] <<-
    plotScatter("Features","MT%",sce[[COL_FEATURES_COUNT]],sce[[COL_MT_PERCENT]],NULL,NULL,LABEL_BATCH,sce[[COL_BATCH]],"",pointSize,color)
  plotListQC[["Scatter_MT_LibSize"]] <<-
    plotScatter("Library Size","MT%",sce[[COL_LIBSIZE]],sce[[COL_MT_PERCENT]],"log10",NULL,LABEL_BATCH,sce[[COL_BATCH]],"",pointSize,color)
  
  
  plot_output_list <- list(
    tabPanel("Feature/Count", plt1 <- renderPlot({
      print(plotListQC$Scatter_Feature_LibSize)
    })),
    tabPanel("MT%/Feature",  renderPlot({
      print(plotListQC$Scatter_MT_Feature)
    })),
    tabPanel("MT%/Count",renderPlot({
      print(plotListQC$Scatter_MT_LibSize)
    }))
  )
  
  do.call(tabBox, args = c(width = 12, plot_output_list))
})


output$downloadQC = downloadHandler(
    filename = function() {
      'QC_Plots.zip'
    }, 
    content = function(fname) {
      fs <- c()
      setwd(tempdir())
      
      foreach(key=names(plotListQC), val=plotListQC, .packages = c("foreach")) %do% {
        path <- paste0(key, ".pdf")
        fs <- c(fs, path)
        ggsave(plot = val, dpi = 600, filename = path, useDingbats=FALSE, width=8, height=6)
      }
      
      zip::zipr(zipfile=fname, files=fs)
    },
    contentType = "application/zip"
)

