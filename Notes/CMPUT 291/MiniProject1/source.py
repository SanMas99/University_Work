# CMPUT 291 - Fall 2020
# Mini - Project 1
# Authors: Tyler Bach, Sanad Masannat, Ivan Stoyanov


# Import required modules. 
import getpass
import sqlite3
import sys
from uuid import uuid4
from datetime import datetime

    
# This function represents the login page.
# If you are already registered, login.
# If you are already registered, but you want to create another account, create an account. 
# If you are not registered, create an account.
def LoginSignUp():    
    print("\n---LOGIN PAGE---")
    
    # Prompt user for what option they would like.
    # 'Y' for yes they are registered so login.
    # 'N' for no they are not registered so create an account.
    # 'Q' to quit the program.
    UserChoice = input("Are you a registered User (Y/N)?\nEnter Q to quit the program\n")
    
    # Quit option is enabled, hence TRUE.
    # Checks that user input is in the valid choices and is NOT a simple enter key press.
    # If user pressed the enter key without entering a valid choice or simply hit the enter key, reprompt them for a choice.
    while not CheckInput(UserChoice, True): 
        UserChoice = input("Are you a registered User (Y/N)?\nEnter Q to quit the program\n")        
    
    # Checks to see if the user's choice is 'yes' they are registered already.
    if UserChoice in "Yy":
        print("\nLogging in...\nPlease input your credentials ")
        
        # Set the current login information to be incorrect.
        incorrectInput = True
        
        # While loop continues to loop until all the login information entered is correct.
        while incorrectInput:
            
            # Prompt user for their ID.
            RegisteredID = input("\nWhat is your ID? ")
            
            # Checks that user input is NOT a simple enter key press.
            # If user pressed the enter key without entering an ID, reprompt them for an ID.
            while RegisteredID == '':
                RegisteredID = input("\nID can't be blank.\nWhat is your ID? ")
            
            # Prompt user for their login password.
            # As the password is being typed, it's hidden from view.
            RegisteredPwd = getpass.getpass('\nPlease enter your password: ')
            
            # Checks that user input is NOT a simple enter key press.
            # If user pressed the enter key without entering their login password, reprompt them for their login password.
            # As the password is being typed, it's hidden from view.
            while RegisteredPwd == '':
                RegisteredPwd = getpass.getpass("\nPassword can't be blank.\nPlease enter your password: ")
            
            # Checks if the password entered exists in the users table.
            # If the password entered exists, continue.
            if passwordVerification(RegisteredPwd):           
                
                # If the password entered corispondes to the user id entered, return that all the login information entered is correct.
                if validMatch(RegisteredID, RegisteredPwd):
                        print("\nID and Password match.")
                        
                        # Exits out of the loop.
                        incorrectInput = False
                
                # If the password entered does NOT corispondes to the user id entered, return to the beginning of the loop.        
                else:
                    print("\nIncorrect Credentials\nPlease input your credentials: ")                    
            
            # If the password entered does not exist, return to the beginning of the loop.
            else:
                print("\nIncorrect Credentials\nPlease input your credentials: ")
             
        return RegisteredID
    
    # Checks to see if the user's choice is 'no' they are not registered yet, or they simply wish to create another account.    
    elif UserChoice in "Nn":
        print("\nSigning you up! Please follow the prompts and enter your information. ")
        
        # Set the current sign up information to be incorrect.
        incorrectInput = True
        
        # While loop continues to loop until all the sign up information entered is correct.
        while incorrectInput: 
            
            # Prompt user for what they wish their unique ID to be.
            NewID = input("\nPlease Input a unique ID: ")        
            
            # Checks that user input is NOT a simple enter key press.
            # If user pressed the enter key without entering an ID, reprompt them for an ID.
            while NewID == '':
                NewID = input("\nUnique ID can't be blank.\nPlease Input a unique ID: ")
            
            #Checks if ID is unique; therefore, it does not already exist in the users table.
            # If the ID entered is unique, continue.
            if uniqueIDVerification(NewID):
                # Prompt user for their name.
                NewName = input("\nWhat is your name? ")
                
                # Checks that user input is NOT a simple enter key press.
                # If user pressed the enter key without entering their name, reprompt them for their name.
                while NewName == '':
                    NewName = input("\nYour name can't be blank.\nWhat is your name? ")
                
                # Prompt user for what they wish their password to be
                NewPwd = input("\nPlease Input a Password: ")        
                
                # Checks that user input is NOT a simple enter key press.
                # If user pressed the enter key without entering what they wish their password to be, reprompt them for what they wish their password to be.
                while NewPwd == '':
                    NewPwd = input("\nPassword can't be blank.\nPlease input a Password: ") 
                
                # Prompt user for what city they live in.
                NewCity = input("\nWhat is the current city you live in? ")
                
                # Checks that user input is NOT a simple enter key press.
                # If user pressed the enter key without entering what city they live in, reprompt them for their city.
                while NewCity == '':
                    NewCity = input("\nCity can't be blank.\nWhat is the current city you live in? ")
                
                # Records the day the user got registered.
                Newdate = datetime.today().strftime('%Y-%m-%d')
                
                #Sql code that adds the registration information gathered above to the users table, thus completing the user's registration.
                cur.execute("INSERT INTO users VALUES (?, ?, ?, ?, ?);", (NewID, NewName, NewPwd, NewCity, Newdate))
                conn.commit()
                
                print("\nYou are registered")
                
                # Exits out of the loop.
                incorrectInput = False
            
            # If the ID entered is not unique, thus it already exists in the table, return to the beginning of the loop.
            else:
                print("\nSorry, this ID is already taken!\nPlease follow the prompts and enter your information. ")
                   
        return NewID
    
    # If the user's choice is 'quit' they are exited out of the program.
    elif UserChoice in "Qq":
        ExitProgram()




