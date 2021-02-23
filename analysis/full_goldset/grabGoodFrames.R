# load packages
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)
library(rjson)
library(here)
library(lubridate)
library(magick)
library(ggthemes)


# load preprocessed data
load(file = here::here('headcam-objects/data/preprocessed_data/goldset_category_annotations.RData'))

# load frames that are usable
filtered_by_image <-  d %>%
  select(public_url, age_days, age_day_bin, child_id, category, conf) %>%
  spread(key = category, value=conf) %>% 
  filter(is.na(Nothing)) %>% 
  filter(is.na(Other))

interesting_image_urls <- filtered_by_image %>% 
  select(public_url) %>% 
  transmute(image_url = public_url)

write.csv(interesting_image_urls, here::here('goldset_to_annotate.csv'), row.names = FALSE)

# choose 500 random interesting images
interesting_few <- interesting_image_urls %>% 
  sample_n(500)
write.csv(interesting_few, here::here('goldset_sample_annotate.csv'), row.names = FALSE)

# read in category names
dat = read.table(here::here("categories.txt"), sep="\n")
