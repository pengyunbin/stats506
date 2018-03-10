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
# Census Data by Council District                                                                      #
# https://data.lacity.org/A-Livable-and-Sustainable-City/Census-Data-by-Council-District/ucyn-ru6w     #
#                                                                                                      #
# Description:                                                                                         #
# This script use ggmap package to produce a heatmap of active business in Los Angeles region and      #
# investigate how businesses distribute geographically. This script also use census data by council    #
# district to compute population to business ratio.                                                    #
########################################################################################################

# load packages
library(dplyr)
library(readr)
library(ggplot2)
library(ggmap)
library(RColorBrewer)

# load active business data 
business = read_csv("Listing_of_Active_Businesses.csv")

# remove rows with na in location
work = business %>%
  filter(!is.na(LOCATION))

# load population by council district data
population = read.csv("Population_by_Council_Districts.csv")

##############################
##    Section 1 Heat map    ##
##############################

# function to extract latitude from location
latitude = function(x){
  x = as.character(x)
  # latitude is 1st entry in location
  lat = strsplit(x, ",")[[1]][1]
  n = nchar(lat)
  lat = substring(lat, 2, n)
  return(as.numeric(lat))
}

# function to extract longtitude from location
longtitude = function(x){
  x = as.character(x)
  # longtitude is 2nd entry in location
  long = strsplit(x, ",")[[1]][2] 
  n = nchar(long)
  long = substring(long, 2, n-1)
  return(as.numeric(long))
}

# add latitude and longtitude to data set
work = work %>%
  mutate(lat = sapply(LOCATION, latitude),
         long = sapply(LOCATION, longtitude)) %>%
  select(lat,long) %>%
  filter(!is.na(lat) & !is.na(long)) %>%
  filter((lat != 0) & (long != 0))

# save restaurant location data
save(work, file = "business_location.RData")

# get count data by block
count = work %>%
  mutate(lat = round(lat,3), long = round(long, 3)) %>%
  group_by(lat, long) %>%
  summarise(count = n()) %>%
  mutate(log_count = log(count))

save(count, file = "businesscount.RData")

# get raw map for LA
LArawmap = get_map(location = "los angeles", zoom = 10)

# draw heat map
heatmap = ggmap(LArawmap) +
  geom_point(aes(x=long, y = lat, color = log_count), 
             data = count, alpha = 0.1, size = 0.8) + 
  scale_color_gradientn(limits=c(0, 5), colours = brewer.pal(n = 5, name = "YlGnBu")) +
  scale_x_continuous(limits = c(-118.7, -118)) +
  scale_y_continuous(limits = c(33.7, 34.3)) + 
  ggtitle("Figure 1:Los Angeles Active Business Heat Map") +
  xlab("longitude") + ylab("latitude")
  

heatmap

save(heatmap, file = "businessheatmap.RData")

###########################################
##    Section 2 Business per district    ##
###########################################

# select relevant information from population data
population.work = population %>%
  select(council_district, population = value) %>%
  arrange(council_district)

# compute count of restaurants for each council district
business.work = business %>%
  group_by(`COUNCIL DISTRICT`) %>%
  summarise(count = n()) %>%
  filter(`COUNCIL DISTRICT` %in% 1:15) %>%
  rename(council_district = `COUNCIL DISTRICT`)

# merge population and business count
full = left_join(business.work, population.work, by = "council_district")

# compute population-business ratio
full = full %>%
  mutate(pop_business_ratio = population / count)

# print table 
full.out = full %>%
  select(council_district, pop_business_ratio) %>%
  arrange(pop_business_ratio)

# save council_district and population/business ratio
save(full.out, file = "pop_business_ratio.RData")

# barplot for population-business ratio by district 
barplot = 
  ggplot(data = full.out) +
  geom_bar(mapping = aes(x = reorder(council_district, -pop_business_ratio),
                         y = pop_business_ratio), 
           stat = "identity") +
  coord_flip() +
  xlab('Council District') +
  ylab('Population to Business Ratio') +
  ggtitle('Figure 2:Population to Business Ratio by Council District')

barplot

save(barplot, file = 'barplot.RData')
