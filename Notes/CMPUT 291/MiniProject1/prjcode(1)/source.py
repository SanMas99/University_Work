import getpass
import sqlite3
import sys
from uuid import uuid4
from datetime import datetime


def LoginSignUp():
    # Login page, returns USER ID upon completion
    print("\n---LOGIN PAGE---")
    
    UserChoice = raw_input("Are you a registered User (Y/N)?\nEnter Q to quit the program\n")
    
    while not CheckInput(UserChoice, True): #Quit option is enabled, hence TRUE
        UserChoice = raw_input("Are you a registered User (Y/N)?\nEnter Q to quit the program\n")    
    
    if UserChoice in "Yy":  # If existing user
        print("Logging in...\nPlease input your credentials ")
        RegisteredID = raw_input("What is your ID? ")        
        RegisteredPwd = getpass.getpass('Please enter your password: ')
        
        if not validPassword(RegisteredID, RegisteredPwd):
            print("Invalid.")
            LoginSignUp()
           
        return RegisteredID
        
    elif UserChoice in "Nn": # If new user
        print("Signing you up! Please follow the prompts and enter your information. ")
        # Get user id
        NewID = raw_input("Please Input a unique ID: ")
        while not isUniqueID(NewID):    # Ensure it is unique
            print("Sorry that uid is taken or invalid. Try again.")
            NewID = raw_input("Please Input a unique ID: ")

        # Get name
        NewName = raw_input("What is your name? ")
        while not NewName or not NewName.strip(): # Cannot be empty or spaces
            NewName = raw_input("Name cannot be blank.\nWhat is your name? ")
        
        # Get password
        NewPwd = raw_input("Please Input a Password: ")
        while not NewPwd or not NewPwd.strip():
            NewPwd = raw_input("Password cannot be blank.\nPlease Input a Password: ")       
        
        # Get city
        NewCity = raw_input("What is the current city you live in? ")
        while not NewCity or not NewCity.strip():
            NewCity = raw_input("City cannot be blank.\nWhat is the current city you live in? ")

        Newdate = datetime.today().strftime('%Y-%m-%d') # Get sys date
        
        # Insert new user into db
        cur.execute("INSERT INTO users VALUES (?, ?, ?, ?, ?);", (NewID, NewName, NewPwd, NewCity, Newdate))
        conn.commit()
       
        return NewID
    
    elif UserChoice in "Qq": # Quit selected
        ExitProgram()

def isUniqueID(givenID):
    # Check to see if the given user ID is taken
    if not givenID or not givenID.strip(): # Ensure not empty or spaces
        return False
    cur.execute("SELECT uid from users WHERE uid like ?;", (givenID,))
    allUsers = cur.fetchall()
    if not allUsers:
        return True
    else:
        return False

def validPassword(RegisteredID, RegisteredPwd):
    # Check to see if the given password corresponds to the user id entered.
    
    cur.execute("SELECT * FROM users WHERE uid like ? AND pwd = ?", (RegisteredID, RegisteredPwd))
    found = cur.fetchone()
    if found:   # If not blank, the user/pwd combo exists
        return True     
    else:
        return False

def MainMenu(userID):
    # Main menu of program
    print("\n---MAIN MENU---")
    print ("\n1. Post a question\n2. Search for posts\n9. Logout\n0. Quit") # Options available to all

    OptionList = "1290" # Options available to all
    choice = str(raw_input("Please input a choice from the above list.\n"))

    while choice not in OptionList:
        choice = str(raw_input("Invalid Choice. Please input a choice from the above list.\n"))

    if choice == "1":
        PostQuestion(userID)

    elif choice == "2":
        SearchPost(userID)

    elif choice == "9": # Return to login
        LoginSignUp()

    else:   # Exit
        ExitProgram()

def getPoster(postID):
    # Return the poster's ID from the given postID
    cur.execute("SELECT poster FROM posts WHERE pid like ?;", (postID,))
    poster = cur.fetchall()
    return poster[0][0] # Get raw data from array


