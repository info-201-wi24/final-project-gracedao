

## OVERVIEW TAB INFO

overview_tab <- tabPanel("Obesity in the United States",
                         h1("Exploring the Dynamics of Poverty and Obesity in the United States", align = "center"),
                         h3("Project Overview"),
                         p("This project investigates the relationship between poverty/wealth and obesity in the United States. Through analysis of combined data from the Nutrition, Physical Activity, and Obesity Behavioral Risk Factor Surveillance System provided by the U.S. Department of Health & Human Services and National Obesity by State published by the CDC, we aim to shed light on several critical questions surrounding this topic."),
                         
                         h3("Key Questions:"),
                         p("Correlation Between Poverty and Obesity: We seek to understand the strength of the correlation between poverty and obesity nationwide. Additionally, we explore how the variance in this relationship varies across different states."),
                         p("Impact of the Pandemic: How has the relationship between poverty and obesity rates evolved from 2020 during the pandemic to 2022, after the pandemic? This inquiry delves into the potential effects of the pandemic on these societal issues."),
                         p("Causal Pathway and Barriers to Physical Activity: Is there a causal pathway linking poverty to reduced leisure physical activity and increased obesity rates? We will examine potential barriers to physical activity in low-income areas or states, such as lack of access to recreational spaces or job constraints."),
                         
                         h3("Data Sources and Ethical Considerations"),
                         p("Our analysis takes data from the Nutrition, Physical Activity, and Obesity Behavioral Risk Factor Surveillance System provided by the U.S. Department of Health & Human Services and the National Obesity by State dataset published by the CDC. While these datasets offer valuable insights, it is crucial to acknowledge potential ethical questions and limitations. Issues such as data privacy, biases inherent in survey data collection, and representativeness of the sample are a few issues to think about.")
)

## VIZ 1 TAB INFO
#Brooke
viz_1_main_panel <- mainPanel(
  h2("Correlation between Poverty and Obesity"),
  plotlyOutput(outputId = "obesity_poverty_plot"),
)

 viz_1_sidebar <- sidebarPanel(
   h2("State Selector"),
   
   #Dynamic inputs for selecting State
   selectInput(inputId = "state_name", 
               label = "Enter the State you're interested in",
               choices = selected_df$State, 
               selected = "Alabama", #automatic choice
               multiple = TRUE),
 
   #dynamic outputs for state_name
   #textOuput(outputId = "You have selected: ")
 )
 
 
 viz_1_tab <- tabPanel("Obesity and Poverty Per State",
   sidebarLayout(
     viz_1_main_panel,
     viz_1_sidebar
   )
 )
 
 
## VIZ 2 TAB INFO
#Grace 
viz_2_sidebar <- sidebarPanel(
  h2("Options for graph"),
  dateInput(inputId = "selected_date",
            label = "Select a Date",
            min = as.Date("2020-01-01"),  # Set min date to January 1, 2020
            max = as.Date("2022-12-31"),  # Set max date to December 31, 2022
            value = as.Date("2022-01-01"))
)

viz_2_main_panel <- mainPanel(
  h2("Relationship between Poverty and Obesity Rates"),
  h1("Date: "),
  textOutput("selected_date_output"),
  plotOutput(outputId = "obesity_poverty_plot")
  
)

viz_2_tab <- tabPanel("Over the Years",
  sidebarLayout(
    viz_2_sidebar,
    viz_2_main_panel
  )
)

## VIZ 3 TAB INFO
#Everlyn 
# viz_3_sidebar <- sidebarPanel(
#   h2("Options for graph"),
#   #TODO: Put inputs for modifying graph here
# )
# 
# viz_3_main_panel <- mainPanel(
#   h2("Vizualization 3 Title"),
#   # plotlyOutput(outputId = "your_viz_1_output_id")
# )
# 
# viz_3_tab <- tabPanel("Viz 3 tab title",
#   sidebarLayout(
#     viz_3_sidebar,
#     viz_3_main_panel
#   )
# )


## CONCLUSIONS TAB INFO
 conclusion_tab <- tabPanel("Conclusion",
  h1("Conclusion for Obesity prevelance in the United States from 2020 to 2022"),
  p("some conclusions")
 )



ui <- navbarPage("Example Project Title",
  overview_tab,
   viz_1_tab,
   viz_2_tab,
  # viz_3_tab,
  # conclusion_tab
)
