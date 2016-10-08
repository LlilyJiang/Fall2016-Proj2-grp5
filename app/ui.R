library(shiny)
library(shinydashboard)


shinyUI(dashboardPage(
  dashboardHeader(title = "Trees in New York"
                  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data Visualization",tabName="dashboard",icon= icon("dashboard")),
      menuItem("Clustering Analysis",tabName="Clustering",icon=icon("th"))
      ),
    
    textInput("location","One location:",'Columbia University NY, NYC'),
#    selectInput("Tree_types","Choose One Category",Types),
    checkboxGroupInput("Category","Your Favorite Tree:",Types,inline=T),
    submitButton("Apply Changes")
    ),
  dashboardBody(
    tabItems(
      tabItem(tabName="dashboard",
        fluidRow(
          column(width=9,
                 box(width=NULL,solidHeader = TRUE,
              title="New York City",
              collapsible=T,
            leafletOutput("map")
            )),
          column(width=3,
                 box(
                   plotOutput("Tree_Icon")
                 ),
                 box(
                   textOutput("Information")
                 ),offset=0
                 )
          )
            ),
      tabItem(tabName="Clustering",
        fluidRow(
          box(
            ))
        )
    )
  )
))

