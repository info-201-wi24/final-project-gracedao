library(ggplot2)
library(plotly)

#add newly created csv file here  Unified_dataset.csv
combined_df <- read.csv(~/final-project-brookedietmeier/Unified_dataset.csv)
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