# This function checks to see if the given uid already exists in the users table; therefore it checks if it's unique.
def uniqueIDVerification(NewID):    
    # Initially the ID is assumed to be valid and awaits to be checked.
    isValid = True
    
    # SQL that returns all the IDs in the users table.
    cur.execute("SELECT uid FROM users;")    
    # Then stores the results in a variable called "allIDs".
    allIDs = cur.fetchall()    
    
    # Loops through all the IDs' string value and compares each of them to the ID entered by the user.
    # If the ID entered exists in the users table, then the ID's existence is verified. Return false since the ID entered by the user is not unique.
    # If the ID entered does not exist in the users table, then the ID does not exist yet. Return true since the ID entered by the user is unique.    
    for ID in allIDs:           
        for text in ID:
            # Include case sensitivity
            if NewID == text:                
                isValid = False
    
    return isValid     




# This function checks to see if the password entered is in the users table; therefore checks if it exists.
def passwordVerification(RegisteredPwd):   
    # Initially the password is assumed to be invalid and awaits to be checked.
    isValid = False
    
    # SQL that returns all the passwords in the user table.
    cur.execute("SELECT pwd FROM users;")
    # Then stores the results in a variable called "allPasswords".
    allPasswords = cur.fetchall()
    
    # Loops through all the passwords' string value and compares each of them to the login password entered by the user.
    # If the password entered exists in the users table, then the password's existence is verified.
    # If the password entered does not exist in the users table, then the password does not exist.
    for password in allPasswords:           
        for text in password:
            # Include case sensitivity
            if RegisteredPwd == text:                
                isValid = True
    
    return isValid    




# This function checks to see if the password entered corresponds to the user id entered.
def validMatch(RegisteredID, RegisteredPwd):  
    # SQL code that checks if the login password entered by the user corresponds to the user id entered by the user.
    cur.execute("SELECT * FROM users WHERE uid= ? AND pwd= ?", (RegisteredID, RegisteredPwd))
    # Then stores the results in a variable called "found".
    matching = cur.fetchone()
    
    # If SQL code finds a match, then the password corresponds to the user id, return true.
    # If SQL code does not find a match, then the password does not corispond to the user id, return false.
    if matching:
        return True
    else:
        return False




