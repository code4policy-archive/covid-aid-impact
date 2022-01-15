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

currencies_long <- gather(currencies, currency, values, 'DKK':'USD', factor_key=TRUE)

merged_data <-  merge(recent_data, currencies_long, by.x = c("year_start", "default_currency"), by.y=c("year", "currency")) %>% 
  mutate(commitment_in_usd = total_Commitment*values, 
         disbursement_in_usd = total_Disbursement*values)

final <- merged_data %>% 
  select(year_start, recipient_country, commitment_in_usd, disbursement_in_usd) %>% 
  group_by(recipient_country, year_start) %>%
  summarise(commitments = sum(commitment_in_usd),
         disbursements = sum(disbursement_in_usd),
         projects = n()) 

commitments <- final %>% 
  select(year_start, recipient_country, commitments) %>% 
  spread(year_start, commitments) %>% 
  drop_na()

disbursements <- final %>% 
  select(year_start, recipient_country, disbursements) %>% 
  spread(year_start, disbursements) %>% 
  drop_na()

projects <- final %>% 
  select(year_start, recipient_country, projects) %>% 
  spread(year_start, projects) %>% 
  drop_na()

projects_trend <- projects %>% 
  filter(`2019`>=5) %>% 
  mutate(change_in_2020 = round((`2020`*100/`2019`)-100), 
         average_2018_2019 = (`2019`+`2018`)/2,
         change_from_average = round((`2020`*100/average_2018_2019)-100))




                                                             