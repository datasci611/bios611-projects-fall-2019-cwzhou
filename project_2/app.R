#Project 2
#user interface (UI) and server pieces
library(shiny)
library(shinydashboard)
#setwd("~/Desktop/611 Notes/bios611-projects-fall-2019-cwzhou/project_2")
source("helper_functions.R")

# Define UI for app that displays Project 2 analysis dashboard----
ui <- dashboardPage(
  
  # Title ----
  dashboardHeader("Project 2 Urban Ministries Analysis Dashboard"),
  
  # Sidebar layout with menu options ----
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "intro", icon = icon("Introduction")),
      menuItem("Data Source", tabName = "data", icon = icon("Data Source")),
      menuItem("Aims", tabName = "aims", icon = icon("Aims")),
      menuItem("Data Analysis", tabName = "analysis", icon = icon("Data Analysis"),
               menuSubItem("Question 1-3", tabName = "Q1-3", icon = icon("Question 1-3")),
               menuSubItem("Question 4", tabName = "Q4", icon = icon("Question 2")))
    )
  ),
  
  # Body to display plots and analysis
  dashboardBody(
    tabItems(
      # Background
      tabItem(tabName = "background",
              htmlOutput("background")
      ), 
      
      # Purpose of Analysis
      tabItem(tabName = "purpose",
              htmlOutput("purpose")
      ),
      
      # Question 1-3
      tabItem(tabName = "Q1-3",
              fluidRow(
                # Sidebar to choose a type of help UMD provided
                sidebarPanel(
                  htmlOutput("trend_text"),
                  selectInput('trend_variable',
                              'Type of Help UMD Provided',
                              c("Number of People Receiving Food", "Food Pounds", "Clothing Items")
                  )
                ),
                
                # Trend of a variable over time
                mainPanel(
                  plotOutput("trend_plot"),
                  htmlOutput("trend_interpretation")
                )
              )
      ),

    )
  )
)



# Define server
server <- function(input, output) {
  set.seed(435)
  
  # background
  output$background <- renderUI({
    HTML(paste(umd_description, data_description, sep="<br/>"))
  })
  
  # Purpose of analysis
  output$purpose <- renderUI({
    HTML(paste("<ul><li>", purpose[1], 
               "</li><li>", purpose[2], 
               "</li><li>", purpose[3],
               "</li><li>", purpose[4], "</li><ul>"))
  })
  
  # Interpretation of trend sidebar
  output$trend_text <- renderUI({
    HTML("Please select a type of help UMD provided and view its trend over time:")
  })
  
  # Plot of trend_variable over time
  output$trend_plot <- renderPlot({
    trend(input$trend_variable)
  })
  
  # Interpretation of trend plot
  output$trend_interpretation <- renderUI({
    HTML(paste("<ul><li>", trend_interpretation[input$trend_variable][1,], 
               "</li><li>", trend_interpretation[input$trend_variable][2,], 
               "</li><li>", trend_interpretation[input$trend_variable][3,], "</li><ul>"))
  })
  
  # Average food per person plot for Question 4
  output$average_food <- renderPlot({
    average_food_plot
  })
  
  # Interpretation of plot in Question 4
  output$average_food_interpretation <- renderUI({
    HTML(paste("<ul><li>", average_food_interpretation[1], 
               "</li><li>", average_food_interpretation[2], 
               "</li><li>", average_food_interpretation[3],
               "</li><li>", average_food_interpretation[4],
               "</li><li>", average_food_interpretation[5],
               "</li><li>", average_food_interpretation[6],
               "</li><li>", average_food_interpretation[7],
               "</li><ul>"))
  })
  
  # Estimate of food pounds in calculator
  output$food_pounds <- renderText({
    if (input$group==1) {
      paste('Estimated Food Pounds UMD should provide for', input$number_of_people, ' people in Group One:', round(model$one$coefficients * input$number_of_people, 2), 'pounds')
    } else {
      paste('Estimated Food Pounds UMD should provide:', input$number_of_people, ' people in Group Two:',round(model$two$coefficients * input$number_of_people, 2), 'pounds')
    }})
  
}

# Run the application 
shinyApp(ui = ui, server = server)