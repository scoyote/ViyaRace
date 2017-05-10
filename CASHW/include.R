library(swat)
library(tidyr)


#files <- reactiveValues()
#list_files <- function(sessionID,caslibID){
#  files <- tryCatch({
#    return(unnest(data.frame(cas.table.fileInfo(sessionID,caslib=caslibID))))
#  },
#  error = function(err){return(NULL)}
#  )
#  return(files[,4])
#}

tables <- reactiveValues()
list_tables <- function(sessionID,caslibID) {
  tables <- tryCatch({
    tb <- unnest(data.frame(cas.table.tableInfo(sessionID,caslib=caslibID)))
    names(tb) <- sub("TableInfo.", "", names(tb))
    return(tb)
  },
  error = function(err){ return(NULL)}
  )
  print(tables)
  return(tables)
}

caslibs <- reactiveValues()
list_caslibs <- function(sessionID) {
  caslibs <- data.frame(cas.table.caslibInfo(sessionID))
  return(caslibs[,1])
}
