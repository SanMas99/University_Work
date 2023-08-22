# CMPUT 291 Fall 2020 Mini Project 2
# Worked on by Leo, Sanad and Mutaal (minor edits) 
import random, pymongo, sys
from datetime import datetime

def get_uid(): # get the uid from the user
    valid = False
    print('If you want to exit the program, please enter "e".')
    while valid == False:
        uid = input('Please enter an User ID (Press enter to continue without entering User ID): ')
        if uid == '':
            valid = True
        elif uid == 'e':
            print("Exiting the program...")
            exit()
        elif uid.isnumeric() == True:
            valid = True
        elif uid.isnumeric() == False:
            print('Error: Please enter a valid User ID.')
        elif int(uid) < 0:
            print('Error: Please enter a valid User ID.')
            
    return uid
    
def norm_menu(db, uid): # first menu when getting inside the program
    valid = False
    while valid == False:
        print('\nIf you want to exit the program, please enter "e".')
        print('1. Post a question')
        print('2. Search for questions')
        cho_opt = input('Please enter an option: ')
        if cho_opt.lower().strip() == 'e':
            print("Exiting the program...")
            exit()
        elif cho_opt.strip() == '1':
            valid = True
            post_a_question(db, uid)
        elif cho_opt.strip() == '2':
            valid = True
            search_for_questions(db, uid)
        else:
            print('Please enter a valid option.')
            
def post_a_question(db, uid):
    # ask the user to enter the title and body
    cho_opt = input('If you want to go back to the main page, please enter "q". Press any other key to post a question. ')
    if cho_opt.lower().strip() == 'q':
            norm_menu(db, uid)
    else:
        print("\n-- Post A Question --")
        title = input('Enter a title: ')
        body = input('Enter a text: ')
        post_type = "1" # Set the post type to the question
        crtdate = datetime.today().strftime('%Y-%m-%d')
        content_license = 'CC BY-SA 2.5'
        user_id = uid
        tag_list = []
        fin = False
        while fin == False:
            keyword = input('Enter a tag. (Press enter without enetering a tag): ')
            if keyword == "":
                fin = True
            else:
                in_fin = False
                while in_fin == False:
                    in_ask = input('Do you want to input more tags? ')
                    if in_ask.lower() == 'y' or in_ask.lower() == 'yes':
                        tag_list.append(keyword.lower().strip())
                        in_fin = True
                    elif in_ask.lower() == 'n' or in_ask.lower() == 'no':
                        tag_list.append(keyword.lower().strip())
                        in_fin = True
                        fin = True
                    else:
                        print('Please enter "y" or "n", "yes" or "no".')
        
        # check if the tags contain duplicates
        check_dup = []
        for i in tag_list:
            if i not in check_dup:
                check_dup.append(i)
                
        tag_list = check_dup
        print('Posting the question...')
        valid = False
        if tag_list == ['']:
            valid = True
        while valid == False:
            ## These lines insert the Tags.json
            find = db.Tags.find()
            tag_name = [] # the list that contains all the tag names in Tag.json
            not_in = [] # the list that contains all the tag that not in the Tag.json
            inside = [] # the list that contains all the tag that is inside the Tag.json
            
            for i in find:
                tag_name.append(i["TagName"])
            for h in tag_list:
                if h not in tag_name:
                    not_in.append(h)
                if h in tag_name:
                    inside.append(h)
                
            tid_used = []
            find = db.Tags.find()
            for i in find:
                tid_used.append(i["Id"])
            
            for j in not_in:
                valid = False
                while valid == False:
                    random_tid = random.randint(1, 999999999)
                    gen_tid = str(random_tid)
                    
                    list_set = set(tid_used)
                    result = gen_tid in list_set
                    if result == False:
                        tid = gen_tid
                        valid = True
                        
                insertion = {"Id": tid, "TagName": j, "Count": 1}
                db.Tags.insert_one(insertion)
            
            for k in inside: # add the use count
                find = db.Tags.find({"TagName": k})
                for l in find:
                    use_count = l["Count"]
                    use_count += 1
                db.Tags.update_one({"TagName": k}, {"$set": {"Count" : use_count}})
                
            valid = True
            ##
        
        ### These lines are combing tags
        tag_c = ""
        for tag_iterate in tag_list:
            tag_str = "<{}>".format(tag_iterate)
            tag_c += tag_str
        
        ### These lines check if the pid is been used
        find = db.Posts.find()
        list_pid = [] # list_pid is the list that contains the used pid
        for i in find:
            list_pid.append(i['Id'])
            
        # generate the pid if the pid has not been used
        valid = False
        while valid == False:
            random_pid = random.randint(1, 999999999)
            gen_pid = str(random_pid)

            list_set = set(list_pid)
            result = gen_pid in list_set
            if result == False:
                pid = gen_pid
                valid = True
                
        ###
        #### insert values to the database
        if user_id == '-1':
            insertion = {"Id": pid, "PostTypeId": post_type, "CreationDate": crtdate, "Score": 0, "ViewCount": 0, "Body": body,
                        "Title": title, "Tags": tag_c, "AnswerCount": 0, "CommentCount": 0, "FavoriteCount": 0, "ContentLicense": content_license}
            db.Posts.insert_one(insertion)
        else:
            insertion = {"Id": pid, "PostTypeId": post_type, "CreationDate": crtdate, "Score": 0, "ViewCount": 0, "Body": body,
                        "OwnerUserId": user_id, "Title": title, "Tags": tag_c, "AnswerCount": 0, "CommentCount": 0, "FavoriteCount": 0, "ContentLicense": content_license}
            db.Posts.insert_one(insertion)
        if tag_list == []:
            db.Posts.update_one({"Id": pid},{"$unset": {"Tags": ""}})
        ####
        
        # inform pid
        print('Successfully posted. Your Post ID is {}.'.format(pid))
        # go back to the menu
        norm_menu(db, uid)

