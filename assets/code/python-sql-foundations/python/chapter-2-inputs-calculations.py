#Tyson Test Python Coding Homework for Ch. 2
#----------------------------page 27 problem 2.1-------------------------------
# request user tells program how many miles he or she intends to drive
distance=float(input("How many miles do you intend to drive?:"))
#request user tells program how fast in mph he or she intends to drive
speed=float(input("How fast in miles per hour do you intend to drive?:"))
#calcuate the ETA of the drive to the user
eta=distance/speed
#display the ETA to the user
print("Estimate time of drive:",round(eta, 1), "hours") 
#convert hours to minutes
print("Minutes until arrival:", round(eta*60,1),"minutes")       

#----------------------------page 28 problem 2.4-------------------------------
#calcuate bmi, given someone's height and weight
#this requires me to prompt for the user's height
height = float(input("please enter height (inches): ")) 
#now that height is known, what range of weight is healthy according to bmi?
weight_low = 18.5*(height**2) / 703
weight_high = 24.9*(height**2) / 703
#print the healthy weight range
print("Healthy weight range:", round(weight_low, 2), "lbs -", round(weight_high, 2), "lbs")

#----------------------------page 28 problem 2.5-------------------------------
#prompt the user to give the program their weight and height using imperial units
height=float(input("please enter your height in inches"))
weight=float(input("please enter your weight in pounds"))
#these imperial units must now be converted to SI units
#take inches*0.0254 to get meters
#take pounds*0.453592 to get kilograms
si_height=height*0.0254
si_weight=weight*0.453592
#use equation for bmi w/ si figures to give user his or her bmi
bmi=si_weight/si_height**2
#display bmi to user
print(round(bmi)) 