def PostActionMenu(userID, postID):
    # Action menu of program
    print("\n---POST ACTION MENU---")
    print("1. Post answer\n2. Cast vote") # Actions availble to all

    if CheckPrivilege(userID):  # Check is user is privileged
        print ("3. Mark as the accepted \n4. Give a badge\n5. Add a tag\n6. Edit")
        OptionList = "123456890" # Enable extra options
    else:
        OptionList = "12890"

    print("8. Return to main menu\n9. Logout\n0. Quit") # Actions available to all

    choice = str(raw_input("Please input a choice from the above list.\n"))

    while choice not in OptionList:
        choice = str(raw_input("Invalid Choice. Please input a choice from the above list.\n"))

    if choice == "1":
        AnswerPost(userID, postID)

    elif choice == "2":
        VotePost(userID, postID)

    elif choice == "3":
        MarkAnswer(userID, postID)

    elif choice == "4":
        GiveBadge(userID, postID)

    elif choice == "5":
        AddTags(userID, postID)

    elif choice == "6":
        EditAPost(userID, postID)

    elif choice == "8":
        MainMenu(userID) # Return to main menu
        
    elif choice == "9":
        LoginSignUp()
    
    else:     
        ExitProgram()

def SearchPost(userID):
    print("You have selected 'Search for a Post'\n")

    keyWordList = []
    end = False

    while not end: # Adds as many key words as the user wants to search for in posts
        keyWord = raw_input("What keyword are you looking for? ")
        keyWordList.append(keyWord)
        choice = raw_input("Would you like to add another keyword (Y/N)? ")
        while not CheckInput(choice, False): # Ensure valid y\n
            choice = raw_input("Would you like to add another keyword (Y/N)? ")
        if choice in "Nn":
            end = True

    # Use each keyword to query
    for i in range(len(keyWordList)):
        currentKeyword = ('%{}%'.format(keyWordList[i])) # Same as %?% in sql, allows for string matching
        cur.execute("SELECT posts.pid, pdate, title, body, poster, ifNull(ansFreq,0), ifNull(voteCnt,0), t3.tag \
            FROM tags, posts \
            LEFT JOIN (SELECT questions.pid, COUNT(answers.pid) AS ansFreq \
            FROM questions, answers \
            WHERE questions.pid = answers.qid \
            GROUP BY questions.pid) AS t1 ON posts.pid=t1.pid \
            LEFT JOIN (SELECT posts.pid, COUNT(votes.pid) AS voteCnt \
            FROM posts,votes \
            WHERE posts.pid=votes.pid \
            GROUP BY posts.pid \
            ORDER BY posts.pid ASC) AS t2 ON posts.pid=t2.pid \
            LEFT JOIN (SELECT posts.pid, tags.tag \
            FROM posts \
            LEFT JOIN tags ON posts.pid=tags.pid \
            GROUP BY posts.pid, tags.tag) AS t3 ON posts.pid=t3.pid \
            WHERE t3.tag LIKE ? \
            OR title LIKE ? \
            OR body LIKE ? \
            GROUP BY posts.pid;", (currentKeyword, currentKeyword, currentKeyword))

        listofPost=cur.fetchall() # Get all relevant posts
        
        if not listofPost: # If no results
            print("No relevant posts")
            MainMenu(userID)
        else: # Print results
            isFinished = False # Indicate if user is done going through pages
            
            while i != len(listofPost) and not isFinished: # While there are posts left and the user isnt done
                if (i%5 == 0 or i == len(listofPost)): # While the count is a multiple of 5 or at the end of the list
                    if (i != 0): # Ignore first index because (0%5 == 0)
                        
                        print("---END OF PAGE---") # Prompt user for next page
                        choice = raw_input("Do you want to see the next page (Y/N)? ")
                        if not CheckInput(choice, False):
                            choice = raw_input("Do you want to see the next page (Y/N)?")
                        if choice in "Nn": # Break loop if they want to end
                            isFinished = True
                if not isFinished:
                    print(listofPost[i]) # Print the post after each iteration
                    i += 1   # Increase count

            if i == len(listofPost): #When reached the end of the list
                print("---END OF RESULTS---")
        
            # Get a list of all relevant post ids
            listofIDs = []
            for post in listofPost:
                listofIDs.append(post[0].lower())

            # Let the user choose a post id from the prompts
            chosenPostID = raw_input("Please type in your chosen post ID.\nTyping 'return' will return you back to the main menu.\n").lower()
            if chosenPostID == "return":
                MainMenu(userID)
            while chosenPostID not in listofIDs:
                chosenPostID = raw_input("Invalid input.\nPlease type in your chosen post ID.\nTyping 'return' will return you back to the main menu.\n").lower()
                if chosenPostID == "return":
                    MainMenu(userID) # Return to main menu
            PostActionMenu(userID, chosenPostID) # Go to action menu



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
    print("You have selected 'Post a question'\n")
    # Get post data
    title, bodyText, newPostID, newDate = makePostInfo()

    # Insert post data into database as question
    try:
        params = (newPostID, newDate, title, bodyText, userID)
        cur.execute("INSERT INTO posts VALUES(?, ?, ?, ?, ?);", params)
        conn.commit()

        cur.execute("INSERT INTO questions VALUES(?, NULL);", (newPostID,)) # No answer thus far
        conn.commit()

        print("\n--\nYour question has been successfully posted.\n--")
        MainMenu(userID)
        
    except:
        print("\n--\nAn error has occurred, please try again\n--")

