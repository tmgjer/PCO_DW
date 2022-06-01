#PCO
#Author: Thijmen Jeroense

#DW2
#create a plot file for DW2
library(tidyverse)
library(haven)
library(countrycode)

#import data
wvs <- read_sav("data/data-raw/WVS_files/WVS_TimeSeries_spss_v1_6.sav")

#
wvs_aggregated <- read_sav("data/data-raw/WVS_files/wvs_aggregated_postmat.sav")

#keep distinct records
wvs_agg_unique <- wvs_aggregated %>%
  distinct()

wvs_agg_netherlands <- wvs_agg_unique %>%
  filter(S003 == 528) %>%
  select(-S017) %>%
  distinct()

wvs_netherlands <- wvs %>%
  filter(S003 == 528) %>%
  distinct()

wvs_agg_netherlands %>%
  ggplot(aes(y = postmat_cy, x = S020)) +
  geom_col() +
  theme_minimal() +
  scale_x_continuous()




cy_selection <- wvs_agg_unique %>% 
  select(postmat_cy, S002, S003) %>%
  distinct() %>%
  mutate(country = countrycode(S003, origin = "iso3n", destination = "country.name"))

cy_selection %>%
  filter(S002 == 3) %>%
  mutate(country_fac = as.factor(country),
         country_fac = fct_reorder(.f = country_fac, .x = postmat_cy)) %>%
  filter(country_fac != "Colombia") %>%
  ggplot(aes(x = country_fac, y = postmat_cy)) +
  geom_col() +
  labs(x = "Country", y = "Postmaterialism score", title = "Postmaterialism score by country (1994-1998)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90))

cy_selection %>%
  filter(S002 == 3) %>%
  mutate(country_fac = as.factor(country),
         country_fac = fct_reorder(.f = country_fac, .x = postmat_cy),
         label = paste0(round(postmat_cy,2), "%"), hjust = 3.5) %>%
  filter(country_fac != "Colombia") %>%
  ggplot(aes(y = country_fac, x = postmat_cy)) +
  geom_col() +
  #geom_text(aes(label = label), size = 3, colour = "red")
  labs(y = "Country", x = "Postmaterialism score", title = "Postmaterialism score by country (1994-1998)") +
  theme_minimal()

cy_selection %>%
  filter(S002 == 3) %>%
  mutate(country_fac = as.factor(country),
         country_fac = fct_reorder(.f = country_fac, .x = postmat_cy),
         label = paste0(round(postmat_cy,2), "%"), hjust = 3.5) %>%
  filter(country_fac != "Colombia") %>%
  ggplot(aes(y = country_fac, x = postmat_cy, fill = postmat_cy)) +
  geom_col() +
  #geom_text(aes(label = label), size = 3, colour = "red")
  labs(y = "Country", x = "Postmaterialism score", title = "Postmaterialism score by country (1994-1998)") +
  theme_minimal()
  
