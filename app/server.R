library(shiny)
library(leaflet)


shinyServer(function(input, output) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "https://api.mapbox.com/v4/mapbox.streets/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoiZnJhcG9sZW9uIiwiYSI6ImNpa3Q0cXB5bTAwMXh2Zm0zczY1YTNkd2IifQ.rjnjTyXhXymaeYG6r2pclQ",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = -73.97, lat = 40.70, zoom = 10)
  })
  
  
  TType <- reactive({
    t <- Trees
    
#    if(length(input$Tree_types)!=0){
#      t = t[t$category==input$Tree_types,]
#    }
    
    if(length(input$Category)!=0){
      t = t[t$category==input$Category,]
    }
    return(t)
  })
  
  
  observe({
    leafletProxy("map") %>%
      clearMarkers() %>%
      addCircles(data = TType(), ~longitude, ~latitude,radius=1,opacity=0.5, 
                 popup = paste("*Name:", TType()$name, "<br>",
                               "*Health:", TType()$health, "<br>")) #%>%
  })
  
  
  
})
     
