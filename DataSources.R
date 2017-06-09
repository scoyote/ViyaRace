#install.packages('http://reartifact.unx.sas.com:8081/artifactory/swat-local/r-swat/r-swat-1.0.0-vb007-linux64.tgz', repos=NULL, type='file') 
system('whoami')

library(swat)
library(tidyr)

# Connect to CAS, start a session
s <- CAS('localhost', 5570, authfile='~./authinfo')

#set the default caslib
cas.sessionProp.setSessOpt(s,caslib='DemoData')

#enable code completion
options(cas.gen.function.sig=TRUE)

# take a look at the file system under the CAS in memory space
files <- unnest(data.frame(cas.table.fileInfo(s)))

#list them according to size
files[order(-files[7]),c(4,7)]

#Load a file from remote filesystem to cas
cas.table.loadTable(s,path='gartner.sas7bdat',caslib="DemoData")

tables <- unnest(data.frame(cas.table.tableInfo(s,caslib='DemoData')))
tables[,1]

#load a table from R to CAS in memory space
data("iris")
iris_cas <- as.casTable(s,df=iris)

# Use basic R functions on CAS table
min(iris_cas$Sepal.Length)

max(iris_cas$Sepal.Length)

cas.mean(iris_cas)

# Call CAS actions on the table
out <- cas.simple.summary(iris_cas)
out




