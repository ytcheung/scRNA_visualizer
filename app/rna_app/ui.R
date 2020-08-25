require(shinydashboard)
require(shinyjs)
require(shiny)
require(V8)
require(DT)

#require(Seurat)
#require(scater)

ui <- tagList(
    dashboardPage(
        skin = "purple",
        dashboardHeader(title = "scRNA-seq Visualizer"),
        dashboardSidebar(
            sidebarMenu(
                id = "tabs",
                menuItem("Quality Control", tabName = "qcTab", icon = icon("filter")),
                menuItem("Dimension Reduction", tabName = "pcaTab", icon = icon("codepen")),
                menuItem("Feature Plots", tabName = "geneExpTab", icon = icon("braille")),
                menuItem("Expression Distribution", tabName = "expDistrTab", icon = icon("signal")),
                menuItem("DE Analysis", tabName = "deTab", icon = icon("th"))
            )
        ),
        dashboardBody(
            shinyjs::useShinyjs(),
            extendShinyjs(script = "www/custom.js"),
            tags$head(
                tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
                tags$link(rel = "stylesheet", type = "text/css", href = "buttons.css")
            ),
            tabItems(
                source("ui-tab-qc.R", local = TRUE)$value,
                source("ui-tab-pca.R", local = TRUE)$value,
                source("ui-tab-gene-exp.R", local = TRUE)$value,
                source("ui-tab-exp-distr.R", local = TRUE)$value,
                source("ui-tab-de.R", local = TRUE)$value
            )
        )
    ),
    tags$footer(
        HTML(
          '<p align="center" style="margin:10px">Ming Wai Lau Centre for Reparative Medicine, Karolinska Institute</p>'
        )
        ,
        tags$script(src = "imgModal.js")
    )
)
