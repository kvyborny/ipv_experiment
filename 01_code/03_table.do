
use "$data/final_dataset.dta", replace				

***********************************************
*	Table 1
**********************************************

estimates clear
local counter = 0

foreach		i in acasi_1_physical acasi_2_physical acasi_3_physical acasi_4_physical ///
	acasi_5_physical acasi_6_physical {
	local		counter = `counter' + 1

	reg			`i' ipvascending , robust 

	est			sto ascend_`counter'



}

esttab 	ascend_1 ascend_2 ascend_3 ascend_4 ascend_5 ascend_6 ///
	using "$output/table1.tex", ///
	label parentheses nogaps compress nonotes  ///
	b(5) se(5) ///
	width(1.0\hsize) ///
	star(* 0.101 ** 0.05 *** 0.01) ///
	stats( N , label("Observations") fmt(%9.0f 0)) ///
	substitute({l} {p{1.0\linewidth}}) ///
	addnotes("Notes: The table reports results from an experiment where we randomised the order of the frequency answer options. Ascending is an indicator of the order options displayed to the respondent in ascending order for questions related to the experience of violence asked using ACASI. The dependent variables take on the value 0 if the respondent did not experience the type of violence in the last 6 months, 1.5 if she experienced it once or twice and 3 if she experienced it three or more times. Standard errors are in parentheses. \sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\).") keep(ipvascending) coeflabels (ipvascending "Ascending") ///
	collabels(none) mtitles("Push, Shake, Throw" "Slap" "Twist Arm, Pull Hair" "Punch" "Choke, Burn" "Threaten to attack with weapon") ///
	replace