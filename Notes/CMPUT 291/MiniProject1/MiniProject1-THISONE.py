import getpass
import sqlite3
import sys
from uuid import uuid4
from datetime import datetime


def LoginSignUp():
    print("\n---LOGIN PAGE---")
    
    UserChoice = input("Are you a registered User (Y/N)?\nEnter Q to quit the program\n")
    while not CheckInput(UserChoice, True): #Quit option is enabled, hence TRUE
        UserChoice = input("Are you a registered User (Y/N)?\nEnter Q to quit the program\n")

    if UserChoice in "Yy":
        print("Logging in...\nPlease input your credentials ")
        RegisteredID = input("What is your ID? ")
        RegisteredPwd = getpass.getpass("What is your Password? ")
        try:
            #Sql code to check if they are in db and see if ID matches pwd
            a = 1 # REMOVE WHEN DONE
        except:
            print("Incorrect Credentials \n Please input your credentials ")
            RegisteredID = input("What is your ID? ")
            RegisteredPwd = getpass.getpass("What is your Password?" )
        return RegisteredID
        
    elif UserChoice in "Nn":
        print("Signing you up! Please follow the prompts and enter your information.")
        NewID   = input("Please enter a unique ID: ")
        NewPwd  = input("Please enter a password: ")
        NewName = input("What is your name? ")
        NewCity = input("What is the current city you live in? ")
        #Sql code to add to db
        return NewID
    else:
        ExitProgram()

def MainMenu(userID):
    print("\n---MAIN MENU---")
    print ("\n1. Post a question\n2. Search for posts \n3. Logout\n0. Quit") # Options available to all
    OptionList = "123490"

    choice = str(input("Please input a choice from the above list.\n"))
    
    while choice not in OptionList:#Prevents the user from inputting an invalid choice
        choice = str(input("Invalid Choice. Please input a choice from the above list.\n"))
    
    if choice == "1":
        PostQuestion(userID)

    elif choice == "2":
        SearchPost()

    elif choice == "3":
        AnswerPost(userID)

    elif choice == "4":
        VotePost(userID)

    elif choice == "5":
        MarkAnswer()

    elif choice == "6":
        GiveBadge()

    elif choice == "7":
        AddTags()

    elif choice == "8":
        EditAPost()

    elif choice == "3": # Breaks menu loop, returns to login page
        return True

    else:     
        ExitProgram()

def CheckPrivilege(userID):
    # Gather all priv users and see if current userid is in the list
    # Assume user is not priv until proven in search (isPriv is set to false)
    # Set isPriv to true is user is priv

    isPriv = False
    cur.execute("SELECT * FROM privileged")
    PrivUsers = cur.fetchall()
    for user in PrivUsers:
        if userID in user:
            isPriv = True

    return isPriv

def PostQuestion(userID):
    #Gets the users choice of title and the body text from the makePostInfo() function
    #Attempts to inset them into posts and the questions tables
    #Flags an error to the user if fails
    print("You have selected 'Post a question'\n")

    title, bodyText, newPostID, newDate = makePostInfo()

    try: 
        params = (newPostID, newDate, title, bodyText, userID)
        cur.execute("INSERT INTO posts VALUES(?, ?, ?, ?, ?);", params)
        conn.commit()
        
        cur.execute("INSERT INTO questions VALUES(?, NULL);", (newPostID,))
        conn.commit()
    
        print("\nYour question has been successfully posted.")
    except:
        print("An error has occurred, please try again")

def makePostInfo():
    # Gather title and bodytext (cannot be blank)
    # Gather date and new unique pid
    # Return all gathered post data

    title = input("What will the title of your post be? ")
    while not title:
        title = input("Title cannot be blank. Please Try again.\nWhat will the title of your post be? ")
    
    bodyText = input("Enter the main body of your post: ")
    while not bodyText:
        bodyText = input("Body cannot be blank. Please Try again.\nEnter the main body of your post: ")

    postID  = makePostID()
    date    = datetime.today().strftime('%Y-%m-%d')

    return title, bodyText, postID, date 

