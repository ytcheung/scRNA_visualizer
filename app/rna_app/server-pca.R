# plotPCA <- function(){
#   color <- "Dark2"
#   pointSize <- 1.75
#   
#   dim1 <- input$plot.dims[1]
#   dim2 <-  tail(input$plot.dims, n=1)
#   groups <- sce[[input$plot.group]]
#   
#   plotType <- input$plot.type
#   plotData <- reducedDim.results[[plotType]]
#   
#   plotPCA <- plotScatter(paste0(plotType," ",dim1),paste0(plotType," ",dim2),
#                                           plotData[,dim1],plotData[,dim2],NULL,NULL,input$plot.group,groups,"",pointSize,color)
# }

plotListReduced <- list()

observeEvent(input$vizPlot,{
  withProgress(message = "Processing , please wait",{
    color <- "Dark2"
    pointSize <- 1.75
    
    dim1 <- input$plot.dims[1]
    dim2 <-  tail(input$plot.dims, n=1)
    groups <- sce[[input$plot.group]]
    
    plotType <- input$plot.type
    plotData <- reducedDim.results[[plotType]]
    plotName <- paste0(plotType,dim1,dim2,"_",input$plot.group)
    
    temp <- list()
    temp[[plotName]] <- plotScatter(paste0(plotType," ",dim1),paste0(plotType," ",dim2),
                                  plotData[,dim1],plotData[,dim2],NULL,NULL,input$plot.group,groups,"",pointSize,color)
    
    plotListReduced[[input$plot.id]] <<- temp
  
    output[[input$plot.id]] <- renderPlot({
      print(temp[[1]])
    })
  })
})

observeEvent(input$plot.type,{
    updateSliderInput(session, "plot.dims", label = "Dimension",  min = 1, max = min(ncol(reducedDim(sce,input$plot.type)),4))
})

output$downloadReduced = downloadHandler(
  filename = function() {
    if (length(plotListReduced) > 1) 
      'Reduced_Plots.zip'
    else
      paste0(names(plotListReduced[[1]])[1], ".pdf")
  }, 
  content = function(fname) {
    if (length(plotListReduced) > 1) {
      fs <- c()
      setwd(tempdir())
      
      foreach(key=names(plotListReduced), val=plotListReduced, .packages = c("foreach")) %do% {
        path <- paste0(names(val)[1], ".pdf")
        fs <- c(fs, path)
        ggsave(plot = val[[1]], dpi = 600, filename = path, useDingbats=FALSE, width=8, height=6)
      }
      
      zip::zipr(zipfile=fname, files=fs)
    } else {
      ggsave(filename = fname, plot = plotListReduced[[1]][[1]], dpi = 600, useDingbats=FALSE, width=8, height=6)
    }
  }
)
