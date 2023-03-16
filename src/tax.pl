use_module(library(clpr)).
use_module(library(apply)).

dep_contribution_reduction(6940.08).
fd_reduction(198).

intervals([
	[200004, 0.45],
	[150000, 0.44],
	[100002, 0.42],
	[45897, 0.41],
	[43953, 0.40],
	[42009, 0.38],
	[40065, 0.36],
	[38121, 0.34],
	[36177, 0.32],
	[34233, 0.29],
	[32289, 0.27],
	[30345, 0.25],
	[28401, 0.23],
	[26457, 0.21],
	[24513, 0.19],
	[22569, 0.17],
	[20625, 0.14],
	[18753, 0.12],
	[16881, 0.11],
	[15009, 0.10],
	[13137, 0.09],
	[11265, 0.08]
]).

deduction_healthcare(Gross, Deduction):-
	{Deduction = Gross * 0.028}.

deduction_healthcare_contrib(Gross, Deduction):-
	{Deduction = Gross * 0.0025}.

deduction_pension(Gross, Deduction):-
	{Deduction = Gross * 0.08}.

deduction_unemployment(Gross, Deduction):-
	dep_contribution_reduction(DCR),
	{Deduction = (Gross - DCR) * 0.014}.

get_intervals(_, TotalTax, []):-
	{TotalTax=0}.

get_intervals(Sum, TotalTax, [CurrentInterval|NextIntervals]):-
	CurrentInterval=[CurrentLimit|_],
	{Sum < CurrentLimit},
	get_intervals(Sum, TotalTax, NextIntervals).
	
get_intervals(Sum, TotalTax, [CurrentInterval|NextIntervals]):-
	CurrentInterval=[CurrentLimit, CurrentTax|_],
	{
		Sum >= CurrentLimit,
		Taxable = Sum - CurrentLimit,
		Tax = Taxable * CurrentTax
	},
	get_intervals(CurrentLimit, RemainingTax, NextIntervals),
	{TotalTax = Tax + RemainingTax}.

get_intervals(Sum, TotalTax):-
	intervals(Int),
	get_intervals(Sum, TotalTax, Int).

to_month(ValueY, ValueM):-
	{ValueM = ValueY / 12}.
	
lux_tax(yearly(Gross), yearly(Net, Deductions, AllDeductions, TaxedIncome, Tax)):-
	fd_reduction(FD),
	deduction_healthcare(Gross, Healthcare),
	deduction_healthcare_contrib(Gross, HealthcareContrib),
	deduction_pension(Gross, Pension),
	deduction_unemployment(Gross, Unemployemnt),
	AllDeductions=deductions{
		healthcare: Healthcare,
		healthcare_contrib: HealthcareContrib,
		pension: Pension,
		unemployment: Unemployemnt
	},

	{
		Deductions = Healthcare + HealthcareContrib + Pension,
		TaxedIncome = Gross - Deductions - FD
	},
	
	get_intervals(TaxedIncome, Tax),
	
	{
		Net = (TaxedIncome - Tax - Unemployemnt)
	}.

lux_tax(yearly(Gross), monthly(Net, Deductions, AllDeductions, TaxedIncome, Tax)):-
	lux_tax(yearly(Gross), yearly(NetY, DeductionsY, AllDeductions, TaxedIncomeY, TaxY)),
	% maplist(to_month, AllDeductionsY, AllDeductions),
	to_month(NetY, Net),
	to_month(DeductionsY, Deductions),
	to_month(TaxedIncomeY, TaxedIncome),
	to_month(TaxY, Tax).

lux_tax(monthly(Gross), monthly(Net, Deductions, AllDeductions, TaxedIncome, Tax)):-
	to_month(GrossY, Gross),
	lux_tax(yearly(GrossY), monthly(Net, Deductions, AllDeductions, TaxedIncome, Tax)).

lux_tax(monthly(Gross), yearly(Net, Deductions, AllDeductions, TaxedIncome, Tax)):-
	to_month(GrossY, Gross),
	lux_tax(yearly(GrossY), yearly(Net, Deductions, AllDeductions, TaxedIncome, Tax)).
