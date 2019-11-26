#!/usr/bin/env python
# coding: utf-8

# In[3]:


# load Python packages used data wrangling
import pandas as pd
import numpy as np
import datetime as datetime

# UMD shelter data from github
client = pd.read_csv('https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project2_2019/CLIENT_191102.tsv',sep='\t')
visit = pd.read_csv('https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project2_2019/ENTRY_EXIT_191102.tsv',sep='\t')

#client.head()
#visit.head()

visit['Entry'] =  pd.to_datetime(visit['Entry Date'], format='%m/%d/%Y')
visit['Exit'] =  pd.to_datetime(visit['Exit Date'], format='%m/%d/%Y')
visit['Total Nights'] = visit['Exit'] - visit['Entry']  # difference automatically calculated in days
#visit["Total Nights"][0].days
visit["Total Nights"] = visit["Total Nights"].apply(lambda row: row.days)
#visit["Total Nights"]

visit1 = visit.drop(['Entry Exit Group Id','Entry Exit Household Id', 'Unnamed: 6','Entry Exit Date Added','Entry Exit Date Updated','Housing Move-in Date(5584)','Destination','Entry Exit Type'], axis=1)
client1 = client.drop(['Client Age at Exit','Client Veteran Status'],axis=1)


# In[4]:


visit1.head()
#visit1['Total Nights'].dtype


# In[5]:


#visit1.head()
#client1.head()


# In[6]:


df = client1.merge(visit1, on=['Client Unique ID','EE Provider ID', 'EE UID', 'Client ID'], how='left')
#df.dropna(df, axis=0, how='any')
df.columns


# In[7]:


#df['Client Age at Entry'].unique()
#df['Client Gender'].unique()
#df['Client Primary Race'].unique()
#df['Client Ethnicity'].unique()
df['Reason for Leaving'].unique()


# In[17]:


df.shape


# In[27]:


#df.isna().mean()


# In[26]:


#df.isna().mean()


# In[22]:


df1 = df.dropna(axis=0,how='any')


# In[25]:


#df1.isna().mean()
df1.shape


# In[28]:


from pandas import DataFrame
export_csv = df1.to_csv ('../data/export_dataframe.csv', index = None, header=True)
