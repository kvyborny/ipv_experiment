use "$data\final_dataset.dta", replace	


***********************************************
*	Figure 3
**********************************************

estimates clear
local counter = 1
foreach var in  f2f_slap f2f_cuts f2fslap_ext f2fcuts_ext {
	sum `var' if acasisecond==0
 	local cmean= `r(mean)' 
	reg `var' acasisecond, robust
	eststo reg`counter'
	estadd 	scalar	control_mean = `cmean' : reg`counter'
	local counter = `counter' + 1
}
//- plot
    matrix add_mat = (. , ., .)
    forvalues i = 1(1)4{
        estimates restore reg`i'
        scalar define control = e(control_mean)
        estimates replay reg`i'
        matrix add_mat = (add_mat \ e(control_mean), r(table)[1,1], r(table)[2,1])  
    }
    
    matrix add_mat = add_mat[2...,1..3]
    matrix colnames add_mat = "control_mean" "diff" "se"
    matrix rownames add_mat = "nl" "al" "lc" 
    clear
    svmat2 add_mat, names(col) rnames(var)
    gen lowgraph = cond(control_mean < 0.2, 1, 0)
    
    gen treat_mean = control_mean + diff, after(diff)
    gen up_90 = treat_mean + se*1.645
    gen lo_90 = treat_mean - se*1.645
    *sort var
    gen x = _n
    
    preserve
    keep control_mean var  x
    gen cat = "control"
    rename control_mean mean
    tempfile toappend
    save `toappend'
    restore
    keep treat_mean up_90 lo_90 var  x
    gen cat = "treatment"
    rename treat_mean mean
    append using `toappend'
    
    gsort  x cat
    
    local xlabel_lo 1 `" {stSerif:Slaps Frequency}"' ///
                    2 `" {stSerif:Cuts Frequency}"' ///
                    3 `" {stSerif:Slaps Indicator}"' ///
					4 `" {stSerif:Cuts Indicator}"' 
    preserve
    cap drop x_
    clonevar x_ = x
    replace x_ = cond(cat == "control", x_ - 0.172, x_ + 0.172) //0.01
    
    twoway (bar mean x_ if cat == "control", c(1) barw(0.3) color(black%100)) ///
           (bar mean x_ if cat == "treatment", c(1) barw(0.3) color(grey%50)) ///
           (rspike up_90 lo_90 x_, color(black) lwidth(medthick)) ///
           (rcap up_90 up_90 x_, color(black)) ///
           (rcap lo_90 lo_90 x_, color(black)), ///
           xtitle("") ///
           xlabel(`xlabel_lo', labsize(small)) ///
           legend(label(1 "{stSerif:ACASI First}") label(2 "{stSerif:ACASI Second}") order(1 2)) ///
           graphregion(color(white)) ///
           name(lowgraph, replace) 
		   
		   
	   graph export "$output/figure3.png" , replace