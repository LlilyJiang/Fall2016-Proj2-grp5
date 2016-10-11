library(shiny)
library(shinydashboard)
library(leaflet)
library(XML)
library(zipcode)
library(dplyr)
library(plotly)


#Load data
Trees=read.csv("trees_classified.csv",header=T)
names(Trees)


#Create dataset used for kmeans
zip_data=matrix(ncol=15)
levels(as.factor(Trees$brch_light))
colnames(zip_data)=c("Zipcode","Fair health","Poor health","Harmful Guards",
                     "Helpful Guards","Sidewalk Damage","rootstone","rootgrate","rootother",
                     "trunkwire","trnklight","trnkother","brchlight","brchshoe","brchother")
ziplist=as.numeric(levels(as.factor(Trees$zipcode)))
for (i in ziplist){
  temp=Trees[Trees$zipcode==i,]
  h1=tally(temp[temp$health=="Fair",])
  h2=tally(temp[temp$health=="Poor",])
  g1=tally(temp[temp$guards=="Harmful",])
  g2=tally(temp[temp$guards=="Helpful",])
  s1=tally(temp[temp$sidewalk=="Damage",])
  a1=tally(temp[temp$root_stone=="No",])
  a2=tally(temp[temp$root_grate=="No",])
  a3=tally(temp[temp$root_other=="No",])
  a4=tally(temp[temp$trnk_wire=="No",])
  a5=tally(temp[temp$trnk_light=="No",])
  a6=tally(temp[temp$trnk_other=="No",])
  a7=tally(temp[temp$brch_light=="No",])
  a8=tally(temp[temp$brch_shoe=="No",])
  a9=tally(temp[temp$brch_other=="No",])
  b=nrow(temp)
  temp=as.vector(c(i,h1/b,h2/b,g1/b,g2/b,s1/b,a1/b,a2/b,a3/b,a4/b,a5/b,a6/b,a7/b,a8/b,a9/b))
  zip_data=rbind(zip_data,temp)
}
zip_data=zip_data[2:nrow(zip_data),]

zip_data<-data.frame(zip_data)

zipdata<-zip_data[,2:13]
zipdata<-data.frame(zipdata)
zipdata[,1:12] <- sapply(zipdata[, 1:12], as.numeric)
set.seed(123)


Types=names(summary(Trees$genus))
Variables=c("Harmful Guards","Sidewalk Damage","rootstone","rootgrate","rootother","trunkwire","trnklight","trnkother","brchlight","brchshoe","brchother")


#Processing Tree
treedata <- Trees[!(Trees$health == "N.A."), ]

### factor into integer
treedata$root_stone<-as.integer(treedata$root_stone=='Yes')
treedata$root_grate<-as.integer(treedata$root_grate=='Yes')
treedata$trunk_wire<-as.integer(treedata$trunk_wire=='Yes')
treedata$trnk_light<-as.integer(treedata$trnk_light=='Yes')
treedata$brch_light<-as.integer(treedata$brch_light=='Yes')
treedata$brch_shoe<-as.integer(treedata$brch_shoe=='Yes')
treedata$sidewalk<-as.integer(treedata$sidewalk=='Damage')
#treedata$guards<-factor(treedata$guards, levels = c("Unsure","Harmful","None","Helpful"),labels= c("1","2","3","4"))
#treedata$guards<-as.integer(treedata$guards)
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

rownames(TreeProblems)<-c('root_stone','root_grate','trnk_wire',
                          'trnk_light','brch_light','brch_shoe','sidewalk')
rownames(TreeNOProblems)<-c('root_stone','root_grate','trnk_wire',
                            'trnk_light','brch_light','brch_shoe','sidewalk')

##### bar plot to compare the health percent of tree in BAD CONDITION between different problem causes ######

rowtree<-rownames(TreeProblems)
top_labels <- c('Poor', 'Fair', 'Good')

HealthData<-data.frame(rowtree,TreeProblems)
#rownames(HealthData)=c("rowtree","X1","X2","X3")



##### bar plot to compare the health status with or without a single cause

#ProblemPresence<-c('Yes', 'No')
#Poor<-rbind(TreeProblems[1,1],TreeNOProblems[1,1])
#Fair<-rbind(TreeProblems[1,2],TreeNOProblems[1,2])
#Good<-rbind(TreeProblems[1,3],TreeNOProblems[1,3])
#HealthData2<-data.frame()
#HealthData2<-data.frame(ProblemPresence,Poor,Fair,Good)


#plot_ly(HealthData2, x=ProblemPresence, y = Poor, type = 'bar', name = 'Poor') %>%
#  add_trace(x=ProblemPresence,y = Fair, type = 'bar',name = 'Fair') %>%
#  add_trace(x=ProblemPresence,y = Good, type = 'bar',name = 'Good') %>%
#  layout(yaxis = list(title = 'Percent'),xaxis = list(title = 'Precense of Problem'), barmode = 'stack')