def makePostInfo():
    # Gather title and bodytext (cannot be blank)
    # Gather date and new unique pid
    # Return all gathered post data

    title = raw_input("What will the title of your post be? ")
    while not title:
        title = raw_input("\nTitle cannot be blank. Please Try again.\nWhat will the title of your post be? ")

    bodyText = raw_input("Enter the main body of your post: ")
    while not bodyText:
        bodyText = raw_input("\nBody cannot be blank. Please Try again.\nEnter the main body of your post: ")

    postID  = makePostID() # Get post id
    date    = datetime.today().strftime('%Y-%m-%d') # Get sys date

    return title, bodyText, postID, date

def AnswerPost(userID, questionID):
    print("You have selected 'Post action-Answer'\n")

    if questionIDVerification(questionID): # Ensure the selected post is a question
        # Get post data
        title, bodyText, newPostID, newDate = makePostInfo()
        # Insert into database as answer
        try:
            params = (newPostID, newDate, title, bodyText, userID)
            cur.execute("INSERT INTO posts VALUES(?, ?, ?, ?, ?);", params)
            conn.commit()

            cur.execute("INSERT INTO answers VALUES(?, ?);", (newPostID, questionID)) # Use the selected question ID
            conn.commit()

            print("\n--\nYour answer has been successfully posted.\n--")
            PostActionMenu(userID, questionID)  # Return back to menu
        except:
            print("\n--\nAn error has occurred, please try again\n--")
            PostActionMenu(userID, questionID) 
    else:
        print("\n--\nSorry that is not a valid question ID\n--")
        PostActionMenu(userID, questionID)

def GiveBadge(userID, postID):
    print ("You have selected 'Post action-Give a Badge'\n")
    posterID = getPoster(postID) # Get poster from postID
    badgeName = str(raw_input("What is the name of the badge you are giving? "))
    if validBadge(badgeName): # Ensure badge is valid
        badgeName = getRealBadge(badgeName) # Get the badge from the database (ignore users case sensitivity)
        newDate = datetime.today().strftime('%Y-%m-%d')
        try:
            params = (posterID, newDate, badgeName)
            cur.execute("INSERT INTO ubadges VALUES(?, ?, ?);", params) # Give badge to poster
            conn.commit()
            print("\n--\nThe badge has been successfully awarded.\n--")
            PostActionMenu(userID,postID) # Return to menu
        except:
            print("\n--\nAn error has occurred, please try again\n--")
            PostActionMenu(userID,postID)
    else:
        print("That is not a valid badge.")
        PostActionMenu(userID,postID)

def VotePost(userID, postID):
    print("You have selected 'Post action-Vote'\n")
    if validVote(userID, postID): # Ensure user hasnt voted on the post
        newDate = datetime.today().strftime('%Y-%m-%d')
        newVno = makeVno(postID) # Get new vno

        # Add to database
        try:
            params = (postID, newVno, newDate, userID)
            cur.execute("INSERT INTO votes VALUES(?, ?, ?, ?);", params)
            conn.commit()

            print("\n--\nYour vote has been successfully cast.\n--")
            PostActionMenu(userID ,postID) # Return to menu
        except:
            print("\n--\nAn error has occurred, please try again\n--")
            PostActionMenu(userID, postID)

    else:
        print("\n--\nYou have already voted on this post.\n--")
        PostActionMenu(userID ,postID)

