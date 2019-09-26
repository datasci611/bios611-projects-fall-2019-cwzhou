library(tidyverse)
library(ggplot2)
library(dplyr)
#project 1
setwd("~/Desktop/611 Notes/bios611-projects-fall-2019-cwzhou/project_1/scripts")

#load dataset
urban <- read.delim("~/Desktop/611 Notes/bios611-projects-fall-2019-cwzhou/project_1/data/UMD_Services_Provided_20190719.tsv", header=T)
#View(urban)
urban$Date <- as.Date(urban$Date, "%m/%d/%Y")
urban$Year <- format(as.Date(urban$Date, format="%d/%m/%Y"),"%Y")
df1 <- filter(urban, urban$Date <= Sys.Date()) #remove dates from FUTURE
df2 = df1 %>%
  arrange(Client.File.Number,Date) %>% 
  select(Date, Client.File.Number,Food.Provided.for, Food.Pounds) %>%
  filter(Date >= "2001-01-01")%>% #to stay up to date with current trends, we will only examine data in the last 10 years (2001-01-01 to 2019-08-31)
  filter(Date <= "2019-07-17") %>%
  drop_na(Food.Provided.for, Food.Pounds) %>% #only keep rows that do not have missing variables food.provided.for and food.pounds
  group_by(Client.File.Number) %>%
  summarise(no_dates = n(),
            max_food = max(Food.Provided.for),
            min_food = min(Food.Provided.for),
            mean_food_pounds_per_day = mean(Food.Pounds))


df1 %>%
  arrange(Client.File.Number,Date) %>% 
  select(Client.File.Number,Food.Provided.for, Food.Pounds,Year) %>%
  filter(Year >= "2001")%>% #only select observations from 2001 onward
  drop_na(Food.Provided.for, Food.Pounds) %>% #only keep rows that do not have missing variables food.provided.for and food.pounds
  group_by(Client.File.Number)  %>%
  summarize(no_visits = n(),
            first_year = as.numeric(first(Year)),
            last_year = as.numeric(last(Year)),
            no_years = last_year-first_year+1) %>%
  arrange(desc(no_years, no_visits, as.date(first_year)))

test1 = df2 %>% filter(max_food==min_food) %>% #subset those with same number of family members (1+) each visit
  filter(max_food >0) %>% #remove observations who do not take food from UMD since we are only examining those who take food
  filter(max_food <= 100) %>% #remove the observation with 200 family members (likely a typo)
  filter(mean_food_pounds_per_day <= 100) #remove observations with more than an average of 500 pounds of food per day
test1$family = as.factor(ifelse(test1$max_food>1,1,0)) #create indicator: if food.provided.for > 1 then family = 1 else family = 0
#define family as more than 1 person, as assumed by "provided.food.for"
#7423 observations

#View(test1)

test1 %>%
  group_by(family) %>%
  summarise(total_family = n())
#    Family      Total_family
#      0         3538
#      1         3885



####################FIG 1######################
#Boxplot of avg pounds of food per household per day, comparing single-member households vs. family households
#As expected, those with families have much higher averages per day, also higher outliers
test1 %>% ggplot(aes(x=family, y=mean_food_pounds_per_day, fill=family))+
  geom_boxplot(aes(fill=family))+
  theme_bw() + theme(panel.border = element_blank())+
  labs(x="Household Type",
       y="Average number of pounds of food per day",
       title ="Fig 1: Boxplot of average pounds of food per day by household type")+
  scale_fill_discrete(name="Household Type",
                      breaks=c("0", "1"),
                      labels=c("Single", "Family"))+
  scale_x_discrete(labels=c("Single","Family"))
ggsave("Project1_Fig1_Box.png", height=5, width=7)


####################FIG 2######################
#Boxplot of total number of visits in last 10 years per household, comparing single-member households vs. family households
#More (and more extreme) outliers for single households, wider spread, than family households
test1 %>% 
  ggplot(aes(x=family, y= no_dates, fill=family))+
  geom_boxplot(aes(fill=family))+
  theme_bw() + theme(panel.border = element_blank())+
  labs(x="Household Type",
       y="Total number of visits per household",
       title ="Fig 1: Boxplot of total visits by household type")+
  scale_fill_discrete(name="Household Type",
                      breaks=c("0", "1"),
                      labels=c("Single", "Family"))+
  scale_x_discrete(labels=c("Single","Family"))
ggsave("Project1_Fig2_Box.png", height=5, width=5)


####################FIG 3a######################
#Histogram comparison of total number of visits between families vs single people.
#More visits from single households, as well as greater spread.
#For both types, largest count is LOW-count visits like 1-3 etc
test1 %>% ggplot(aes(x=no_dates, group=family))+
  geom_bar(position="dodge",aes(fill=family)) + theme_bw()


####################FIG 3b######################
test1 %>%
  filter(no_dates <=10) %>% #removing extreme outliers for no_dates (mostly for single household)
  ggplot(aes(x=no_dates, group=family)) +
  geom_bar(position="dodge",aes(fill=family))+
  theme_bw() + theme(panel.border = element_blank())+
  labs(x="Number of Visits",
       y="Total Households",
       title ="Fig 3: Distribution of number of visits (up to 10) by household type",
       fill="Household Type")+
  scale_fill_discrete(name="Household",
                      breaks=c("0", "1"),
                      labels=c("Single", "Family"))
#define family as more than 1 person, as assumed by "provided.food.for"
ggsave("Project1_Fig3_Bar.png", height=4, width=7)
#More family single visits, more long-term visits from single households
#Could be due to family households try harder to escape homelessness for their kids?

######################################################3
