*Created by Morgan Blein
*May/June 2016.
*feel free to copy use and modify this code. 

*load the data
use "C:\wowah\CLEANED_DATA.dta", clear
*from string, generate a date variable that STATA understands and extract days month and year.
gen double date_VAR = clock(timestamp,"MD20Yhms")
format date_VAR %tc
gen hour = hh(date_VAR)
gen minute = mm(date_VAR)
gen sec = ss(date_VAR)
gen double date21 = date(timestamp,"MD20Yhms")
format date21 %tc
generate month_VAR=month(date21)
generate day_VAR=day(date21)
generate year_VAR=year(date21)

*number of player online for 24h: hourly averages.
bysort hour date21 char : gen tag = _n ==1
by hour date21 : gen COUNT_avatar_hour = sum(tag)
by hour date21 : replace COUNT_avatar_hour = COUNT_avatar_hour[_N]
by hour date21 : replace tag = _n ==1

*get mean, max and min for each hour
by hour: egen MEAN_avatar_hour=mean(COUNT_avatar_hour)
replace MEAN_avatar_hour = round(MEAN_avatar_hour) 
by hour: egen MIN_avatar_hour=min(COUNT_avatar_hour)
by hour: egen MAX_avatar_hour=max(COUNT_avatar_hour)


*number of player online monthly daily averages

bysort day_VAR date21 char : gen tag2 = _n ==1
by day_VAR date21 : gen COUNT_avatar_days = sum(tag2)
by day_VAR date21 : replace COUNT_avatar_days = COUNT_avatar_days[_N]
by day_VAR date21 : replace tag2 = _n ==1

*get mean, max and min for each hour
*there are 3 years. we need to divide those results by 3. we then round up to avoid decimals
by day_VAR: egen MEAN_avatar_days=mean(COUNT_avatar_days/3)
replace MEAN_avatar_days = round(MEAN_avatar_days) 
by day_VAR: egen MIN_avatar_days=min(COUNT_avatar_days/3)
replace MIN_avatar_days = round(MIN_avatar_days) 
by day_VAR: egen MAX_avatar_days=max(COUNT_avatar_days/3)
replace MAX_avatar_days = round(MAX_avatar_days) 

*generating days of the week.
*gen days_of_week_index = dow( mdy( m, day, yr) )
*creates an index such as: 0=Sunday,...,6=Saturday.
*TODO: figure out what to do with days. 

save "C:\wowah\CLEANED_DATA_DATES.dta", replace
*collapse data to export for graphs
*hours
collapse MEAN_avatar_hour MAX_avatar_hour MIN_avatar_hour, by(hour)
export delimited using "C:\wowah\HOUR_averages.csv", replace

*days:
use "C:\wowah\CLEANED_DATA_DATES.dta", clear
collapse MEAN_avatar_days MIN_avatar_days MAX_avatar_days, by(day_VAR)
export delimited using "C:\wowah\DAYS_averages.csv", replace
