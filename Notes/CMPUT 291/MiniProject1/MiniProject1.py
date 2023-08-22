import getpass
import sqlite3
from datetime import datetime


def LoginSignup():
    print("Login Screen! Welcome!")
    RegisteredBoolean=input("Are you a registered User? Input one of the following: Y/N")
    while RegisteredBoolean not in "YN":
        RegisteredBoolean=input("Invalid Input. Are you a registered User? Input one of the following: Y/N")
    if RegisteredBoolean=="Y":
        print("Logging in...\n Please input your credentials ")
        RegisteredID=input("What is your ID? ")
        RegisteredPwd=getpass.getpass("What is your Password?" )
        try:
            #Sql code to check if they are in db and see if ID matches pwd
        except:
            print("Incorrect Credentials \n Please input your credentials ")
            RegisteredID=input("What is your ID? ")
            RegisteredPwd=getpass.getpass("What is your Password?" )
        return RegisteredID
        
    else:
        print("Signing you up! Please Input the following Details ")
        NewID=input("Please Input a unique ID ")
        NewPwd=input("What is your Password? ")
        NewName=input("What is your name? ")
        NewCity=input("What is the current city you live in? ")
        #Sql code to add to db
        return NewID
def MainMenu(userID):
    print("Main Menu!")
    print ("Current Actions you can do.\n  1. Post A Question\n 2. Search for Posts\n 3.LogOut")
    choice=str(input("Please input a choice from the following list based on above list. 1/2/3"))
    while choice not in "123":
        choice=str(input("Invalid Choice. Please input a choice from the following list based on above list. 1/2/3 "))
    if int(choice)==1:
        print("You have selected 'Post a Question' ")
        logOutBoolean=PostQuestion(userID)
        return logOutBoolean
    elif int(choice)==2:
        print("You have selected 'Search for a Post' ")
        logOutBoolean=postsID=SearchPost(userID)
        #SQL code to check if they are a privaliged user
        if privaligedUser==True:
            logOutBoolean=Privaliged(postsID)
            return logOutBoolean
        else:
            logOutBoolean=NotPrivaliged(postsID)
            return logOutBoolean
    else:
        print("Logging Out")
        return logOutBoolean=True
    
def NotPrivaliged(postsID):
    print ("Current Actions you can do. 1. Answer a Post\n 2. Vote on Post")
    choice=str(input("Please input a choice from the following list based on above list. 1/2 "))
    while choice not in "12":
        choice=str(input("Invalid Choice. Please input a choice from the following list based on above list. 1/2 "))
    if int(choice)==1:
        print("You have selected 'Answer for a Post' ")
        logOutBoolean=AnswerPost(postsID,userID)
    elif int(choice)==2:
        print("You have selected Vote on a Post")
         logOutBoolean=VotePost(postsID)
    return logOutBoolean




def Privaliged(postsID):
    print ("Current Actions you can do.\n1. Answer a Post\n 2. Vote on Post\n 3. Mark Answer as Accepted Answer\n 4. Give A Badge\n 5. Add a tag\n 6. Edit A Post\n")
    choice=str(input("Please input a choice from the following list based on above list. 1/2/3/4/5/6 "))
    while choice not in "123456":
        choice=str(input("Invalid Choice. Please input a choice from the following list based on above list. 1/2/3/4/5/6 "))
    if int(choice)==1:
        print("You have selected 'Answer for a Post' ")
         logOutBoolean=AnswerPost(postsID,userID)

    elif int(choice)==2:
        print("You have selected Vote on a Post")
         logOutBoolean=VotePost(postsID,userID)

    elif int(choice)==3:
        print("You have selected Mark accepted answer")
         logOutBoolean=MarkAnswer(postsID)

    elif int(choice)==4:
        print ("You have selected 'Give a Badge' ")
         logOutBoolean=GiveBadge(postsID,userID)
        
    elif int(choice)==5:
        print("You have selected Add Tags")
         logOutBoolean=AddTags()

    elif int(choice)==6:
        print("You have selected Edit a Post")
         logOutBoolean=EditAPost(postsID)
    return logOutBoolean

def PostQuestion(userID):
    title=input(" What is your post title? ")
    bodyText= input(" What is your body text? Note: for new line, input \n instead of enter. ")
    newPostID=input(" What do you want your post id to be? ")
    poster=userID
    newDate=datetime.today().strftime('%Y-%m-%d')
    #SQL to add fields to database
    moreActions=input("Would you like to do more actions or log out? True for More Actions, False for Logging out")
    return moreActions
    
