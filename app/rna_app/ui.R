require(shinydashboard)
require(shinyjs)
require(shiny)
require(V8)

require(Seurat)
require(scater)

ui <- tagList(
    dashboardPage(
        skin = "purple",
        dashboardHeader(title = "scRNA-seq Visualizer"),
        dashboardSidebar(
            sidebarMenu(
                id = "tabs",
                menuItem("Quality Control", tabName = "qcTab", icon = icon("filter")),
                menuItem("Dimension Reduction", tabName = "pcaPlotsTab", icon = icon("codepen"))
            )
        ),
        dashboardBody(
            shinyjs::useShinyjs(),
            extendShinyjs(script = "www/custom.js"),
            tags$head(
                tags$style(HTML(
                    " .shiny-output-error-validation {color: darkred; }
                      
                      .skin-purple .main-header .logo {
                          background-color: #870052;
                      }
                      
                      /* logo when hovered */
                      .skin-purple .main-header .logo:hover {
                          background-color: #D40963;
                      }
                    
                      /* navbar (rest of the header) */
                      .skin-purple .main-header .navbar {
                        background-color: #870052;
                      }
                      /* toggle button when hovered  */                    
                      .skin-purple .main-header .navbar .sidebar-toggle:hover{
                          background-color: #D40963;
                      }
                    "
                )),
                tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
                tags$link(rel = "stylesheet", type = "text/css", href = "buttons.css")
            ),
            tabItems(
                source("ui-tab-qc.R", local = TRUE)$value
            )
        )
    ),
    tags$footer(
    #    wellPanel(
    #        HTML(
    #            '
    #  <p align="center" width="4">Core Bioinformatics, Center for Genomics and Systems Biology, NYU Abu Dhabi</p>
    #  <p align="center" width="4">Github: <a href="https://github.com/nasqar/SeuratV3Wizard/">https://github.com/nasqar/SeuratV3Wizard/</a></p>
    # <p align="center" width="4">Created by: <a href="mailto:ay21@nyu.edu">Ayman Yousif</a> </p>
    #  <p align="center" width="4">Using Seurat version 3.1.0 </p>'
    #        )
    #    ),
        tags$script(src = "imgModal.js")
    )
)
