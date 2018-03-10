########################################################################################################
# Author:                                                                                              #
# Yunbin Peng                                                                                          #
#                                                                                                      #
# Software:                                                                                            #
# R                                                                                                    #
#                                                                                                      #
# Data:                                                                                                #
# Listing of Active Businesses                                                                         #
# https://data.lacity.org/A-Prosperous-City/Listing-of-Active-Businesses/6rrh-rzua                     #
# Business Closures 20130701 - Present                                                                 #
# https://data.lacity.org/A-Prosperous-City/Business-Closures-20130701-Present/sg5j-gp4v               #
#                                                                                                      #
# Description:                                                                                         #
# This script use dplyr package to make count of business entities for each business sectors for       #    
# currently open businesses and closed businesses since 2013. Then percentage of closures for each     #
# business type is computed.                                                                           #
########################################################################################################

# load packages  
library(readr)
library(dplyr)

# read data set for closures
closure = read_csv("Business_Closures_20130701_-_Present.csv")
# save(closure, file = "closure.RData")

# load data set for closures
# load("closure.RData")

# get count of closures for different NAICS category
close = closure %>%
  # remove closures with no NAICS category
  filter(!is.na(NAICS)) %>%
  # group by NAICS code and category
  group_by(NAICS, `PRIMARY NAICS DESCRIPTION`) %>%
  # get count data
  summarise(close_count = n())

# read data set for active business
active <- read_csv("Listing_of_Active_Businesses.csv")
# save(active, file = "active.RData")

# load data set for active business
# load("active.RData")

# get count of active business for different NAICS category
open = active %>%
  # remove closures with no NAICS category
  filter(!is.na(NAICS)) %>%
  # group by NAICS code and category
  group_by(NAICS, `PRIMARY NAICS DESCRIPTION`) %>%
  # get count data
  summarise(open_count = n())


# join dataset for open and closed business
# fill missing value with 0
full = full_join(open, close, by = c("NAICS", 'PRIMARY NAICS DESCRIPTION')) %>%
  replace_na(list(open_count = 0, close_count = 0))

# compute total count of business by categories
full.out = full %>%
  ungroup %>%
  mutate(total_count = open_count + close_count)

# compute percentage of business closed (for type of business with >= 100 entities)
close_percent = full.out %>%
  mutate(percent_close = round(close_count/total_count*100,2)) %>%
  select("Category" = `PRIMARY NAICS DESCRIPTION`, total_count, percent_close) %>%
  arrange(desc(percent_close)) %>%
  filter(total_count >= 100)

# print table 1 for close %
close.out = close_percent %>%
  select(Category, total_count, percent_close)

# find categories with smaller % of closures
evergreen = close_percent %>%
  arrange(percent_close)

# print table 2 for evergreen business
evergreen.out = evergreen %>%
  select(Category, total_count, percent_close)

# save data set that needed 
save(close.out, file = "close_rank.RData")
save(evergreen.out, file = "evergreen_rank.RData")
