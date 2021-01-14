## libraries
library(here)
library(janitor)
library(tidyverse)
library(readxl)
library(ggplot2)
library(ggthemes)

# read in csvs

nlabeledImages <- read.csv(file='naitiHandsObjLabeled.csv')
nlabeledImages <- as_tibble(nlabeledImages)

blabeledImages <- read.csv(file='briaHandsObjLabeled.csv')
blabeledImages <- as_tibble(blabeledImages)

# join csvs
labeledImages <- full_join(nlabeledImages, blabeledImages)

# retrieve counts
count_by_category <- labeledImages %>%
  filter(!label %in% c('no child hands','allocentric')) %>%
  mutate(total_images = length(url)) %>%
  group_by(label) %>%
  summarize(count = n(), Frequency = count / total_images) %>%
  ungroup() %>%
  mutate(label = fct_reorder(label, Frequency, .desc=TRUE)) 
 

# plot
ggplot(data=count_by_category, aes(x=label, y=Frequency)) +
  geom_point() +
  theme_few(base_size=10) +
  theme(axis.text.x = element_text(angle = 90, vjust = .5, hjust=1)) +
  xlab('')  +
  ylim(0,.3)

# retrieve higher frequencies only
top_freqs <- count_by_category %>%
  filter(!label %in% c('no object','unknown object')) %>%
  filter(!(Frequency < 0.001))

# plot top frequencies
ggplot(data=top_freqs, aes(x=label, y=Frequency)) +
  geom_point() +
  theme_few(base_size=10) +
  theme(axis.text.x = element_text(angle = 90, vjust = .5, hjust=1)) +
  xlab('')  +
  ylim(0,.3)