def search_for_questions(db, uid):
    
    print("\n-- Search For Questions --")
    key_list = [] # keyword list
    fin = False
    while fin == False:
        keyword = input('Enter a keyword. (Press enter without enetering a keyword): ')
        if keyword == "":
            fin = True
        else:
            in_fin = False
            while in_fin == False:
                in_ask = input('Do you want to input more keyword? ')
                if in_ask.lower() == 'y' or in_ask.lower() == 'yes':
                    key_list.append(keyword.lower().strip())
                    in_fin = True
                elif in_ask.lower() == 'n' or in_ask.lower() == 'no':
                    key_list.append(keyword.lower().strip())
                    in_fin = True
                    fin = True
                else:
                    print('Please enter "y" or "n", "yes" or "no".')
                    
    print('Searching for Questions...')
    include = []
    print("\n-- Result --")
    for key in key_list:
        find = db.Posts.find({"PostTypeId": "1"})
        for posts in find:
            title = posts["Title"]
            body = posts["Body"]
            if "Tags" in posts.keys(): # see if the post has a tag
                tag = posts["Tags"]
                if key.lower().strip() in title.lower() or key.lower().strip() in body.lower() or key.lower().strip() in tag.lower():
                    include.append(posts["Id"])
                    print("PID:", posts["Id"], "\nTitle:", posts["Title"], "\nCreation Date:", posts["CreationDate"], 
                    "\nScore:", posts["Score"], "\nAnswer Count:", posts["AnswerCount"])
                    print("-"*90)
            else: # if no tag, proceed here
                if key.lower().strip() in title.lower() or key.lower().strip() in body.lower():
                    include.append(posts["Id"])
                    print("PID:", posts["Id"], "\nTitle:", posts["Title"], "\nCreation Date:", posts["CreationDate"], 
                    "\nScore:", posts["Score"], "\nAnswer Count:", posts["AnswerCount"])
                    print("-"*90)
    if include == []: # check if there is anything in the list
        print('\n-- No Result --')
        norm_menu(db, uid)
    
    valid = False
    while valid == False:
        # ask to choose the post input
        chosen = input('\nEnter the Post ID to choose the post, or enter "q" to go to the main page: ')
        if chosen.strip() == 'q':
            valid = True
            norm_menu(db, uid)
        elif chosen.strip() in include:
            valid = True
            print('\n-- Post Details --')
            print('Post chosen: {}'.format(chosen))
            find = db.Posts.find({"Id": chosen})
            for i in find:
                title = i["Title"]
                body = i["Body"]
                score = i["Score"]
                crt_date = i["CreationDate"]
                if "AnswerCount" in i.keys():
                    ans_cnt = i["AnswerCount"]
                else:
                    ans_cnt = 'None'
                cmt_cnt = i["CommentCount"]
                if "CommentCount" in i.keys():
                    cmt_cnt = i["CommentCount"]
                else:
                    cmt_cnt = 'None'
                if "FavoriteCount" in i.keys():
                    fav_cnt= i["FavoriteCount"]
                else:
                    fav_cnt = 'None'
                if "ContentLicense" in i.keys():
                    con_lin = i["ContentLicense"]
                else:
                    con_lin = 'None'
                if "OwnerUserId" in i.keys():
                    own_id = i["OwnerUserId"]
                else:
                    own_id = "None (Anonymous)"
                if "Tags" in i.keys():
                    tags = i["Tags"]
                else:
                    tags = "None"
                    
            # increase the view count by 1
            find = db.Posts.find({"Id": chosen})
            for i in find:
                current_count = i["ViewCount"]
            updated_count = current_count + 1
            db.Posts.update_one({"Id": chosen}, {"$set": {"ViewCount" : updated_count}})
            
            print('Title: {}'.format(title.replace('<p>', '').replace('</p>', '')))
            print('Owner User ID: {}'.format(own_id))
            print('Score: {}'.format(score))
            print('Creation Date: {}'.format(crt_date))
            print('View Count: {}'.format(updated_count))
            print('Answer Count: {}'.format(ans_cnt))
            print('Comment Count: {}'.format(cmt_cnt))
            print('Favorite Count: {}'.format(fav_cnt))
            print('Content License: {}'.format(con_lin))
            print('Tags: {}'.format(tags))
            print('Body: {}'.format(body.replace('<p>', '').replace('</p>', '')))
            input('\nEnter any key to proceed.')
            
            second_menu(db, uid, chosen)
        else:
            print('Please enter a valid option.')
    
