#Please see R markdown file for more descriptions of code

#project 1

library(tidyverse)
library(ggplot2)
library(dplyr)
library(knitr)
library(kableExtra)

#set working directory
setwd("~/Desktop/611 Notes/bios611-projects-fall-2019-cwzhou/project_1/results")

#load dataset
urban <- read.delim("~/Desktop/611 Notes/bios611-projects-fall-2019-cwzhou/project_1/data/UMD_Services_Provided_20190719.tsv", header=T)
#change date format
urban$Date <- as.Date(urban$Date, "%m/%d/%Y")
#extract year variable
urban$Year <- format(as.Date(urban$Date, format="%d/%m/%Y"),"%Y")
#View(arrange(urban,Date))

#create dataset df1 that remove dates from FUTURE
df1 <- filter(urban, urban$Date <= Sys.Date()) 
#create a dataset df2 that only keeps dates of interest and drops rows with missing data from food variables
df2 = df1 %>%
  arrange(Client.File.Number,Date) %>% 
  select(Date, Client.File.Number,Food.Provided.for, Food.Pounds,Year) %>%
  filter(Date >= "2001-01-01")%>% #to stay up to date with current trends, we will only examine data in the last 10 years (2001-01-01 to 2018-12-31)
  filter(Date <= "2018-12-31") %>%
  drop_na(Food.Provided.for, Food.Pounds)  #only keep rows that do not have missing variables food.provided.for and food.pounds

#create dataset df3 that contains summaries per ID: number of visits, maximum number of family members over all visits, minimum number of family members over all visits, mean pounds of food per visit.
df3 = df2 %>%
  group_by(Client.File.Number) %>%
  summarise(Number_of_Visits = n(),
            max_food = max(Food.Provided.for),
            min_food = min(Food.Provided.for),
            mean_food_pounds_per_day = mean(Food.Pounds))
#create table that keeps subjects between 2001-2018 without missing data from food variables, sorted by households, counting number of visits, first year of visit, last year of visit, range between first and last visit.

#table of number of visits, first visit year, last visit year, and range of visits per ID
df2 %>%
  group_by(Client.File.Number)  %>%
  summarise(Number_of_Visits = n(),
            First_Visit_Year = as.numeric(first(Year)),
            Last_Visit_Year = as.numeric(last(Year)),
            Range = Last_Visit_Year-First_Visit_Year + 1) %>%
  arrange(desc(Number_of_Visits), desc(Range), First_Visit_Year) %>%
  head(10) %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", full_width = F)

#create dataset that subsets data to those with same number of members for every visit
df4 = df3 %>% filter(max_food==min_food) %>% #subset those with same number of family members (1+) each visit
  mutate(Number_of_Members = max_food) %>%
  select(Client.File.Number, Number_of_Visits, Number_of_Members, mean_food_pounds_per_day)

#top 5 observations of table sorting by descending order number of family members to identify outliers
df4 %>% arrange(desc(Number_of_Members), desc(mean_food_pounds_per_day)) %>%
  head(5)  %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", full_width = F)

#top 15 observations of table sorting by descending order mean pounds of food per day to identify outliers
df4 %>%
  arrange(desc(mean_food_pounds_per_day),desc(Number_of_Members)) %>%
  head(15)  %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", full_width = F)

#create dataset test1 that removes outliers and meets previous data subseting
test1 = df4 %>% 
  filter(Number_of_Members >0) %>% #remove observations who do not take food from UMD since we are only examining those who take food
  filter(Number_of_Members <= 100) %>% #remove the observation with 200 family members (likely a typo)
  filter(mean_food_pounds_per_day <= 100) %>%#remove observations with more than an average of 500 pounds of food per day
  select(Client.File.Number,Number_of_Visits,Number_of_Members,mean_food_pounds_per_day)
test1$family = as.factor(ifelse(test1$Number_of_Members>1,1,0)) #create indicator: if food.provided.for > 1 then family = 1 else family = 0
#define family as more than 1 person, as assumed by "provided.food.for"

#View(test1)
head(arrange(test1, desc(mean_food_pounds_per_day), desc(Number_of_Visits),desc(Number_of_Members)),5) %>%
  kable() %>%
  kable_styling(bootstrap_options = "striped", full_width = F)

