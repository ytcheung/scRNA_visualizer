tabItem(tabName = "deTab",
   fluidRow(
     box(
       width = 12,
       fluidRow(
         column(4, selectInput("dePlot_geneData","Marker Genes", list("Upregulated" = "up", "Up + Down Regulated" = "up_and_down",
                                                                              "Downregulated" = "down","Custom" = "custom"))),
         conditionalPanel(condition="input.dePlot_geneData == 'custom'",
                          column(4, selectizeInput('dePlot.genes', 'Gene ID/Name', choices = NULL, multiple = TRUE, 
                                                   options = list(openOnFocus = FALSE, maxOptions = 10)), server = TRUE)),
         conditionalPanel(condition="input.dePlot_geneData != 'custom'",
                          column(4, sliderInput("dePlot.geneCount", "No. of gene per cluster", min = 1, max = 30, value = 15)),
                          column(4, selectInput("dePlot.cluster","Cluster", list("All"))))
       ),
       fluidRow(
         width = 12,
         column(2, selectInput("dePlot.group1","Group 1:", GROUP_BY_OPTIONS)),
         column(2, selectInput("dePlot.group2","Group 2:", append(list("None" = "NULL"), GROUP_BY_OPTIONS))),
         column(2, selectInput("dePlot.clusterCell","Cluster cells", list("Correlation" =  "correlation", "Euclidean" =  "euclidean", "No" = "FALSE"))),
         column(2, selectInput("dePlot.clusterGene","Cluster genes", list("Correlation" =  "correlation", "Euclidean" =  "euclidean", "No" = "FALSE"))),
         column(2, selectInput("dePlot.orderBy","Order genes by", list("Fold Change" = COL_DE_LOG_FC, "p Value" =  COL_DE_P_VAL))),
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

