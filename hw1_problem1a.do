* Author: Yunbin Peng 
* Reference: "RESHAPING DATA WIDE TO LONG | STATA LEARNING MODULES" 
*			 "RESHAPING DATA LONG TO WIDE | STATA LEARNING MODULES" 
* Reference URL: 
*         https://stats.idre.ucla.edu/stata/modules/reshaping-data-wide-to-long/ 
*         https://stats.idre.ucla.edu/stata/modules/reshaping-data-long-to-wide/ 
* Dataset: "kid.dta", "dadmomlong.dta", "dadmomwide.dta"
* Dataset URL: https://stats.idre.ucla.edu/stat/stata/modules/kids
*              https://jbhender.github.io/Stats506/dadmomlong.dta
*              https://stats.idre.ucla.edu/stat/stata/modules/dadmomw
* Description: this script provides example of converting data between 
*			   long format and wide format, using "reshape" command in stata 


// reshaping data long to wide example 1 (basic case)

/* import dataset "kids" from current working directory */
use kids, clear 

/* Drop variables "kidname", "sex" and "wt", then list observations */
drop  kidname sex wt 
list 

/* reshape the dataset from long format to wide format 
   by making long variable "age" wide,
   with "famid" to uniquely identify wide observations (rows), 
   with "birth" to create suffix of wide variable "age" (columns) in result */
reshape wide age, i(famid) j(birth)

/* print out dataset (wide format) after reshape */
list

/* convert the dataset back to long format, print out the result */
reshape long
list


// reshaping data long to wide example 2 (with more than one variable)

/* import dataset "kids" from current working directory, print dataset */
use kids, clear 
list

/* reshape the dataset from long format to wide format 
   by making long variables "kidname", "age", "wt" and "sex" wide,
   with "famid" to identify each observation in wide form,
   with "birth" to create suffix of "kidname", "age", "wt" and "sex" in result */
reshape wide kidname age wt sex, i(famid) j(birth)

/* print out dataset (wide format) after reshape */
list


// reshaping data long to wide example 3 (with character suffixes)

/* clear the current data in memory, import and print dataset "dadmoml" */
use dadmomlong.dta, clear
list

/* reshape dataset from long to wide format by 
   reshaping long variables "name", "inc" to wide,
   with "famid" to uniquely identify observations in wide form,
   with "dadmom" with string command to use value of string variable "dadmom"
   to create suffix of wide variable "name" and "inc" */
reshape wide name inc, i(famid) j(dadmom) string

/* print out dataset (wide format) after reshape */
list


// reshaping data wide to long example 1 

/* import dataset using URL and list data */
use https://stats.idre.ucla.edu/stat/stata/modules/faminc, clear 
list 

/* reshape dataset from wide to long format 
   by converting stem of variable "faminc" from wide to long,
   with variable "famid" as unique identifier of observations,
   extract suffix of "faminc" and convert to a variable called "year" */
reshape long faminc, i(famid) j(year)

/* print out dataset (long format) after reshape */
list

/* convert the dataset back to wide format, print out the result */
reshape wide
list

/* convert the dataset to long format, print out the result */
reshape long
list


// reshaping data wide to long example 2 

/* import dataset with source URL */
use https://stats.idre.ucla.edu/stat/stata/modules/kidshtwt, clear 

/* print out variables of famid, birth, ht1, ht2 from data */
list famid birth ht1 ht2

/* reshape dataset from wide to long format
   by converting stem of variable "ht" from wide to long,
   with variables "famid" and "birth" as unique identifier of observations,
   extract suffix of "ht" and convert into a variable called "age" */
 reshape long ht, i(famid birth) j(age)
 
/* print out famid birth age ht of dataset (long format) after reshape */
list famid birth age ht 


// reshaping data wide to long example 3

/* import dataset with source URL */
use https://stats.idre.ucla.edu/stat/stata/modules/kidshtwt, clear

/* print out variables famid, birth, ht1, ht2, wt1, wt2 */
list famid birth ht1 ht2 wt1 wt2

/* reshape dataset from wide to long format 
   by converting stem of variables "ht" and "wt" from wide to long,
   with variables "famid" and "birth" as unique identifier of observations,
   extract suffix of "ht" and "wt" and convert into a variable called "age" */
reshape long ht wt, i(famid birth) j(age)  

/* print out variables famid birth age ht wt after reshaping to long format*/
list famid birth age ht wt


// reshaping data wide to long example 4 (with character suffixes)

/* import dataset with source URL */
use https://stats.idre.ucla.edu/stat/stata/modules/dadmomw, clear 

/* print out dataset */
list

/* reshape dataset from wide to long format
   by converting stem of variables "name" and "inc" from wide to long,
   with variables "famid" as unique identifier of observations,
   extract suffix (which is string) of "name" and "inc" and 
   convert the suffix into a variable called "dadmom" */
reshape long name inc, i(famid) j(dadmom) string

/* print out the result */
list 
