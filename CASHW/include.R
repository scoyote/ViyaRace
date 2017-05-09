cas.sessionProp.setSessOpt(s,caslib="DemoData")

files <- reactiveValues()
list_files <- function(sessionID,caslibID){
  files <- unnest(data.frame(cas.table.fileInfo(sessionID,caslib=caslibID)))
  return(files[,4])
}

tables <- reactiveValues()
list_tables <- function(sessionID,caslibID) {
  tables <- unnest(data.frame(cas.table.tableInfo(sessionID,caslib=caslibID)))
  names(tables) <- sub("TableInfo.", "", names(tables))
  return(tables)
}

caslibs <- reactiveValues()
list_caslibs <- function(sessionID) {
  caslibs <- data.frame(cas.table.caslibInfo(sessionID))
  return(caslibs[,1])
}