# This function represents the main menu.
def MainMenu(userID):
    print("\n---MAIN MENU---")
    # Options available to all users.
    print ("\n1. Post a question\n2. Search for posts\n9. Logout\n0. Quit") 
    
    # List of the numbers corisponding to the 4 options the user can choose.
    OptionList = "1290"
    
    # Prompt user for what option they would like.
    choice = str(input("\nPlease input a choice from the above list.\n"))

    # Checks that user input is in the valid choices and is NOT a simple enter key press.
    # If user's choice is invalid or they pressed the enter key without entering a choice, reprompt them for a choice.    
    while choice not in OptionList:
        choice = str(input("\nInvalid Choice. Please input a choice from the above list.\n"))
    
    # Check if user selected option 1 - post a question.
    if choice == "1":
        PostQuestion(userID)
    
    # Check if user selected option 2 - searchg for a post.
    elif choice == "2":
        SearchPost(userID)
    
    # Check if user selected option 9 - logout and return to login page.
    elif choice == "9": 
        LoginSignUp()
    
    # Check if user selected option 0 - exit the entire program.
    else:
        ExitProgram()




# This function Return the poster's ID from the given postID.
def getPoster(postID):
    # SQL that returns all the posters in the posts table that match the postID entered by the user.     
    cur.execute("SELECT poster FROM posts WHERE pid like ?;", (postID,))
    # Then stores the results in a variable called "poster".
    poster = cur.fetchall()    
    return poster[0][0]




# This function represents the post action menu.
def PostActionMenu(userID, postID):
    print("\n---POST ACTION MENU---")
    
    # Get poster from postID.
    posterID = getPoster(postID) 
    
    # Options available to all users.
    print("1. Post answer\n2. Cast vote")
    
    # Check if user is privileged.
    if CheckPrivilege(userID):
        # Options available only to privileged users.
        print ("3. Mark as the accepted \n4. Give a badge\n5. Add a tag\n6. Edit")
        
        # Enable extra/privileged options.
        OptionList = "123456890" 
    
    else:
        # Enable non-privileged options.
        OptionList = "12890"
    
    # Options available to all users.
    print("8. Return to main menu\n9. Logout\n0. Quit")
    
    # Prompt user for what option they would like.
    choice = str(input("Please input a choice from the above list.\n"))
    
    # Checks that user input is in the valid choices and is NOT a simple enter key press.
    # If user's choice is invalid or they pressed the enter key without entering a choice, reprompt them for a choice.    
    while choice not in OptionList:
        choice = str(input("Invalid Choice. Please input a choice from the above list.\n"))
    
    # Check if user selected option 1 - answer a post.
    if choice == "1":
        AnswerPost(userID, postID)

    # Check if user selected option 2 - vote on a post.
    elif choice == "2":
        VotePost(userID, postID)
    
    # Check if user selected option 3 - mark answer as the accepted answer.
    elif choice == "3":
        MarkAnswer(userID, postID)

    # Check if user selected option 4 - give a badge.
    elif choice == "4":
        GiveBadge(userID, postID)

    # Check if user selected option 5 - add a tag.
    elif choice == "5":
        AddTags(userID, postID)

    # Check if user selected option 6 - edit a post.
    elif choice == "6":
        EditAPost(userID, postID)

    # Check if user selected option 8 - return to the main menu.
    elif choice == "8":
        MainMenu(userID)
        
    # Check if user selected option 9 - logouts out and returns to login page.    
    elif choice == "9":
        LoginSignUp()
    
    # Check if user selected option 0 - exit the entire program.
    else:     
        ExitProgram()




