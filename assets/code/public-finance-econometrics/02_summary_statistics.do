/**********************************************************************
02_summary_statistics.do
Purpose: Summary statistics for outcomes and key policy variables.
**********************************************************************/

version 18
use "outputs/public_finance_panel_clean.dta", clear

local outcomes percapitagsp percapitaprivategsp
local xvars stategovconsumptioninvestmentdiv localtaxpercentincome logcompetingjursdiction ///
    statetaxpercentincome debtpercentincome statelocalemploymentdivrivateemp ///
    sumfiscal sumlocaltax regcompensationassessmentrequire eminentdomainreform ///
    whartonlanduseregulationindex minimumtomedianwageratio discriminationlaw ///
    sumhealthinsurancefreedom sumcabletelecomm sumeducexperrequirements ///
    sumoccupationalfreedom otherregulationfreedom regulatorysum

summarize `outcomes' `xvars'

* Optional export if estout is installed.
capture which estpost
if !_rc {
    estpost summarize `outcomes' `xvars'
    esttab using "outputs/public_finance_summary_stats.rtf", ///
        cells("mean sd min max") replace label title("Summary Statistics")
}
