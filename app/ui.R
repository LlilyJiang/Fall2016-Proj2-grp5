library(shiny)
library(shinydashboard)

# Choices for drop-downs
#TreeType <- c(
#  "All"=""
#  "Maple"="maple"
#)


shinyUI(dashboardPage(
  dashboardHeader(title = "Trees in New York"
                  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data Visualization",tabName="dashboard",icon= icon("dashboard")),
      menuItem("Clustering Analysis",tabName="Clustering",icon=icon("th"))
      )
    ),
  dashboardBody(
    tabItems(
      tabItem(tabName="dashboard",
        fluidRow(
          box(
            plotOutput("maps")),
          box(
            plotOutput("treeIcon"))
          )),
      tabItem(tabName="Clustering",
        fluidRow(
          box(
            ))
        )
    )
  )
))

