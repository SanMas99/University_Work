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
        cur.execute("SELECT uid, pwd FROM users;")#Gets a list of all uid and associated pwds
        credentialList=cur.fetchall()
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
    OptionList = "1230"

    choice = str(input("Please input a choice from the above list.\n"))
    
    while choice not in OptionList:#Prevents the user from inputting an invalid choice
        choice = str(input("Invalid Choice. Please input a choice from the above list.\n"))
    
    if choice == "1":
        PostQuestion(userID)

    elif choice == "2":
        SearchPost()
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

def AnswerPost(userID,chosenPostID):
    #Passes in chosen PostID to answer question 
    print("You have selected 'Post action-Answer'\n")
    
    if questionIDVerification(chosenPostID):
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

def GiveBadge(chosenPostID):
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
            #SQL attempt below
            '''
select posts.pid, pdate, title, body, poster,  ifNull(ansFreq,0), ifNull(voteCnt,0),t3.tag
from tags,posts left join (select questions.pid,answers.pid as ansFreq
from questions, answers
where questions.pid=answers.qid
group by questions.pid) as t1 on posts.pid=t1.pid left join (select posts.pid, count(votes.pid) as voteCnt
from posts,votes
where posts.pid=votes.pid
group by posts.pid
order by posts.pid asc) as t2 on posts.pid=t2.pid left join (
select posts.pid, tags.tag
from posts left join tags on posts.pid=tags.pid
group by posts.pid, tags.tag) as t3 on posts.pid=t3.pid
where t3.tags like ? or title like ? or body like ?, ('%{}%'.format(keyWord[i]))
group by posts.pid;

'''
    postList=[]
    for i in range(len(keyWordList)):
        cur.execute("SELECT posts.pid, pdate, title, body, poster,  ifNull(ansFreq,0), ifNull(voteCnt,0),t3.tag FROM tags,posts LEFT JOIN (SELECT questions.pid,answers.pid AS ansFreq FROM questions, answers WHERE questions.pid=answers.qid GROUP BY questions.pid) AS t1 ON posts.pid=t1.pid LEFT JOIN (select posts.pid, count(votes.pid) as voteCntFROM posts,votes WHERE posts.pid=votes.pid GROUP BY posts.pid ORDER BY posts.pid asc) AS t2 ON posts.pid=t2.pid LEFT JOIN (SELECT posts.pid, tags.tag FROM posts LEFT JOIN tags ON posts.pid=tags.pid GROUP BY posts.pid, tags.tag) AS t3 ON posts.pid=t3.pid WHERE t3.tags LIKE ? or title LIKE ? or body LIKE ?, ('%{}%'.format(keyWordList[i])) GROUP BY posts.pid;")
        listofPost=cur.fetchall()
        for j in range (len(listofPost)):
            postList.append(listofPost[i]) 
    chosenPostID=input("Please type in your chosen post ID")
    print ("1. Post action-Answer a Question \n2. Post action-Vote")
    if CheckPrivilege(userID):  # Check is user is privileged
        print ("3. Post action-Mark as the accepted \n4. Post action-Give a badge\n5. Post action-Add a tag\n6. Post Action-Edit")
        OptionList = "12345670" # Enable extra options
    else:
        OptionList = "120"
    if choice == "1":
        AnswerPost(userID,chosenPostID)

    elif choice == "1":
        VotePost(userID,chosenPostID)

    elif choice == "3":
        MarkAnswer(chosenPostID)

    elif choice == "4":
        GiveBadge(chosenPostID)

    elif choice == "5":
        AddTags(chosenPostID)

    elif choice == "6":
        EditAPost(chosenPostID)
        
    elif choice == "7": # Breaks menu loop, returns to login page
        return True

    else:     
        ExitProgram()

def VotePost(userID,chosenPostID):
    #Function allows user to input values into the votes table so as to vote for a post if they havent done so for chosen post
    print("You have selected 'Post action-Vote'\n")

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
    answerID = input("Please enter the post ID of the answer: ")
    if answerIDVerification(answerID):
        questionID = input("Please enter the post ID of the question: ")
        if questionIDVerification(questionID):
            if relevantAnswer(questionID, answerID):
                if not hasAnswer(questionID):
                    updateAnswer(questionID, answerID)
                else:
                    choice = input("The given question already has an answer.\nWould you like to change it(Y/N)? ")
                    while not CheckInput(choice, False):
                        choice = input("The given question already has an answer.\nWould you like to change it(Y/N)? ")
                    if choice in "Yy":
                        updateAnswer(questionID, answerID)
            else:
                print("\nSorry that answer is not related to the given question.")
        else:
            print("\nSorry that question ID is invlaid.")
    else:
        print("\nSorry that answer ID is invalid.")

def updateAnswer(questionID, answerID):
    # Update the table to have the new answer id in place of the old/NULL
    cur.execute("UPDATE questions SET theaid = ? WHERE pid like ?;", (answerID, questionID))
    conn.commit()
    print("\nThe answer has successfully been set.")

def relevantAnswer(questionID, answerID):
    # Return boolean to indicate if the answer is related to the question
    cur.execute("SELECT pid FROM answers WHERE qid like ?", (questionID,))
    AnswerIDs = cur.fetchall()
    for answers in AnswerIDs:
        if answerID in answers: # If given answerID matches
            return True
        else:
            return False

def hasAnswer(questionID):
    # Check to see if the given questionID has an answer
    cur.execute("SELECT theaid FROM questions WHERE pid like ?", (questionID,))
    AnswerIDs = cur.fetchall()
    if AnswerIDs[0][0] == None: # Check for NULL (No answer ID present)
        return False
    else:
        return True

def AddTags(chosenPostID):
    #Adds tags in to chosen post ID
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

def EditAPost(chosenPostID):
    #Edits the chosen post ID
    #goes through  3 options-selected by the user, either edits title only, body only or both
    print("You have selected 'Post action-Edit'\n")

    postID = input("Please enter the post ID: ")

    choice = input("Would you like to edit the title of this post(Y/N)? ")
    while not CheckInput(choice, False):
        choice = input("Would you like to edit the title of this post(Y/N)? ")

    if choice in "Yy":
        newTitle = input("Please enter the new title: ")
        if not newTitle:
            newTitle = input("Title cannot be blank.\nPlease enter the new title: ")
        try:
            cur.execute("UPDATE posts SET title = ? WHERE pid like ?;", (newTitle, postID))
            conn.commit()
            print("\nTitle successfully edited.")
        except:
            print("\nAn error has occurred, please try again")

    choice = input("Would you like to edit the body of this post(Y/N)? ")
    while not CheckInput(choice, False):
        choice = input("Would you like to edit the body of this post(Y/N)? ")

    if choice in "Yy":
        newBody = input("Please enter the new body: ")
        if not newBody:
            newBody = input("Body cannot be blank.\nPlease enter the new title: ")
        try:
            cur.execute("UPDATE posts SET title = ? WHERE pid like ?;", (newBody, postID))
            conn.commit()
            print("\nBody successfully edited.")
        except:
            print("\nAn error has occurred, please try again")

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
    conn.close()
    ExitProgram()   # Shutdown safely after loop ends
        
main()

