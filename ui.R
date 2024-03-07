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
   h2("User Opinion"),
   
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
   tags$img(src = "https://landgeistdotcom.files.wordpress.com/2021/04/usa-obesity.png", height = 150, width = 250)
   

 )
 viz_1_main_panel <- mainPanel(
   h2("Correlation between Poverty and Obesity"),
   plotlyOutput(outputId = "obesity_poverty_plot"),
   
   h2("Data Analysis:"),
   p("This graph shows the correlation between Obesity rates and Poverty rates per state. Besides a few outliers, it's easy to identify the skew in the data. One can clearly observe that States that have higher poverty rates, tend to have much higher Obesity rates compared to States that have much lower poverty rates. Take Utah and West Virgina: Utah has an extremely low poverty rate AND an extremely low obesity rate. However, if you observe the State where over 15.5% of their population lives below the poverty line, West Virginia, you also observe that over 40% of their population is considered obese. It's also important to recognize the outliers such as Nebraska, Wisconsin,Minnesota, that have very high rates of obesity but relatively low rates of poverty. It's important to question if there are other factors that contribute to obesity rather than just poverty. For example, we could analyze these states against number of fast food restaurant within a 10 mile radius. Or perhaps we could analyze weather patterns in these States to compare cold weather to Obesity rates. Regardless of the outliers and multitude of possible explanations for Obesity rates in the USA, this data shows a high correlation between poverty rates and obesity percentages."),
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
  plotOutput(outputId = "obesity_year_plot"),
  h2("Data Analysis:"),
  p("This visualization shows the change in the average in obesity rates for the selected year and the year before. Most comaprisons have little to no change, but the biggest change would be from 2018 with a rate of 31.56% to 2019 with 31.64%. 
    The average obesity rate remains the same of around 31.56% for 2020-2022. This shows that time does not have a factor in obesity rates. A lack of barely any change in obesity rates in the United States over time, shows how this problem is persisent and not improving significantly. 
    This stagnation suggests that despite various public health iniatives and even the COVID-19 pandemic health crisis, the pandemic of Obesity in the United States rages on. This stagnation also goes to show just how embedded obesity is into the culture and society of the United States. 
    Based on the conclusion of our data, this could be caused due to lower-income populations having higher obesity rates and much lower rates of physical activity levels. This evidence inidicates that obesity is resistant to the passage of time and persistent through sever global health
    crises, which have highlighted the increased vulnerability and mortatlity risk of individuals with Obesity.")
)

viz_2_tab <- tabPanel("Over the Years",
  sidebarLayout(
    viz_2_sidebar,
    viz_2_main_panel
  )
)

## VIZ 3 TAB INFO
#Everlyn 
viz_3_sidebar <- sidebarPanel(
  sliderInput(inputId = "state_activity",
              h4("Which year do you think had the highest rate of 'No physical activity'"), 
              min = 2018, 
              max = 2022,
              value = 2019),
  # Dropdown for selecting years
  selectInput("years_selection", "Select the Years you're interested in to see data:",
              choices = unique(combined_df$YearStart),
              multiple = TRUE),
)

viz_3_main_panel <- mainPanel(
  h2("Physical Activity and Obesity"),
  plotlyOutput(outputId = "year_activity_plot"),
  h2("From the CDC:"),
  p("Only half of adults get the physical activity they need to help reduce and prevent chronic diseases, and more than 100 million have obesity.
       During 1999–March 2020, obesity prevalence increased from 31% to 42% for adults and from 14% to 20% for children and adolescents.\"
       For more information, visit the CDC website."),
  h2("Data Analysis:"),
  p("According to the CDC, physical activity is linked to a myriad of health benefits, including but not limited to reducing anxiety, improving sleep, and lowering blood pressure; further, it is shown to reduce the risk of type 2 diabetes, heart disease, and other cancers (1). Physical activity also helps prevent severe outcomes from COVID-19 (2).
    Early in the pandemic, uneven access to safe places for physical activity and shifting work–life demands may have exacerbated existing disparities in physical activity levels. These changes affected some people’s ability to be active more than others (3). For example, people who could access safe, walkable neighborhoods or who worked at home may have increased their physical activity. Understanding prevalence patterns of people who are physically inactive (or who participate in no leisure-time physical activity) before and during the pandemic can provide insight into who initiates any physical activity during large public health emergencies."),
  )

viz_3_tab <- tabPanel("Causal Pathway Analysis",
                      sidebarLayout(
                        viz_3_sidebar,
                        viz_3_main_panel,
                        )
)



## CONCLUSIONS TAB INFO
conclusion_tab <- tabPanel("Takeaways",
                  h1("Key Findings", align = "center"),
                  h3("We initially sought to answer the following questions:"),
                  p("What is the correlation between poverty and obesity in the United States?"),
                  p("What kind of impact did the pandemic have on the relationship between obesity and poverty?"),
                  p("Are there casual pathways and barreirs to physical activity that link poverty to reduced physical activity?"),
                  
                  h3("Our critical research questions aimed to identify:"),
                  p("A correlation between poverty and obesity in the United States"),
                  p("How the years 2018-2022, and the COVID-19 pandemic, affected low-income communities and what affect, if any, that had on Obesity rates in those areas"),
                  p("How the lack of access to fitness facilities impacts obesity rates"),
                  
                  
                  h3("Specific Takeaways:"),
                  p("West Virginia has the highest obesity rate (40.3% of their population classified as Obese) and 15.3% of their population lives below the poverty line"),
                  p("New Mexico has the highest poverty rate (18.3% of their population classified as under the poverty level) and 25.7% of their population is considered Obese"),
                  p("Mississipi has the highest level of people who perform little to no physical activity (31.2% of their population) and 34.8% of their population is considered obese (17.8% of their population lives below the poverty line"),
                  p("The greatest change in average obesity levels from 2018 to 2022 is between 2018 to 2019."),
                  p("The greatest change in average obesity levels from 2018 to 2022 is between 2018 to 2019. The average obesity rate is around 31.56% across the 4 years."),
                  
                  h3("Insights:"),
                  p("Insights from our research into the affect that Poverty has on Obesity is that besides a few outliers, it is very clear that high obestiy rates can be closely linked to high poverty rates in the United States. The interplay between obesity and poverty is rooted in various factors, including access to healthy foods, education levels, physical activity levels, and living environments. Lower-income communities often face greater challenges in accessing nutritious food options, contributing to higher rates of obesity. Moreover, our data analysis showed that these lower income communities often have limited access to safe spaces for physical activity, further compounding the issue of obesity in low income areas. We also wanted to analyze how the time has impacted the correlation between obesity and poverty. Taking to consideration of COVID-19, lockdowns and social distancing measures led to reduced physical activity and decrease in overall net income per family. Economic hardships intensified by the pandemic, especially in already low income communities, have made it much harder for people living in poverty to afford healthy food options or access fitness facilities. However, it looks like there was little to no correlation between time and obesity rates. State-by-State analysis also revealed that low physical activity rates are closely linked with higher obesity and poverty rates. States with lower socioeconomic status often report less access to recreational facilities, increasing the number of people per state who perform zero leisure physical activity. This relationship underscores the importance of public health strategies and policies that aim to increase physical activity levels across all socioeconomic levels."),                  
                  h3("Conclusion"),
                  p("In conclusion, while this data provides valuable insights ..., it is important to note that it is not entirely comprehensive and may not accurately reflect the full extent of the causations of obesity in the United States. However, even with the data present here, it is easy to draw the conclusion that there is a very serious epidemic in the United States in regards to health, obesity, and poverty. The years of 2018-2022 have shed light on the intricate relationship between obesity and poverty, with the COVID-19 pandemic playing a significant role in exacerbating these issues. Although we have highlighted a correlation between poverty, obesity, and lack of physical activity, it's important to address that obesity is a highly complex issue that is multifaceted by American culture, diet fads, mental health, healthcare access, and much more. Public health interventions must be tailored to address the specific needs of dispared communities that aren't given equitable access to resources that promote healthy lifestyles and combat the cycle of obesity and poverty."),
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
   viz_3_tab,
   conclusion_tab
)
