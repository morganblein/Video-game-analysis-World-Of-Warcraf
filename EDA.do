*load the data
use "C:\wowah\CLEANED_DATA.dta", clear
*use "C:\wowah\averages.dta", clear

*create frequency table for race choice by player
tabulate  raceingame
*creates graph for the distrubtion of races chosen by players. 
*with legend and percentages on the graph.
graph pie, over(raceingame) pie(2,explode) plabel(_all percent, size(*1.5) color(white))legend(on)
*save graph: edit to your path:
graph save Graph "C:\wowah\raceingame_distribution.gph

*create frequency table for race choice by player
tabulate  classingame
*creates graph for the distrubtion of races chosen by players. 
graph pie, over(classingame) pie(2,explode) plabel(_all percent, size(*1.5) color(white))legend(on)
*save graph: edit to your path:
graph save Graph "C:\wowah\classingame_distribution.gph


*re-encode the level in groups for visualization
egen levelgroup1 = cut(level), at(0,10,20,30,40,50,60,70,80) label
*TO DO: rename labels.
tabulate  levelgroup
histogram levelgroup
*to do: get the pie charts. 

*rework the guild field such as if char belongs to a guild, set to 1, if not, set to 0. 

replace guild =1 if guild >= 0 
replace guild =0 if guild < 0 
*recode to binary
recast byte guild
tabulate  guild

save "C:\wowah\CLEANED_DATA_EDA.dta", replace
