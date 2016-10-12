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
               conditionalPanel(condition="input.edaPanels==2",
                                helpText("Select the Tree you want to analysze"),
                                selectInput("Tree2","Choose one Tree:",Types,selected = "Ash"),
                                submitButton("Apply Changes")
                                ),
               conditionalPanel(condition="input.edaPanels==1",
                                helpText("Select the Problem You want to analyze"),
                                checkboxGroupInput("variables2","Choose at least 2 Components:",
                                                   Problems,selected = c("Root Stone", "Root Grate","Trunk Wire")),
                                submitButton("Apply Changes")
                                )
             ),
             mainPanel(
               tabsetPanel(type="pill",id="edaPanels",
                           tabPanel("Analysis of diferrent problems",
                                    plotlyOutput("plot1",width= 600 , height = 300),
                                    plotlyOutput("plot2",width= 600 , height = 300),value=1),
                           tabPanel("Ananysis of one Tree",
                                    plotlyOutput("plot3"),value=2)
                           
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

