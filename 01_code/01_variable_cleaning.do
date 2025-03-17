
use "$data/data_measurement.dta", replace



***********************************************
* harmonize variables 
***********************************************
// align variables that had alternative randomized order 
gen 		ipv_order_treat = .
replace ipv_order_treat = 1 if acasi_prac_0_1_2nd < .
replace ipv_order_treat = 2 if acasi_prac_0_1_1st < .  
replace ipv_order_treat = 3 if acasi_prac_0_2_2nd < .  
replace ipv_order_treat = 4 if acasi_prac_0_2_1st < . 

label 		define ipv_order_treat 1 "ACASI first descending frequency" 2 "F2F first descending frequency" ///
	3 "ACASI first ascending frequency" 4 "F2F first ascending frequency" 

label		values ipv_order_treat ipv_order_treat
label 		variable ipv_order_treat "IPV order"


foreach i in "acasi_1_physical"	"acasi_2_physical" ///
	"acasi_3_physical"	"acasi_4_physical" ///
	"acasi_5_physical" "acasi_6_physical" ///
	"s05q5h" "s05q6h" "s05q7h"  ///
	"f2f_s05q5h" "f2f_s05q6h" "f2f_s05q7h" ///
	"f2f_cuts" "f2f_slap"	{

	capture replace		`i'_2_1st = `i'_1_1st if `i'_2_1st>=.
	capture replace		`i'_2_1st = `i'_1_2nd if `i'_2_1st >=. 
	capture replace		`i'_2_1st = `i'_2_2nd if `i'_2_1st >=. 

	capture drop 		`i'_1_1st	
	capture drop		`i'_1_2nd
	capture drop 		`i'_2_2nd

	rename		`i'_2_1st `i' 

}

***********************************************
* Cleaning don't knows and refusals
*********************************************** 			

foreach		i in acasi_1_physical acasi_2_physical acasi_3_physical acasi_4_physical ///
	acasi_5_physical acasi_6_physical ///
	f2f_slap f2f_cuts {   
	replace		`i' = .d if `i' < 0 

}	

***********************************************
* Recoding
***********************************************

label define recoded 0 "Never" 15 "Once or twice" 3 "More than thrice"

foreach		i of varlist acasi_1_physical acasi_2_physical acasi_3_physical acasi_4_physical acasi_5_physical acasi_6_physical  {
	local lab_`i' : variable label `i'

	* Recode frequency category options to number of times 
	recode		`i' (1 = 1.5) (2 = 3)
	label value `i' recoded

}

save "$data/cleaned_data.dta", replace	