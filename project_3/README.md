# Project 3 README
## Christina Zhou
## 12/1/2019

### Purpose and Background

The purpose of project 3 is to use different data science toolkits to examine collected real life data. This data is from the shelter side of Urban Ministries of Durham (UMD), an organization that focuses on lowering the community's rate of homelessness by providing food, shelter and other resources. More information can be found at http://www.umdurham.org/. Our goal is to use Makefile to organize the analysis in a way that allows future repetition easily accessible (ultimately, making a HTML version of the Rmd file), Docker to make it easy for different machines to run the same analysis with the same necessary packages, Python to wrangle the data, and Rmd to plot figures and run analysis.

### Aim

Our question of interest is how does length of stay at the UMD shelter (determined by the total nights spent at UMD) relate to client demographics (such as entry age, race, gender, ethnicity)? 

### Data source

There is a lot of potential data for this project. A list of all possible datasets can be found here: https://github.com/biodatascience/datasci611/tree/gh-pages/data/project2_2019. For this project, we focus on the following datasets: CLIENT_191102.tsv and ENTRY_EXIT_191102.tsv. After our data wrangling in python, our merged dataset is located in the data folder as export_dataframe.csv.

### Project Repo
The project 3 repo is as follows: The two specific datasets of interest can be found in the data subfolder. Data from after wrangling can also be found here (the data after removing missing data known as export_dataframe.csv and the final dataset for analysis marked as final_dataframe.csv). In the scripts subfolder, one can find the Python wrangling file (both .ipynb and .py - note: these contain the same wrangling), Makefile, Docker file, R Markdown file, and HTML output of R Markdown for checking. In the results folder (currently empty), one will find the R Markdown HTML output after running the make command (see the section below for more details).

### HOW TO CREATE FINAL HTML OUTPUT

To create the the R markdown HTML output (which will be located in the currently empty results folder), log into the UNC Virtual Computing Lab at vcl.unc.edu using ssh and clone the following github repository: https://github.com/datasci611/bios611-projects-fall-2019-cwzhou.git

Then set the working directory to bios611-projects-fall-2019-cwzhou/project_3/scripts/. Type "make" into the command line. The R markdown HTML report output will be saved to the results folder (bios611-projects-fall-2019-cwzhou/project_3/results). To view this report, scp the file to your local machine.