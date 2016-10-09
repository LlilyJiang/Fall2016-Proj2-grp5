#install.packages("shinydashboard")

dat.trees<-read.csv("/Users/monicatao/Documents/ads/project2/Fall2016-Proj2-grp5/data/TreesCount.csv")
#orig.trees<-read.csv("/Users/monicatao/Documents/ads/project2/TreesCount2015Trees.csv")
dat.trees2<-dat.trees


dat.trees<-dat.trees2
dat.trees$category<-as.character(dat.trees$category)
dat.trees$name<-as.character(dat.trees$name)
dat.trees$category[dat.trees$category=="Redcedar"]<-unique(dat.trees$name[dat.trees$category=="Redcedar"])
dat.trees$category[dat.trees$category=="Redwood"]<-unique(dat.trees$name[dat.trees$category=="Redwood"])
dat.trees$category[dat.trees$category=="Snowbell"]<-unique(dat.trees$name[dat.trees$category=="Snowbell"])
dat.trees$category[dat.trees$category=="Orange"]<-unique(dat.trees$name[dat.trees$category=="Orange"])
dat.trees$category[dat.trees$category=="Coffeetree"]<-unique(dat.trees$name[dat.trees$category=="Coffeetree"])
dat.trees$category[dat.trees$category=="Heaven"]<-unique(dat.trees$name[dat.trees$category=="Heaven"])
dat.trees$category[dat.trees$category=="Hazelnut"]<-unique(dat.trees$name[dat.trees$category=="Hazelnut"])
dat.trees$category[dat.trees$category=="Raintree"]<-unique(dat.trees$name[dat.trees$category=="Raintree"])
dat.trees$category[dat.trees$category=="Maackia"]<-"Amur Maackia"
dat.trees$category[dat.trees$category=="Crabapple"]<-"Apple"
dat.trees$category[dat.trees$category=="Boxelder"]<-"Maple"
dat.trees$category[dat.trees$category=="inermis"]<-"Locust"
dat.trees$category[dat.trees$category=="Ironwood"]<-"Witch Hazel"
dat.trees$category[dat.trees$category=="Plum"]<-"Cherry"
dat.trees$category[dat.trees$category=="Aspen"]<-"Cottonwood"
dat.trees$category[dat.trees$category=="Gum"]<-"Tupelo"
dat.trees$category[dat.trees$category=="Myrtle"]<-"Crepe Myrtle"
dat.trees$category[dat.trees$category=="other"]<-"Unknown"


dat.trees$category[dat.trees$name=="Katsura Tree"]<-"Katsura"
dat.trees$category[dat.trees$name=="Hardy Rubber Tree"]<-"Hardy Rubber Tree"
dat.trees$category[dat.trees$name=="Amur Cork Tree"]<-"Cork Tree"
dat.trees$category[dat.trees$name=="Express Tree"]<-"Express Tree"
dat.trees$category[dat.trees$name=="Chinese FringeTree"]<-"Katsura"
dat.trees$category[dat.trees$name=="Tulip Poplar"]<-"Tulip Tree"
dat.trees$category[dat.trees$name=="Persian Ironwood"]<-"Parrotia"
dat.trees$category[dat.trees$name=="Horse Chestnut"]<-"Buckeye"
dat.trees$category[dat.trees$name=="Red Horse Chestnut"]<-"Buckeye"

write.csv(dat.trees,"TreeCount_classified.csv")

