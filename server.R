library(tidyverse)
library(ggplot2)
library(plotly)
library(shiny)
library(bslib)


#add newly created csv file here  Unified_dataset.csv
combined_df <- read.csv("Unified_dataset.csv")


server <- function(input, output) {
  #Brooke Visualization One
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
  


# Grace visualization 2 
  output$selected_date_output <- renderText({
    paste("Date Range: ", as.numeric(input$selected_date[1]) - 1, " to ", input$selected_date[1])
  })

# Render the plot based on the selected date range
  output$obesity_year_plot <- renderPlot({
    combined_df <- combined_df[complete.cases(combined_df$Obesity_Prevelance), ]
    selected_date_output <- input$selected_date[1]
    
    selected_df <- filter(combined_df, combined_df$YearStart == input$selected_date)
  
    # Compute the total obesity rate for the selected year range
    avg_obesity_rate <- mean(selected_df$Obesity_Prevelance, na.rm = TRUE)
  
    # Compute the change in obesity rate from the previous year
    if (input$selected_date == "2018") {
      previous_year <- 2018
    } else {
      # If selected year is greater than 2018, get data for the previous year
      previous_year <- as.numeric(input$selected_date[1]) - 1
    }
    
    previous_year_df <- filter(combined_df, combined_df$YearStart == previous_year)
    avg_previous_year_obesity_rate <- mean(previous_year_df$Obesity_Prevelance, na.rm = TRUE)
    
    plot_df <- data.frame(
      Year = factor(c(input$selected_date[1], previous_year)), 
      Average_Obesity_Rate = c(avg_obesity_rate, avg_previous_year_obesity_rate)
    )
  
    # Plot the data
    obesity_year_plot <- ggplot(plot_df, aes(x = factor(Year), y = Average_Obesity_Rate, fill = factor(Year))) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Comparison of Average Obesity Rate",
           x = "Year", y = "Average Obesity Rate (%)") +
      theme_minimal()
      return((ggplotly(obesity_year_plot)))
  })
}

#Everlyn Visualization 3
# Causal pathway
# output$causal_pathway <- renderText({
#   if (input$causal_pathway == "yes") {
#     "You are correct!"
#   } else if (input$causal_pathway == "no") {
#     "You are incorrect!"
#   } else {
#     "Please select an option."
#   }
# })
# #
# # # Render the line graph for obesity and poverty
# output$obesity_poverty_line_plot <- renderPlot({
# #   # using obesity_poverty_df
#   ggplot(obesity_poverty_df, aes(x = State)) +
#     geom_line(aes(y = Poverty_Rate, color = "Poverty Rate")) +
#     geom_line(aes(y = Obesity_Prevalence, color = "Obesity Prevalence")) +
#     labs(x = "State", y = "Rate (%)", color = "Variable") +
#     scale_color_manual(values = c("Poverty Rate" = "blue", "Obesity Prevalence" = "red")) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
# })