# This function searches for a post based on keywords given by the user.
def SearchPost(userID):    
    print("You have selected 'Search for a Post'\n")
    
    # Initialize an empty list where all the keywords will be stored.
    keyWordList = []
    
    # Initialize the end of the input of keywords as false.
    end = False
    
    # Adds as many key words as the user wants to search for in posts.
    # Loops until the user does not want to add any other keywords.
    while not end:
        # Prompt user for a keyword.
        keyWord = input("What keyword are you looking for? ")
        
        # Append the keyword to the key word list. 
        keyWordList.append(keyWord)
        
        # Prompt user whether or not they want to add another keyword.
        choice = input("Would you like to add another keyword (Y/N)? ")
        
        # Quit option is disabled, hence False.
        # Checks that user input is in the valid choices and is NOT a simple enter key press.
        # If user pressed the enter key without entering a valid choice or simply hit the enter key, reprompt them for a choice.        
        while not CheckInput(choice, False):
            choice = input("Would you like to add another keyword (Y/N)? ")
        
        # If the user enters 'no' they don't want to choose anymore keywords, exit loop.
        if choice in "Nn":
            end = True

    # Initialize an empty list that will store all the posts that have the chosen keywords.
    postList=[]
    
    # SQL code that uses a for loop to go through every element in the key word list and check whether 1 or more of the key words appear in any post.
    # If such a post exists, store it in the post list.
    for i in range(len(keyWordList)):
        currentKeyword = ('%{}%'.format(keyWordList[i]))
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

        # Then stores the results in a variable called "listofPost".
        listofPost=cur.fetchall()
        count = 0
        isFinished = False
        
        # If there are no posts with the selected key words, return to the main menu.
        if not listofPost:
            print("No relevant posts")
            MainMenu(userID) 
        
        # If there are posts with the selected key words, continue.
        else:
            while i != len(listofPost) and not isFinished:
                
                if (i%5 == 0 or i == len(listofPost)):
                    
                    if (i != 0):
                        print("---END OF PAGE---")
                        choice = input("Do you want to see the next page (Y/N)? ")
                        
                        if not CheckInput(choice, False):
                            choice = input("Do you want to see the next page (Y/N)?")
                        
                        if choice in "Nn":
                            isFinished = True
                
                if not isFinished:
                    print(listofPost[i])
                    i += 1

            if i == len(listofPost):
                print("---END OF RESULTS---")
        
            listofIDs = []
            
            for post in listofPost:
                listofIDs.append(post[0].lower())
            
            # Prompt user for a post ID.
            chosenPostID = input("Please type in your chosen post ID.\nTyping 'return' will return you back to the main menu.\n").lower()
            if chosenPostID == "return":
                MainMenu(userID)
            
            while chosenPostID not in listofIDs:
                chosenPostID = input("Invalid input.\nPlease type in your chosen post ID.\nTyping 'return' will return you back to the main menu.\n").lower()
                
                if chosenPostID == "return":
                    MainMenu(userID)
            
            PostActionMenu(userID, chosenPostID)




# This function checks if the user is privileged.
def CheckPrivilege(userID):  
    # Assume user is not privileged until proven in search (isPriv is set to false)
    isPriv = False
    
    # SQL code that gathers all privileged users from the privileged table.
    cur.execute("SELECT * FROM privileged")
    # Then stores the data in a variable called "PrivUsers".
    PrivUsers = cur.fetchall()
    
    # Checks if current userid is in the privileged list.
    for user in PrivUsers:
        if userID in user:
            # Set isPriv to true is user is privileged.
            isPriv = True

    return isPriv




