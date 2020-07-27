tabItem(tabName = "qcTab",
   fluidRow(
      uiOutput("rawDataHisto"),
      #uiOutput("filteredDataHisto")
      uiOutput("rawDataVlnPlot"),
      uiOutput("filteredDataVlnPlot"),
      uiOutput("rawDataScatter"),
      uiOutput("filteredDataScatter")
   )
)
