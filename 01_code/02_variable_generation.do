use "$data/cleaned_data.dta", replace	

// count = 9,670

***********************************************
* Set sample 
***********************************************
keep		if consent_1==1

***********************************************
* Generate variables
***********************************************

gen			acasifirst = inlist(ipv_order_treat, 1, 3)

gen 		acasisecond = (acasifirst==0)

gen			ipvascending = inlist(ipv_order_treat, 3, 4)

//Generating extensive margin (indicator vars)

gen 		f2fcuts_ext = (f2f_cuts==1 |  f2f_cuts==2)
replace 	f2fcuts_ext =. if f2f_cuts==-99 //replacing with missing if they refused to answer

gen 		f2fslap_ext = (f2f_slap==1 |  f2f_slap==2)
replace 	f2fslap_ext =. if f2f_slap==-99 //replacing with missing if they refused to answer

// Generating agreement between acasi and f2f
gen			agree_meat = f2f_s05q5h == s05q5h if f2f_s05q5h < . & s05q5h < . 
gen			agree_eggs = f2f_s05q6h == s05q6h if f2f_s05q6h < . & s05q6h < . 
gen			agree_fruit = f2f_s05q7h == s05q7h if f2f_s05q7h < . & s05q7h < . 

***********************************************
* Labels
***********************************************

label 		variable f2f_slap "Slap frequency"
label 		variable f2f_cuts "Cuts frequency"

label 		variable acasifirst "ACASI first"
label 		variable acasisecond "ACASI second"

label 		variable acasi_1_physical "Push, shake, throw something"
label 		variable acasi_3_physical "Twist arm or pull hair"
label 		variable acasi_4_physical  "Punch"
label 		variable acasi_5_physical "Kick, drag, beat"
label		variable acasi_6_physical "Choke or burn"

label 		variable agree_meat "Meat: acasi f2f agree"
label 		variable agree_fruit "Fruit: acasi f2f agree"
label 		variable agree_eggs "Eggs: acasi f2f agree"



save "$data/final_dataset.dta", replace				