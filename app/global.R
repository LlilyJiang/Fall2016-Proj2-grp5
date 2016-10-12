library(shiny)
library(shinydashboard)
library(leaflet)
library(XML)
library(zipcode)
library(plotly)
library(choroplethr)
library(dplyr)
library(ggplot2)
library(devtools)
#install_github('arilamstein/choroplethrZip@v1.3.0')
library(choroplethrZip)
library(mapproj)
library(stringr)
library(reshape2)
library(NLP)
library(tm) 
library(proxy) 


#Load data
Trees=read.csv("~/Fall 2016/GR5243/Project2/trees_classified.csv",header=T)
HealthData <- read.csv("~/Fall 2016/GR5243/Project2/HealthData.csv",header=T)
zip_data=read.csv("~/Fall 2016/GR5243/Project2/zip_data.csv",header=T)
cat_data=read.csv("~/Fall 2016/GR5243/Project2/cat_data.csv",header=T)
treepath="~/Fall 2016/GR5243/Project2/tree/"
namemap <- list.files(treepath)

#Trees=Trees[sample(dim(Trees)[1],100000),]
#names(Trees)
colnames(HealthData)

#########################################################################################################
#Create dataset used for kmeans
#zip_data=matrix(ncol=15)

#colnames(zip_data)=c("Zipcode","Fair health","Poor health","Harmful Guards",
#                     "Helpful Guards","Sidewalk Damage","rootstone","rootgrate","rootother",
#                     "trunkwire","trnklight","trnkother","brchlight","brchshoe","brchother")

#ziplist=as.numeric(levels(as.factor(Trees$zipcode)))
#for (i in ziplist){
#  temp=Trees[Trees$zipcode==i,]
#  h1=tally(temp[temp$health=="Fair",])
#  h2=tally(temp[temp$health=="Poor",])
#  g1=tally(temp[temp$guards=="Harmful",])
#  g2=tally(temp[temp$guards=="Helpful",])
#  s1=tally(temp[temp$sidewalk=="Damage",])
#  a1=tally(temp[temp$root_stone=="No",])
#  a2=tally(temp[temp$root_grate=="No",])
#  a3=tally(temp[temp$root_other=="No",])
#  a4=tally(temp[temp$trnk_wire=="No",])
#  a5=tally(temp[temp$trnk_light=="No",])
#  a6=tally(temp[temp$trnk_other=="No",])
#  a7=tally(temp[temp$brch_light=="No",])
#  a8=tally(temp[temp$brch_shoe=="No",])
#  a9=tally(temp[temp$brch_other=="No",])
#  b=nrow(temp)
#  temp=as.vector(c(i,h1/b,h2/b,g1/b,g2/b,s1/b,a1/b,a2/b,a3/b,a4/b,a5/b,a6/b,a7/b,a8/b,a9/b))
#  zip_data=rbind(zip_data,temp)
#}
#zip_data=zip_data[2:nrow(zip_data),]
#dim(zip_data)
#head(zip_data)
#write.csv(zip_data,file="~/Fall 2016/GR5243/Project2/zip_data.csv",row.names = F)

#########################################################################################################
#Create dataset used for barplot
#cat_data=matrix(ncol=15)

#colnames(cat_data)=c("category","Fair health","Poor health","Harmful Guards",
#                     "Helpful Guards","Sidewalk Damage","rootstone","rootgrate","rootother",
#                     "trunkwire","trnklight","trnkother","brchlight","brchshoe","brchother")

#catlist=as.character(levels(as.factor(Trees$category)))
#for (i in catlist){
#  temp=Trees[Trees$category==i,]
#  h1=tally(temp[temp$health=="Fair",])
#  h2=tally(temp[temp$health=="Poor",])
#  g1=tally(temp[temp$guards=="Harmful",])
#  g2=tally(temp[temp$guards=="Helpful",])
#  s1=tally(temp[temp$sidewalk=="Damage",])
#  a1=tally(temp[temp$root_stone=="No",])
#  a2=tally(temp[temp$root_grate=="No",])
#  a3=tally(temp[temp$root_other=="No",])
#  a4=tally(temp[temp$trunk_wire=="No",])
#  a5=tally(temp[temp$trnk_light=="No",])
#  a6=tally(temp[temp$trnk_other=="No",])
#  a7=tally(temp[temp$brch_light=="No",])
#  a8=tally(temp[temp$brch_shoe=="No",])
#  a9=tally(temp[temp$brch_other=="No",])
#  b=nrow(temp)
#  temp=as.vector(c(i,h1/b,h2/b,g1/b,g2/b,s1/b,a1/b,a2/b,a3/b,a4/b,a5/b,a6/b,a7/b,a8/b,a9/b))
#  cat_data=rbind(cat_data,temp)
#}
#cat_data=cat_data[2:nrow(cat_data),]

#head(cat_data)
#write.csv(cat_data,file="~/Fall 2016/GR5243/Project2/cat_data.csv",row.names = F)

###########################################################################################################
Types=names(summary(Trees$category))
Variables=c("Harmful Guards","Sidewalk Damage","rootstone","rootgrate","rootother","trunkwire","trnklight","trnkother","brchlight","brchshoe","brchother")

