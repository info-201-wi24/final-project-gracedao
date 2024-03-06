library(plotly)
library(shiny)
library(tidyverse)
library(bslib)

## OVERVIEW TAB INFO
combined_df <- read.csv("Unified_dataset.csv")
# Extract unique state names from the 'State' column
state_name <- unique(combined_df$State)

# Filter the data frame based on the predefined state names
selected_df <- combined_df %>% 
  filter(State %in% state_name)

overview_tab <- tabPanel("Introduction",
                         h1("Exploring the Dynamics of Poverty and Obesity in the United States", align = "center"),
                         h3("Project Overview"),
                         p("This project investigates the relationship between poverty/wealth and obesity in the United States. Through analysis of combined data from the Nutrition, Physical Activity, and Obesity Behavioral Risk Factor Surveillance System provided by the U.S. Department of Health & Human Services and National Obesity by State published by the CDC, we aim to shed light on several critical questions surrounding this topic."),
                         
                         h3("Key Questions:"),
                         p("Correlation Between Poverty and Obesity: We seek to understand the strength of the correlation between poverty and obesity nationwide. Additionally, we explore how the variance in this relationship varies across different states."),
                         p("Impact of the Pandemic: How has the relationship between poverty and obesity rates evolved from 2020 during the pandemic to 2022, after the pandemic? This inquiry delves into the potential effects of the pandemic on these societal issues."),
                         p("Causal Pathway and Barriers to Physical Activity: Is there a causal pathway linking poverty to reduced leisure physical activity and increased obesity rates? We will examine potential barriers to physical activity in low-income areas or states, such as lack of access to recreational spaces or job constraints."),
                         
                         h3("Data Sources and Ethical Considerations"),
                         p("Our analysis takes data from the Nutrition, Physical Activity, and Obesity Behavioral Risk Factor Surveillance System provided by the U.S. Department of Health & Human Services and the National Obesity by State dataset published by the CDC. While these datasets offer valuable insights, it is crucial to acknowledge potential ethical questions and limitations. Issues such as data privacy, biases inherent in survey data collection, and representativeness of the sample are a few issues to think about."),
          tags$img(src = "https://landgeistdotcom.files.wordpress.com/2021/04/usa-obesity.png", height = 600, width = 800)
)

## VIZ 1 TAB INFO
#Brooke

 viz_1_sidebar <- sidebarPanel(
   h2("User opinion"),
   
   #what state they think has the highest correlation
   radioButtons(inputId = "user_opinion", 
                label= h4("Do you think that obesity and poverty are correlated?"),
                choices = list("Yes" = 1,
                               "No" = 2, 
                               "Don't know" = 3),
                selected = 3),
   
   h2("State Selector"),
   #Dynamic inputs for selecting State
   selectInput(inputId = "state_name", 
               label = "Enter the State you're interested in",
               choices = selected_df$State, 
               selected = "Alabama", #automatic choice
               multiple = TRUE),

 )
 viz_1_main_panel <- mainPanel(
   h2("Correlation between Poverty and Obesity"),
   plotlyOutput(outputId = "obesity_poverty_plot"),
 )
 
 viz_1_tab <- tabPanel("Obesity and Poverty Per State",
   sidebarLayout(
     viz_1_sidebar,
     viz_1_main_panel
   )
 )
 
 
## VIZ 2 TAB INFO
#Grace 
viz_2_sidebar <- sidebarPanel(
  h2("Options for graph"),
  selectInput(inputId = "selected_date",
              label = "Select a Year Range",
              choices = unique(selected_df$YearStart), 
              selected = "2018"),
)

viz_2_main_panel <- mainPanel(
  h2("Relationship between Poverty and Obesity Rates"),
  h1("Date: "),
  textOutput("selected_date_output"),
  plotOutput(outputId = "obesity_plot"),
  p("This visualization shows the change in the average in obesity rates for the selected year and the year before. Most comaprisons have little to no change, but the biggest change would be from 2018 with a rate of 31.56 to 2019 with 31.64. The average obesity rate remains the same of around 31.56 for 2020-2022. This shows that time does not have a factor in obesity rates.")

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
conclusion_tab <- tabPanel("Takeaways",
                  h2("Key Findings"),
                  h3("We initially sought to answer the following questions:"),
                  p("What is the correlation between poverty and obesity in the United States?"),
                  p("What kind of impact did the pandemic have on the relationship between obesity and poverty?"),
                  p("Are there casual pathways and barreirs to physical activity that link poverty to reduced physical activity?"),
                  
                  h3("Our critical research questions aimed to identify:"),
                  p("some text"),
                  
                  
                  h2("Specific Takeaways:"),
                  p("West Virginia has the highest obesity rate (40.3% of their population classified as Obese) and 15.3% of their population lives below the poverty line"),
                  p("New Mexico has the highest poverty rate (18.3% of their population classified as under the poverty level) and 25.7% of their population is considered Obese"),
                  p("Mississipi has the highest level of people who perform little to no physical activity (31.2% of their population) and 34.8% of their population is considered obese (17.8% of their population lives below the poverty line"),
                  p("The greatest change in average obesity levels from 2018 to 2022 is between 2018 to 2019."),
                  p("Otherwise, time does not have a large factor in the increase or decrease of obesity rates."),
                  
                  h3("Insights:"),
                  p("Insights from our research into the affect that Poverty has on Obesity is that.. "),
                  
                  h2("Conclusion"),
                  p("In conclusion, while this data provides valuable insights ..., it is important to note that it is not entirely comprehensive and may not accurately reflect the full extent of the causations of obesity in the United States. However, even with the data present here, it is easy to draw the conclusion that there is a very serious epidemic in the United States in regards to health, obesity, and poverty."),
)

 my_theme <- bs_theme(bg = "#2f716c",
                      fg = "white", 
                      primary = "#bce3e0")
 my_theme <- bs_theme_update(my_theme, bootswatch = "flatly")


ui <- navbarPage(
  theme = my_theme,
  "Obesity in The United States",
   overview_tab,
   viz_1_tab,
   viz_2_tab,
  # viz_3_tab,
   conclusion_tab
)
