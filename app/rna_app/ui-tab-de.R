tabItem(tabName = "deTab",
   fluidRow(
     box(
       width = 12,
       column(4, selectizeInput('dePlot.genes', 'Marker Genes ID/Name', choices = MARKERS, multiple = TRUE, options = list(create = TRUE), selected = MARKERS)),
       column(2, selectInput("dePlot.group1","Group 1:", GROUP_BY_OPTIONS)),
       column(2, selectInput("dePlot.group2","Group 2:", GROUP_BY_OPTIONS)),
       column(2, style = "margin-top: 25px;", actionButton("vizDePlot", "Visualize", class = "button button-3d button-block button-pill button-primary"))
     )
   ),
   fluidRow(
       box(
          title = "", width = 12,
          plotOutput("dePlot1")
       )
   )
)