def MarkAnswer(userID, answerID):
    print("You have selected 'Post action-Mark as the accepted'\n")
    if answerIDVerification(answerID): # Ensure post is an answer
        questionID = getQuestionID(answerID) # Get the associated question id from the answer
        if not hasAnswer(questionID):       # Check if the question has an official answer
            updateAnswer(questionID, answerID) #If not, immediately update with the new answer
            PostActionMenu(userID, answerID)
        else: # Ask user if they wish to overwrite the answer
            choice = raw_input("The given question already has an answer.\nWould you like to change it(Y/N)? ")
            while not CheckInput(choice, False):
                choice = raw_input("The given question already has an answer.\nWould you like to change it(Y/N)? ")
            if choice in "Yy":
                updateAnswer(questionID, answerID) # If yes, overwrite the answer
                PostActionMenu(userID, answerID) # Return to menu
                
    else:
        print("\n--\nSorry that answer ID is invalid.\n--")
        PostActionMenu(userID, answerID)

def getQuestionID(answerID):
    # Get the associated question id from an answerID
    cur.execute("SELECT qid FROM answers WHERE pid = ?;", (answerID,))
    questionID = cur.fetchall()
    questionID = questionID[0][0]
    return questionID # Return qid

def updateAnswer(questionID, answerID):
    # Update the table to have the new answer id in place of the old/NULL
    cur.execute("UPDATE questions SET theaid = ? WHERE pid like ?;", (answerID, questionID))
    conn.commit()
    print("\n--\nThe answer has successfully been set.\n--")

def hasAnswer(questionID):
    # Check to see if the given questionID has an answer
    cur.execute("SELECT theaid FROM questions WHERE pid like ?", (questionID,))
    AnswerIDs = cur.fetchall()
    if AnswerIDs[0][0] == None: # Check for NULL (No answer ID present)
        return False
    else:
        return True

def AddTags(userID, postID):
    # Add tags to the given post
    print("You have selected 'Post action-Add a tag'\n")
    if postIDVerification(postID): # Ensure is valid post
        tags = [] # List of new tags to add
        moreTags = True # Loop until user does not want to add more tags

        while moreTags:
            tag = raw_input("Enter the tag you'd like to add: ")
            while not validTag(postID, tag): # Ensure the tag is unique
                tag = raw_input("Tag already in use.\nEnter the tag you'd like to add: ")

            tags.append(tag) # Add new tag to list
            choice = raw_input("Would you like to add another tag (Y/N)? ") # Prompt for adding another tag
            while not CheckInput(choice, False):
                choice = raw_input("Would you like to add another tag (Y/N)? ")
            if choice in "Nn":
                moreTags = False
        
        try:    # Add all tags individually to the post
            for tag in tags: 
                cur.execute("INSERT INTO tags VALUES(?, ?)", (postID, tag))
                conn.commit()
            print("\n--\nYour tag(s) have been successfully added.\n--")
            PostActionMenu(userID, postID) # Return to menu
        except:
            print("\n--\nSorry duplicate tags are not allowed\n--")
            PostActionMenu(userID, postID)
    else:
        print("\n--\nSorry that post ID is invalid.\n--")
        PostActionMenu(userID, postID)

def EditAPost(userID, postID):
    # Edit contents of the given post
    print("You have selected 'Post action-Edit'\n")

    # Prompt if to edit title
    choice = raw_input("Would you like to edit the title of this post(Y/N)? ")
    while not CheckInput(choice, False):
        choice = raw_input("Would you like to edit the title of this post(Y/N)? ")

    if choice in "Yy":
        newTitle = raw_input("Please enter the new title: ") # Get new text
        while not newTitle:
            newTitle = raw_input("Title cannot be blank.\nPlease enter the new title: ")
        try: # Update title with new text
            cur.execute("UPDATE posts SET title = ? WHERE pid like ?;", (newTitle, postID))
            conn.commit()
            print("\n--\nTitle successfully edited.\n--")
            PostActionMenu(userID, postID)
        except:
            print("\n--\nAn error has occurred, please try again\n--")
            PostActionMenu(userID, postID)

    # Prompt if to edit body
    choice = raw_input("Would you like to edit the body of this post(Y/N)? ")
    while not CheckInput(choice, False):
        choice = raw_input("Would you like to edit the body of this post(Y/N)? ")

    if choice in "Yy":
        newBody = raw_input("Please enter the new body: ") # Get new text
        while not newBody:
            newBody = raw_input("Body cannot be blank.\nPlease enter the new title: ")
        try: # Update body with new text
            cur.execute("UPDATE posts SET body = ? WHERE pid like ?;", (newBody, postID))
            conn.commit()
            print("\n--\nBody successfully edited.\n--")
            PostActionMenu(userID, postID)
        except:
            print("\n--\nAn error has occurred, please try again\n--")
            PostActionMenu(userID, postID)

    PostActionMenu(userID, postID) # Return to menu