############################################################################################################
#Processing Tree
treedata <- Trees[!(Trees$health == "N.A."), ]
head(treedata)
### factor into integer
treedata$root_stone<-as.integer(treedata$root_stone=='Yes')
treedata$root_grate<-as.integer(treedata$root_grate=='Yes')
treedata$trunk_wire<-as.integer(treedata$trunk_wire=='Yes')
treedata$trnk_light<-as.integer(treedata$trnk_light=='Yes')
treedata$brch_light<-as.integer(treedata$brch_light=='Yes')
treedata$brch_shoe<-as.integer(treedata$brch_shoe=='Yes')
treedata$sidewalk<-as.integer(treedata$sidewalk=='Damage')
treedata$health<-factor(treedata$health, levels = c("Poor","Fair","Good"),labels= c("1","2","3"))
treedata$health<-as.integer(treedata$health)
head(treedata)
TreeProblems<-rbind()
TreeNOProblems<-rbind()

treetable<-table(treedata$root_stone,treedata$health)
treetable<-treetable/rowSums(treetable)
TreeProblems<-rbind(TreeProblems,treetable[2,])
TreeNOProblems<-rbind(TreeNOProblems,treetable[1,])

treetable<-table(treedata$root_grate,treedata$health)
treetable<-treetable/rowSums(treetable)
TreeProblems<-rbind(TreeProblems,treetable[2,])
TreeNOProblems<-rbind(TreeNOProblems,treetable[1,])


treetable<-table(treedata$trunk_wire,treedata$health)
treetable<-treetable/rowSums(treetable)
TreeProblems<-rbind(TreeProblems,treetable[2,])
TreeNOProblems<-rbind(TreeNOProblems,treetable[1,])


treetable<-table(treedata$trnk_light,treedata$health)
treetable<-treetable/rowSums(treetable)
TreeProblems<-rbind(TreeProblems,treetable[2,])
TreeNOProblems<-rbind(TreeNOProblems,treetable[1,])


treetable<-table(treedata$brch_light,treedata$health)
treetable<-treetable/rowSums(treetable)
TreeProblems<-rbind(TreeProblems,treetable[2,])
TreeNOProblems<-rbind(TreeNOProblems,treetable[1,])


treetable<-table(treedata$brch_shoe,treedata$health)
treetable<-treetable/rowSums(treetable)
TreeProblems<-rbind(TreeProblems,treetable[2,])
TreeNOProblems<-rbind(TreeNOProblems,treetable[1,])



treetable<-table(treedata$sidewalk,treedata$health)
treetable<-treetable/rowSums(treetable)
TreeProblems<-rbind(TreeProblems,treetable[2,])
TreeNOProblems<-rbind(TreeNOProblems,treetable[1,])

rownames(TreeProblems)<-c('Root Stone','Root Grate','Trunk Wire',
                          'Trunk Light','Brch Light','Brch Shoe','Sidewalk')
rownames(TreeNOProblems)<-c('Root Stone','Root Grate','Trunk Wire',
                             'Trunk Light','Brch Light','Brch Shoe','Sidewalk')
##### bar plot to compare the health percent of tree in BAD CONDITION between different problem causes ######

rowtree<-rownames(TreeProblems)
colnames(TreeProblems) <- c("Poor","Fair","Good")
top_labels <- c('Poor', 'Fair', 'Good')
#class(rowtree)
#HealthData<-data.frame(rowtree,TreeProblems)
#write.csv(HealthData,file="~/Fall 2016/GR5243/Project2/HealthData.csv",row.names = F)

Problems<-c('Root Stone','Root Grate','Trunk Wire',
            'Trunk Light','Brch Light','Brch Shoe','Sidewalk')
#plot_ly(HealthData, x = X1, y = rowtree, type = 'bar', orientation = 'h', name='Poor',
#        marker = list(color = 'rgba(38, 24, 74, 0.8)',
#                      line = list(color = 'rgb(248, 248, 249)'))) %>%
#  add_trace(x = X2, y=rowtree,type = 'bar',orientation = 'h', name='Fair',marker = list(color = 'rgba(71, 58, 131, 0.8)')) %>%
#  add_trace(x = X3, y=rowtree,type = 'bar',orientation = 'h', name='Good',marker = list(color = 'rgba(190, 192, 213, 1)')) %>%
#  layout(barmode = 'stack',
#         paper_bgcolor = 'rgb(248, 248, 255)', plot_bgcolor = 'rgb(248, 248, 255)',
         #margin = list(l = 120, r = 10, t = 140, b = 80),
#         showlegend = TRUE)  



############################################################################################################


#Load Zip Map Data

data(df_pop_zip)
#head(df_pop_zip)

#km.res<-kmeans(zipdata,3,nstart = 25)
#    fviz_cluster(km.res, data = data.scaled, geom = "point",
#                stand = FALSE, frame.type = "norm")

#aggregate(zipdata,by=list(km.res$cluster),FUN=mean)

#zip_data$kmcluster<-km.res$cluster

