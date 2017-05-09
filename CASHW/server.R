library(shiny)
source("include.R")

shinyServer(function(input, output) {

  file_names <- reactive({
    return(list_files(s,input$selected_caslib))
  })
  caslib_names <- reactive({
    return(list_caslibs(s))
  })
  table_names <- reactive({
    tabs <- list_tables(s,input$selected_caslib)[,1]
    return(tabs)
  })
  output$caslib_dropdown <- renderUI({
    selectInput("selected_caslib","Select your choice",choices=as.vector(caslib_names()))
  })
  
  xloadcaslib <- eventReactive(input$loadcaslib,{
    cas.sessionProp.setSessOpt(s,caslib=input$selected_caslib)
  })
  
  output$file_dropdown <- renderUI({
    selectInput("selected_file","Select your choice",choices = as.vector(file_names()))
  })
  
  xloadtable <- eventReactive(input$loaddf,{
    cas.table.loadTable(s,path=input$selected_file)
    paste("Loading",input$selected_file,sep=" ")
  })
  
  output$text <- renderPrint({
    xloadtable()
  })
  
  xrefreshit <- eventReactive(input$refreshit,{
    return(list_tables(s,input$selected_caslib))
  })
   
  output$mytable1 = renderDataTable({
   xrefreshit()
  })
  
  output$table_radio <- renderUI({
    options = as.vector(table_names())
    radioButtons("selected_table", "Table Deletion",options,selected=character(0))
  })

  
})