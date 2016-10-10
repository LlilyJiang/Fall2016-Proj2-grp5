
data = read.csv("TreesCount.csv")  

data2=read.csv("TreesCount2015Trees.csv")

attach(data2)
df2<-data.frame(status,health,guards,sidewalk,root_stone,root_grate,trunk_wire,trnk_light,brch_light,brch_shoe,zipcode,latitude,longitude)
detach(data2)

attach(data)
df1<-data.frame(name,genus)
detach(data)

treedata<-cbind(df1,df2)
###treedata <- treedata[!(treedata$health == ""), ]


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

write.csv(treedata, file = "TreesCount2.csv")
