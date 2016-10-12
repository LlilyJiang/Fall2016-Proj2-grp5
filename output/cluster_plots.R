#####present cluster character
cl_result<-aggregate(zipdata,by=list(km.res$cluster),FUN=mean)
cl_result[,7:15]<-1-cl_result[,7:15]
ranktable<-cl_result[,c(1,3,4,6:15)]
for(i in c(2:13)){
  ranktable[,i]<-rank(-ranktable[,i])
}
colnames(ranktable)[1:4]<-c("Cluster","Health","Guards","Sidewalk")


m<-names(ranktable[,2:13])
longdata<-melt(ranktable,measure.vars = m)

area.color<-longdata$value
area.color[!area.color==3]<-"other clusters"
area.color[area.color==3]<-"top rank cluster"
p1<-ggplot(longdata,aes(x=factor(Cluster), y = value,fill = area.color)) + 
  facet_wrap(~variable) +
  geom_bar(aes(fill = area.color),stat="identity")+
  scale_fill_manual(values = c("gray50", "red"))+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        legend.position="none")
p1 
