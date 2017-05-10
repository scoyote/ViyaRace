
#source("include.R")

shinyServer(function(input, output) {

  tabs <- NULL

  file_names <- reactive({
    files <- tryCatch({
      return(unnest(data.frame(cas.table.fileInfo(s,caslib=input$selected_caslib)))[,4])
    },
    error = function(err){return(NULL)}
    )
  })
  caslib_names <- reactive({
    return(data.frame(cas.table.caslibInfo(s))[,1])
  })
  
  table_names <- reactive({
    tryCatch({
      tables <- unnest(data.frame(cas.table.tableInfo(s,caslib=input$selected_caslib)))
      names(tables) <- sub("TableInfo.", "", names(tables))
      return(tables)
    },
    error = function(err){ return(NULL)}
    )
  })
  
  reftab <- reactive({
    output$x1 <- DT::renderDataTable({tryCatch({
      tables <- unnest(data.frame(cas.table.tableInfo(s,caslib=input$selected_caslib)))
      names(tables) <- sub("TableInfo.", "", names(tables))
      return(tables)
    },
    error = function(err){ return(NULL)}
    )
    }, server = FALSE)
  })

  
  
  
# Populate the  active CASLIBs
  output$caslib_radio <- renderUI({
    available_caslibs = as.vector(caslib_names())
    radioButtons("selected_caslib", "Available CASLIBs",available_caslibs,selected="DemoData")
  })
  
  observeEvent(input$selected_caslib ,{
    cas.sessionProp.setSessOpt(s,caslib=input$selected_caslib)
    output$x1 <- DT::renderDataTable(table_names(), server = FALSE)
  })
 
  output$file_dropdown <- renderUI({
    selectInput("selected_file","Select your choice",choices = as.vector(file_names()))
  })
  
  
  

  
  xloadtable <- eventReactive(input$loaddf,{
    #log <- capture.output(cas.table.loadTable(s,path=input$selected_file),type="message")
    #paste(log,sep=" ")
    cas.table.loadTable(s,path=input$selected_file,caslib=input$selected_caslib)
    tabs <- unnest(data.frame(cas.table.tableInfo(s,caslib=input$selected_caslib)))
    output$x1 <- DT::renderDataTable(tabs, server = FALSE)
  })
  
  output$text <- renderPrint({
    xloadtable()
  })
  
  
  xdroptable <- eventReactive(input$unloadit,{
    clib <- input$selected_caslib
    tn <- unnest(data.frame(cas.table.tableInfo(s,caslib=clib)))
    for(tname in tn[input$x1_rows_selected,1]){
      cas.table.dropTable(s,name=tname)
    }
   print(paste("Unloading ",tn[input$x1_rows_selected,1],sep=""))    
   
   tabs <- unnest(data.frame(cas.table.tableInfo(s,caslib=clib)))
   output$x1 <- DT::renderDataTable(tabs, server = FALSE)
   })  
  
  output$text2 <- renderPrint({
    xdroptable()
  })
})