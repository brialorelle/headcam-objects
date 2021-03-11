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
  mutate(total_images = n()) %>%
  group_by(basic_level)  %>%
  summarize(count = length(public_url), total_images = total_images[1]) %>%
  mutate(Freq = count/total_images) %>%
  ungroup() %>%
  mutate(basic_level = fct_reorder(basic_level, Freq, .desc=TRUE)) %>% 
  arrange(desc(count))

top_cats <- count_by_category %>% 
  filter(count>6, !basic_level=='person')

list_cats <- top_cats %>% 
  pull(basic_level)

# make a list of categories
d_top <- d_basic %>% 
  filter(basic_level %in% list_cats)

d_top %>% 
  transmute(image_url = public_url) %>% 
  write.csv(here::here('analysis/panoptic-segmentation/top_category_frames.csv'), row.names=FALSE)