# This function allows the user to post a question.
def PostQuestion(userID):
    print("\nYou have selected 'Post a question'\n")
    
    # Get post information/parameters from makePostInfo().
    title, bodyText, newPostID, newDate = makePostInfo()
    
    # Try and execute the following code.
    # If no issues are raised, question post is successful.
    try:        
        # Store all the post information/parameters in 1 variable called 'params'.
        params = (newPostID, newDate, title, bodyText, userID)
        
        #Sql code that adds the post information/parameters gathered above to the posts table.
        cur.execute("INSERT INTO posts VALUES(?, ?, ?, ?, ?);", params)
        conn.commit()
        
        #Sql code that gives the question the id chosen by the user, thus completing the user's posting of the post. 
        cur.execute("INSERT INTO questions VALUES(?, NULL);", (newPostID,))
        conn.commit()
        
        print("\n--\nYour question has been successfully posted.\n--")
    
    # If any of the code in the try block crashes, enter the ecept block and print out the following message.
    # Post is not posted successfully.
    except:
        print("\n--\nAn error occurred, please try again.\n--")    




# This function gets all the information for the post.
def makePostInfo():    
    # Prompt user for the title of the post.
    title = input("\nWhat will the title of your post be? ")
    
    # Checks that user input is NOT a simple enter key press.
    # If user pressed the enter key without entering a title, reprompt them for a title.    
    while not title:
        title = input("\nTitle cannot be blank. Please Try again.\nWhat will the title of your post be? ")
    
    # Prompt user for the body of the post.
    bodyText = input("\nEnter the main body of your post: ")
    
    # Checks that user input is NOT a simple enter key press.
    # If user pressed the enter key without entering a body of the post, reprompt them for the body.    
    while not bodyText:
        bodyText = input("\nBody cannot be blank. Please Try again.\nEnter the main body of your post: ")
    
    # The id of the post unique and randomly selected.
    postID = makePostID()
    
    # The date of when the post is created is recorded.
    date = datetime.today().strftime('%Y-%m-%d')

    return title, bodyText, postID, date




# This function allows you to answer a post.
def AnswerPost(userID, questionID):
    print("\nYou have selected 'Post action-Answer'\n")
    
    # If the question's id exists, continue.
    if questionIDVerification(questionID):
        
        # Get post information/parameters from makePostInfo().
        title, bodyText, newPostID, newDate = makePostInfo()
        
        # Try and execute the following code.
        # If no issues are raised, answer post is successful.        
        try:  
            # Store all the post information/parameters in 1 variable called 'params'.
            params = (newPostID, newDate, title, bodyText, userID)
            
            #Sql code that adds the post information/parameters gathered above to the posts table.
            cur.execute("INSERT INTO posts VALUES(?, ?, ?, ?, ?);", params)
            conn.commit()
            
            #Sql code that gives the answer the new id chosen by the user and the question's id, thus completing the user's posting of the answer.
            cur.execute("INSERT INTO answers VALUES(?, ?);", (newPostID, questionID))
            conn.commit()        
            
            print("\n--\nYour question has been successfully posted.\n--")
            
            # Return to post action menu.
            PostActionMenu(userID, questionID)
        
        # If any of the code in the try block crashes, enter the ecept block and print out the following message.
        # Post is not posted successfully.        
        except:
            print("\n--\nAn error occurred, please try again\n--")
            # Return to post action menu.
            PostActionMenu(userID, questionID)
    
    else:
        print("\n--\nSorry that is not a valid question ID\n--")
        # Return to post action menu.
        PostActionMenu(userID, questionID)




# This function gives a badge to post.
def GiveBadge(userID, postID):
    print ("\nYou have selected 'Post action-Give a Badge'\n")
    
    # Prompt user for a badge name.
    badgeName = str(input("\nWhat is the name of the badge you are giving? "))
    
    if validBadge(badgeName):
        badgeName = getRealBadge(badgeName)
        newDate = datetime.today().strftime('%Y-%m-%d')
        
        try:
            params = (userID, newDate, badgeName)
            cur.execute("INSERT INTO ubadges VALUES(?, ?, ?);", params)
            conn.commit()
            print("\n--\nThe badge has been successfully awarded.\n--")
            
            # Return to post action menu.
            PostActionMenu(userID, postsID)            
        
        except:
            print("\n--\nAn error has occurred, please try again.\n--")
            
            # Return to post action menu.
            PostActionMenu(userID, postsID)
    else:
        print("\nThat is not a valid badge.")
        PostActionMenu(userID, postID)    




