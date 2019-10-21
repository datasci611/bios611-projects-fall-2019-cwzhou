## app.R ##
#library(shinydashboard)
#library(shiny)
#library(rsconnect)
#setwd("~/Desktop/611 Notes/bios611-projects-fall-2019-cwzhou/project_2")
source("helper_functions.R")

ui = dashboardPage(
  dashboardHeader(title = "Project 2 Urban Ministries Analysis Dashboard",
                  titleWidth = 450
  ),
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "background", icon = icon("home")),
      menuItem("Goals", tabName = "goals", icon = icon("star")),
      menuItem("Data Source", tabName = "data", icon = icon("database")),
      menuItem("Data Analysis", tabName = "analysis", icon = icon("chart-bar"))
    )
  ),
  
  ## Body content
  dashboardBody(
    tabItems(
      # FIRST tab content
      tabItem(tabName = "background",
              h2("Background"),
              textOutput("background")
      ),
      
      # SECOND tab content
      tabItem(tabName = "goals",
              h2("Project Aims"),
              textOutput("goals")
      ),      
      
      # THIRD tab content
      tabItem(tabName = "data",
              h2("Data Source and Data Cleaning"),
              textOutput("data")
      ),
      
      # FOURTH tab content
      tabItem(tabName = "analysis",
              h2("Data Analysis: Results and Conclusions"),
              fluidRow(
                
                box(radioButtons("radio", label = "Select a variable",
                                 choices = c("Food.Provided.for", "Food.Pounds","Clothing.Items",
                                             "Diapers", "School.Kits", "Hygiene.Kits")),
                    textOutput("text1")
                ),
                
                box(
                  selectInput("date1", h3("Select Year"), 
                              choices = list("2001", "2002",
                                             "2003", "2004",
                                             "2005", "2006",
                                             "2007", "2008",
                                             "2009", "2010",
                                             "2011", "2012",
                                             "2013", "2014",
                                             "2015", "2016",
                                             "2017", "2018"), 
                              selected = 1)
                )
              ),
              mainPanel(
                plotOutput(outputId = "varPlot")#,
                #    dataTableOutput(outputId = "popTable")
              )
      )
    )
  )
)



server = function(input, output) {
  
  # INTRODUCTION/BACKGROUND
  output$background <- renderText({
    paste(bg1, bg2, ref1[1], ref1[2])
  })
  
  # GOALS
  output$goals<- renderText({
   paste(g1)
   paste(g2[1])
  })
  
  # DATA SOURCE and DATA CLEANING
  output$data<- renderText({
    paste(ds1,ds2, ds3)
  })
  
  # ANALYSIS
  
  output$text1 <- renderText({
    paste("You selected", toString(input$radio),"NOTE: we omit rows with missing", toString(input$radio), "Thus, each dataset is different.")
  })
  
  output$varPlot <- renderPlot({
    helper2(input$radio,input$date1)
  })
  
  
  #  output$popTable <- renderTable({
  #    helper_1(input$radio, input$date1)
  #  })
  
}

shinyApp(ui, server)


