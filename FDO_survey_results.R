library(shiny)
library(shinydashboard)
library(ggplot2)
library(rsconnect)

rsconnect::setAccountInfo(name='aosman4',
                          token='0C55A46CD316C63C6E89E436DFACBBBD',
                          secret='AZhZnE6NC2TUCxesP8h+LYYxRT3ljWOcdSmTIObm')

data <-read.csv("https://raw.githubusercontent.com/Aosman4/FDOsurveyresults/main/FDOresultsdata.csv")
ui = 
  dashboardPage(
    dashboardHeader(title = "FDO PSES Results"),
    dashboardSidebar(
      
      sidebarMenu(
        menuItem("FDO Results", tabName = "Results", icon = icon("clipboard"))
      )
    ),
    
    dashboardBody(
      
      tabItems(
        tabItem("Results",
                box(
                  selectInput("TITLE_E", "Select Question:", choices = unique(data$TITLE_E)),width = 6),
                box(plotOutput("bar_plot", height = "400px", width = "400px"), width =6)
                
        ))))

server <- function(input, output) {
  
  
  output$bar_plot <- renderPlot({
    selected_question <- input$TITLE_E
    filtered_data <- data[data$TITLE_E == selected_question, ]
    
    ggplot(filtered_data, aes(x = descrip_E, y = SCORE100, fill = descrip_E)) +
      geom_bar(stat = "identity") +
      labs(title = "FDO Survey results", x = "Office", y = "Score out of 100", fill = "Department/Location")
  })
}

shinyApp(ui, server)
