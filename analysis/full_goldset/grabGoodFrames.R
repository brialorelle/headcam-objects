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
  filter(is.na(Nothing))


dat = read.table(here::here("categories.txt"), sep="\n")
