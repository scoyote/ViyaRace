#install.packages('http://reartifact.unx.sas.com:8081/artifactory/swat-local/r-swat/r-swat-1.0.0-vb007-linux64.tgz', repos=NULL, type='file') 
system('whoami')

library(swat)
library(tidyr)
s <- CAS('localhost', 5570, authfile='~./authinfo')

options(cas.gen.function.sig=TRUE)
#set the default caslib
#cas.sessionProp.setSessOpt(s,caslib='DemoData')

caslib <- unnest(data.frame(cas.table))



files <- unnest(data.frame(cas.table.fileInfo(s)))
files[order(-files[7]),c(4,7)]

tables <- unnest(data.frame(cas.table.tableInfo(s,caslib='DemoData')))
cas.table.loadTable(s,path='gartner.sas7bdat')
tables[,1]

data("iris")
iris_cas <- as.casTable(s,df=iris)



cas.table.caslibInfo(s)
