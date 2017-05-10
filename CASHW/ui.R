
shinyUI(fluidPage(
  headerPanel('Examples of DataTables'),
  sidebarPanel(
    uiOutput("caslib_radio"),
    uiOutput("file_dropdown"),
    actionButton("loaddf", "Load"),
    verbatimTextOutput("text")
  ),
  mainPanel(
    actionButton("rx","rx"),
    fluidRow(
      column(12, DT::dataTableOutput('x1'))
    ),
    verbatimTextOutput("logdata"),
    actionButton("unloadit","Unload"),
    actionButton("promoteit","Promote"),
  verbatimTextOutput("text2"),
  verbatimTextOutput("text3")
  )
)
)
