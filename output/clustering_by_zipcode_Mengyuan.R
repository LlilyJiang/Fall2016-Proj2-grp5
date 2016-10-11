#######Manage data by zipcode
Trees=dat.trees
zip_data=matrix(ncol=15)
colnames(zip_data)=c("zipcode","Fair health","Poor health","Harmful Guards","Helpful Guards","Sidewalk Damage","rootstone","rootgrate","rootother","trunkwire","trnklight","trnkother","brchlight","brchshoe","brchother")
ziplist=as.numeric(levels(as.factor(Trees$zipcode)))
for (i in ziplist){
  temp=Trees[Trees[,25]==i,]
  h1=tally(temp[temp[,9]=="Fair",])
  h2=tally(temp[temp[,9]=="Poor",])
  g1=tally(temp[temp[,12]=="Harmful",])
  g2=tally(temp[temp[,12]=="Helpful",])
  s1=tally(temp[temp[,13]=="Damage",])
  a1=tally(temp[temp[,15]=="No",])
  a2=tally(temp[temp[,16]=="No",])
  a3=tally(temp[temp[,17]=="No",])
  a4=tally(temp[temp[,18]=="No",])
  a5=tally(temp[temp[,19]=="No",])
  a6=tally(temp[temp[,20]=="No",])
  a7=tally(temp[temp[,21]=="No",])
  a8=tally(temp[temp[,22]=="No",])
  a9=tally(temp[temp[,23]=="No",])
  b=nrow(temp)
  temp=as.vector(c(i,h1/b,h2/b,g1/b,g2/b,s1/b,a1/b,a2/b,a3/b,a4/b,a5/b,a6/b,a7/b,a8/b,a9/b))
  zip_data=rbind(zip_data,temp)
}
zip_data=zip_data[2:nrow(zip_data),]




###########kmeans of zipcode
zip_data<-data.frame(zip_data)
zipdata<-zip_data[,2:13]
zipdata<-data.frame(zipdata)
zipdata[,1:12] <- sapply(zipdata[, 1:12], as.numeric)

set.seed(123)
# Compute and plot wss for k = 2 to k = 15
k.max <- 15 # Maximal number of clusters
data <- zipdata
wss <- sapply(1:k.max, 
              function(k){kmeans(data, k, nstart=15 )$tot.withinss})
fviz_nbclust(zipdata, kmeans, method = "wss") +
  geom_vline(xintercept = 6, linetype = 2)

km.res<-kmeans(zipdata,3,nstart = 25)
fviz_cluster(km.res, data = data.scaled, geom = "point",
             stand = FALSE, frame.type = "norm")

aggregate(zipdata,by=list(km.res$cluster),FUN=mean)

zip_data$kmcluster<-km.res$cluster
dat.trees$kmcluster<-zip_data$kmcluster[match(dat.trees$zipcode,zip_data$zipcode)]





########Hierarchical clustering
# Compute pairewise distance matrices
dist.res <- dist(zipdata, method = "euclidean")
# Hierarchical clustering results
hc <- hclust(dist.res, method = "complete")
# Visualization of hclust
plot(hc, labels = FALSE, hang = -1)
# Add rectangle around 3 groups
rect.hclust(hc, k = 5, border = 2:4) 


