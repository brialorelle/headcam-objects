library(tidyverse)
library(here)
library(ggthemes)
library(viridis)
library(egg)
library(igraph)
library(data.table)
library(dplyr)
library(formattable)
library(tidyr)

load(file = here::here('data/preprocessed_data/merged_annotations.RData'))

d_basic <- d %>%
  filter(!is.na(basic_level)) %>%
  mutate(age_group = cut(age_day_bin, c(5,12,18,34), labels = c('6-12m','12-18m','18-32m'))) %>%
  filter(!is.na(basic_level)) %>% 
  filter(!basic_level %in% c('no child hands','allocentric','no object','unknown object','no objects','no child')) %>%
  distinct(public_url, basic_level, child_id, age_days, age_day_bin, age_group) %>%
  ungroup() 


# to check relative to child in larger set
d_child_check <- d %>% 
  distinct(public_url, basic_level, child_id) 


# colllapse across 
d_basic <- d_basic %>%
  mutate(basic_level_all_formats = str_replace(basic_level, '-drawing','')) %>%
  mutate(basic_level_all_formats = str_replace(basic_level_all_formats, '-toy','')) 
d_basic_limited <- d_basic %>%
  filter(!basic_level %in% c('food','toy','book','person')) 


# get frequencies by category
freq_by_category <- d_basic %>%
  mutate(total_images = n()) %>%
  group_by(basic_level_all_formats)  %>%
  summarize(count = n(), total_images = total_images[1]) %>%
  mutate(freq_category = count/total_images) %>%
  ungroup() %>%
  mutate(category = fct_reorder(basic_level_all_formats, freq_category, .desc=TRUE)) %>% 
  arrange(desc(count))

top_cats <- freq_by_category %>% 
  rename(basic_level = basic_level_all_formats) %>% 
  filter(count>7, !basic_level=='person')

# get frequencies by category by child
freq_by_category_by_child <- d_basic %>%
  group_by(child_id) %>%
  mutate(count_frames = n())  %>%
  ungroup() %>%
  group_by(basic_level_all_formats, child_id) %>%
  dplyr::summarize(count_categories = n(), count_frames = count_frames[1]) %>%
  mutate(freq = count_categories / count_frames) %>%
  left_join(freq_by_category) %>%
  ungroup() %>%
  mutate(category = forcats::fct_reorder(category, freq_category, .desc=TRUE)) 

top_cats_by_child <- freq_by_category_by_child %>% 
  rename(Child_ID = child_id) %>% 
  rename(basic_level = basic_level_all_formats) %>% 
  filter(count_categories>7, !basic_level=='person')

# export top categories
list_cats <- top_cats %>% 
  pull(basic_level)

# make a list of categories
d_top <- d_basic %>% 
  filter(basic_level %in% list_cats)

d_top %>% 
  transmute(image_url = public_url) %>% 
  write.csv(here::here('analysis/panoptic-segmentation/top_frames.csv'), row.names=FALSE)


