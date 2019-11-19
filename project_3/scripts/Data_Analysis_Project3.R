#install.packages('reticulate', repo="http://cran.us.r-project.org")
rmarkdown::render("~/Desktop/611 Notes/bios611-projects-fall-2019-cwzhou/project_3/scripts/bios611_project3.Rmd", "html_document")

library(ggplot2)
library(tidyverse)

setwd("~/Desktop/611 Notes/bios611-projects-fall-2019-cwzhou/project_3/data")
dat = read.csv("export_dataframe.csv", header = TRUE)

dat_noID = dat[,-c(1,2,3,4)]
summary(dat_noID)

dat %>%
  ggplot(aes(x=Client.Primary.Race)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

dat %>%
  ggplot(aes(x=Client.Gender)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

dat %>%
  ggplot(aes(x=Client.Ethnicity)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

dat$Client.Gender <- as.factor(dat$Client.Gender)
ggplot(dat, aes(x = dat$Client.Age.at.Entry)) + geom_histogram() + facet_wrap(~Client.Gender)

mod1 = lm(formula = Total.Nights ~ Client.Gender + Client.Age.at.Entry + Client.Ethnicity + Client.Primary.Race, data = dat)
summary(mod1)