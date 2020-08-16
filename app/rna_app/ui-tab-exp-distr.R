tabItem(tabName = "expDistrTab",
   fluidRow(
     box(
       width = 12,
       column(2, selectInput("expDistrPlot.id","Plot:", list("Plot 1" = "expDistrPlot1", "Plot 2" = "expDistrPlot2"))),
       column(4, selectizeInput('expDistrPlot.genes', 'Genes ID/Name', choices = NULL, multiple = TRUE, options = list(create = TRUE))),
       column(2, selectInput("expDistrPlot.groupBy","Group by:", GROUP_BY_OPTIONS)),
       column(2, selectInput("expDistrPlot.colourBy","Colour by:", append(list("None" = "NULL"), GROUP_BY_OPTIONS))),
       column(2, style = "margin-top: 25px;", actionButton("vizExpDistrPlot", "Visualize", class = "button button-3d button-block button-pill button-primary"))
     )
   ),
   fluidRow(
       box(
          title = "Plot 1", width = 6,
          uiOutput("expDistrPlot1")
       ),
       box(
         title = "Plot 2", width = 6,
         uiOutput("expDistrPlot2")
       )
   )
)