def second_menu(db, uid, pid): # the menu after the search for questions
    valid = False
    while valid == False:
        print('\nIf you want to go to the main page, please enter "q".')
        print('1. Question Action - Answer')
        print('2. Question Action - List Answers')
        print('3. Question Action - Vote Question')
        print('4. Return to Search for questions.')
        cho_opt = input('Select an option: ')
        if cho_opt.lower().strip() == 'q':
            norm_menu(db, uid)
        elif cho_opt.strip() == '1':
            valid = True
            question_action_answer(db, uid, pid)
        elif cho_opt.strip() == '2':
            valid = True
            # Check if this question has an answer
            check = []
            find = db.Posts.find({"ParentId": pid})
            for i in find:
                check.append(i)
            if len(check) > 0:
                question_action_list(db, uid, pid)
            else:
                print('\n-- There is no answer in this question. --')
                norm_menu(db, uid)
        elif cho_opt.strip() == '3':
            in_valid = False
            while in_valid == False:
                confirm = input('"Confirmation" Press enter to vote for the question, enter "q" to return to the main menu: ')
                if confirm.lower().strip() == "":
                    in_valid = True
                    action_vote(db, uid, pid)
                elif confirm.lower().strip() == "q":
                    in_valid = True
                    print('Exiting to the main menu...')
                    norm_menu(db, uid)
                else:
                    print('Please enter a valid option.')
        elif cho_opt.strip() == '4':
            valid = True
            search_for_questions(db, uid)
        else:
            print('Please enter a valid option.')
    
def question_action_answer(db, uid, pid):
    # answer the question function
    find = db.Posts.find({"Id": pid})
    for i in find:
        post_type = i["PostTypeId"]
    
    if post_type == "1": # input information
        print('\n## Answer ##')
        user_id = uid
        ans_body = input('Enter the body of answer: ')
        crtdate = datetime.today().strftime('%Y-%m-%d')
        p_type = "2"
        parent_id = pid
        score = 0
        comment_count = 0
        content_license = 'CC BY-SA 2.5'
        
        print('Recording the Answer...')
        ### These codes generate the pid if the pid has not been used
        find = db.Posts.find()
        list_pid = [] # list_pid is the list that contains the used pid
        for i in find:
            list_pid.append(i['Id'])
        valid = False
        while valid == False:
            random_pid = random.randint(1, 9999999)
            gen_pid = str(random_pid)
            
            list_set = set(list_pid)
            result = gen_pid in list_set
            if result == False:
                ans_pid = gen_pid
                valid = True
        ###
        # Insert the title and body
        if user_id != '-1':
            insertion = {"Id": ans_pid, "PostTypeId": p_type, "ParentId": parent_id, "CreationDate": crtdate, "Score": score, "Body": "<p>" + ans_body + "<p>", "OwnerUserId": user_id, 
                        "CommentCount": comment_count, "ContentLicense": content_license}
            db.Posts.insert_one(insertion)
        elif user_id == '-1':
            insertion = {"Id": ans_pid, "PostTypeId": p_type, "ParentId": parent_id, "CreationDate": crtdate, "Score": score, "Body": "<p>" + ans_body + "<p>",
                        "CommentCount": comment_count, "ContentLicense": content_license}
            db.Posts.insert_one(insertion)
        
        print('Posted Successfully. Your Answer Post ID is {}.'.format(ans_pid))
        norm_menu(db, uid)
    else: # in case validation
        print('This is not a question type post.')
        norm_menu(db, uid)
        
