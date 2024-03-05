library(dplyr)
library(stringr)
library(readr)

# Loads in your datasets
obesity_df <- read.csv("2022-white.csv") 
poverty_df <- read.csv("poverty_state_grid_table.csv", skip = 3, header = TRUE)
nutrition_df <- read.csv("Nutrition__Physical_Activity__and_Obesity_-_Behavioral_Risk_Factor_Surveillance_System.csv")

#nutrition 
nutrition_df <- nutrition_df %>% 
  filter(YearStart >= 2018 & YearStart <= 2022) %>%
  select(YearStart, LocationDesc, Question, Data_Value) 

nutrition_df <- nutrition_df %>%
  filter(Question == "Percent of adults who engage in no leisure-time physical activity")

#change name of nutrition_df column from 'LocationDesc' to 'State'
nutrition_df <- nutrition_df %>% 
  rename(State = LocationDesc)

#keep all columns up to the one just before "Margin of Error"
poverty_df <- poverty_df %>%
  select(1:which(names(poverty_df) == "Margin.of.error1......") - 1)

obesity_df <- obesity_df %>%
  select(1:which(names(obesity_df) == "X95..CI") - 1)

#join poverty and obesity datasets
obesity_poverty_df <- inner_join(poverty_df, obesity_df, by = "State")

#rename column names to properly identify data in joined dataset 
obesity_poverty_df <- obesity_poverty_df %>% 
  rename(Poverty_Rate = Rate)

obesity_poverty_df <- obesity_poverty_df %>% 
  rename(Obesity_Prevelance = Prevalence)

#create combined_df to join datasets
combined_df <- inner_join(obesity_poverty_df, nutrition_df, by = "State")

#clean out NA values in Data_values
combined_df <- combined_df %>% 
              filter(!is.na(Data_Value))

#Take average of Data values per state for no physical activity 
average_activity_per_state <- combined_df%>%
                              group_by(State) %>%
                              summarise(Average_No_Physical_Activity = mean(Data_Value, na.rm = TRUE))

#Clean dataset and inlcude only certain columns
combined_df<- combined_df %>%
              left_join(average_activity_per_state, by = "State") %>% 
              distinct(State, YearStart, Poverty_Rate, Obesity_Prevelance, Average_No_Physical_Activity, .keep_all = TRUE)


combined_df$Data_Value <- NULL
combined_df$Question <- NULL

#make obesity_prevelance a number instead of characters: 

combined_df <- combined_df %>%
  mutate(Obesity_Prevelance = parse_number(Obesity_Prevelance))

#Key Takeaways
highest_obesity <- combined_df %>%
  group_by(State) %>%
  summarise(AverageObesityRate = mean(Obesity_Prevelance, na.rm = TRUE)) %>%
  arrange(desc(AverageObesityRate)) %>%
  slice(1)
print(highest_obesity)

highest_poverty <- combined_df %>%
  group_by(State) %>%
  summarise(AveragePovertyRate = mean(Poverty_Rate, na.rm = TRUE)) %>%
  arrange(desc(AveragePovertyRate)) %>%
  slice(1)
print(highest_poverty)

highest_no_physical <- combined_df %>%
  group_by(State) %>%
  summarise(AverageActivityRate = mean(Average_No_Physical_Activity, na.rm = TRUE)) %>%
  arrange(desc(AverageActivityRate)) %>%
  slice(1)
print(highest_no_physical)

#save unified dataset to a new file 
write.csv(combined_df, "Unified_dataset.csv", row.names = FALSE)

