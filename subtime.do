
*load the data
use "C:\wowah\CLEANED_DATA.dta", clear
gen double date21 = date(timestamp,"MD20Y###")
format date21 %td
by char: egen lastdate2 = max(date21)
by char: egen firstdate2 = min(date21)

gen between = lastdate2 - firstdate2
save "C:\wowah\CLEANED_DATA_SUBTIME.dta", replace
collapse between , by(char)
*bysort char (between) : keep if _n == _N 
*drop

drop  if between<31
*dropped the values for non paying custoemrs as the first month is free
summarize  between, detail

stset between
sts graph
