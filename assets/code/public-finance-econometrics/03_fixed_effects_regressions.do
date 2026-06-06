/**********************************************************************
03_fixed_effects_regressions.do
Purpose: Main fixed-effects regressions for state economic performance.
**********************************************************************/

version 18
use "outputs/public_finance_panel_clean.dta", clear
xtset state_n year

local xvars stategovconsumptioninvestmentdiv localtaxpercentincome logcompetingjursdiction ///
    statetaxpercentincome debtpercentincome statelocalemploymentdivrivateemp ///
    sumfiscal sumlocaltax regcompensationassessmentrequire eminentdomainreform ///
    whartonlanduseregulationindex minimumtomedianwageratio discriminationlaw ///
    sumhealthinsurancefreedom sumcabletelecomm sumeducexperrequirements ///
    sumoccupationalfreedom otherregulationfreedom regulatorysum

* Main model 1: real GSP per capita
xtreg percapitagsp `xvars', fe
estimates store gsp_pc

* Main model 2: real private-sector GSP per capita
xtreg percapitaprivategsp `xvars', fe
estimates store private_gsp_pc

* Robustness option for future extension:
* xtreg percapitagsp `xvars', fe vce(cluster state_n)
* xtreg percapitaprivategsp `xvars', fe vce(cluster state_n)