# This function allows you to vote for a post.
def VotePost(userID, postID):
    print("\nYou have selected 'Post action-Vote'\n")

    if postIDVerification(postID):
        if validVote(userID, postID):
            newDate = datetime.today().strftime('%Y-%m-%d')
            newVno = makeVno(postID)

            try:
                params = (postID, newVno, newDate, userID)
                cur.execute("INSERT INTO votes VALUES(?, ?, ?, ?);", params)
                conn.commit()

                print("\n--\nYour vote has been successfully cast.\n--")
                PostActionMenu(userID ,postID)
            
            except:
                print("\n--\nAn error has occurred, please try again\n--")
                PostActionMenu(userID, postID)

        else:
            print("\n--\nYou have already voted on this post.\n--")
            PostActionMenu(userID, postID)
    else:
        print("\n--\nSorry that post ID is invalid.\n--")
        PostActionMenu(userID, postID)




# This function allows you to mark an answer as the accepted answer.
def MarkAnswer(userID, answerID):
    print("\nYou have selected 'Post action-Mark as the accepted'\n")
    
    if answerIDVerification(answerID):
        questionID = getQuestionID(answerID)
        
        if not hasAnswer(questionID):
            updateAnswer(questionID, answerID)
            PostActionMenu(userID, answerID)
        
        else:
            # Prompts user for a choice.
            choice = input("\nThe given question already has an answer.\nWould you like to change it(Y/N)? ")
            
            # Checks that user input is NOT a simple enter key press.
            # If user pressed the enter key without entering a valid choice, reprompt them for a valid choice.            
            while not CheckInput(choice, False):
                choice = input("The given question already has an answer.\nWould you like to change it(Y/N)? ")
            
            if choice in "Yy":
                updateAnswer(questionID, answerID)
                PostActionMenu(userID, answerID)                 
    else:
        print("\n--\nSorry that answer ID is invalid.\n--")
        PostActionMenu(userID, answerID)    




# This function gets the question id of a post.
def getQuestionID(answerID):
    cur.execute("SELECT qid FROM answers WHERE pid = ?;", (answerID,))
    questionID = cur.fetchall()
    questionID = questionID[0][0]
    return questionID




# This function updates the questions table to have the new answer id in place of the old/NULL
def updateAnswer(questionID, answerID):
    cur.execute("UPDATE questions SET theaid = ? WHERE pid like ?;", (answerID, questionID))
    conn.commit()
    print("\n--\nThe answer has successfully been set.\n--")




# This function returns boolean to indicate if the answer is related to the question.
def relevantAnswer(questionID, answerID):
    cur.execute("SELECT pid FROM answers WHERE qid like ?", (questionID,))
    AnswerIDs = cur.fetchall()
    
    for answers in AnswerIDs:
        if answerID in answers: # If given answerID matches
            return True
        else:
            return False




# This function checks to see if the given questionID has an answer.
def hasAnswer(questionID):
    cur.execute("SELECT theaid FROM questions WHERE pid like ?", (questionID,))
    AnswerIDs = cur.fetchall()
    
    # Check for NULL (No answer ID present).
    if AnswerIDs[0][0] == None: 
        return False
    else:
        return True




