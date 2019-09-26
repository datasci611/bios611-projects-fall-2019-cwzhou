---
title: "Project 1 README"
author: "Christina Zhou"
date: "9/25/2019"
output: html_document
---
This data is from Urban Ministries of Durham (UMD), which focuses on lowering the community's rate of homelessness by providing food, shelter and other resources. Their website is here: http://www.umdurham.org/.

The data includes variables such as number of people in the family for which food was provided, money provided to clients and more. A full list of variables can be found here: https://github.com/biodatascience/datasci611/blob/gh-pages/data/project1_2019/UMD_Services_Provided_metadata_20190719.tsv.

In my analysis, I focused on comparison trends between families and single individuals. For example, do individuals with larger families (defined based onfood provided for) tend to visit to UM more often? Do families take more food than individuals without families? This information would be likely useful for UM to analyze who is more likely to make more effort to come find them and how long often they might visit. Thus, variables of interest include date, Client file number, food provided for, pounds of food, and self-created variables such as year, number of visits, and family indicator.

The data can be found in the data folder of the project1 folder. In the file project1.R in the scripts folder, one can find the entire analysis R script. Project1.Rmd contains the R markdown file. The output of this file is Project1.html. Figures from the output are also in the results folder.

