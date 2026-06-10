#------------Tyson Test Computer Coding Homework for Chapter 5-----------------
#-----------------Question 5.7 - The Dollar Store (pg. 85)---------------------
# All items are sold for a dollar
# Those who buy 10 or more items are given a 5% discount
# Applicable sales tax is 7.5%
# write a function that defines CalcCost within itself
# ask user for input 
count=int(input("Please enter the number of items: "))     
# define CalcCost function
def CalcCost(count): 
     price_per_item = 1 
     total_cost = price_per_item * count 
     if count >= 10:
         total_cost*=(1-.05)  
     return total_cost 
# display one line of output formatted to a certain number of decimal places
def displayLine(label, amount):
    rounded_amount=format(amount, '.2f') 
    print(label, rounded_amount)      
# display net cost, tax, and after tax amounts using calls to the displayline() function   
def display (cost, tax):  
    after_tax=cost + tax 
    displayLine("Net Cost:",cost)  
    displayLine("Tax:",tax) 
    displayLine("After Tax:", after_tax)    
# calcuate total cost and after-tax cost
total_cost=CalcCost(count)
tax = total_cost*.075 # this is the decimal representation of a 7.5% sales tax
# display results to user
display(total_cost,tax) 
#-------------------Question 6.1 - Min & Max (pg. 99)--------------------------
#Write a function called minmax()that takes a list argument and returns 
#the largest and smallest number without using the in-built functions of python
#prompt the user to give the program a list of numbers
num_list=input("Please enter a list of numbers that are seperated by spaces: ").split()
num_list=[int(num)for num in num_list] 
# define minmax function  
def minmax(alist): 
    # initialize min and max with the first element of the list
    min_value = alist[0] 
    max_value = alist[0]
    # iterate through this list to find the min and max values
    for num in alist :
        if num<min_value :
            min_value=num  
        if num>max_value :
            max_value=num 
    # return min and max values  
    return min_value, max_value 
#call the minmax function to display the results 
lo, high=minmax(num_list) 
if lo is not None and high is not None: 
    print("low", lo)
    print("high", high) 
else : 
    print("No numbers were inserted, as such there is no min or max to speak of")
#----------------Question 6.3 - Mean & Standard Deviation (pg. 100)------------
#Write a program that determines the mean and standard deviation of numbers that fall in a certain range 
#prompt the user to give the program a list of numbers 
num_list=input("Please enter a list of numbers that are seperated by spaces: ").split()
#make sure these numbers are in float form 
try:
    num_list=[float(num)for num in num_list]  
except ValueError :
    print("You have provided an input that is incompatable with the program, please reattempt: ")
    exit() 
#range for filitering 
range_input=input("Please enter the range for filtering (low, high): ")
#convert the range input given by the user into floats
try:
    low, high=[float(num) for num in range_input.split()]
except ValueError:
    print("Please be sure to give the program the low and high value")
    exit()
#filter outliers    
def filterOutliers(alist, arange):
    return [num for num in alist if arange[0]<=num<=arange[1]] 
#write a function to calculate the mean and standard deviation 
def calcStats(alist) :
    if not alist:
        return None, None
    #calculate
    mean=sum(alist)/len(alist)  
    #calculate variance
    variance=sum((num-mean)**2 for num in alist)/len(alist) 
    #calculate standard deviation
    standard_deviation=variance**.5
    return mean, standard_deviation 
#filter numbers with the certain range
certain_range=filterOutliers(num_list, (low, high)) 
#compute mean and standard deviation by calling the function
mean, standard_deviation=calcStats(certain_range)  
#display mean and standard deviation (but not variance, that is used to find std dev.)
if mean is not None and standard_deviation is not None:
    print("Numbers within the range:", certain_range) 
    print("Mean", mean)
    print("Standard Deviation", standard_deviation) 