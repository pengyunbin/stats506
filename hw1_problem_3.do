* Author: Yunbin Peng 
* Dataset used: NHANES 2005-2006 Examination Data - Audiometry
*               NHANES 2005-2006 Demographics Data
* Data URL: https://wwwn.cdc.gov/Nchs/Nhanes/2005-2006/AUX_D.XPT
*           https://wwwn.cdc.gov/Nchs/Nhanes/2005-2006/DEMO_D.XPT
* Description: This script will merge both dataset by common identifier "seqn",
*              then compare hearing threshold result for different age groups 
*              and gender groups. The analysis performed attempt to find trend
*              in age-related hearing loss.


// 3.a.

/* set current working directory to where datasets are located */ 
/* cd "C:\Users\Yunbin\OneDrive\UM\1st Year\Fall 2017\STATS 506\Homework 1" */

/* import the first dataset (in XPT format) */
fdause AUX_D.XPT, clear

/* sort dataset by variable seqn which is used later to merge datasets */
sort seqn

/* save the data in dta format */
save AUX_D.dta

/* clear current data in memory and import demographics dataset */
fdause DEMO_D.XPT, clear

/* sort dataset by variable seqn which is used later to merge datasets */ 
sort seqn

/* merge current data in memory and AUX_D.dta with "seqn" as common identifier */
merge 1:1 seqn using AUX_D.dta

/* keep only observations that are matched during merge */
keep if _merge == 3


// 3.b.

/* create a categorical variable "agegroup" based on variable "ridageyr" */
generate agegroup = "Young" if ridageyr <= 20
replace agegroup = "Old" if ridageyr >= 70 

/* get a summary of variable "agegroup" */
tabulate agegroup

/* drop missing values for threshold tests */
foreach varname of varlist auxu* {
	drop if `varname' ==.
	drop if `varname' > 200
}

/* get summary statistic of threshold tests by age group*/
tabstat auxu*, by (agegroup)


// 3.c.

/* create a categorical variable called "gender" based on variable "riagendr" */
generate gender = "Male" if riagendr == 1
replace gender = "Female" if riagendr == 2

/* get a summary of variable "gender" */
tabulate gender

/* compute and print mean of each threshold test for each age group and gender */
collapse (mean) auxu*r, by (agegroup gender)
list
