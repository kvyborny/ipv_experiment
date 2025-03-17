
	******************************************************************
	******************************************************************
	** 	Purpose: BISP recert - measurement note analysis master		**
	******************************************************************
	******************************************************************
		clear all 
		* User Number:
		
		* Jaweria       1


		*Set this value to the user currently using this file
		global user  1

		*Set this value to 1 if you want to install the packages
		global firsttime 0
		
		if $user == 1 {
			global github		"E:/GitHub/ipv_experiment"
		}
/*

		if $user == 2 {
		   global github	
		}
		
		if $user == 3 {
		   global github	
		}

		if $user == 4 {
			global github	
		}

		if $user == 5 {
			global github		
		}
*/
		
		
		
		if $firsttime==1 {
		
			net install grc1leg2.pkg, from (http://digital.cgdev.org/doc/stata/MO/Misc/)
			set scheme plotplainblind
			local packages tabout estout dm79
			
			foreach p of local packages {
			  cap which `p'.ado
			  if _rc==111 ssc install `p', replace
			}
		}
		
		
		* 	file paths
		global code			"$github/01_code"
		global data 		"$github/02_data"		
		global output 		"$github/03_output"
		
	
		*	do file sequence
		local 01_variable_cleaning		 			1								// cleans variables in use
		local 02_variable_generation	 			1								// generates new variables
		local 03_table								0								// constructs table in the measurement note
		local 04_figure								0								// constructs figure in the measurement note
		local 05_stats								0								// for stats reported in the measurement note

	
	foreach j in 	01_variable_cleaning 				///
					02_variable_generation 				///
					03_table 							///
					04_figure 							///
					05_stats {	
		if ``j'' == 1 {	
			qui do "${code}/`j'.do"		
		}
	}
