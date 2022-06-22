#Load Libraries
library(shiny)
library(ggplot2)
library(dplyr)

#Load data
#Create a dummy data frame =====
df <- data.frame(matrix(ncol = 11, nrow = 100))
colnames(df) <- c("ID", "Age" , "Date", "Gender" , "Ethnicity" , "FlatType" , 
                  "GRC" , "Division" , "Marital.Status" , "Mobility" , "MobilityLevel")
df$Gender <- rep(c("M" , "F"))
df$FlatType <- rep(c("HDB" , "LANDED"))
df$ID <- sample(1:100, 100 , replace = FALSE)
df$Ethnicity <- rep(c("C" , "I" , "M" , "O"))
df$Age <- sample(65:100, 100 , replace = T)
df$GRC <- rep(c("GRC A" , "GRC B"))
df$Division <- rep(c("Div 1" , "Div 2"))
df$Marital.Status <- rep(c("Married" , "Single" , "Divorced" , "Widow" ))
df$Mobility <- rep(c("Yes" , "No"))
df$MobilityLevel <- rep(c("Difficulty Walking" , "Wheelchair-Bound" , "Bedridden" , "NIL"))
df$Date <- sample(seq(as.Date('2017/01/01'), as.Date('2018/01/01'), by="day"), 100)



# Define UI for miles per gallon application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Mobility issue in Senior (2016-2017)"),
  
  # Sidebar with controls to select city, month and type of plot
  sidebarLayout(
    
    sidebarPanel(
      helpText("Type/Select one or more GRCs:"),
      
      uiOutput("GRCSelector"),
      
      helpText("Type/Select one or more MobilityLevel:"),
      uiOutput("MobilityLevelSelector"),
      
      helpText("Select type of plot:"),
      checkboxGroupInput("checkPlot", 
                         label = ("Plots"), 
                         choices=c("GAM Plot","Point Plot"),
                         selected = "GAM Plot"
      ),

      
      
      tags$a(href = "https://www.gov.sg/sgdi/ministries/mccy/statutory-boards/pa/departments/pgo", "Source")
      
    ),
    
    #Main Panel contains the plot/s
    mainPanel(
      
      textOutput("overview"),
      plotOutput("RegPlot")
      # verbatimTextOutput("ff")
      
      
      
    )
  )
))