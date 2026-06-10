# Tyson Test Python Coding Homework for Problem 3.1
#-------------------------page 43 question 3.1---------------------------------
#prompt the user to tell the program how many items he or she is buying
items_bought=int(input("How many items is the customer buying?:"))
#All items in this store are a dollar, before discount and tax are applied
unit_rate=items_bought*1
#determine if the customer is eligible for the bulk-purchase discount (10+ items)
#discount is 5% off total, so take items*95 cents/item to get that total 
if items_bought>=10:
    gross_cost=unit_rate*.95
else: 
    gross_cost=items_bought
#this gives us pre-tax total, the sales tax of 7.5% must now be applied 
sales_tax=gross_cost*.075
net_cost=gross_cost+sales_tax
#the customer must now be informed of his or her total
print("Gross cost: $",round(gross_cost,2))
print("Sales tax: $",round(sales_tax,2))
print("Total due: $", round(net_cost,2))
#-------------------------page 43 question 3.2---------------------------------
#prompt the user to give the program their weight and height using imperial units
height=float(input("please enter your height in inches"))
weight=float(input("please enter your weight in pounds"))  
#calculate bmi using the appropriate equation for imperial units
bmi=(weight/(height**2))*703
#plug user bmi data into logical and math operations 
if 18.5<=bmi<=24.9: 
    print("you are within the healthy bmi range")
elif bmi > 24.9 :
#if the user is overweight, I can calcuate what weight would get him or her back to healthy
    target_weight=24.9*(height**2)/703
    weight_loss_required=weight-target_weight 
    print(round(weight_loss_required),2)
else : 
    target_weight=18.5*(height**2)/703
    weight_gain_required=target_weight-weight 
    print(round(weight_gain_required),2)
#-------------------------page 44 question 3.5--------------------------------- 
#prompt the user to give the program his or her income
user_income=float(input("What was your total income last year?: "))
# initalize the federal_income_tax_paid & marginal_tax_rate variables 
federal_income_tax_paid=0
marginal_tax_rate=0 
#now that income is known, federal income tax paid can be calculated
if user_income <= 9875 :
    federal_income_tax_paid=user_income*.10 
    marginal_tax_rate=.10
elif user_income <=40125 :
    federal_income_tax_paid=((user_income-9875)*.12)+986
    marginal_tax_rate=.12
elif user_income <=85524 :
    federal_income_tax_paid=((user_income-40125)*.22)+4618
    marginal_tax_rate=.22
elif user_income <=163300 :
    federal_income_tax_paid=((user_income-85524)*.24)+14606
    marginal_tax_rate=.24
elif user_income <=207350 :
    federal_income_tax_paid=((user_income-163300)*.32)+33272
    marginal_tax_rate=.32
elif user_income <=518400 :
    federal_income_tax_paid=((user_income-207350)*.35)+47368
    marginal_tax_rate=.35
else:
    federal_income_tax_paid=((user_income-518400)*.37)+156235
    marginal_tax_rate=.37
#calcuate the effective tax rate
effective_tax_rate=(federal_income_tax_paid/user_income)*100
#print values to be displayed to the user
print("federal inccome tax paid" ,(federal_income_tax_paid))
print("effective tax rate", (effective_tax_rate))
print("marginal tax rate", (marginal_tax_rate)) 