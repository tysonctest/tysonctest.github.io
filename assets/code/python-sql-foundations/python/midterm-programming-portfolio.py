#----------------------Tyson Test Midterm Programming Portfolio----------------
#------------------DSCI 405----------------Business Analytics Fundamentals-----
#------------------------------Problem 2.2-(example on pg. 20)------------------
#A parking garage charges $5 plus $2.50 for every hour parked, the max fee is $20
#Write a program that prompts for hours parked, the calcuates and displayed the total owed
hours_parked=float(input("For how many hours was your car in the garage?:")) 
#now that I know how many hours he was parked, take this times the hourly charge rate
hourly_charge=hours_parked*2.50 
#now that the charge for number of hours is known, the fixed cost needs to be added
total_charge=hourly_charge+5 
#total charge is capped at $20
final_charge=min(total_charge,20) #min function says if total charge is more than 20, go with 20
#display final charge to the user, with formatting done to ensure visually appealing presentation
print("Total Owed: $", format(final_charge,'2,.2f'))  
#---------------------------------Problem 3.1-(example on pg. 36)--------------
#Write a progam that prompts a user to give temperature in degrees Fahrenheit
#Calcuate and then display the same temperature in degrees Celsius 
#Tell the user what state of matter water at that temperature is in
temperature_fahrenheit=float(input("What is the temperature in Fahrenheit? ")) 
#convert this to celsius using the formula given in the problem
temperature_celsius=(temperature_fahrenheit-32) * 5/9
#tell the user what state of matter water at the temprature is in 
if temperature_celsius>100:
    print("Water is a gas at this temperature.") 
elif 0<temperature_celsius<100:
    print("Water is a liquid at this temprature.") 
else:
    temperature_celsius<=0 
    print("Water is solid at this temprature.")
print("Temperature in degrees Celsius:", round(temperature_celsius,1)) 
#----------------------------Problem 4.2 (example on pg. 47)-------------------
#Write a program that allows a user to enter a set of numbers that keeps track of the max and min
#When the user is done entering numbers, the program should calcuate and display the range of numbers
#The user being done with entering numbers is denoted by him entering a zero
user_value=float(input("Please enter an initial value:   ")) 
#make sure starting value isn't 0
if user_value<=0:
    print("Please make sure initial value is not 0 or a negative number")
#now that the user his provided his first number, initialize the variables prior to iteration
largest=user_value # keep track of the largest variable 
smallest=user_value # keep track of the smallest variable 
#repitition to prompt for values and keep track of the max and min
while user_value !=0 :
    if user_value > largest : # is the latest entry larger than the entries up till now?
        largest=user_value 
    if user_value < smallest : # is the latest entry smaller than the entries up till now? 
        smallest=user_value
#prompt for subsequent values 
    user_value=float(input("Please enter another value (entering 0 will end the program):   "))
#calcuate the range
range_of_user_values=largest-smallest 
#output the result
print("The range of your numbers is:   ",range_of_user_values)
#----------------------------Problem 5.2-(example on pg. 72)-------------------
#Write a function named CalcCost, that takes two required parameters, count & price
#The function should have one named parameter named discount
#prices very depending on the item in question 
#discount is 10%, it kicks in once item count exceeds 4
#define the function using the signature the problem gave me
def calcCost(count, price, discount=.1):
    #check if the count is equal to or exceeds 5 for discount 
    if count >=5 :
        total=count*price*(1-discount)
    else: 
        total=count*price
#return the total so it can be used when the function is called later
    return total 
# get inputs
count=int(input("Please enter the number of items you are buying today: "))
price=float(input("Please enter the price per item of your purchase today:$ ")) 
#call the function to get the total cost
total=calcCost(count, price) 
#display function output to user
print("Cost=$", format(total, '2.2f'))  
#---------------------------Problem 6.3-(example on pg. 90)--------------------
#Write a program that allows the user to input a series of numbers
#My program should store these numbers in a list
#After the user has completed entering the numbers (by entering a 0), 
#My program should display the list and range of the numbers within said list
def getValues():
    result = [] # define an empty list  
    user_value=float(input("Please enter an initial value:   ")) #prompt for first input
    while user_value !=0:   #keep prompting for values until the user enters 0
        result.append(float(user_value)) # add a value to end of list
        user_value=float(input("Please enter another value (entering 0 will end the program):  "))
    return result # the result needs to be returned so it can be used later to calcuate range 
#call the function so that it can be used 
user_values=getValues() 
#display this list of values to the user
print("Your list contains the following:", user_values)
#find the max and min of the user's list
if user_values:
    largest=max(user_values)
    smallest=min(user_values)
#now that max and min are both known, find range
range=largest-smallest
#display the list and range to the user 
print("Range:",range)   