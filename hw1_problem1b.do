* Author: Yunbin Peng 
* Reference: "LOGISTIC REGRESSION | STATA DATA ANALYSIS EXAMPLES" 
* Reference URL: https://stats.idre.ucla.edu/stata/dae/logistic-regression 
* Description: this script fits a logistic model on grad school admission data 
*			   with admission decision as response variable and gre gpa and 
*			   school rank as predictors. 

                                                                                
// import and get summary statistic of data

/* clear data at current workspace and load data from internet */
use https://stats.idre.ucla.edu/stat/stata/dae/binary.dta, clear

/* create summary statistic for numeric variables gre & gpa */
summarize gre gpa 

/* create summary for categorical variable rank */
tab rank 

/* create summary for categorical variable admit */
tab admit 

/* create two-dimension contingency table for admit and rank */
tab admit rank 


// implement logistic regression 

/* run logistic regression with dependent variable : admit
   independent variables : gre (numeric), gpa (numeric), rank (factor) */
logit admit gre gpa i.rank

/* test whether overall effect of rank is statistically significant (non-zero) */
test 2.rank 3.rank 4.rank

/* test hypotheses that coefficients of rank=2 and rank=3 are equal */
test 2.rank = 3.rank 

/* compute odds ratio for different independent variables */
logit , or


// predict probability of admit for hypothetical data 

/* predict probability of admit for various ranks, given gre and gpa at means
   margins rank, atmeans */

/* predict probability of admit for gre score range between 200 and 800 
   with 100 as increment, averaging across sample gpa and rank */
margins, at(gre=(200(100)800)) vsquish


// measure goodness of fit of logistic model to the data 

/* install user-written command "fitstat" */
ssc install fitstat

/* get summary of how well the model fit the data */
fitstat