def AnswerPost(userID):
    print("You have selected 'Post action-Answer'\n")
    questionID = input("What is the ID of the question you wish to answer: ")
    
    if questionIDVerification(questionID):
        title, bodyText, newPostID, newDate = makePostInfo()

        try:
            params = (newPostID, newDate, title, bodyText, userID)
            cur.execute("INSERT INTO posts VALUES(?, ?, ?, ?, ?);", params)
            conn.commit()

            cur.execute("INSERT INTO answers VALUES(?, ?);", (newPostID, questionID))
            conn.commit()

            print("\nYour answer has been successfully posted.")
        except:
            print("An error has occurred, please try again")
    else:
        print("Sorry that is not a valid question ID")

def GiveBadge():
    print ("You have selected 'Post action-Give a Badge'\n")

    badgeName: input("What is the name of the badge you are giving? ")
    # postToGiveBadge = postsID
    # postToGiveBadge = posterIDVerification(postToGiveBadge)
    # uid = userID

def SearchPost(userID):
    
    print("You have selected 'Search for a Post'\n")

    keyWordList = []
    end = False

    while not end:#Adds as many key words as the user wants to search for in posts
        keyWord = input("What keyword are you looking for? ")
        keyWordList.append(keyWord)
        choice = input("Would you like to add another keyword (Y/N)? ")
        while not CheckInput(choice, False):
            choice = input("Would you like to add another keyword (Y/N)? ")
        if choice in "Nn":
            end = True
    #SEARCH DB
            
      if CheckPrivilege(userID):  # Check is user is privileged
        print ("3. Post action-Mark as the accepted \n4. Post action-Give a badge\n5. Post action-Add a tag\n6. Post Action-Edit")
        OptionList = "12345670" # Enable extra options
    else:
        OptionList = "120"
    if choice == "1":
        AnswerPost(userID)

    elif choice == "1":
        VotePost(userID)

    elif choice == "3":
        MarkAnswer()

    elif choice == "4":
        GiveBadge()

    elif choice == "5":
        AddTags()

    elif choice == "6":
        EditAPost()
        
    elif choice == "7": # Breaks menu loop, returns to login page
        return True

    else:     
        ExitProgram()

def VotePost(userID):
    print("You have selected 'Post action-Vote'\n")
    
    postID = input("Please enter the post ID of a post you'd like to vote on: ").lower()
    if postIDVerification(postID):
        if validVote(userID, postID):
            newDate = datetime.today().strftime('%Y-%m-%d')
            newVno = makeVno(postID)

            try:
                params = (postID, newVno, newDate, userID)
                cur.execute("INSERT INTO votes VALUES(?, ?, ?, ?);", params)
                conn.commit()
                
                print("\nYour vote has been successfully cast.")
            except:
                print("\nAn error has occurred, please try again")

        else:
            print("\nYou have already voted on this post.")
    else:
        print("\nSorry that post ID is invalid.")

def MarkAnswer():
    print("You have selected 'Post action-Mark as the accepted'\n")


    # questionPost = postsID
    # questionPost = questionIDVerification(questionPost)
    # answerPost = input("What is the answer post you wish to choose? ")
    # answerPost = answerIDVerification(answerPost)
    #Another issue will arise here. We need to replace theaid if there is already one there and if its null just insert it

def AddTags():
    print("You have selected 'Post action-Add a tag'\n")
    postID = input("Please enter the post ID to add a tag to: ").lower()
    if postIDVerification(postID):
        tags = []
        moreTags = True
        
        while moreTags:
            tag = input("Enter the tag you'd like to add: ")
            tags.append(tag)
            choice = input("Would you like to add another tag (Y/N)? ")
            while not CheckInput(choice, False):
                choice = input("Would you like to add another tag (Y/N)? ")
            if choice in "Nn":
                moreTags = False
        try:
            for tag in tags:
                cur.execute("INSERT INTO tags VALUES(?, ?)", (postID, tag))
                conn.commit()
            print("\nYour tag(s) have been successfully added.")
        except:
            print("\nSorry duplicate tags are not allowed")
    else:
        print("\nSorry that post ID is invalid.")

