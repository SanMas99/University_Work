# CMPUT 291 Fall 2020 Mini Project 2
# Backbone Function coded by Leo, Sanad, Terms Index Function coded by Mutaal
from pymongo import MongoClient
import json
import sys
import string
import time

def database():
    start_time = time.time()
    client = MongoClient("mongodb://localhost:"+str(sys.argv[1])+"/")

    db = client['291db']

    all_list = db.list_collection_names()#Drops Collections if existing
    if 'Posts' in all_list:
        db.Posts.drop()
    if 'Tags' in all_list:
        db.Tags.drop()
    if 'Votes' in all_list:
        db.Votes.drop()
#Creates Votes,Tags,Posts collections
    posts_col = db['Posts']
    tags_col = db['Tags']
    votes_col = db['Votes']
 #Loads collections with data from json files       
    with open('Tags.json') as tags:
        tags_data = json.load(tags)
    tags_col.insert_many(tags_data['tags']['row'])

    with open('Posts.json') as posts:
        posts_data = json.load(posts)
    for doc in posts_data['posts']['row']:#Gets data from individual rows and then inserts post data into the collection
        terms=[]  
        if 'Title' not in doc:
            body=doc['Body']
            result = ""
            for x in str(body):
                if x not in string.punctuation:
                    result += x
                else:
                    result += ' '
            temp=result.split()
            for items in temp:
                if len(items)>=3:                   
                    terms.append(items.lower())
            terms = list(dict.fromkeys(terms))
            doc['terms']=terms
            
        else: 
            title=doc['Title']
            body=doc['Body']
            final_string=str(title)+' '+str(body)
            result = ""
            for x in final_string:
                if x not in string.punctuation:
                    result += x
                else:
                    result += ' '
            temp=result.split()
            for items in temp:
                if len(items)>=3:                  
                    terms.append(items.lower())
            terms = list(dict.fromkeys(terms))
            doc['terms']=terms
            
    posts_col.insert_many(posts_data['posts']['row'])
    posts_col.create_index('terms') 
    
    with open('Votes.json') as votes:
        votes_data = json.load(votes)
    votes_col.insert_many(votes_data['votes']['row'])
    
    client.close()#Closes the client once done and gives a time duration of how long phase lasted
    print("\n\n\n--- %s seconds ---" % (time.time() - start_time))
    
database()
