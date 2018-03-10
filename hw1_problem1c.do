* Author: Yunbin Peng 
* Reference: "ROBUST REGRESSION | STATA DATA ANALYSIS EXAMPLES" 
* Reference link: https://stats.idre.ucla.edu/stata/dae/robust-regression 
* Description: This script is an example of running robust regression model 
*              which is suitable for data set subjected to contamination with 
*              outliers or influential observations. 

				
// import and get summary statistic of data 

/* clear data at current workspace and load data from internet */
use https://stats.idre.ucla.edu/stat/stata/dae/crime, clear

/* get summary statistic of the data */
summarize crime poverty single 


// initial analysis and identify influential observations 

/* running OLS regression of crime against poverty and single */
regress crime poverty single 

/* generate a scatter plot of leverage vs normalized residual squared with
   points leveled with state code */
lvr2plot, mlabel(state)

/* create a new variable called d1 containing values of Cook's D */
predict d1, cooksd

/* display observations with d1 > 4/51(51 is number of total observations) */
clist state crime poverty single d1 if d1>4/51, noobs

/* predict r1 which is standardized redisual */
predict r1, rstandard

/* generate a new variable called absr1 which is absolute value of r1 */
gen absr1 = abs(r1)

/* sort absr1 by descending order and print states with 10 greatest absr1 */
gsort -absr1
clist state absr1 in 1/10, noobs


// robust regression and post analysis

/* fit robust regression model to the dataset, and save the final weights to
   a new variable named weight */
rreg crime poverty single, gen(weight)

/* check whether observation of "dc" is dropped in robust regression model */
clist state weight if state =="dc", noobs

/* print list of observations with 10 smallest weight */
sort weight
clist sid state weight absr1 d1 in 1/10, noobs

/* generate a scatter plot between single and crime with the size of point 
   corresponding to weight of observations in robust regression model */
twoway  (scatter crime single [weight=weight], msymbol(oh)) if state !="dc"

/* predict values of variable "single" holding poverty at its mean */
margins, at(single=(8(2)22)) vsquish
