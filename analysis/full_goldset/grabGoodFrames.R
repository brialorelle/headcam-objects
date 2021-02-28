# load packages
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)
library(rjson)
library(here)
library(lubridate)
library(magick)
library(ggthemes)


# load preprocessed data
load(file = here::here('data/preprocessed_data/goldset_category_annotations.RData'))

# load frames that are usable
filtered_by_image <-  d %>%
  select(public_url, age_days, age_day_bin, child_id, category, conf) %>%
  spread(key = category, value=conf) %>% 
  filter(is.na(Nothing))  %>% 
  filter(is.na(Other))

# just frames with people
people_images <- filtered_by_image %>% 
  filter(!is.na(Person))

# get image urls only and output to csv
interesting_image_urls <- filtered_by_image %>% 
  select(public_url) %>% 
  transmute(image_url = public_url)
write.csv(interesting_image_urls, here::here('goldset_to_annotate.csv'), row.names = FALSE)


# choose 500 random interesting images
interesting_few <- interesting_image_urls %>% 
  sample_n(500)
write.csv(interesting_few, here::here('goldset_sample_annotate.csv'), row.names = FALSE)


# just images with people
person_image_urls <- people_images %>% 
  select(public_url) %>% 
  transmute(image_url = public_url)
write.csv(person_image_urls, here::here('people_goldset.csv'), row.names = FALSE)

# choose 500 random person images
people_few <- person_image_urls %>% 
  sample_n(500)
write.csv(people_few, here::here('analysis/full_goldset/person_sample_annotate.csv'), row.names = FALSE)


# read in category names
dat = read.table(here::here("categories.txt"), sep="\n")

# read in all hands annotations
load(file = here::here('data/annotations/faces_hands/child_adult_hand_annotations_by_frame.RData'))

df = read.csv(here::here('data/annotations/faces_hands/turk_segmentations_hands_only_processed.csv'))

d_hands <- df  %>% 
  select(label, full_image_path) %>% 
  filter(grepl('hand', label)) %>% 
  transmute(image_url = full_image_path)



