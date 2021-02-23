library(tidyverse)
library(here)
library(ggthemes)
library(viridis)
library(egg)
library(igraph)

load(file = here::here('data/preprocessed_data/merged_annotations.RData'))
d_basic <- d %>%
  filter(!is.na(basic_level)) %>%
  mutate(age_group = cut(age_day_bin, c(5,12,18,34), labels = c('6-12m','12-18m','18-32m'))) %>%
  filter(!basic_level %in% c('no child hands','allocentric','no object','unknown object','no objects','no child')) %>%
  distinct(public_url, basic_level, child_id, age_days, age_day_bin, age_group) %>%
  ungroup() 

# to check relative to age distribution in larger set
d_age_check <- d %>%
  distinct(public_url, basic_level, child_id, age_days) 

# colllapse across 
d_basic <- d_basic %>%
  mutate(basic_level_all_formats = str_replace(basic_level, '-drawing','')) %>%
  mutate(basic_level_all_formats = str_replace(basic_level_all_formats, '-toy','')) 

d_basic_limited <- d_basic %>%
  filter(!basic_level %in% c('food','toy','book','person')) 


count_by_category <- d_basic %>%
  group_by(basic_level)  %>%
  summarize(count = length(public_url)) %>%
  arrange(desc(count))
