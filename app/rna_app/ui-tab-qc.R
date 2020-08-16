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
       )#,
       #box(
       #  title = "VlnPLot (Filtered)", width = 4,
       #  uiOutput("filteredDataVlnPlot")
       #)
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
   )
)

