tabItem(tabName = "deMarkerTab",
   fluidRow(
     box(
       width = 12,
       fluidRow(
       #  #column(4, selectInput("deMarkerPlot_geneData","Marker Genes", list("Upregulated" = "up", "Up + Down Regulated" = "up_and_down",
       #  #                                                                     "Downregulated" = "down","Custom" = "custom"))),
       #  column(4, selectInput("deMarkerPlot_geneData","Marker Genes", list("Upregulated" = "up","Custom" = "custom"))), 
       #   
       #  conditionalPanel(condition="input.deMarkerPlot_geneData == 'custom'",
       #                   column(4, selectizeInput('deMarkerPlot.genes', 'Gene Name', choices = NULL, multiple = TRUE, 
       #                                            options = list(openOnFocus = FALSE, maxOptions = 10)), server = TRUE)),
          column(4,selectInput("deMarkerPlot_FilterGeneCount","Filter gene count per cluster", list("Yes","No"))),
          conditionalPanel(condition="input.deMarkerPlot_FilterGeneCount == 'Yes'",
                          column(4, sliderInput("deMarkerPlot.geneCount", "No. of genes per cluster", min = 1, max = 24, value = 15)))
       ),
       fluidRow(
         width = 12,
         column(3,numericInput("deMarkerPlot.pvalue", label = "p Value Less Than", value = 0.05, min = 0, max = 0.05, step = 0.01)),
         #column(3,selectInput("deMarkerPlot.foldChangeSymbol","Fold Change Limit Type", list(">", "<"))), 
         column(3,numericInput("deMarkerPlot.foldChange", label = "Log2 Fold Change Greater Than", value = 0.5, min = 0.5, step = 0.5)),
         column(2, selectInput("deMarkerPlot_subsetType","Subset", append(list("None" = "NULL"), MARKER_SUBSET_OPTIONS))),
         conditionalPanel(condition="input.deMarkerPlot_subsetType != 'NULL'",
                          column(3, selectizeInput("deMarkerPlot.subset","Selected Subset(s)", choices = NULL, multiple = TRUE)))
       ),
       fluidRow(
         width = 12,
         #column(2, selectInput("deMarkerPlot.group1","Group 1", GROUP_BY_OPTIONS)),
         #column(2, selectInput("deMarkerPlot.group2","Group 2", append(list("None" = "NULL"), GROUP_BY_OPTIONS))),
         column(3, selectInput("deMarkerPlot.clusterCell","Cluster cells", list("Euclidean" =  "euclidean", "No" = "FALSE"))),
         #column(3, selectInput("deMarkerPlot.clusterGene","Cluster genes", list("Euclidean" =  "euclidean", "No" = "FALSE"))),
         #column(2, selectInput("deMarkerPlot.orderBy","Order genes by", list("Fold Change" = COL_DE_LOG_FC, "p Value" =  COL_DE_P_VAL))),
         column(2, style = "margin-top: 25px;", actionButton("vizDeMarkerPlot", "Visualize", class = "button button-3d button-block button-pill button-primary"))
       )
     )
   ),
   fluidRow(
       uiOutput("deMarkerPlot_UI")
   ),
   fixedPanel(
     downloadButton("downloadDEMarkerHeatmap", label = "Download Heatmap", class = "button-primary", icon = icon("download")),
     right = 15,
     bottom = 15
   )
)

