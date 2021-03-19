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

ggplot(data=top_cats, aes(x=category, y=freq_category)) +
  geom_bar(stat="identity", width=0.5) +
  theme_minimal() +
  xlab('Category') +
  ylab('Frequency of occurence') +
  theme(axis.text.x = element_text(angle = 90))

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

ggplot(data=top_cats_by_child, aes(x=category, y=(freq), fill=Child_ID)) +
  geom_bar(stat="identity", position=position_dodge()) +
  theme_minimal() +
  xlab('Category') +
  ylab('Frequency of occurence') +
  theme(axis.text.x = element_text(angle = 90))


# quantify power law fit
length_annotations = length(d_basic$basic_level)
basic_level_categories = (unique(d_basic$basic_level))
basic_level_all_formats = (unique(d_basic$basic_level_all_formats))

obj_freq = sort(table(d_basic$basic_level), desc=T)
pl_fit <- power.law.fit(obj_freq)

obj_freq_all_formats = sort(table(d_basic$basic_level_all_formats), desc=T)
pl_fit_formats <- power.law.fit(obj_freq_all_formats)

obj_freq_limited = sort(table(d_basic_limited$basic_level), desc=T)
pl_fit_limited <- power.law.fit(obj_freq_all_formats)


# separate dbasic by child and calculate power law
s_basic <- d_basic %>% 
  filter(child_id =="S")

s_basic_limited <- d_basic_limited %>% 
  filter(child_id =="S")

s_length_annotations = length(s_basic$basic_level)
s_basic_level_categories = (unique(s_basic$basic_level))
s_basic_level_all_formats = (unique(s_basic$basic_level_all_formats))

s_obj_freq = sort(table(s_basic$basic_level), desc=T)
s_pl_fit <- power.law.fit(s_obj_freq)

s_obj_freq_all_formats = sort(table(s_basic$basic_level_all_formats), desc=T)
s_pl_fit_formats <- power.law.fit(s_obj_freq_all_formats)

s_obj_freq_limited = sort(table(s_basic_limited$basic_level), desc=T)
s_pl_fit_limited <- power.law.fit(s_obj_freq_all_formats)

a_basic <- d_basic %>% 
  filter(child_id =="A")

a_basic_limited <- d_basic_limited %>% 
  filter(child_id =="A")


a_length_annotations = length(a_basic$basic_level)
a_basic_level_categories = (unique(a_basic$basic_level))
a_basic_level_all_formats = (unique(a_basic$basic_level_all_formats))

a_obj_freq = sort(table(a_basic$basic_level), desc=T)
a_pl_fit <- power.law.fit(a_obj_freq)

a_obj_freq_all_formats = sort(table(a_basic$basic_level_all_formats), desc=T)
a_pl_fit_formats <- power.law.fit(a_obj_freq_all_formats)

a_obj_freq_limited = sort(table(a_basic_limited$basic_level), desc=T)
a_pl_fit_limited <- power.law.fit(a_obj_freq_all_formats)

# make table with results

power_law_table <- tribble(
 ~name, ~all_frames, ~S, ~A,
  #--|--|--|----
 "Alpha for Original Categories", round(pl_fit$alpha,2),  round(s_pl_fit$alpha,2),  round(a_pl_fit$alpha,2), 
 "Alpha for Collapsed Categories",round(pl_fit_formats$alpha,2), round(s_pl_fit_formats$alpha,2), round(a_pl_fit_formats$alpha,2),
 "Alpha for Limited Categories", round(pl_fit_limited$alpha,2), round(a_pl_fit_limited$alpha,2), round(s_pl_fit_limited$alpha,2)
) %>% 
  column_to_rownames(var="name") %>% 
  rename(`All Frames` = all_frames, `Just S` = S, `Just A` = A)

formattable(power_law_table)

# export top categories
list_cats <- top_cats %>% 
  pull(basic_level)

# make a list of categories
d_top <- d_basic %>% 
  filter(basic_level %in% list_cats)

d_top %>% 
  transmute(image_url = public_url) %>% 
  write.csv(here::here('analysis/panoptic-segmentation/top_frames.csv'), row.names=FALSE)


