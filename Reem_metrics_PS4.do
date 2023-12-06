////PROBLEM 2////
use "C:\Users\rqamar\Downloads\ccapm.dta", clear

gen cratio_lag = cratio[_n-1]
gen rrate_lag = rrate[_n-1]
gen e_lag = e[_n-1]

//(a)//
gmm ({b=1}*(cratio^(-{g=1}))*rrate-1), inst(cratio_lag rrate_lag e_lag)

//(b)//
gen time = _n
gmm ({b=1}*(cratio^(-{g=1}))*rrate-1), inst(cratio_lag rrate_lag e_lag) wmatrix(hac ba 5)

clear all

////PROBLEM 4////
use "C:\Users\rqamar\Downloads\MURDER.DTA", clear
//(a)//
reg mrdrte exec unem d90 d93

//(b)//
xtset id year
xtreg mrdrte exec unem d90 d93, fe

mat betafe=get(_b)
mat Vfe=get(VCE)

//(c)//
xi: qui reg mrdrte i.id
predict rmrdrte, residuals
xi: qui reg exec i.id
predict rexec, residuals
xi: qui reg unem i.id
predict runem, residuals
xi: qui reg d90 i.id
predict rd90, residuals
xi: qui reg d93 i.id
predict rd93, residuals

reg rmrdrte rexec runem rd90 rd93, noconstant

//(d)//
xtreg mrdrte exec unem d90 d93
mat betare = get(_b)
mat Vre = get(VCE)

//Hausman:

mat hausman=(betafe[1,1..4]-betare[1,1..4])*invsym(Vfe[1..4,1..4]-Vre[1..4,1..4])*(betafe[1,1..4]-betare[1,1..4])'
mat list hausman