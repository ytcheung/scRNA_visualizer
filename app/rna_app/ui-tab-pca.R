tabItem(tabName = "pcaTab",
   fluidRow(
     box(
       width = 12,
       column(2, selectInput("plot.id","Plot:", list("Plot 1" = "pcaPlot1", "Plot 2" = "pcaPlot2", "Plot 3" = "pcaPlot3", "Plot 4" = "pcaPlot4"))),
       column(2, selectInput("plot.type","Type:", DIM_TYPES)),
       column(2, selectInput("plot.group","Group By:", GROUP_BY_OPTIONS)),
       column(2, sliderInput("plot.dims", label = "Dimension",  min = 1, max = 4, value = c(1, 2))),
       column(2, style = "margin-top: 25px;", actionButton("vizPlot", "Visualize", class = "button button-3d button-block button-pill button-primary"))
     )
   ),
   fluidRow(
       box(
          title = "Plot 1", width = 6,
          plotOutput("pcaPlot1")
       ),
       box(
         title = "Plot 2", width = 6,
         plotOutput("pcaPlot2")
       )
   ),
   fluidRow(
     box(
       title = "Plot 3", width = 6,
       plotOutput("pcaPlot3")
     ),
     box(
       
       title = "Plot 4", width = 6,
       plotOutput("pcaPlot4")
     )
   )
)

