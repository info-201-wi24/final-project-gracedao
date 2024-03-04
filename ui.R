

## OVERVIEW TAB INFO

overview_tab <- tabPanel("Obesity in the United States",
   h1("Observing Obesity and Poverty Within the United States"),
   p("some explanation")
)

## VIZ 1 TAB INFO
#Brooke
 viz_1_sidebar <- sidebarPanel(
   h2("State Selector"),
   
   #Dynamic inputs for selecting State
   selectInput(inputId = "state_name", 
               label = "Enter the State you're interested in",
               choices = unique(combined_df$State), 
               selected = "Alabama", #automatic choice
               multiple = TRUE),
 
   #dynamic outputs for state_name
  # textOuput(outputId = "obesity_poverty_plot")
 )
 
 viz_1_main_panel <- mainPanel(
   h2("Correlation between Poverty and Obesity"),
    plotlyOutput(outputId = "obesity_poverty_plot")
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

# conclusion_tab <- tabPanel("Conclusion Tab Title",
#  h1("Some title"),
#  p("some conclusions")
# )



ui <- navbarPage("Example Project Title",
  overview_tab,
   viz_1_tab,
   viz_2_tab,
  # viz_3_tab,
  # conclusion_tab
)