def AnswerPost(postsID,userID):
    questionID=postsID
    questionID=questionIDVerification(questionID)
    answerID=input("Input a new answer ID. ")
    answerText=input("Input the body to your answer post")
    postDate=datetime.today().strftime('%Y-%m-%d')
    poster=userID
    #SQL to add fields to database
    moreActions=input("Would you like to do more actions or log out? True for More Actions, False for Logging out")
    return moreActions
    
    
    

def GiveBadge(postsID,userID):
    badgeName: input("What is the name of the badge you are giving? ")
    postToGiveBadge=postsID
    postToGiveBadge=posterIDVerification(postToGiveBadge)
    uid=userID
    moreActions=input("Would you like to do more actions or log out? True for More Actions, False for Logging out")
    return moreActions

def SearchPost(userID):
    keyWordList=[]
    while end==False:
        keyWord=input("What keyword are you looking for?")
        keyWordList.append(keyWord)
        end=input("Would you like to add another keyword? Enter True/False ")
    #SQL code to get a list of codes that match.
    ID=input("What is the id of the post you wish to access? ")
    postID=posterIDVerification(ID)
    return PostID
    #This became a lot ttrickers once I read through it again. The idea we need to look for post with the keywords. Done above i hope. However, we need to show five at a time only.
    #If not we show the next five. We also need to select a Post from here not in other modules .
    # Ill try attempt this


def posterIDVerification(ID):
    ID=input("What is the id of the post you wish to verify? ")
    #Get SQL Post IDs via SQL, Return to an array
def questionIDVerification(ID):
    ID=input("What is the id of the post you wish to verify? ")
    #Get SQL Post IDs via SQL, Return to an array
def answerIDVerification(ID):
    ID=input("What is the id of the post you wish to verify? ")
    #Get SQL Post IDs via SQL, Return to an array

def VotePost(postsID,userID):
    postToVoteOn=postsID
    postToVoteOn=posterIDVerification(postToVoteOn)
    uid=userID
    #update votes table
    moreActions=input("Would you like to do more actions or log out? True for More Actions, False for Logging out")
    return moreActions
    

def MarkAnswer(postsID):
    questionPost=postsID
    questionPost=questionIDVerification(questionPost)
    answerPost=input("What is the answer post you wish to choose? ")
    answerPost=answerIDVerification(answerPost)
    #Another issue will arise here. We need to replace theaid if there is already one there and if its null just insert it
    moreActions=input("Would you like to do more actions or log out? True for More Actions, False for Logging out")
    return moreActions


def AddTags(postsID):
    questionID=postsID
    questionID=postIDVerification(questionID)
    tags=[]
    while end==False:
        tag=input("What tag are you looking to add?")
        tags.append(tag)
        end=input("Would you like to add another tag? Enter True/False ")
    #SQL for adding tags
    moreActions=input("Would you like to do more actions or log out? True for More Actions, False for Logging out")
    return moreActions


def EditAPost(postsID):
    questionID=postsID
    questionID=questionIDVerification(questionID)
    toEdit=input("What do you want to edit: 1) title\n 2) body\n 3)both")
    if toEdit==1:
        newTitle=input("Input the new title")

    if toEdit==2:
        newBody=input("Input the new body")
        
    else:
        newTitle=input("Input the new title")
        newBody=input("Input the new body")

    moreActions=input("Would you like to do more actions or log out? True for More Actions, False for Logging out")
    return moreActions
        
    
    
def Main():
    conn = sqlite3.connect()
    c=conn.cursor()
    #Open the database here....Unsure how to do that
    while quitProgram ==False:#Idea here is to continuously loop through the program 
        userID=LoginSignUp()
        while logOutBoolean==False:
            logOutBoolean=MainMenu(userID)
        quitProgram=input("Would you like to exit or login as another user? True for Logging in/False to quit ")
        if quitProgram==True:
            finalCheck=input("Are you sure? This will close the program? Y/N")
        if finalCheck=='Y':
            print("Quitting program....GoodBye!")
            quit
        else:
            print("Returning to Main Program")
            quitProgram =False
        
    
    
Main()        
        
        
