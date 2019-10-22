#Project 2

library(tidyverse)
#setwd("~/Desktop/611 Notes/bios611-projects-fall-2019-cwzhou/project_2")

# INTRODUCTION/BACKGROUND
bg1 = c("Homelessness is defined as any person living without a home. Homeless people typically live on the streets. In North Carolina, the Continuums of Care to the U.S. Department of Housing and Urban Development (HUD) reported approximately 9,268 people experience homelessness on any given day as of January 2018 (1). Shelters and volunteers attempt to lower this number by providing resources that can potentially help a person or family find the means to obtain a home, and thus stop living on the streets.")
bg2=c("One of these shelters in Durham, North Carolina, is Urban Ministries of Durham (UMD). Established in 1983, UMD is a non-profit organization that focuses on lowering the community's rate of homelessness by providing food, shelter and other resources to those in need. In 2001, three organizations (Durham Community Shelter for HOPE, St. Philip’s Community Cafe, and the United Methodist Mission Society) merged to create UMD as it exists today. UMD strives to holistically lower Durham's homelessness rates with the help from the Durham community and over 4,000 volunteers. UMD provides 'food, shelter, and a future' to over 6,000 men, women, and children every year (2).")
ref1 = c("1) https://www.usich.gov/homelessness-statistics/nc/", "2) http://www.umdurham.org/")

# GOALS
g2 = c("Create an user-friendly interactive Shiny dashboard to display various UMD data trends
       (such as Food.Provided.for, Food.Pounds, Clothing.Items, Diapers, School.Kits, Hygiene.Kits)",
       "Examine the number of visits each year per client and this trend over time")
g1 = c("For this project, after data cleaning, we have the following aims:")

# DATA SOURCE and DATA CLEANING
ds1 = c("The data for our analysis is from UMD. UMD has been collecting data about people who utilize its resources for decades. This data includes an identifier (ID), date of visit, number of people the food from that visit provided for, pounds of food taken from food pantry, amount of clothing taken from clothing closet, and more. The total number of observations of this data is 79838.")
ds3 = c("Variable descriptions for the UMD data can be found here: https://github.com/biodatascience/datasci611/blob/gh-pages/data/project1_2019/UMD_Services_Provided_metadata_20190719.tsv")
ds2 = c("Since UMD as it is known today was created in 2001, we truncate our dataset to be collected data from January 1, 2001 to the last date of a full year of data, which is December 31, 2018. Since the data for 2019 is not complete, we omit data that was collected after December 31, 2018.")
ds4 = c("For our analysis in the next tab, we plot the data by year. Since this data is abundant, we remove missing data within each variable for the variable examined. Thus our datasets are all different for each graph. Additionally, we remove any outliers to have a better view of the data.")
ds5 = c("Outliers include ")

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
  as.data.frame()

# ANALYSIS
#create data frame for complete case analysis without missing values for variable selected
helper_1 = function(var,date){
  df2 %>% 
    arrange(Client.File.Number,Date,Year)  %>%
    drop_na(var) %>% 
    filter(Year %in% date) %>%
    select(Client.File.Number,Date,var) #%>% #outliers - fix to remove them
   # mutate(lowerq = quantile(var)[2]) %>%
  #  mutate(upperq = quantile(var)[4]) %>%
  #  mutate(iqr = upperq - lowerq) %>%
  #  mutate(extreme.threshold.upper = (iqr * 3) + upperq) %>%
  #  mutate(extreme.threshold.lower = lowerq - (iqr * 3)) %>%
  #  filter(extreme.threshold.upper >= var &  extreme.threshold.lower >= var)
}

helper2 = function(var,date){
 newdf = helper_1(var,date)
  ggplot(newdf,
         aes(x=Date, y = get(var))) +
    geom_point() + theme_bw()+
    labs(y = "Variable selected",
        x = "Date",
        title = "Scatter Plot of UMD variables within each Year")
}

