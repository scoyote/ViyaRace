library(shiny)
library(ggplot2)  # for the diamonds dataset
source("include.R")

shinyUI(fluidPage(
  headerPanel('Examples of DataTables'),
  sidebarPanel(
    uiOutput("caslib_dropdown"),
    actionButton("loadcaslib","Load CASLIB"),
    
    uiOutput("file_dropdown"),
    actionButton("loaddf", "Load"),
    verbatimTextOutput("text")
  ),
  mainPanel(
    actionButton("refreshit","Refresh"),
  #  dataTableOutput("mytable1"),
    fluidRow(
      column(12, DT::dataTableOutput('x1'))
    )
    #uiOutput("table_radio")
    ,actionButton("unloadit","Unload"),
  verbatimTextOutput("text2")
  )
)
)