def EditAPost():
    print("You have selected 'Post action-Edit'\n")
    questionID = postsID
    questionID = questionIDVerification(questionID)
    toEdit = input("What do you want to edit: 1) title\n 2) body\n 3)both")
    if toEdit == 1:
        newTitle = input("Input the new title")

    if toEdit == 2:
        newBody = input("Input the new body")
        
    else:
        newTitle = input("Input the new title")
        newBody = input("Input the new body")

def validTag(postID, newTag):
    # Check to see if the given tag is unique to that post
    cur.execute("SELECT * FROM tags WHERE pid = ? AND tag like ?", (postID, newTag))
    allTags = cur.fetchall()
    if not allTags:
        return True
    else:
        return False

def validVote(userID, postID):
    # Check to see if the given user has already voted on the given post
    cur.execute("SELECT * FROM votes WHERE pid = ? AND uid = ?", (postID, userID))
    allVotes = cur.fetchall()
    if not allVotes:    # Check to see if return is empty
        return True     # Signal that a vote can be cast by this user
    else:
        return False    # Signal user has already voted

def postIDVerification(ID):
    if questionIDVerification(ID) or answerIDVerification(ID):
        return True
    else:
        return False

def questionIDVerification(ID):
    isValid = False
    
    allQuestions = cur.execute("SELECT pid FROM questions;")
    for question in allQuestions:
        if ID in question:
            isValid = True
    return isValid
    
def answerIDVerification(ID):
    isValid = False
    
    allAnswers = cur.execute("SELECT pid FROM answers;")
    for answer in allAnswers:
        if ID in answer:
            isValid = True
    return isValid

def CheckInput(UserInput, EnableQuitting):
    # Check y/n input, case-insensitive
    # Returns true if input is y or n
    # Return true if input is q (if quitting is enabled through EnableQuitting)

    if EnableQuitting:
        AllowedLetters = "YyNnQq"
    else:
        AllowedLetters = "YyNn"
    if UserInput not in AllowedLetters:
        print("Invalid Input.")
        return False 
    return True

def ExitProgram():
    # Exits program upon being called 
    # Saves database changes before closure
    conn.commit()
    conn.close()
    print("\nShutting down...\nGoodbye.")
    exit()

def GetDB():
    # Gets the sqlite3 database from the command line arguments
    # Exits program is database is invalid

    global conn, cur
    preface = "./"
    try:
        db_file = str(sys.argv[1])
        conn = sqlite3.connect(preface + db_file)
        cur = conn.cursor()
        conn.commit()
    except:
        print("Invalid database file.")
        exit()

def makePostID():
    # Will make a random and UNIQUE post id
    # Uses the first 4 characters from UUID4()
    
    prevUsed = True # Assume it has been used already
    while prevUsed:
        newPID = str(uuid4())[:4] # Create pid
        
        cur.execute("SELECT pid FROM posts WHERE pid = ?;", (newPID,))
        allPosts = cur.fetchall()
        
        if not allPosts:
            prevUsed = False # Prove it is unique

    return newPID

def makeVno(postsID):
    # Make the new highest vno for the given post
    maximum = 0

    allnums = cur.execute("SELECT vno FROM votes WHERE pid = ?;", (postsID,)) 
    for tuples in allnums:
        for num in tuples:
            maximum = num # Get current highest vno
    return str(maximum + 1)
    
def main():
    
    isQuit      = False # Has the user chosen to quit
    isLogout    = False # Is the user logged out

    GetDB()    # Get the database from command line
    while not isQuit:
        userID = LoginSignUp()  # Get user ID
        
        while not isLogout: # Loop main menu until user wants to log out
            isLogout = MainMenu(userID)
        print("\nLogging out.\n")
    ExitProgram()   # Shutdown safely after loop ends
        
main()

