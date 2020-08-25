tabItem(tabName = "qcTab",
   fluidRow(
       box(
          title = "Histogram", width = 6,
          #downloadButton('downloadPlot','Download Plot'),
          uiOutput("rawDataHisto"),
       ),
       box(
         title = "Violin Plot", width = 6,
         uiOutput("rawDataVlnPlot")
       )
   ),
   fluidRow(
     box(
       title = "Scatter (Raw)", width = 6,
       uiOutput("rawDataScatter")
     ),
     box(
       title = "Scatter (Filtered)", width = 6,
       uiOutput("filteredDataScatter")
     )
   ),
   fixedPanel(
     downloadButton("downloadQC", label = "Download Plots", class = "button-primary", icon = icon("download")),
     right = 15,
     bottom = 15
   )
)

