library(shiny)
library(swat)



shinyServer(function(input, output) {

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

  writeDTx <- function(sess,caslb,colx=c(1,8,11,12,16,17)){
    tryCatch({
      tables <- unnest(data.frame(cas.table.tableInfo(s,caslib=input$selected_caslib)))
      names(tables) <- sub("TableInfo.", "", names(tables))
      output$x1 <-DT::renderDataTable(tables[,colx], server = FALSE)
    },
    error = function(err){ return(NULL)}
    )
  }
  writeFLx <- function(sess,caslb,colx=c(4,6,7)){
    tryCatch({
      files <- unnest(data.frame(cas.table.fileInfo(s,caslib=input$selected_caslib)))
      output$f1 <-DT::renderDataTable(files[,colx], server = FALSE)
    },
    error = function(err){ return(NULL)}
    )
  }
  
#  xconnectit <- eventReactive(input$connectit,{
#    tryCatch({
#      return(CAS('localhost', 5570, authfile='~./authinfo',session=input$sessionid))
#    },
#    error = function(err){ return("error")}
#    )
#  })
  
  output$sessionText <- renderPrint({print(paste("Session:",s$session,sep=""),row.names = FALSE)})
  output$userText <- renderPrint({print(paste("Username:",s$username,sep=""),row.names = FALSE)})
  
  
# Populate the  active CASLIBs
  output$caslib_radio <- renderUI({
    available_caslibs = as.vector(caslib_names())
    radioButtons("selected_caslib", "Available CASLIBs",available_caslibs,selected="DemoData")

  })
  
  observeEvent(input$selected_caslib ,{
    cas.sessionProp.setSessOpt(s,caslib=input$selected_caslib)
    writeDTx(s,input$selected_caslib)
    writeFLx(s,input$selected_caslib)
  })
 
  output$file_dropdown <- renderUI({
    selectInput("selected_file","Select your choice",choices = as.vector(file_names()))
  })
  
  xloadtable <- eventReactive(input$loaddf,{
    #log <- capture.output(cas.table.loadTable(s,path=input$selected_file),type="message")
    #paste(log,sep=" ")
    cas.table.loadTable(s,path=input$selected_file,caslib=input$selected_caslib)
    
    writeDTx(s,input$selected_caslib)
  })
  
  output$text <- renderPrint({
    xloadtable()
  })
  
  observeEvent(input$multiload,{
    clib <- input$selected_caslib
    fn <- unnest(data.frame(cas.table.fileInfo(s,caslib=clib)))
    for(fname in fn[input$f1_rows_selected,4]){
      cas.table.loadTable(s,path=fname,caslib=clib) 
    }
    writeDTx(s,input$selected_caslib)
  })  
  
  observeEvent(input$unloadit,{
    clib <- input$selected_caslib
    tn <- unnest(data.frame(cas.table.tableInfo(s,caslib=clib)))
    for(tname in tn[input$x1_rows_selected,1]){
      cas.table.dropTable(s,name=tname) 
    }
    print(paste("Unloading ",tn[input$x1_rows_selected,1],sep=""))
   
    writeDTx(s,input$selected_caslib)
   })  

  
  observeEvent(input$promoteit,{
    clib <- input$selected_caslib
    tn <- unnest(data.frame(cas.table.tableInfo(s,caslib=clib)))
    for(tname in tn[input$x1_rows_selected,1]){
      cas.table.promote(s,name=tname,caslib=clib) 
    }
    print(paste("Promoting ",tn[input$x1_rows_selected,1],sep=""))
    writeDTx(s,input$selected_caslib)
  }) 

})