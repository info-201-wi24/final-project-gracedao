library(ggplot2)
library(plotly)
library(shiny)

#add newly created csv file here  Unified_dataset.csv
combined_df <- read.csv("Unified_dataset.csv")


server <- function(input, output){
  #user inputing State they're interested in seeing --> output
  output$obesity_poverty_plot <- renderPlotly({
    
    selected_df <- combined_df %>% filter(State %in% input$state_name)
    
    obesity_poverty_plot <- ggplot(selected_df) +
          geom_col(aes(x = Obesity_Prevelance,
                       # Reorder values
                       y = Poverty_Rate)) +
                       labs(title = "Correlation between Poverty and Obesity", x = "Obesity Prevelance %", y = "Poverty Rate (%)", color = "YearStart")
        
        ggplotly(obesity_poverty_plot)
})
  
}

# server logic 
#SHOULD NOT BE DEFINING SERVER TWICE?
server <- function(input, output, session) {
  selected_df <- reactive({
    filter(combined_df, Year == input$selected_date)
  })
  
  total_obesity_rate <- reactive({
    sum(selected_df$ObesityRate)
  })
  
  change_in_obesity <- reactive({
    previous_year_data <- filter(combined_df, Year == input$selected_date - 1)
    
    if (nrow(previous_year_data) == 0) {
      return ("No data for the previous year")
    }
    
    previous_year_obesity_rate <- sum(previous_year_data$ObesityRate)
    percent_change <- ((total_obesity_rate() - previous_year_obesity_rate) / previous_year_obesity_rate) * 100
    
    if (percent_change > 0) {
      return(paste0("Increase of ", round(percent_change, 2), "% from the previous year"))
    } else if (percent_change < 0) {
      return(paste0("Decrease of ", round(abs(percent_change), 2), "% from the previous year"))
    } else {
      return("No change from the previous year")
    }
  })
  
  output$selected_date_output <- renderText({
    paste("Date:", input$selected_date)
  })
  
 output$obesity_plot < renderPlot({
    ggplot(combined_df, aes(x = State, y = Obesity_Prevelance, fill = YearStart)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Obesity Rates per State from 2020 + 2022",
           x = "State", y = "Obesity Rate") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
}