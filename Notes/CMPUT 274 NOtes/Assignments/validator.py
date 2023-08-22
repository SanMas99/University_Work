# Weekly Exercise 1: PASSWORD VALIDATOR:
# Name:Sanad Masannat, UofA ID:1626221,  Fall 2019 CMPUT 274.

def validate(password):
        UpperCaseChecker=False
        LowerCaseChecker=False
        NumberChecker=False
        SpecialCharacterChecker=False
        Length=len(password)#Finds length of the string
        if Length<8:#Checks length and will invalidate any passwords less than 8 characters
            IsValid="Invalid"
            return IsValid
        for counter in range (0,Length):#Will check all characters and exit till reaches end.Length -1 is used as we are starting from 0
            if password[counter]== " " or password[counter]== "-" or password[counter]=="_":
                IsValid="Invalid"
                return IsValid #Exits loop if any invalid characters from a space, hyphen and underscore
            elif password[counter] >= "A" and password[counter]<= "Z":#Checks if the current character is an Upper Case letter
                UpperCaseChecker=True #One of the condition which will be used to see if Password is Secure
            elif password[counter]>="a" and password[counter]<="z":#Checks if the current character is a Lower Case letter
                LowerCaseChecker=True#One of the conditions which will be used to see if Password is Secure
            elif password[counter]== "!" or password[counter] =="#" or password[counter]=="$" or password[counter] == "%" or  password[counter]=="&" or password[counter]=="'" or  password[counter]=="(" or password[counter]==")" or password[counter]=="*" or password[counter]=="[" or password[counter]=="]" or password[counter]== "+" or password[counter]=="," or password[counter]=="." or password[counter]=="/" or password[counter]==":" or password[counter]==";" or password[counter]=="<" or password[counter]==">" or password[counter]=="?" or password[counter]=="@" or password[counter]=="^" or password[counter]=="`" or password[counter]=="{" or password[counter]=="}" or password[counter]=="|" or password[counter]=="~":#Checks to see if ithe current character is from the special characters
                SpecialCharacterChecker = True#One of the conditions to check if password is Secure.
            elif ord(password[counter])>=48 and ord(password[counter])<=57:#Check if current character is a number. Switched the character to ASCII as an error will occur if using number
                NumberChecker=True ##One of the condition which will be used to see if Password is Secure
        if SpecialCharacterChecker ==True and UpperCaseChecker==True and LowerCaseChecker==True and NumberChecker ==True:
            IsValid="Secure"
        else:
            IsValid="Insecure"
        return IsValid
""" Analyzes an input password to determine if it is "Secure", "Insecure", or "Invalid" based on the assignment description criteria.

    Arguments:
        password (string): a string of characters
    Variables used:
        UpperCaseChecker:Check if there is an upper case
        LowerCaseChecker: Check if there is a lower case
        NumberChecker: Check if a number exists within the program
        SpecialCharacterChecker: Check if there is a special character.

    Returns:
        result (string): either "Secure", "Insecure", or "Invalid". IsValid will store the string and then return it and store it in ResultOfValidation
    """
def generate(n):
        UpperCaseChecker=False
        LowerCaseChecker=False
        NumberChecker=False
        SpecialCharacterChecker=False
        import random
        secure_password=""
        ArrayOfCharacters=["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",0,1,2,3,4,5,6,7,8,9,"!","#","$","%","&","'","(",")","*","+",",",".","/",":",";","<","=",">","?","@","[","]","^","`","{","|","}","~"]#All characters that can be used in a secure password
        while UpperCaseChecker==False or LowerCaseChecker==False or NumberChecker==False or SpecialCharacterChecker==False:#Will keep looping until generated password is secure
                UpperCaseChecker=False
                LowerCaseChecker=False
                NumberChecker=False
                SpecialCharacterChecker=False
                secure_password=""
                for Count in range (0,n):#Loops until it reaches a length specified by user
                        secure_password= secure_password+str(ArrayOfCharacters[random.randint(0,89)])#Will generate a random number and look it up from the array and then concatenate it to the generated password
                        if secure_password[Count] >= "A" and secure_password[Count]<= "Z":#Checks if the current character is an Upper Case letter
                                UpperCaseChecker=True #One of the condition which will be used to see if Password is Secure
                        elif secure_password[Count]>="a" and secure_password[Count]<="z":#Checks if the current character is a Lower Case letter
                                LowerCaseChecker=True#One of the conditions which will be used to see if Password is Secure
                        elif ord(secure_password[Count])>=48 and ord(secure_password[Count])<=57:#Check if current character is a number.
                                NumberChecker=True
                        else:
                                SpecialCharacterChecker = True#If it is not a number, or letter, it must be a special character
        return (secure_password)
        """ Generates a password of length n which is guaranteed to be Secure according to the given criteria.
        Arguments:
        n (integer): the length of the password to generate, n >= 8.This has been inputted in the main program before it is passed in and will never be less than 8

        Returns:
        secure_password (string): a Secure password of length n. This is made sure by the while loop preventing it for not being secure
        """
        pass

if __name__ == "__main__":
        Choice = "Yes"
        from random import random
        while Choice=="Yes" or Choice=="yes":#Loop to test various passwords if they are secure or not
                password=input("Input a password to check if it is valid ")
                ValidationString=validate(password)#Calls function and stores it
                print (ValidationString)
                Choice=input("Would you like to try another password? ")
        n=int(input("What length of a secure password would you like? "))#User will input password
        while n<=7:# Will keep looping until the user enter a passowrd length that is greater than 7
                n=int(input("Too Short. Please enter length of a password greater than 7 "))
        GeneratedPassword=generate(n)
        print (GeneratedPassword)
pass





