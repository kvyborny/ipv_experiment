
use "$data/data_measurement.dta", replace


	
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