# This function allows you to add tags to posts.
def AddTags(userID, postID):
    print("\nYou have selected 'Post action-Add a tag'\n")
    
    if postIDVerification(postID):
        tags = []
        moreTags = True

        while moreTags:
            # Prompt user for a tag.
            tag = input("\nEnter the tag you'd like to add: ")
            
            # Checks that user input is NOT a simple enter key press.
            # If user pressed the enter key without entering an tag, reprompt them for a tag.            
            while not validTag(postID, tag):
                tag = input("\nTag already in use.\nEnter the tag you'd like to add: ")
            
            # Append the tag name into the list of tags.
            tags.append(tag)
            
            # Prompt user for what option they would like.
            choice = input("Would you like to add another tag (Y/N)? ")
            
            # Checks that user input is NOT a simple enter key press.
            # If user pressed the enter key without entering a valid choice, reprompt them for a valid choice.            
            while not CheckInput(choice, False):
                choice = input("Would you like to add another tag (Y/N)? ")
            
            if choice in "Nn":
                moreTags = False
        
        try:
            for tag in tags:
                cur.execute("INSERT INTO tags VALUES(?, ?)", (postID, tag))
                conn.commit()
            
            print("\n--\nYour tag(s) have been successfully added.\n--")
            PostActionMenu(userID, postID)
        
        except:
            print("\n--\nSorry duplicate tags are not allowed\n--")
            PostActionMenu(userID, postID)
    else:
        print("\n--\nSorry that post ID is invalid.\n--")
        PostActionMenu(userID, postID)    




# This function allows you to edit a post.
def EditAPost(userID, postID):
    print("\nYou have selected 'Post action-Edit'\n")
    
    # Prompt user for what option they would like.
    choice = input("\nWould you like to edit the title of this post(Y/N)? ")
    
    # Checks that user input is NOT a simple enter key press.
    # If user pressed the enter key without entering a valid choice, reprompt them for a valid choice.    
    while not CheckInput(choice, False):
        choice = input("\nWould you like to edit the title of this post(Y/N)? ")

    if choice in "Yy":
        # Prompt user for a new title for the post.
        newTitle = input("\nPlease enter the new title: ")
        
        # Checks that user input is NOT a simple enter key press.
        # If user pressed the enter key without entering a new title for the post, reprompt them for a new title.        
        while not newTitle:
            newTitle = input("\nTitle cannot be blank.\nPlease enter the new title: ")
        
        try:
            cur.execute("UPDATE posts SET title = ? WHERE pid like ?;", (newTitle, postID))
            conn.commit()
            
            print("\n--\nTitle successfully edited.\n--")
            PostActionMenu(userID, postID)
        
        except:
            print("\n--\nAn error has occurred, please try again\n--")
            PostActionMenu(userID, postID)
    
    # Prompt user for what option they would like.
    choice = input("\nWould you like to edit the body of this post(Y/N)? ")
    
    # Checks that user input is NOT a simple enter key press.
    # If user pressed the enter key without entering a valid choice, reprompt them for a valid choice.    
    while not CheckInput(choice, False):
        choice = input("\nWould you like to edit the body of this post(Y/N)? ")

    if choice in "Yy":
        # Prompt user for a bew body for the post.
        newBody = input("\nPlease enter the new body: ")
        
        # Checks that user input is NOT a simple enter key press.
        # If user pressed the enter key without entering a new body for the post, reprompt them for a new body.        
        while not newBody:
            newBody = input("\nBody cannot be blank.\nPlease enter the new title: ")
        
        try:
            cur.execute("UPDATE posts SET title = ? WHERE pid like ?;", (newBody, postID))
            conn.commit()
            
            print("\n--\nBody successfully edited.\n--")
            PostActionMenu(userID, postID)
        
        except:
            print("\n--\nAn error has occurred, please try again\n--")
            PostActionMenu(userID, postID)

    PostActionMenu(userID, postID)    




# This function checks to see if the given tag is unique to that post       
def validTag(postID, newTag):
    cur.execute("SELECT * FROM tags WHERE pid like ? AND tag like ?", (postID, newTag))
    allTags = cur.fetchall()
    
    # If no similar tags are found
    if not allTags:  
        return True
    # If a similar tag is found
    else:
        return False




