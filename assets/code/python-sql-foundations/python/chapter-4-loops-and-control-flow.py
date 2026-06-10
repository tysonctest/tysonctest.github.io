#-----------------------------------HW 3.1-------------------------------------
#Assume that a, b, and c have been defined as a=7, b=8, c=9
#Write if statements that print 'OK' provided that:
    #(a) a is less than b
    #(b) c is less than b
    #(c) the sum of a & b is equal to c
    #(d) the sum of a**2 and b**2 is equal to c**2
a=7
b=8
c=9 
if a<b: 
    print("OK")
if c<b:
    print("OK")
if a+b==c:
    print("OK")
if a**2+b**2==c**2:
    print("OK")
#----------------------------------HW 3.2--------------------------------------
#Repeat what was done prior but have 'Not OK' print when the condition is false
#the variables (e.g. a,b,c) have already been defined, no need to repeat this 
if a<b:
    print("OK")
else:
    print("Not OK")
if c<b: 
    print("OK")
else:
    print("Not OK")
if a+b==c:
    print("OK")
else:
    print("Not OK")
if a**2+b**2==c**2:
    print("OK")
else: 
    print("Not OK")
#---------------------------------HW 3.3---------------------------------------
#Write a for loop that iterates over a list of numbers of a list named lst3
#this list contains the numbers 2 though 9
#Print the odd numbers over the iterated list
lst3=[2,3,4,5,6,7,8,9]
for odd_num in lst3 :
    if odd_num % 2 !=0:
        print(odd_num)
#--------------------------------HW 3.4----------------------------------------
#Write a for loop that iterates over a list of numbers named lst34
#this list contains the same numbers as before
#have it print the numbers whose square is divisible by 9
lst34=[2,3,4,5,6,7,8,9] 
for num in lst34:
    if (num**2) % 9==0:
        print(num)
#an alternative way to solve this problem exists
list34=[2,3,4,5,6,7,8,9]
for num in lst34:
    if ((num**2)/9).is_integer():
        print(num)
#----------------------------------HW 3.6--------------------------------------
#Implement a program that requests positive integer n from the user
#take this integer and print the first 5 mulitples of it
user_number=int(input("Choose a number, any positive whole number will do!: "))
#make 5 multiples 
for i in range(1,6):
    multiples=user_number*i 
    print(multiples)  
#---------------------------------HW 3.7---------------------------------------
#Implement a program that requests a positive integer n 
#print on the screen all the positive integer divisors of n 
user_number=int(input("Choose a number, any positive whole number will do! "))
for i in range(1,user_number+1):
    if user_number % i==0:
       print(i)
#-------------------------------HW 3.8-----------------------------------------
#Implement a program that requests 4 numbers (int or floating point)
#Summarize the first 3 numbers, then compare that to number 4
#If they are equal, print equal 
user_number1=float(input("Please enter your first number: "))
user_number2=float(input("Please enter your second number: "))
user_number3=float(input("Please enter your third number: "))
user_number4=float(input("Please enter your fourth number: "))
sum_of_first_three_user_numbers=user_number1+user_number2+user_number3
if sum_of_first_three_user_numbers==user_number4:
    print("equal")
else:
    print("not equal")