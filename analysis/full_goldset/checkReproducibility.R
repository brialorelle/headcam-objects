library(tidyverse)
library(rjson)
library(here)
library(lubridate)
library(magick)
library(ggthemes)
library(dplyr)
library(tidyr)
library(RCurl)

g <- getURL("https://raw.githubusercontent.com/brialorelle/headcam-objects/master/data/annotations/basic_level_manual/georgeHandsObjLabeled.csv")
gLabels <- read.csv(text=g)
gLabels <- as_tibble(gLabels)

n = getURL("https://raw.githubusercontent.com/brialorelle/headcam-objects/master/data/annotations/basic_level_manual/reproducibleHandsObjLabeled.csv")
nLabels <- read.csv(text=n)
nLabels <- as_tibble(nLabels)

gCompare <- gLabels %>% 
  filter(url %in% nLabels$url)

nCompare <- nLabels %>% 
  filter(url %in% gCompare$url)

comparisonTable <- gCompare %>% 
  mutate(gLabel = label, .keep="unused") %>% 
  mutate(nLabel = nCompare$label)  %>% 
  mutate(basic_level = str_replace(basic_level, '-book','-drawing'))

sameComp <- comparisonTable %>% 
  rowwise() %>% 
  filter(grepl(nLabel,gLabel))
diffComp <- comparisonTable %>% 
  rowwise() %>% 
  filter(!grepl(nLabel,gLabel))


