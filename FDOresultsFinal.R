
# Load your data
df <- read.csv("results_data")  # Original data
df2 <- read.csv("results_data2")  # New data, make sure to specify the correct file name

ui <- dashboardPage(
  dashboardHeader(title = "FDO PSES Results"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("FDO Results", tabName = "Results1", icon = icon("clipboard")),  # Original tab
      menuItem("New Results", tabName = "Results2", icon = icon("clipboard"))  # New tab
    )
  ),
  dashboardBody(
    tabItems(
      tabItem("Results1",  # Original tab
              box(
                selectInput("TITLE_E1", "Select Question:", choices = unique(df$TITLE_E)),
                width = 6
              ),
              box(
                plotOutput("bar_plot1", height = "400px"),
                width = 6
              )
      ),
      tabItem("Results2",  # New tab
              box(
                selectInput("TITLE_E2", "Select Question:", choices = unique(df2$TITLE_E)),
                width = 6
              ),
              box(
                plotOutput("bar_plot2", height = "400px"),
                width = 6
              )
      )
    )
  )
)

server <- function(input, output) {
  output$bar_plot1 <- renderPlot({
    selected_question <- input$TITLE_E1 
    filtered_data <- df[df$TITLE_E == selected_question, ]
    long_data <- gather(filtered_data, key = "Answer", value = "Value", ANSWER1, ANSWER2, ANSWER3)
    
    ggplot(long_data, aes(x = descrip_E, y = Value, fill = Answer)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "FDO Survey results", x = "Office", y = "Value", fill = "Answer")
  })
  
  output$bar_plot2 <- renderPlot({
    selected_question <- input$TITLE_E2 
    filtered_data <- df2[df2$TITLE_E == selected_question, ]
    
    ggplot(filtered_data, aes(x = descrip_E, y = SCORE100, fill = descrip_E)) +
      geom_bar(stat = "identity") +
      labs(title = "FDO Survey results", x = "Office", y = "Score out of 100", fill = "Department/Location")
  })
}

shinyApp(ui, server)
deployApp(appDir = "C:/Users/OsmanA/Documents/rsconnect/shinyapps.io")





