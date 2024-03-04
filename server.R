library(ggplot2)
library(plotly)

#add newly created csv file here  Unified_dataset.csv
combined_df <- read.csv("/final-project-brookedietmeier/Unified_dataset.csv")
#unified or combined
server <- function(input, output){
  #user inputing State they're interested in seeing --> output
  output$obesity_poverty_plot <- renderPlotly({
    
    selected_df <- combined_df %>% filter(State %in% input$state_name)
    
    obesity_poverty_plot <- ggplot(selected_df) +
      geom_col(aes(x = Obesity_Prevelance,
                   # Reorder values
                   y = Poverty_Rate)) +
                   labs(title = "Correlation between Poverty and Obesity", x = "Obesity Prevelance Percentage", y = "Poverty Rate", color = "Year")
    
    return(ggplotly(obesity_poverty_plot))
})
  
}


#output$obesity_poverty_plot <- renderPlotly({ 
# combined_df <- unified
#  group_by(State) %>% 
# summarize(correlation between states)
#if(input$link_between_obesity_physical_activit) {
#  my_plot <- ggplot(combined)+
#            geom_point(mapping = aes(x = `Obesity Prevelance`, 
#                                     y = `Poverty Rate`,
#                                      fill = state))
#} else {
# my_plot <- ggplot(combined)+
#            geom_point(mapping = aes(x = `Obesity Prevelance`, 
#                                     y = Poverty_Rate))

#}
# return(ggplotly(my_plot))
#})


# server logic 
server <- function(input, output, session) {
  selected_data <- reactive({
    filter(combined_data, Year == input$selected_date)
  })
  
  total_obesity_rate <- reactive({
    sum(selected_data()$ObesityRate)
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
    ggplot(combined_df, aes(x = State, y = ObesityRate, fill = Year)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Obesity Rates per State from 2020 + 2022",
           x = "State", y = "Obesity Rate") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
}