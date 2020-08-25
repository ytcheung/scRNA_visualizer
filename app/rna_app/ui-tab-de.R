tabItem(tabName = "deTab",
   fluidRow(
     box(
       width = 12,
       fluidRow(
         column(4, selectInput("dePlot_geneData","Gene Data", list("Default" = "default","Upregulated" = "up",
                                                                              "Downregulated" = "down","Custom" = "custom"))),
         conditionalPanel(condition="input.dePlot_geneData == 'custom'",
                          column(4, selectizeInput('dePlot.genes', 'Gene ID/Name', choices = NULL, multiple = TRUE, options = list(create = TRUE)))),
         conditionalPanel(condition="input.dePlot_geneData != 'custom'",
                          column(4, sliderInput("dePlot.geneCount", "Count", min = 2, max = 100, value = 50)))
       ),
       fluidRow(
         width = 12,
         column(3, selectInput("dePlot.group1","Group 1:", GROUP_BY_OPTIONS)),
         column(3, selectInput("dePlot.group2","Group 2:", GROUP_BY_OPTIONS)),
         column(2, selectInput("dePlot.cluster","Cluster", list("Yes" =  "TRUE", "No" = "FALSE"))),
         column(2, selectInput("dePlot.orderBy","Order by", list("Fold Change" = COL_DE_LOG_FC, "p Value" =  COL_DE_P_VAL))),
         column(2, style = "margin-top: 25px;", actionButton("vizDePlot", "Visualize", class = "button button-3d button-block button-pill button-primary"))
       )
     )
   ),
   fluidRow(
       uiOutput("dePlot_UI")
   ),
   fixedPanel(
     downloadButton("downloadDEHeatmap", label = "Download Heatmap", class = "button-primary", icon = icon("download")),
     right = 15,
     bottom = 15
   )
)

