library(tidyverse)
library(ggplot2)
library(plotly)
library(shiny)


#add newly created csv file here  Unified_dataset.csv
combined_df <- read.csv("Unified_dataset.csv")


server <- function(input, output) {
  #user inputing State they're interested in seeing --> output
  output$obesity_poverty_plot <- renderPlotly({
    
    selected_df <- combined_df %>% 
                   filter(State %in% input$state_name)
    
    obesity_poverty_plot <- ggplot(selected_df) +
                            geom_point(aes(x = Obesity_Prevelance,
                                           y = Poverty_Rate)) +
                                           labs(title = "Correlation between Poverty and Obesity", x = "Obesity Prevelance %", y = "Poverty Rate (%)" )+
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
 
 ##conclusion
 output$Takeaways <- renderUI({
   HTML("<h2>Key Findings</h2>
          <h4>We initially sought to answer the following questions:</h4>
          <ul>
            <li>What is the correlation between poverty and obesity in the United States?</li>
            <li>What kind of impact did the pandemic have on the relationship between obesity and poverty?</li>
            <li>Are there casual pathways and barreirs to physical activity that link poverty to reduced physical activity?</li>
          </ul>
          <p>Our critical research questions aimed to identify ... </p>
          <h2>Specific Takeaways</h2>
          <ul>
            <li>West Virginia has the highest obesity rate (<b>40.3% of their population classified as Obese</b>) and 15.3% of their population lives below the poverty line</li>
            <li>New Mexico has the highest poverty rate (<b>18.3% of their population classified as under the poverty level</b>) and 25.7% of their population is considered Obese</li>
            <li>Mississipi has the highest level of people who perform little to no physical activity (<b>31.2% of their population</b>) and 34.8% of their population is considered obese (<b>17.8% of their population lives below the poverty line</b>)</li>
            <li>The State that had the greatest change in obesity levels from 2020 to 2022 is (<b></b>).</li>
          </ul>
          <p>Insights from our research into the affect that Poverty has on Obesity is that.. .</p>
          <p>In conclusion, while this data provides valuable insights ..., it is important to note that it is not entirely comprehensive and may not accurately reflect the full extent of the causations of obesity in the United States. However, even with the data present here, it is easy to draw the conclusion that there is a very serious epidemic in the United States in regards to health, obesity, and poverty. </p>")
 })
}