#count how many people are in each category household type
test1 %>%
  group_by(family) %>%
  summarise("Total Count" = n()) %>%
  kable() %>%
  kable_styling( bootstrap_options = "striped",full_width = F)
#    Family      Total_family
#      0         3405
#      1         3786

#Analysis plots
####################FIG 1######################
#Boxplot of avg pounds of food per household per day, comparing single-member households vs. family households
#As expected, those with families have much higher averages per day, also higher outliers
levels(test1$family) <- c("Single", "Family")

test1 %>% ggplot(aes(x=family, y=mean_food_pounds_per_day, fill=family))+
  geom_boxplot(aes(fill=family))+
  theme_bw() + theme(panel.border = element_blank())+
  labs(x="Household Type",
       y="Average number of pounds of food per day",
       title ="Fig 1: Boxplot of average pounds of food per day by household type")+
  scale_fill_manual(values=c("lightslateblue","steelblue1"))
ggsave("Project1_Fig1_Box.png", height=5, width=7)


####################FIG 2a######################
#Boxplot of total number of visits in last 10 years per household, comparing single-member households vs. family households
#More (and more extreme) outliers for single households, wider spread, than family households
test1 %>% 
  ggplot(aes(x=family, y= Number_of_Visits, fill=family))+
  geom_boxplot(aes(fill=family))+
  theme_bw() + theme(panel.border = element_blank())+
  scale_fill_manual(values=c("lightslateblue","steelblue1"))+
  labs(x="Household Type",
       y="Total number of visits per household",
       title ="Fig 2a: Boxplot of total visits by household type")
ggsave("Project1_Fig2a_Box.png", height=5, width=5)


#Boxplot of total number of visits in last 10 years per household, comparing single-member households vs. family households
#More (and more extreme) outliers for single households, wider spread, than family households
test1 %>% 
  filter(Number_of_Visits <60) %>% #removing extreme outliers for Number_of_Visits (mostly for single household)
  ggplot(aes(x=family, y= Number_of_Visits, fill=family))+
  geom_boxplot(aes(fill=family))+
  theme_bw() + theme(panel.border = element_blank())+
  scale_fill_manual(values=c("lightslateblue","steelblue1"))+
  labs(x="Household Type",
       y="Total number of visits per household",
       title ="Fig 2b: Boxplot of total visits by household type")
ggsave("Project1_Fig2b_Box.png", height=5, width=5)



####################FIG 3a######################
#Histogram comparison of total number of visits between families vs single people.
#More visits from single households, as well as greater spread.
#For both types, largest count is LOW-count visits like 1-3 etc
test1 %>% 
  filter(Number_of_Visits > 10) %>% #removing extreme outliers for Number_of_Visits (mostly for single household)
  ggplot(aes(x=Number_of_Visits))+
  geom_bar(aes(fill=family)) +
  guides(fill=FALSE)+
  scale_fill_manual(values=c("lightslateblue","steelblue1"))+
  theme_bw() + theme(panel.border = element_blank())+
  labs(x="Number of Visits",
       y="Total Households",
       title ="Fig 3a: Distribution of number of visits greater than 10 by household type")+
  facet_wrap(vars(family))
ggsave("Project1_Fig3a_Bar.png", height=4, width=7)

####################FIG 3b######################
test1 %>%
  filter(Number_of_Visits <=10) %>% #removing extreme outliers for Number_of_Visits (mostly for single household)
  ggplot(aes(x=Number_of_Visits, group=family)) +
  geom_bar(position="dodge",aes(fill=family))+
  scale_fill_manual(values=c("lightslateblue","steelblue1"))+
  theme_bw() + theme(panel.border = element_blank())+
  labs(x="Number of Visits",
       y="Total Households",
       title ="Fig 3b: Distribution of number of visits (up to 10) by household type",
       fill="Household Type")
#define family as more than 1 person, as assumed by "provided.food.for"
ggsave("Project1_Fig3b_Bar.png", height=4, width=7)
#More family single visits, more long-term visits from single households
#Could be due to family households try harder to escape homelessness for their kids?