def validTag(postID, newTag):
    # Check to see if the given tag is unique to that post
    cur.execute("SELECT * FROM tags WHERE pid like ? AND tag like ?", (postID, newTag))
    allTags = cur.fetchall()
    if not allTags:  # If no similar tags are found
        return True
    else:
        return False

def validVote(userID, postID):
    # Check to see if the given user has already voted on the given post
    cur.execute("SELECT * FROM votes WHERE pid like ? AND uid like ?", (postID, userID))
    allVotes = cur.fetchall()
    if not allVotes:    # Check to see if return is empty
        return True     # Signal that a vote can be cast by this user
    else:
        return False    # Signal user has already voted

def validBadge(givenName):
    # Verifies the given badge name is real (case insensitive)
    cur.execute("SELECT bname from badges WHERE bname like ?", (givenName,))
    allBadges = cur.fetchall()
    if not allBadges: # If there is no relevant badge
        return False
    else:
        return True

def getRealBadge(givenName):
    # Returns the proper badge name regardless of case sensitivity from input
    cur.execute("SELECT bname from badges WHERE bname like ?", (givenName,))
    allBadges = cur.fetchall()
    return allBadges[0][0] #Return the properly written badge name

def postIDVerification(ID):
    # If either a question or an answer
    if questionIDVerification(ID) or answerIDVerification(ID):
        return True
    else:
        return False

def questionIDVerification(ID):
    # Check to see if the given id is a question
    isValid = False

    cur.execute("SELECT pid FROM questions;")
    allQuestions = cur.fetchall()
    for question in allQuestions: 
        for text in question:
            if ID.lower() == text.lower(): # Remove case sensitivity
                isValid = True # Is in the query
    return isValid

def answerIDVerification(ID):
    # Check to see if the given id is an answer
    isValid = False

    cur.execute("SELECT pid FROM answers;")
    allAnswers = cur.fetchall()
    for answer in allAnswers:
        for text in answer:
            if ID.lower() == text.lower(): # Remove case sensitivity
                isValid = True # Is in the query
    return isValid

def CheckInput(UserInput, EnableQuitting):
    # Check y/n input, case-insensitive
    # Returns true if input is y or n
    # Return true if input is q (if quitting is enabled through EnableQuitting)

    if EnableQuitting:
        AllowedLetters = "YyNnQq"
    else:
        AllowedLetters = "YyNn"
    if UserInput not in AllowedLetters or not UserInput: # Prevent blanks
        print("Invalid Input.")
        return False
    return True

def ExitProgram():
    # Exits program upon being called
    # Saves database changes before closure
    try:
    	conn.commit()
    	conn.close()
    	print("\nShutting down...\nGoodbye.")
    	exit()
    except:
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
        print("\n--\nInvalid database file.\n--")
        exit()

def makePostID():
    # Will make a random and UNIQUE post id
    # Uses the first 4 characters from UUID4()

    prevUsed = True # Assume it has been used already
    while prevUsed:
        newPID = str(uuid4())[:4] # Create pid

        cur.execute("SELECT pid FROM posts WHERE pid like ?;", (newPID,))
        allPosts = cur.fetchall()
        if not allPosts:
            prevUsed = False # Prove it is unique

    return newPID

def makeVno(postsID):
    # Make the new highest vno for the given post
    maximum = 0

    cur.execute("SELECT vno FROM votes WHERE pid like ?;", (postsID,))
    allnums = cur.fetchall()
    for tuples in allnums:
        for num in tuples:
            maximum = num # Get current highest vno
    return str(maximum + 1)

def main():
    # Main function of program

    isQuit = False # Has the user chosen to quit

    GetDB()    # Get the database from command line
    while not isQuit:
        userID = LoginSignUp()  # Get user ID
        isLogout = False # Is the user logged out
        while not isLogout: # Loop main menu until user wants to log out
            isLogout = MainMenu(userID)
        print("\nLogging out.\n")
    ExitProgram()   # Shutdown safely after loop ends

main()
