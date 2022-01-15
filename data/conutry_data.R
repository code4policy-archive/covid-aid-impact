library(readxl)
library(tidyverse)
library(haven)
library(ggplot2) 
library(dplyr)
library(forcats)
library(tidyr)
install.packages("tidyr")

recent_data <- read_excel("Documents/HKS/DPI-691/Intern Aid Data/df_tab_viz.xlsx") %>% 
  filter(year_start == c(2018, 2019, 2020))

currencies <- read_csv(file = "/Users/nomko/Development/covid-aid-impact/data/FRB_H10.csv")

country_codes <- read_csv(file = "/Users/nomko/Development/covid-aid-impact/data/country_codes.csv")

currencies_long <- gather(currencies, currency, values, 'DKK':'USD', factor_key=TRUE)

currency_clean <-  merge(recent_data, currencies_long, by.x = c("year_start", "default_currency"), by.y=c("year", "currency")) %>% 
  mutate(commitment_in_usd = total_Commitment*values, 
         disbursement_in_usd = total_Disbursement*values)

merged_data <- merge(currency_clean, country_codes, by.x = c("recipient_country_code"), by.y=c("Alpha_2_code")) 
  
final <- merged_data %>% 
  select(year_start, recipient_country, commitment_in_usd, disbursement_in_usd, Alpha_3_code) %>% 
  group_by(recipient_country, year_start,Alpha_3_code) %>%
  summarise(commitments = sum(commitment_in_usd),
         disbursements = sum(disbursement_in_usd),
         projects = n()) 

commitments <- final %>% 
  select(year_start, recipient_country, commitments, Alpha_3_code) %>% 
  spread(year_start, commitments) %>% 
  drop_na()

disbursements <- final %>% 
  select(year_start, recipient_country, disbursements,Alpha_3_code) %>% 
  spread(year_start, disbursements) %>% 
  drop_na()

projects <- final %>% 
  select(year_start, recipient_country, projects,Alpha_3_code) %>% 
  spread(year_start, projects)

projects_trend <- projects %>% 
  filter(`2019`>=5) %>% 
  mutate(change_in_2020 = round((`2020`*100/`2019`)-100), 
         average_2018_2019 = (`2019`+`2018`)/2,
         change_from_average = round((`2020`*100/average_2018_2019)-100))

commitments_trend <- commitments %>% 
  mutate(change_in_2020 = round((`2020`*100/`2019`)-100), 
         average_2018_2019 = (`2019`+`2018`)/2,
         change_from_average = round((`2020`*100/average_2018_2019)-100))

disbursements_trend <- disbursements %>% 
  mutate(change_in_2020 = round((`2020`*100/`2019`)-100), 
         average_2018_2019 = (`2019`+`2018`)/2,
         change_from_average = round((`2020`*100/average_2018_2019)-100))

write.csv(projects_trend,"/Users/nomko/Development/covid-aid-impact/data/country_projects.csv", row.names = FALSE)



                                                             