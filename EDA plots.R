
#### Processing
treedata <- treedata[!(treedata$health == ""), ]

### factor into integer
treedata$root_stone<-as.integer(treedata$root_stone=='Yes')
treedata$root_grate<-as.integer(treedata$root_grate=='Yes')
treedata$trunk_wire<-as.integer(treedata$trunk_wire=='Yes')
treedata$trnk_light<-as.integer(treedata$trnk_light=='Yes')
treedata$brch_light<-as.integer(treedata$brch_light=='Yes')
treedata$brch_shoe<-as.integer(treedata$brch_shoe=='Yes')
treedata$sidewalk<-as.integer(treedata$sidewalk=='Damage')
treedata$guards<-factor(treedata$guards, levels = c("Unsure","Harmful","None","Helpful"),labels= c("1","2","3","4"))
treedata$guards<-as.integer(treedata$guards)
treedata$health<-factor(treedata$health, levels = c("Poor","Fair","Good"),labels= c("1","2","3"))
treedata$health<-as.integer(treedata$health)

####
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

rownames(TreeProblems)<-c('root_stone','root_grate','trnk_wire','trnk_light','brch_light','brch_shoe','sidewalk')
rownames(TreeNOProblems)<-c('root_stone','root_grate','trnk_wire','trnk_light','brch_light','brch_shoe','sidewalk')


##### bar plot to compare the health percent of tree in BAD CONDITION between different problem causes ######
library(plotly)

rowtree<-rownames(TreeProblems)
#top_labels <- c('Poor', 'Fair', 'Good')

HealthData<-data.frame(rowtree,TreeProblems)

plot_ly(HealthData, x = X1, y = rowtree, type = 'bar', orientation = 'h', name='Poor',
        marker = list(color = 'rgba(38, 24, 74, 0.8)',
                      line = list(color = 'rgb(248, 248, 249)'))) %>%
  add_trace(x = X2, y=rowtree,type = 'bar',orientation = 'h', name='Fair',marker = list(color = 'rgba(71, 58, 131, 0.8)')) %>%
  add_trace(x = X3, y=rowtree,type = 'bar',orientation = 'h', name='Good',marker = list(color = 'rgba(190, 192, 213, 1)')) %>%
  layout(barmode = 'stack',
         paper_bgcolor = 'rgb(248, 248, 255)', plot_bgcolor = 'rgb(248, 248, 255)',
         #margin = list(l = 120, r = 10, t = 140, b = 80),
         showlegend = TRUE,
         xaxis=list(title = ""),yaxis=list(title = ""))  




##### bar plot to compare the health status with or without a single cause

ProblemPresence<-c('Yes', 'No')
Poor<-rbind(TreeProblems[1,1],TreeNOProblems[1,1])
Fair<-rbind(TreeProblems[1,2],TreeNOProblems[1,2])
Good<-rbind(TreeProblems[1,3],TreeNOProblems[1,3])
HealthData2<-data.frame()
HealthData2<-data.frame(ProblemPresence,Poor,Fair,Good)


plot_ly(HealthData2, x=ProblemPresence, y = Poor, type = 'bar', name = 'Poor') %>%
  add_trace(x=ProblemPresence,y = Fair, type = 'bar',name = 'Fair') %>%
  add_trace(x=ProblemPresence,y = Good, type = 'bar',name = 'Good') %>%
  layout(yaxis = list(title = 'Percent'),xaxis = list(title = 'Precense of Problem'), barmode = 'stack')


######## Heatmap #######
plot_ly(
  x = c("Poor", "Fair", "Good"), y = rownames(TreeProblems),
  z = TreeProblems,type = "heatmap"
)%>%
  layout(xaxis=list(title = "",showticklabels = TRUE),yaxis=list(title = "",showticklabels = TRUE))

#cor(treedata$root_grate,treedata$root_stone)


###### pie chart ######
Problem_Yes<-TreeProblems[1,]
Problem_Yes<-data.frame(Problem_Yes)
rownames(Problem_Yes)=c("Poor", "Fair", "Good")

Problem_No<-TreeNOProblems[1,]
Problem_No<-data.frame(Problem_No)
rownames(Problem_No)=c("Poor", "Fair", "Good")


plot_ly(Problem_Yes, labels = c("Poor", "Fair", "Good"), values = Problem_Yes,type = "pie") %>%
  layout(title = "Health for Trees WITH the problem")

plot_ly(data=Problem_No, labels = c("Poor", "Fair", "Good"), values = Problem_No,type = "pie") %>%
  layout(title = "Health for Trees WITHOUT the problem")
  
