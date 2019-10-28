#Project 2

library(tidyverse)
#setwd("~/Desktop/611 Notes/bios611-projects-fall-2019-cwzhou/project_2")

# INTRODUCTION/BACKGROUND
bg0 = c("Thank you for coming to this interactive app! This app was designed to help any person obtain a better understanding on the data collected by Urban Ministries of Durham (UMD) in order to become more familiar with their services and how useful they are.")
bg1 = c("Homelessness is defined as any person living without a home. Homeless people typically live on the streets. In North Carolina, the Continuums of Care to the U.S. Department of Housing and Urban Development (HUD) reported approximately 9,268 people experience homelessness on any given day as of January 2018")
bg1.5 = c("Shelters and volunteers attempt to lower this number by providing resources that can potentially help a person or family find the means to obtain a home, and thus stop living on the streets.")
bg2=c("One of these shelters in Durham, North Carolina, is Urban Ministries of Durham (UMD). Established in 1983, UMD is a non-profit organization that focuses on lowering the community's rate of homelessness by providing food, shelter and other resources to those in need. In 2001, three organizations (Durham Community Shelter for HOPE, St. Philip’s Community Cafe, and the United Methodist Mission Society) merged to create UMD as it exists today. UMD strives to holistically lower Durham's homelessness rates with the help from the Durham community and over 4,000 volunteers. UMD provides 'food, shelter, and a future' to over 6,000 men, women, and children every year through UMD's community cafe and food pantry, clothing closet, and community shelters")

# GOALS
g2 = c("First, create an user-friendly interactive Shiny dashboard to display raw data of various UMD collected data
       (such as the number of people food taken was provided for, pounds of food taken from the food pantry, number of clothing items taken from the closet, numbers of diapers taken, number of school kits taken, number of hygiene kits taken)",
       "Second, examine the number of visits each year per client and summaries")
g1 = c("For this project, after data cleaning, we have the following aims:")

# DATA SOURCE and DATA CLEANING
ds1 = c("The data for our app is from UMD. UMD has been collecting data about people who utilize its resources for decades. This data includes an identifier (ID), date of visit, number of people the food from that visit provided for, pounds of food taken from food pantry, amount of clothing taken from clothing closet, and more. The total number of observations of this data is 79838.")
ds3 = c("Variable descriptions for the UMD data can be found ")
ds2 = c("Since UMD as it is known today was created in 2001, we truncate our dataset to be collected data from January 1, 2001 to the last date of a full year of data, which is December 31, 2018. Since the data for 2019 is not complete, we omit data that was collected after December 31, 2018.")
ds4 = c("To examine the raw data, we plot the data by year. Since this data is abundant, we remove missing data within each variable for the variable examined. For the purposes of this app, we only examine the following variables: the number of people food taken was provided for, pounds of food taken from the food pantry, number of clothing items taken from the closet, numbers of diapers taken, number of school kits taken, number of hygiene kits taken. Thus the dataset changes for each graph, since different observations are missing depending on the variable of interest. Additionally, we remove any outliers to have a better view of the data.")
ds5 = c("We determine outliers using the Inter-Quartile Range (IQR) method and remove them from our analysis.")

# DATA CLEANING
#load dataset
urban <- read.delim("./data/UMD_Services_Provided_20190719.tsv", header=T)
#change date format
urban$Date <- as.Date(urban$Date, "%m/%d/%Y")
#extract year variable
urban$Year <- format(as.Date(urban$Date, format="%d/%m/%Y"),"%Y")
#create dataset df1 that remove dates from FUTURE
#df1 <- filter(urban, urban$Date <= Sys.Date()) 
df1 <- filter(urban, urban$Date <= "2018-12-31") #delete dates 2019 and beyond
#create a dataset df2 that only keeps dates of interest and variables of interest
df2 = df1 %>%
  arrange(Client.File.Number,Date,Year) %>% 
  select(Date, Year, Client.File.Number,
         Food.Provided.for, Food.Pounds,
         Clothing.Items, Diapers, School.Kits, Hygiene.Kits) %>%
  filter(Date >= "2001-01-01")%>% #to stay up to date with current trends, we will only examine data in the 20 years (2001-01-01 to 2018-12-31)
 filter(Food.Provided.for<=8.5) %>%
  # filter(Food.Provided.for<=20, Food.Pounds <=30, Clothing.Items <= 30, Diapers <=40, School.Kits<=40, Hygiene.Kits<=30) %>%
  as.data.frame()

# ANALYSIS
#create data frame for complete case analysis without missing values for variable selected
helper_1 = function(var,date){
  df2 %>% 
    arrange(Client.File.Number,Date,Year)  %>%
    drop_na(var) %>% 
    filter(Year %in% date) %>%
    select(Client.File.Number,Date,var) %>%
    mutate(lq = quantile(get(var))[2]-1.5*(quantile(get(var))[4]-quantile(get(var))[2]),
           uq = quantile(get(var))[4]+1.5*(quantile(get(var))[4]-quantile(get(var))[2])) %>%
    filter(lq <= get(var))%>%
    filter(get(var)<= uq)
}

helper2 = function(var,date,var_lab){
 newdf = helper_1(var,date)
 ggplot(newdf,
         aes(x=Date, y = get(var))) +
    geom_point() + theme_bw()+
    labs(y = var_lab,
        x = "Date",
        title = c("Scatter Plot of data points within each Year"))
}

year_df =  df2 %>%
 #filter( > quantile(precip, 0.9, na.rm=TRUE)) %>%
  mutate(ID = Client.File.Number) %>%
  group_by(ID,Year) %>%
  count(Year) %>%
  arrange(-n, ID) %>%
 mutate("Number of Visits" = n) %>%
  select(-n) 

avg_df = df2 %>%
  arrange(Year) %>%
  group_by(Year) %>%
  summarise(Visits=n(),
            Clients = n_distinct(Client.File.Number),
            Mean = round(Visits/Clients,3)) %>%
  arrange(-Mean)