# This function checks to see if the given user has already voted on the given post.
def validVote(userID, postID):
    cur.execute("SELECT * FROM votes WHERE pid like ? AND uid like ?", (postID, userID))
    allVotes = cur.fetchall()
    
    # Check to see if return is empty.
    if not allVotes:    
        # Signal that a vote can be cast by this user.
        return True     
    else:
        # Signal user has already voted.
        return False    





# This function verifies the given badge name is real (case insensitive).
def validBadge(givenName):
    cur.execute("SELECT bname from badges WHERE bname like ?", (givenName,))
    allBadges = cur.fetchall()
    
    # If there is no relevant.
    if not allBadges: 
        return False
    # If there is relevant.
    else:
        return True




# This function returns the proper badge name regardless of case sensitivity from input.
def getRealBadge(givenName):
    cur.execute("SELECT bname from badges WHERE bname like ?", (givenName,))
    allBadges = cur.fetchall()
    
    #Return the properly written badge name
    return allBadges[0][0] 




# This function checks if post is either a question or an answer.
def postIDVerification(ID):    
    if questionIDVerification(ID) or answerIDVerification(ID):
        return True
    else:
        return False    




# This function checks to see if the given id is a question.
def questionIDVerification(ID):
    isValid = False

    cur.execute("SELECT pid FROM questions;")
    allQuestions = cur.fetchall()
    
    for question in allQuestions:
        for text in question:
            # Remove case sensitivity
            if ID.lower() == text.lower():
                isValid = True
    
    return isValid    





# This function checks to see if the given id is an answer.
def answerIDVerification(ID):
    isValid = False
    
    cur.execute("SELECT pid FROM answers;")
    allAnswers = cur.fetchall()    
    
    for answer in allAnswers:       
        for text in answer:
            # Remove case sensitivity.
            if ID.lower() == text.lower(): 
                isValid = True    
    
    return isValid    




# This function checks the user's input, then determines the appropriate course of action.
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




# This function is used to exit the program upon being called.
def ExitProgram():
    # Saves database changes before closure
    conn.commit()
    conn.close()
    print("\nShutting down...\nGoodbye.")
    exit()




# This function gets the sqlite3 database from the command line arguments.
def GetDB():
    global conn, cur
    preface = "./"
    
    try:
        db_file = str(sys.argv[1])
        conn = sqlite3.connect(preface + db_file)
        cur = conn.cursor()
        conn.commit()
    
    except:
        print("\n--\nInvalid database file.\n--")
        # Exits program is database is invalid
        exit()




# This function will make a random and UNIQUE post id.
def makePostID():        
    # Assume hasnt been previously used.
    prevUsed = True 
    
    while prevUsed:
        # Create pid.
        # Uses the first 4 characters from UUID4().
        newPID = str(uuid4())[:4] 
                
        cur.execute("SELECT pid FROM posts WHERE pid like ?;", (newPID,))
        allPosts = cur.fetchall() 
        
        if not allPosts:
            # Prove it is unique.
            prevUsed = False         

    return newPID




# This function makes the new highest vno for the given post.
def makeVno(postsID):
    maximum = 0

    cur.execute("SELECT vno FROM votes WHERE pid like ?;", (postsID,))
    allnums = cur.fetchall()
    
    for tuples in allnums:
        for num in tuples:
            # Get current highest vno.
            maximum = num 
    
    return str(maximum + 1)




def main():        
    # Has the user chosen to quit.
    isQuit = False 
    
    # Get the database from command line.
    GetDB() 
    
    while not isQuit:
        # Get user ID.
        userID = LoginSignUp()  
        
        # Initialized to be that the user is not logged out yet.
        isLogout = False
        
        # Loop main menu until user wants to log out.
        while not isLogout: 
            isLogout = MainMenu(userID)
        
        print("\nLogging out.\n")
    
    # Shutdown safely after loop ends.
    ExitProgram() 
    
main()