def question_action_list(db, uid, pid):
    
    print('Searching for Answers...')
    accepted_list = []
    find = db.Posts.find({"Id": pid}) # List of Answers related to post Question. Tentative name
    for i in find: # Checks through postList to see if there is an Accepted answer and adds it to a list
        if "AcceptedAnswerId" in i.keys():
            accepted_num = i["AcceptedAnswerId"]
            accepted_list.append(accepted_num)
    if len(accepted_list) == 0: # Checks if there is an accepted answer
        find = db.Posts.find({"ParentId": pid})
        print("\n-- Result --")
        for i in find:
            print("PID:", i["Id"], "Body:", i["Body"][:80].replace("<p>", " ").replace("</p>", " "), 
                    "Creation Date:", i["CreationDate"], "Score:", i["Score"]) # Prints out PostList
    else:
        check_accepted = [] # the list that checks if there is accepted answer in this question
        find = db.Posts.find({"Id": accepted_num})
        print("\n-- Result --")
        for i in find:
            check_accepted.append(i)
            print("*", "PID:", i["Id"], "Body:", i["Body"][:80].replace("<p>", " ").replace("</p>", " "), 
                    "Creation Date:", i["CreationDate"], "Score:", i["Score"]) # Prints Accepted answer first
        find = db.Posts.find({"ParentId": pid})
        for i in find:
            if i != check_accepted[0]: # Checks if the currrent ireration is the accepted answers and skips it if it is
                print(" ", "PID:", i["Id"], "Body:", i["Body"][:80].replace("<p>", " ").replace("</p>", " "), 
                    "Creation Date:", i["CreationDate"], "Score:", i["Score"])
    
    find = db.Posts.find({"ParentId": pid})
    all_ans = [] # List with answers of selected pid
    for i in find:
        all_ans.append(i["Id"])
        
    valid = False
    while valid == False:
        aid = input("\nPlease enter a Post ID from the given list: ")
        if aid not in all_ans:
            print('Please enter a valid Answer PID.')
        else:
            valid = True
    
    find = db.Posts.find({"Id": pid}) # print detailed question
    print("\n-- Question --")
    for i in find:
        print("PID:", i["Id"], "\nTitle:", i["Title"].replace('<p>', '').replace('</p>', ''), "\nBody:", i["Body"].replace('<p>', '').replace('</p>', ''))
        
    find = db.Posts.find({"ParentId": pid}) # print the detailed answer
    print("-- Detailed Answer --")
    for i in find:
        if aid == i["Id"]:
            in_find = db.Posts.find({"Id": aid})
            for x in in_find:
                if "OwnerUserId" not in x.keys():
                    ouid = 'None (Anonymous)'
                else:
                    ouid = x["OwnerUserId"]
            print("PID:", i["Id"].replace('<p>', '').replace('</p>', ''), "\nUser ID:", ouid, "\nBody:", i["Body"].replace('<p>', '').replace('</p>', ''))
        
    fin = False
    while fin == False:
        in_ask = input("\nDo you want to take a vote on the answer? ")
        if in_ask.lower() == 'y' or in_ask.lower() == 'yes':
            fin = True
        elif in_ask.lower() == 'n' or in_ask.lower() == 'no':
            fin = True
            norm_menu(db, uid)
        else:
            print('Please enter "y" or "n", "yes" or "no".')
        
    valid = False
    while valid == False:
        choice = input('"Confirmation" Press enter to vote for the answer, enter "q" to return to the main menu: ')
        if choice.lower().strip() == "":
            valid = True
            action_vote(db, uid, aid)
        elif choice.lower().strip() == "q":
            valid = True
            print('Returning to main menu.')
            norm_menu(db, uid)
        else:
            print('Please enter a valid option.')
            
