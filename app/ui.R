library(shiny)
library(shinydashboard)
library(leaflet)

shinyUI(navbarPage("Trees in New York",id="nav",
                   
  tabPanel("New York",
           div(class="outer",
               tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
               leafletOutput("map",width="100%",height = "100%"),
               absolutePanel(id="control1",fixed = T,draggable = T,class = "panel panel-default",top = 80,
                             left = 55, right = "auto", bottom = "auto",
                             width = 280, height = 550,
                             h3("Trees"),
                             helpText("Choose Your Location"),
                             textInput("location","Your Location:","Columbia University NY"),
                             actionButton("submit","Mark"),
                             helpText("Choose Your Favorite Tree"),
                             checkboxInput("Status","Only Alive"),
                             selectInput("Tree","Your Favorite Tree",Types, multiple = T,selected = "Ash"),
 #                            textOutput("text"),
                             submitButton("Apply Changes"),
                             plotOutput("barplot")
                             ))
            
  ),
  tabPanel("EDA",
           #Need corresponding server part
           sidebarLayout(position="right",
             sidebarPanel(
               conditionalPanel(condition="input.edaPanels==1",
                                helpText("Fit your model"),
                                selectInput("variables","Choose one variable:",Problems,selected = "Root Stone")),
               conditionalPanel(condition="input.edaPanels==2",
                                helpText("Choose the Problem"),
                                checkboxGroupInput("variables2","Choose at least 2 Components:",Problems),
                                submitButton("Apply changes"))
             ),
             mainPanel(
               tabsetPanel(type="pill",
                           tabPanel("Overview",
                                    plotlyOutput("plot1",width=600),value=1
                                    ),
                           tabPanel("Ananysis of Effects between different Elements",
                                    plotlyOutput("plot2"),value=2),
                           id="edaPanels"
                           )
             )
           )),
  tabPanel("Clustering",
           #Need corresponding server part
           sidebarLayout(position="right",
                         sidebarPanel(
                           h3("Select the number of clusters"),
                           selectInput("k","Number of clusters:",choices = list('3','4','5'),selected = '3'),
                           submitButton("Apply Changes"),
                           plotOutput("summary")
#                           selectInput("method","Methods for Clustering:",choices=list('Kmeans','Hierarchical Clustering'))

                         ),
                         mainPanel(
                           h2("Clustering"),
                           plotOutput("kmeans",height = 600)
                         ))),
  tabPanel("Text Mining"
           )
))

