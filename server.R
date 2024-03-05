library(tidyverse)
library(ggplot2)
library(plotly)
library(shiny)
library(bslib)


#add newly created csv file here  Unified_dataset.csv
combined_df <- read.csv("Unified_dataset.csv")


server <- function(input, output) {
  #user inputing State they're interested in seeing --> output
  output$user_opinion <- renderText ({
    if(user_selection == 1) {
      "You think that obesity and poverty are correlated."
    } else if(user_selection == 2) {
      "You do not think that obesity and poverty are correlated."
    } else {
      "You are unsure if obesity and poverty are correlated."
    }
  })
  
  output$obesity_poverty_plot <- renderPlotly({
    
    selected_df <- combined_df %>% 
                   filter(State %in% input$state_name)
    obesity_poverty_plot <- ggplot(selected_df) +
                            geom_point(aes(x = Obesity_Prevelance,
                                           y = Poverty_Rate,
                                           color = State)) +
                                           labs(title = "Correlation between Poverty and Obesity", x = "Obesity Prevelance %", y = "Poverty Rate (%)")+
                                           theme_minimal()
        
        return(ggplotly(obesity_poverty_plot))
})
  


# server logic 
#SHOULD NOT BE DEFINING SERVER TWICE?
output$selected_date_output <- renderText({
  paste("Date Range: ", input$selected_date[1], " to ", input$selected_date[2])
})

# Render the plot based on the selected date range
output$obesity_plot <- renderPlot({
  # Filter the data frame based on the selected year range
  selected_df <- combined_df %>%
    filter(Year %in% seq(input$selected_date[1], input$selected_date[2]))

  # Compute the total obesity rate for the selected year range
  total_obesity_rate <- sum(selected_df$Obesity_Prevelance)

  # Compute the change in obesity rate from the previous year
  previous_year_data <- combined_df %>%
    filter(Year %in% (input$selected_date[1] - 1):(input$selected_date[2] - 1))
  if (nrow(previous_year_data) == 0) {
    percent_change <- NA
  } else {
    previous_year_obesity_rate <- sum(previous_year_data$Obesity_Prevelance)
    percent_change <- ((total_obesity_rate - previous_year_obesity_rate) / previous_year_obesity_rate) * 100
  }

  # Plot the data
  ggplot(selected_df, aes(x = State, y = Obesity_Prevelance, fill = as.factor(Year))) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(title = "Obesity Rates per State from 2018 to 2022",
         x = "State", y = "Obesity Rate") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    annotate("text", x = 1, y = 1, label = paste("Change from previous year:", ifelse(is.na(percent_change), "No data", percent_change)))
})
}
