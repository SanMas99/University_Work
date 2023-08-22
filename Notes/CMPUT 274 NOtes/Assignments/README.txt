Name:Sanad Masannat, 
UoA ID: 1626221, 
CMPUT 274 Fall 2019, 
Weekly Exercise 1: Password Validator
Files in ZIP Files:
	validator.py
	README
Ruuning Instructions:
	Open the Virtual Machine
	Run file in python via virtual machine after downloading file
	Will automatically start the validation part fo the vaildator and is in a lopp to test out various passwords.
	To test the generator, when prompted enter either "Yes or "yes" and will then exit while loop 
Known Issues:
	Line 21 is too long but i am unsure of any other more efficient method to make it shorter
Code:
	Used various boolean flags for both the generation and validation to make sure a number, special character and a letter(Both Upper and Lower case) is included within password
	For the generation, i created an array which contains every single character that could be used(A-Z,a-z,0-9,special characters) and used the randint function and concatenated it to a variable which will store the character
	I used 2 loop, a while and a for. The while loop can only be exited if all boolean flags are set to true. The for loop will go up to the length entered and will generate a random number from 0-89 and search up the character stored in the position in array from the random number
