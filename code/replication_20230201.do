// Note: Set working directory to "...\replication_cities_hetfirms" before running this do file.
cd "C:\Users\jasonjia\Dropbox\shared_spaces\Jason-Kilian\replication_cities_hetfirms"

version 17
ssc install estout, replace
clear all
capture log close
log using "output\stata_replication\stata_replication.log", replace

// Data sources
// 1. Exports: https://www.trade.gov/data-visualization/metropolitan-export-map 
// → All MSA Exports Map (2012 - 2021) → Choose a format to download 
// → Crosstab → Table, csv → Download

// 2. Population: https://www.census.gov/data/tables/time-series/demo/popest/2010s-total-metro-and-micro-statistical-areas.html
// → Annual Estimates of the Resident Population: April 1, 2010 to July 1, 2019 
// → Metropolitan Statistical Area; and for Puerto Rico [<1.0 MB]

// 3. MSA Crosswalk: https://www.census.gov/geographies/reference-files/time-series/demo/metro-micro/delineation-files.html
// → Core based statistical areas (CBSAs), metropolitan divisions, and combined statistical areas (CSAs) 
// → Feb. 2013 [<1.0 MB]
// → resaved as .csv file

// 4. Sales: https://www.census.gov/data/datasets/2012/econ/census/2012-core-reports.html
// → Geographic Area Series → All Geographies 
// → ec1200a1.zip

// Exports
frame create exports
frame change exports
import delimited "data\exports_ita.csv", varnames(1) clear 
rename msafullname msa_name 
rename v3 exports_2012
keep msa_name exports_2012
drop if missing(exports_2012)
drop if _n >= _N - 1 // drop non-data rows
replace msa_name = strtrim(msa_name)

// Population
frame create pop
frame change pop
import excel "data\cbsa-met-est2019-annres.xlsx", sheet("CBSA-MET-EST2019-ANNRES") clear
rename A msa_name
rename F pop_2012
drop if _n <= 6 | _n >= _N - 4 // drop non-data rows
keep msa_name pop_2012
drop if missing(pop_2012)
drop if strmatch(msa_name, "*Metro Division*") // we only want MSAs, not Metro Divisions
replace msa_name = strtrim(msa_name)
replace msa_name = subinstr(msa_name, ".", "", 1)
replace msa_name = subinstr(msa_name, "Metro Area", "", .) 
replace msa_name = strtrim(msa_name)
replace msa_name = subinstr(msa_name, "Mayagüez, PR", "Mayaguez, PR", .) 
replace msa_name = subinstr(msa_name, "Nashville-Davidson--Murfreesboro--Franklin, TN", "Nashville-Davidson-Murfreesboro-Franklin, TN", .) 
replace msa_name = subinstr(msa_name, "San Germán, PR", "San German, PR", .) 
replace msa_name = subinstr(msa_name, "San Juan-Bayamón-Caguas, PR", "San Juan-Bayamon-Caguas, PR", .) 
replace msa_name = subinstr(msa_name, "Scranton--Wilkes-Barre, PA", "Scranton-Wilkes-Barre, PA", .) 

// Merge population with exports
frlink 1:1 msa_name, frame(exports)
frget exports_2012, from(exports)
drop exports
drop if missing(exports_2012)

// MSA crosswalk (MSA code -> MSA name)
frame create msa_crosswalk
frame change msa_crosswalk
import delimited "data\msa_crosswalk.csv"
rename v5 metro_or_micro
drop if metro_or_micro != "Metropolitan Statistical Area"
rename v1 msa
rename v4 msa_name
keep msa msa_name
drop if missing(msa)
drop if missing(msa_name)
destring msa, replace
replace msa_name = strtrim(msa_name)
duplicates drop

// Sales
frame create sales
frame change sales
import delimited "data\EC1200A1.dat"
keep msa rcptot naics2012 naics2012_ttl
drop if naics2012 != "31-33" // Keep only manufacturing sales
bysort msa: egen sales_2012 = total(rcptot) // Get total manufacturing sales per MSA
replace sales_2012 = sales_2012 * 1000 // reported sales is in thousands
keep msa sales_2012 
duplicates drop
drop if sales_2012 == 0

// Merge sales with msa_crosswalk
frlink 1:1 msa, frame(msa_crosswalk)
frget msa_name, from(msa_crosswalk)
drop msa_crosswalk
drop if missing(msa_name)

// Merge sales with population and exports
frlink 1:1 msa_name, frame(pop)
frget pop_2012 exports_2012, from(pop)
gen export_intensity_2012 = exports_2012 / sales_2012
drop pop
drop if missing(pop_2012)

// Filter for pop and exports
keep if pop_2012 >= 100000
keep if exports_2012 >= 0

// Table 1
gen pop_2012_thousand = pop_2012 / 1000
summarize pop_2012_thousand export_intensity_2012, detail
est clear
estpost tabstat pop_2012_thousand export_intensity_2012, c(stat) stat(n mean p25 p50 p75 p90 p95)
esttab using "output\stata_replication\table1.tex", replace ////
	cells("count mean p25 p50 p75 p90 p95") nonumber ///
	nomtitle nonote noobs label booktabs ///
	collabels("Obs." "Mean" "25th" "50th" "75th" "90th" "95th")
  
// Table 2
gen pop_2012_log = log(pop_2012)
gen export_intensity_2012_log = log(export_intensity_2012)
est clear
regress export_intensity_2012_log pop_2012_log
esttab using "output\stata_replication\table2.tex", replace ////
	nomtitle nonote noobs label booktabs ///

// Figure 1
scatter export_intensity_2012_log pop_2012_log, msymbol(circle_hollow) ///
mcolor(blue) ylab(, nogrid) graphregion(fcolor(white)) ///
ylabel(#10) xlabel(#10)|| ///
lfit export_intensity_2012_log pop_2012_log, lcolor(red) ///
title("United States (sales only from manufacturing industry)") ///
xti("log(MSA population)") yti("log(Export intensity)") legend(off)
graph export "output\stata_replication\figure_1.png", replace

log close
