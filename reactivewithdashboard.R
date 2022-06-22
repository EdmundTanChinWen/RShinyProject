#Set working directory ----
getwd()
setwd("C:/Users/15007483/Documents/R/R script")

#Import files ----
mosa <- read.csv("Source Files/mobility-of-seniors-annual.csv", stringsAsFactors = F)

library(shinydashboard)
library(shiny)
library(readr)
library("ggplot2")

# The UI
ui <- dashboardPage(
  skin = "black", 
  dashboardHeader(title = "Seniors data"),
  dashboardSidebar(
    sidebarMenu(
      menuItem(text = "Number of Senior over the years", tabName = "No_hist"),
      menuItem(text = "Senior with mobility issue", tabName = "Hi_hist"),
      menuItem(text = "Mobility issues", tabName = "Yes_hist"),
      menuItem(text = "Deceased senior over the years", tabName = "Hello_hist")
    )
  ),
  
  # The body of the UI
  dashboardBody(
    tabItems(
      # Number of Senior over the years tab
      tabItem(tabName = "No_hist",
              h2("Number of Seniors over the years (1670 total)"),
              h3("From year 2009-2015"),
              box(plotOutput("No_plot", height = 300)),
              box(plotOutput("Barchart_plot", height = 300, width = 400))
      ),
      # Senior with mobility issue tab
      tabItem(tabName = "Hi_hist",
              h2("Senior with mobility issue (yes/no)"),
              h3("From year 2009-2015"),
              box(plotOutput("Hi_plot", height = 350, width = 350)),
              box(plotOutput("Bye_plot", height = 350, width = 350))
      ),
      # Mobility issues tab
      tabItem(tabName = "Yes_hist",
              h2("Seniors with different types of mobility issues"),
              box(plotOutput("Wheelchairbound_plot", height = 200, width = 300)),
              box(plotOutput("Bedridden_plot", height = 200, width = 300)),
              box(plotOutput("Difficultywalking_plot", height = 200, width = 300))
              
      ),
      # Deceased Senior over the years tab
      tabItem(tabName = "Hello_hist",
      fluidRow(
        box(plotOutput("histogram")),
        box(sliderInput("bins","Year",1,9,15))
      )
                )
              )
  )
)

# The calculations behind the scenes
server <- function(input, output) {
  
  # Generate the Num of seniors over the years plot
  output$No_plot <- renderPlot({
    ggplot(mosa, aes(year, no_of_seniors)) + geom_point() +
      geom_line(method=lm, level=FALSE, color = 'red', size = 0.5) +
      geom_point(data = mosa, shape = 21, fill = NA, color = "black", alpha = 0.25)
  })
  # Num of seniors over the years barchart
  output$Barchart_plot <- renderPlot({
    ggplot(data = mosa, aes(x=year, y=no_of_seniors)) + geom_bar(stat="identity", fill="darkblue")
  })
  
  # Senior with mobility issue plot (yes/no)
  output$Hi_plot <- renderPlot({
    ggplot(data = mosa, aes(x=year, y=yes)) + geom_bar(stat="identity", fill="darkorange")
  })
  output$Bye_plot <- renderPlot({
    ggplot(data = mosa, aes(x=year, y=no)) + geom_bar(stat="identity", fill="darkorange")
  })
  
  # Generate the Mobility issues plot
  output$Wheelchairbound_plot <- renderPlot({
    ggplot(data = mosa, aes(x=year, y=wheelchairbound)) + geom_bar(stat="identity", fill="darkblue")
  })
  output$Bedridden_plot <- renderPlot({
    ggplot(data = mosa, aes(x=year, y=bedridden)) + geom_bar(stat="identity", fill="darkgreen")
  })
  output$Difficultywalking_plot <- renderPlot({
    ggplot(data = mosa, aes(x=year, y=difficultywalking)) + geom_bar(stat="identity", fill="red")
  })
  
  output$histogram <- renderPlot({
    hist(faithful$eruptions, breaks = input$bins)
  })
  
}


shinyApp(ui, server)