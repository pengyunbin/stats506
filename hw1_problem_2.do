* Author: Yunbin Peng 
* Dataset used: Resedidential Energy Consumption Survey (RECS)
* Data URL: http://www.eia.gov/consumption/residential/data/2009/csv/recs2009_public.csv
* Description: This script runs analysis of RECS dataset. The variables of 
*              interest is roof type of houses from different states and across
*              various years. "svy" command is implemented to incorporate survey
*              weights into the analysis. I avoid overwriting existing variables 
*              in data by creating new variables.


// import RECS dataset and do preliminary cleaning of data

/* change working directory to where recs2009_public.csv is stored */
/* cd "C:\Users\Yunbin\OneDrive\UM\1st Year\Fall 2017\STATS 506\Homework 1" */

/* import dataset which is in csv format */
import delimited recs2009_public.csv, clear

/* generate a new variable named "state" and label it based on values of the 
   variable "reportable_domain" */
generate str state = "None"
replace state = "Connecticut, Maine, New Hampshire, Rhode Island, Vermont" if reportable_domain == 1
replace state = "Massachusetts" if reportable_domain == 2
replace state = "New York" if reportable_domain == 3
replace state = "New Jersey" if reportable_domain == 4
replace state = "Pennsylvania" if reportable_domain == 5
replace state = "Illinois" if reportable_domain == 6
replace state = "Indiana, Ohio" if reportable_domain == 7
replace state = "Michigan" if reportable_domain == 8
replace state = "Wisconsin" if reportable_domain == 9
replace state = "Iowa, Minnesota, North Dakota, South Dakota" if reportable_domain == 10
replace state = "Kansas, Nebraska" if reportable_domain == 11
replace state = "Missouri" if reportable_domain == 12
replace state = "Virginia" if reportable_domain == 13
replace state = "Delaware, District of Columbia, Maryland, West Virginia" if reportable_domain == 14
replace state = "Georgia" if reportable_domain == 15
replace state = "North Carolina, South Carolina" if reportable_domain == 16
replace state = "Florida" if reportable_domain == 17
replace state = "Alabama, Kentucky, Mississippi" if reportable_domain == 18
replace state = "Tennessee" if reportable_domain == 19
replace state = "Arkansas, Louisiana, Oklahoma" if reportable_domain == 20 
replace state = "Texas" if reportable_domain == 21
replace state = "Colorado" if reportable_domain == 22
replace state = "Idaho, Montana, Utah, Wyoming" if reportable_domain == 23
replace state = "Arizona" if reportable_domain == 24
replace state = "Nevada, New Mexico" if reportable_domain == 25
replace state = "California" if reportable_domain == 26
replace state = "Alaska, Hawaii, Oregon, Washington" if reportable_domain == 27

/* generate a new variable named "roof_type" and label it based on values of the 
   variable "rooftype" */
generate roof_type = "None"
replace roof_type = "Ceramic or Clay Tiles" if rooftype == 1
replace roof_type = "Wood Shingles/Shakes" if rooftype == 2
replace roof_type = "Metal" if rooftype == 3
replace roof_type = "Slate or Synthetic Slate" if rooftype == 4
replace roof_type = "Composition Shingles" if rooftype == 5
replace roof_type = "Asphalt" if rooftype == 6
replace roof_type = "Concrete Tiles" if rooftype == 7
replace roof_type = "Other" if rooftype == 8
replace roof_type = "Not Applicable" if rooftype == -2

/* use "svyset" to incorporate survey weights based on variable "nweight" */
svyset doeid [pweight = nweight]


// 2.a. 

/* generate proportion of each roof type within each state */
tab state roof_type, row


// 2.b.

/* generate proportion of each roof type in given decade */
tab yearmaderange roof_type if inlist(yearmaderange, 2, 6), row

/* generate proportion of each roof type in given year */
tab yearmade roof_type if inlist(yearmade, 1950, 2000), row


