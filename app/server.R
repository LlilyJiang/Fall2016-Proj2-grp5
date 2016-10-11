library(shiny)
library(leaflet)
shinyServer(function(input, output) {
  #The background Map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "https://api.mapbox.com/v4/mapbox.streets/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZnJhcG9sZW9uIiwiYSI6ImNpa3Q0cXB5bTAwMXh2Zm0zczY1YTNkd2IifQ.rjnjTyXhXymaeYG6r2pclQ",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -73.97, lat = 40.70, zoom = 11)
  })
  
#  address <- reactive({
#    if(input$submit[1] > 0){
#      result=data.frame()
#      url = paste0('http://maps.google.com/maps/api/geocode/xml?address=',input$location,'&sensor=false')
#      doc = xmlTreeParse(url) 
#      root = xmlRoot(doc) 
#      lat = as.numeric(xmlValue(root[['result']][['geometry']][['location']][['lat']])) 
#      long = as.numeric(xmlValue(root[['result']][['geometry']][['location']][['lng']]))
#      result=data.frame(latitude=lat,longitude=long)
#    }
#    return(result)
#  })
  
  ###Filter the data
  
  TType <- reactive({
    t <- Trees
    
#    if(length(input$Tree_types)!=0){
#      t = t[t$category==input$Tree_types,]
#    }
    
    if(length(input$Tree)!=0){
      t = t[t$category==input$Tree,]
#      t = filter(t,t$category == input$Tree)
    }
    if(input$Status==T){
      t = t[t$status== "Alive",]
#      t = filter(t,t$status=="Alive")
    }
    return(t)
  })
  
  #Add circless to the Trees
  observe({
    leafletProxy("map") %>%
      clearShapes() %>%
        addCircles(data = TType(), ~longitude, ~latitude,radius=1,opacity=1)
  })
#Used to debug  
#  output$text <- renderText(c(input$Tree,dim(TType())))
  
  
  #Add markers to your location
  observeEvent(input$submit,{
    url = paste0('http://maps.google.com/maps/api/geocode/xml?address=',input$location,'&sensor=false')
    doc = xmlTreeParse(url) 
    root = xmlRoot(doc) 
    lat = as.numeric(xmlValue(root[['result']][['geometry']][['location']][['lat']])) 
    long = as.numeric(xmlValue(root[['result']][['geometry']][['location']][['lng']]))

   leafletProxy("map") %>%
      clearMarkers() %>%
#      addMarkers(data=address(),~longitude,lat=latitude)
      addMarkers(lng=long,lat=lat)
   
#   loc_zip=as.numeric(xmlValue(xmlChildren(root[['result']][[13]][[1]])$text))
   
#   output$barplot <- renderPlot({
     #zip_data
     #health, status,species
#   })
  })
  
  output$plot2 <-renderPlotly({
    plot_ly(HealthData, x = X1, y = input$variables2, type = 'bar', orientation = 'h', name='Poor',
            marker = list(color = 'rgba(38, 24, 74, 0.8)',
                          line = list(color = 'rgb(248, 248, 249)'))) %>%
      add_trace(x = X2, y=input$variables2,type = 'bar',orientation = 'h', name='Fair',marker = list(color = 'rgba(71, 58, 131, 0.8)')) %>%
      add_trace(x = X3, y=input$variables2,type = 'bar',orientation = 'h', name='Good',marker = list(color = 'rgba(190, 192, 213, 1)')) %>%
      layout(barmode = 'stack',
             paper_bgcolor = 'rgb(248, 248, 255)', plot_bgcolor = 'rgb(248, 248, 255)',
             #margin = list(l = 120, r = 10, t = 140, b = 80),
             showlegend = TRUE)  
  })
  
  # Compute and plot wss for k = 2 to k = 15
#  k.max <- 15 # Maximal number of clusters
#  data <- zipdata
#  wss <- sapply(1:k.max, 
#                function(k){kmeans(data, k, nstart=15 )$tot.withinss})
#  fviz_nbclust(zipdata, kmeans, method = "wss") +
#    geom_vline(xintercept = 6, linetype = 2)
  
  #Produce the kmeans map
  output$kmeans <- renderPlotly({
    km.res<-kmeans(zipdata,input$k,nstart = 25)
  fviz_cluster(km.res, data = data.scaled, geom = "point",
               stand = FALSE, frame.type = "norm")
  
  aggregate(zipdata,by=list(km.res$cluster),FUN=mean)
  
  zip_data$kmcluster<-km.res$cluster
  dat.trees$kmcluster<-zip_data$kmcluster[match(dat.trees$zipcode,zip_data$zipcode)]
  
  ########Hierarchical clustering
  # Compute pairewise distance matrices
  #  dist.res <- dist(zipdata, method = "euclidean")
  # Hierarchical clustering results
  #  hc <- hclust(dist.res, method = "complete")
  # Visualization of hclust
  #  plot(hc, labels = FALSE, hang = -1)
  # Add rectangle around 3 groups
  #  rect.hclust(hc, k = 5, border = 2:4)
  
  
  })
})