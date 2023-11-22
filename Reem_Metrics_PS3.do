clear all

import excel "C:\Users\rqamar\Downloads\PS4data.xls", sheet("data") firstrow

gen date = yq(year, quarter)
format date %tq
tsset date

//Part(a)
gen cons= (realconsumptionofnondurables+realconsumptionofservices)/population
reg cons l(1/4).cons

test L2.cons=L3.cons=L4.cons=0

//Part(c)
gen y=realdisposableincome/pop
gen lncons=log(cons/l1.cons)
gen lny=log(y/l1.y)
ivregress 2sls lncons (lny=l(2/5).lncons),robust
estat firststage // 

//Part(d)
*test the exogeneity
reg lny l(2/5).lncons
predict e,resid
reg lncons lny e,robust

*test the over-identifying restrictions
gen residuals=lncons-.0026129-0.4369273*lny
reg residuals l(2/5).lncons
