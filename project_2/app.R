## app.R ##
library(shinydashboard)
#library(shiny)
#library(rsconnect)
library(DT)
#setwd("~/Desktop/611 Notes/bios611-projects-fall-2019-cwzhou/project_2")
source("helper_functions.R")

ui = dashboardPage(
  dashboardHeader(title = "Project 2 Urban Ministries Analysis Dashboard",
                  titleWidth = 450
  ),
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Background", tabName = "background", icon = icon("home")),
      menuItem("Goals", tabName = "goals", icon = icon("star")),
      menuItem("Data Source", tabName = "data", icon = icon("database")),
      menuItem("Raw Data", tabName = "analysis", icon = icon("chart-bar")),
      menuItem("Client Visits", tabName = "visits", icon = icon("chart-line"))
    )
  ),
  
  ## Body content
  dashboardBody(
    tabItems(
      # FIRST tab content
      tabItem(tabName = "background",
              h2("Background"),
              p(bg0),p(bg1,a("[1].", href="https://www.usich.gov/homelessness-statistics/nc/"),bg1.5),p(bg2, a("[2].", href="http://www.umdurham.org/"))
      ),
      # SECOND tab content
      tabItem(tabName = "goals",
              h2("Project Aims"),
              p(g1),p(g2[1]),p(g2[2])
      ),      
      # THIRD tab content
      tabItem(tabName = "data",
              h2("Data Source and Data Cleaning"),
              p(ds1,ds2),p(ds3, a("here.", href="https://github.com/biodatascience/datasci611/blob/gh-pages/data/project1_2019/UMD_Services_Provided_metadata_20190719.tsv"),ds4),p(ds5)
      ),
      # FOURTH tab content
      tabItem(tabName = "analysis",
              h2("UMD Raw Data"),
              fluidRow(
                box(title = "UMD Service Variables", status = "primary", solidHeader =TRUE,
                    radioButtons("radio", label = "Select a Service",
                                 choices = c("Number of People Food was Provided for" = "Food.Provided.for",
                                             "Number of Pounds of Food Distributed" = "Food.Pounds",
                                             "Number of Clothing Items Distributed" = "Clothing.Items",
                                             "Number of Diapers Distributed" = "Diapers",
                                             "Number of School Kits Distributed" = "School.Kits",
                                             "Number of Hygiene Kits Distributed" = "Hygiene.Kits")),
                  textOutput("text1"),
                  p("NOTE: we omit rows with missing data for this variable. Thus, each dataset is different. Any outliers identified using the IQR method were removed.")
                  ),
                box(title = "Year at UMD", status = "primary", solidHeader= TRUE,
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
                              selected = 1),
                    textOutput("text2")
                    )
                ),
              fluidRow(
                column(width=12,
                       box(title = "Plot of Raw UMD Data", status = "primary", solidHeader=TRUE,
                           plotOutput(outputId = "varPlot"), width=12))
                )
      ),
    # FIFTH tab content
    tabItem(tabName = "visits",
            h2("UMD Visits Summaries"),
            fluidRow(box(title = "Table of total number of UMD visits per client by year", status = "primary", solidHeader = TRUE,
                                dataTableOutput(outputId = "popTable"),
                         textOutput("text4")
                         ),
                     box(title = "Table of average UMD visits of all clients by year", status = "primary", solidHeader = TRUE,
                         dataTableOutput(outputId = "pop2Table"),
                         textOutput("text5")
                     )
                     )
            )
    )
    )
)


server = function(input, output) {
  
  # ANALYSIS

  output$text1 <- renderText({
    var_lab <- switch(input$radio, 
                      Food.Provided.for = "Number of People Food was Provided for",
                      Food.Pounds = "Number of Pounds of Food Distributed",
                      Clothing.Items = "Number of Clothing Items Distributed",
                      Diapers = "Number of Diapers Distributed",
                      School.Kits = "Number of School Kits Distributed",
                      Hygiene.Kits = "Number of Hygiene Kits Distributed")
    paste("You selected", var_lab,".")
  })
  
  output$text2 <- renderText({
    paste("You selected the year", toString(input$date1),".")
  })
  
  output$text3 <- renderText({
    paste("You selected the year", toString(input$date2),".")
  })
  
  output$varPlot <- renderPlot({
    var_lab <- switch(input$radio, 
                      Food.Provided.for = "Number of People Food was Provided for",
                      Food.Pounds = "Number of Pounds of Food Distributed",
                      Clothing.Items = "Number of Clothing Items Distributed",
                      Diapers = "Number of Diapers Distributed",
                      School.Kits = "Number of School Kits Distributed",
                      Hygiene.Kits = "Number of Hygiene Kits Distributed")
    helper2(input$radio,input$date1,var_lab)
  })
  
  output$popTable <- DT::renderDataTable({
    DT::datatable(year_df, options = list(lengthMenu = c(8, 20, 50), pageLength = 8))
    })
  
  output$text4 <- renderText({
    paste("This table shows the total number of visits each year for every ID for the original dataset. We have not excluded any datapoints. By default, the table is sorted by descending order by number of visits, then year. Click the arrows to change descending/ascneding order for any of the variables: ID, Year, and Number of Visits.")
  })

output$pop2Table <- renderDataTable({
  datatable(avg_df, options = list(lengthMenu = c(5,8,20), pageLength = 8))
})

output$text5 <- renderText({
  paste("This table shows the average number of visits each year all clients that visited UMD that year. We have not excluded any datapoints from the origianl dataset. By default, the table is sorted by descending order by average number of visits. Click the arrows to change descending/ascneding order for any of the variables: ID, Year, and Mean of Visits.")
})

}

shinyApp(ui, server)

#rsconnect::deployApp("~/Desktop/611 Notes/bios611-projects-fall-2019-cwzhou/project_2")
