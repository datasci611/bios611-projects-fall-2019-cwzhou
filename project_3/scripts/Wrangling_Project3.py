#!/usr/bin/env python
# coding: utf-8

# In[6]:


# load Python packages used data wrangling
import pandas as pd
import numpy as np
import datetime as datetime

# UMD shelter data from github
client = pd.read_csv('https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project2_2019/CLIENT_191102.tsv',sep='\t')
visit = pd.read_csv('https://raw.githubusercontent.com/biodatascience/datasci611/gh-pages/data/project2_2019/ENTRY_EXIT_191102.tsv',sep='\t')

#client.head()
#visit.head()

#change Entry and Exit dates to datetime, then create OUTCOME variable (Total.Nights)
visit['Entry'] =  pd.to_datetime(visit['Entry Date'], format='%m/%d/%Y')
visit['Exit'] =  pd.to_datetime(visit['Exit Date'], format='%m/%d/%Y')
visit['Total Nights'] = visit['Exit'] - visit['Entry']  # difference automatically calculated in days
#visit["Total Nights"][0].days
visit["Total Nights"] = visit["Total Nights"].apply(lambda row: row.days)
#visit["Total Nights"]

#remove unused variables
visit1 = visit.drop(['Entry Exit Group Id','Entry Exit Household Id', 'Unnamed: 6','Entry Exit Date Added','Entry Exit Date Updated','Housing Move-in Date(5584)','Destination','Entry Exit Type'], axis=1)
client1 = client.drop(['Client Age at Exit','Client Veteran Status'],axis=1)


# In[7]:


visit1.head()
#visit1['Total Nights'].dtype


# In[8]:


#visit1.head()
#client1.head()


# In[9]:


#Merge the two datasets by ID
df = client1.merge(visit1, on=['Client Unique ID','EE Provider ID', 'EE UID', 'Client ID'], how='left')
#df.dropna(df, axis=0, how='any')
df.columns


# In[10]:


#SHow unique values for each covariate
#df['Client Age at Entry'].unique()
#df['Client Gender'].unique()
#df['Client Primary Race'].unique()
df['Client Ethnicity'].unique()
#df['Reason for Leaving'].unique()


# In[11]:


#how many observations in the dataset
df.shape


# In[12]:


#df.isna().mean()


# In[13]:


#df.isna().mean()


# In[14]:


#drop missing values
df1 = df.dropna(axis=0,how='any')


# In[15]:


#df1.isna().mean()
df1.shape


# In[17]:


#drop Trans Female observations
df2 = df1[df1['Client Gender'] != 'Trans Female (MTF or Male to Female)']
df2.shape


# In[18]:


#drop observations with refuse, doesn't know, or not collected for ethnicity
df3 = df2[df2['Client Ethnicity'] != 'Client refused (HUD)']
df3 = df3[df3['Client Ethnicity'] != "Client doesn't know (HUD)"]
df3 = df3[df3['Client Ethnicity'] != "Data not collected (HUD)"]
df3.shape


# In[23]:


#drop observations with refuse, doesn't know, or not collected for race
df4 = df3[df3['Client Primary Race'] != 'Client refused (HUD)']
df4 = df4[df4['Client Primary Race'] != "Client doesn't know (HUD)"]
df4 = df4[df4['Client Primary Race'] != "Data not collected (HUD)"]
df4.shape


# In[25]:


#create dataframes
from pandas import DataFrame

export_csv = df1.to_csv (r'../data/export_dataframe.csv', index = None, header=True)
final_csv = df4.to_csv (r'../data/final_dataframe.csv', index = None, header=True)
#/Users/zhou/Desktop/611 Notes/bios611-projects-fall-2019-cwzhou/project_3