def action_vote(db, uid, pid):
    
    ### Check if the generate vid in the used list
    find = db.Votes.find({}, {"_id": 0, "Id": 1})
    vid_used = []
    print('Voting...')
    for i in find:
        vid_used.append(i["Id"])
    valid = False
    while valid == False:
        random_pid = random.randint(1, 999999999)
        gen_vid = str(random_pid)
        
        list_set = set(vid_used)
        result = gen_vid in list_set
        if result == False:
            vid = gen_vid
            valid = True
            
    ###
    voteTypeID = "2"
    crtdate = datetime.today().strftime('%Y-%m-%d')
    
    if uid != "-1": # Checks if user is anonymous
        find = db.Votes.find({"PostId": pid})
        with_user = []
        for i in find:
            if "UserId" in i.keys():
                with_user.append(i)
        if with_user == []: # insert the vote with the votes that does not contain user id
            votePost = {"Id": vid,
            "PostId": pid,
            "VoteTypeId": voteTypeID,
            "CreationDate": crtdate,
            "UserId": uid}
            db.Votes.insert_one(votePost)
            print("Successfully vote on PID {}, the Vote ID is {}.".format(pid, vid))
            
        elif with_user != []:
            all_used_uid = []
            for i in with_user:
                all_used_uid.append(i["UserId"])
            
            set_uid = set(all_used_uid)
            result = uid in set_uid
            if result == True:
                print('-- You have voted this post before. --')
            else:
                votePost = {"Id": vid,
                "PostId": pid,
                "VoteTypeId": voteTypeID,
                "CreationDate": crtdate,
                "UserId": uid}
                db.Votes.insert_one(votePost)
                print("Successfully vote to PID {}, the Vote ID is {}.".format(pid, vid))
                
    elif uid == "-1":
        votePost = {"Id": vid,
        "PostId": pid,
        "VoteTypeId": voteTypeID,
        "CreationDate": crtdate}
        db.Votes.insert_one(votePost)
        print("Successfully vote to PID {}, the Vote ID is {}.".format(pid, vid))
        
    find = db.Posts.find({"Id": pid}) # Gets the score for the post
    for i in find:
        score = i["Score"]
    new_score = int(score) + 1
    db.Posts.update_one({"Id": pid},{"$set": {"Score": int(new_score)}}) # After incrementing by one, updates db
    norm_menu(db, uid)

def report(db, uid):
    
    # check if the user id appears in the database
    print('Forming User Report...')
    
    q_own = 0
    a_own = 0
    # find how many questions the user owned
    question_own = db.Posts.aggregate([{"$match": {"OwnerUserId": uid, "PostTypeId": "1"}}, {"$count": "Ques"}])
    for i in question_own:
        q_own = i["Ques"]
    # find how many answers the user owned
    answer_own = db.Posts.aggregate([{"$match": {"OwnerUserId": uid, "PostTypeId": "2"}}, {"$count": "Ans"}])
    for i in answer_own:
        a_own = i["Ans"]
    
    # find the average score
    avg_q = 0
    avg_a = 0
    avg_score = db.Posts.aggregate([{"$match": {"OwnerUserId": {"$in": [uid]}}}, {"$group": {"_id": "$PostTypeId", "avg_score": {"$avg": "$Score"}}}])
    for i in avg_score:
        if i["_id"] == "1":
            avg_q = i["avg_score"]
        if i["_id"] == "2":
            avg_a = i["avg_score"]
    # find the total votes
    sum_v = 0
    find = db.Votes.aggregate([{"$match": {"UserId": uid}}, {"$count": "Total"}])
    for i in find:
        sum_v = i["Total"]
    
    print("\n-- User Report --")
    print("The number of QUESTION owned:", q_own)
    print("The average score for the QUESTIONS:", avg_q)
    print("The number of ANSWER owned:", a_own)
    print("The average score for the ANSWERS:", avg_a)
    print("The number of VOTES registered for the user:", sum_v)
    input("Press any key to continue: ")
    
    print('\nPassing the User ID {} to the main menu...'.format(uid))
    
def main():
    port_num = str(sys.argv[1])
    client = pymongo.MongoClient("mongodb://localhost:" + port_num + "/") # connect to client
    db = client['291db'] # connect to database
    # get uid
    uid = get_uid()
    ### if there is no uid provided, pass to the menu, otherwise pass to the user report
    if uid == "":
        uid = "-1"
    if uid != "-1":
        report(db, uid)
    ###
    norm_menu(db, uid) # program starts
    client.close()
    
if __name__ == "__main__":
    main()