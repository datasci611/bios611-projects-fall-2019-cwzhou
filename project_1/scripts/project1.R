#project 1

#load dataset
urban <- read.delim("~/Desktop/611 Notes/bios611-projects-fall-2019-cwzhou/project_1/data/UMD_Services_Provided_20190719.tsv", header=T)
#View(urban)
df=urban
df$Date <- as.Date(df$Date, "%m/%d/%Y")
df1 <- filter(df, df$Date <= Sys.Date())
View(df1)
df2 = arrange(df1, Date, Client.File.Number, Client.File.Merge,) %>% 
  select(Date, Client.File.Number, Client.File.Merge,Food.Provided.for, Food.Pounds, Clothing.Items, Diapers, School.Kits,Hygiene.Kits)
View(df2)
