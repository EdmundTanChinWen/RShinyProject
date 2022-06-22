#Load Libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(purrr)
library(tidyr)
library(mgcv)

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

shinyServer(function(input, output) {
  
  output$overview<-renderText("Date Report")
  
  
  #read the 2 GRC names (the unique values)
  GRCNames<-df$GRC <- rep(c("GRC A" , "GRC B"))
  
  #GRC names list
  output$GRCSelector<-renderUI({
    selectInput('GRCs', 'GRC',
                GRCNames, 
                multiple=TRUE, 
                selectize=TRUE,
                selected="GRC A") #default value
  })
  
  #MobilityLevel abbreviation list
  output$MobilityLevelSelector<-renderUI({
    selectInput('mobilitylevel', 'MobilityLevel', 
                set_names(c("Difficulty Walking" , "Wheelchair-Bound" , "Bedridden" , "NIL")
                ), 
                multiple=TRUE, 
                selectize=TRUE,
                selected="difficulty walking") #default difficulty walking
  })
  
  #get the selected GRC
  SelectedGRC<-reactive({
    
    if(is.null(input$GRC) || length(input$GRC)==0)
      return()
    as.vector(input$GRC)
    
  })
  
  #get the selected mobilitylevel
  SelectedMobilityLevel<-reactive({
    
    if(is.null(input$MobilityLevel) || length(input$MobilityLevel)==0)
      return()
    as.numeric(as.vector(input$MobilityLevel))
    
  })
  
  
  #filter the data according to the selected city and month/s
  GRCsdf<-reactive({
    df %>%
      unnest(data)%>%
      filter(GRC %in% SelectedGRC()) %>%
      filter(MobilityLevel %in% SelectedMobilityLevel())
  }) 
  
  output$ff <- renderPrint({
    names(GRCsdf())
  })
  
  #get Check group input (type of plot)
  checkedVal <- reactive({
    as.vector(input$checkPlot)
    
  }) 
  
  
  
  ############PLOT#########
  output$RegPlot<-renderPlot({
    #check if grc and mobilitylevel are not null
    if ((length(SelectedGRC())>0) & (length(SelectedMobilityLevel())>0))
      
    {g<-ggplot(GRCsDF(),
               aes(x=GRC,y=MobilityLevel,
                   colour=factor(GRC)))+
      labs(x="GRC",
           y="Mobility Level")+
      facet_wrap(~GRC)+
      scale_color_discrete(name="GRC",
                           breaks="GRC")
    
    if ("GAM Plot" %in% checkedVal())
      
      g<-g+stat_smooth(method="gam", formula=y~s(x),se=FALSE)
    
    if ("Point Plot" %in% checkedVal())
      
      g<-g+geom_point(aes(alpha=0.4))+
        guides(alpha=FALSE)
    
    g
    }
  })
  #########################
})
    
