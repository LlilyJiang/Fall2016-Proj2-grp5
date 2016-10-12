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
                             selectInput("Tree","Your Favorite Tree",Types, multiple = T,selected = "Ash")
 #                            textOutput("text"),
 #                            submitButton("Apply Changes")
                             
                             ))
            
  ),
  tabPanel("EDA",
           #Need corresponding server part
           sidebarLayout(position="right",
             sidebarPanel(
               conditionalPanel(condition="input.edapanels==1",
                                helpText("Select the Problem You want to analyze"),
                                checkboxGroupInput("variables2","Choose at least 2 Components:",
                                                   Problems,selected = c("Root Stone", "Root Grate","Trunk Wire"))
   #                             submitButton("Apply Changes")
                                ),
               conditionalPanel(condition="input.edapanels==2",
                                helpText("Select the Tree you want to analysze"),
                                selectInput("Tree2","Choose one Tree:",Types,selected = "Maple"),
                         #       submitButton("Apply Changes"),
                                hr(),
                                plotlyOutput("piechart")
                                )
               
             ),
             mainPanel(
               tabsetPanel(type="pill",id="edapanels",
                           tabPanel("Analysis of diferrent problems",
                                    plotlyOutput("plot1",width= 800 , height = 300),
                                    plotlyOutput("plot2",width= 800 , height = 300),value=1),
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
     #                      submitButton("Apply Changes"),
                           plotOutput("summary")
#                           selectInput("method","Methods for Clustering:",choices=list('Kmeans','Hierarchical Clustering'))

                         ),
                         mainPanel(
                           h2("Clustering"),
                           plotOutput("kmeans",height = 600)
                         ))),
  tabPanel("Text Mining",
           sidebarLayout( 
             
             sidebarPanel( 
               helpText("Please select trees to view information"),
               selectInput("treename", label = h3("Tree Description"), 
                           choices = list('Alder'=1,
                                          'Amur Cork Tree'=2,'Arborvitae'=3,'Ash'=4,'Aspen'=5,'Beech'=6,
                                          'Birch'=7,'Boxelder'=8,'Buckeye'=9,'Catalpa'=10,'Cedar'=11,
                                          'Cherry'=12,'Chestnut'=13,'Coffetree'=14,'Cottonwood'=15,'Crabapple'=16,
                                          'Cypress'=17,'Dogwood'=18,'Douglas-Fir'=19,'Elm'=20,'Elms'=21,
                                          'Empress Tree'=22,'Fringetree'=23,'Ginkgo'=24,'Gum'=25,'Hackberry'=26,
                                          'Hardy Rubber Tree Mimosa'=27,'Hawthorn'=28,'Hazelnut'=29,'Heaven'=30,
                                          'Hemlock'=31,'Hickory'=32,'Holly'=33,'hophornbeam'=34,'Hornbeam'=35,
                                          'inermis'=36,'Ironwood'=37,'Katsura Tree'=38,'Larch'=39,'Linden'=40,
                                          'Locust(Black Locust)'=41,'Maackia'=42,'Magnolia'=43,'Maple'=44,
                                          'Mulberry'=45,'Myrtle'=46,'Oak'=47,'Orange'=48,'pear'=49,'Pine'=50,
                                          'Planetree'=51,'Plum'=52,'Poplar'=53,'Raintree'=54,'Redbud'=55,
                                          'Redcedar'=56,'Redwood'=57,'Sassafras'=58,'Serviceberry'=59,
                                          'Silverbell'=60,'Smoketree'=61,'Snowbell'=62,'Sophora'=63,
                                          'Spruce'=64,'Sweetgum'=65,'Treelilac'=66,'Walnut'=67,
                                          'Willow'=68,'Yellowwood'=69,'Zelkova'=70), selected = 1),
               helpText("Please refer 'Trees ID-Name table' panel to see
                        the number id for each type of trees and Enter tree IDs seperated by &,eg: 1&12&38"),
               textInput("tt", label = h3("Similarites based Hierarchy cluster among selected trees"), 
                         value = "1&12&38&49&23&21&11&70"),  
      #         submitButton(h3("Query"))
               actionButton("submit2","Query"),
               actionButton("go",uiOutput('test'))
    #           plotOutput("icon")
  
               ),                                   
             
             mainPanel( 
               tabsetPanel( 
                 tabPanel("Description", textOutput("desc")),
                 tabPanel("Similarity(Cosine Distance)", tableOutput("cd")),
                 tabPanel("Hierarchy Plot", plotOutput("fig")),
                 tabPanel("Trees ID-Name table", tableOutput("tb"))
               )
             )               
             
             
  ))
))

