#!/usr/bin/env python
# coding: utf-8

# In[15]:


#! python3
import praw
import pandas as pd
import datetime as dt

reddit = praw.Reddit(client_id='wqgiDqmuyVMaDA',                      client_secret='ey56_kOHP2WsdbrV_XdTbVk3AFM',                      user_agent='sentiment_anal',                      username='dynasourkeys',                      password='anacondanohtyp')

subreddit = reddit.subreddit('SurreyBC')
top_subreddit = subreddit.top(limit=5000)
#for submission in subreddit.top(limit=1000):
    #print(submission.title, submission.id)

topics_dict = { "title":[],                 "score":[],                 "id":[],                 "url":[],                 "comms_num": [],                 "created": [],                 "body":[]}

for submission in top_subreddit:
    topics_dict["title"].append(submission.title)
    topics_dict["score"].append(submission.score)
    topics_dict["id"].append(submission.id)
    topics_dict["url"].append(submission.url)
    topics_dict["comms_num"].append(submission.num_comments)
    topics_dict["created"].append(submission.created)
    topics_dict["body"].append(submission.selftext)
    
topics_data = pd.DataFrame(topics_dict)

def get_date(created):
    return dt.datetime.fromtimestamp(created)
_timestamp = topics_data["created"].apply(get_date)

topics_data = topics_data.assign(timestamp = _timestamp)


topics_data.to_csv('sentiment_anal.csv', index=False) 


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




