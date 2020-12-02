tabItem(tabName = "geneExpTab",
   fluidRow(
     box(
       width = 12, title="Plot 1",
       column(2, selectInput("geneExpPlot1.type","Type:", DIM_TYPES)),
       column(2, selectInput("geneExpPlot1.group","Group By:", GROUP_BY_OPTIONS)),
       #column(2, sliderInput("geneExpPlot1.dims", label = "Dimension",  min = 1, max = 4, value = c(1, 2))),
       column(2, style = "margin-top: 25px;", actionButton("vizGeneExpPlot1", "Visualize", class = "button button-3d button-block button-pill button-primary"))
     )
   ),
   fluidRow(
     box(
       width = 12, title="Plot 2",
       column(2, selectizeInput('geneExpPlot2.genes', 'Gene Name', choices = NULL, multiple = TRUE, options = list(openOnFocus = FALSE, maxOptions = 10)), server = TRUE),
       column(2, selectInput("geneExpPlot2.group","Group By:", append(list("None" = "NULL"), GROUP_BY_OPTIONS))),
       #column(2, selectInput("geneExpPlot2.type","Type:", DIM_TYPES)),
       #column(2, sliderInput("geneExpPlot2.dims", label = "Dimension",  min = 1, max = 4, value = c(1, 2))),
       column(2, style = "margin-top: 25px;", actionButton("vizGeneExpPlot2", "Visualize", class = "button button-3d button-block button-pill button-primary"))
     )
   ),
   fluidRow(
       box(
          title = "Plot 1", width = 6,
          plotOutput("geneExpPlot1",brush = brushOpts(
            id = "geneExpPlot1_brush",
            resetOnNew = TRUE
          ))
       ),
       uiOutput("geneExpPlot2")
   ),
   fixedPanel(
     downloadButton("downloadFeaturePlots", label = "Download Plots", class = "button-primary", icon = icon("download")),
     right = 15,
     bottom = 15
   )
)

