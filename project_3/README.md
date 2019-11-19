---
title: "Project 3 README"
author: "Christina Zhou"
date: "11/14/2019"
output: html_document
---
The purpose of project 3 is to use different data science toolkits to examine collected real life data. This data is from the shelter side of Urban Ministries of Durham (UMD), an organization that focuses on lowering the community's rate of homelessness by providing food, shelter and other resources. More information can be found at http://www.umdurham.org/. Our goal is to use Makefile to organize the analysis in a way that allows future repetition easily accessible, Docker to make it easy for different machines to run the same analysis with the same necessary packages, Python to wrangle the data, and R to run analysis.

Our question of interest is how does length of stay at the UMD shelter (determined by the total nights spent at UMD) relate to client demographics (such as entry age, race, gender, ethnicity)? 

There is a lot of potential data for this project. A list of all possible datasets can be found here: https://github.com/biodatascience/datasci611/tree/gh-pages/data/project2_2019. For this project, we focus on the following datasets: CLIENT_191102.tsv and ENTRY_EXIT_191102.tsv.

The project 3 repo is as follows: The specific datasets of interest can be found in the data subfolder. Data from after wrangling can also be found here (marked as export_dataframe.csv). In the scripts subfolder, one can find the Python wrangling file, R analysis code files, Makefile, Docker file, and R Markdown file, along with the html R markdown output. The corresponding results are saved in the results folder.



Draft due date: need to fix Makefile for final project.