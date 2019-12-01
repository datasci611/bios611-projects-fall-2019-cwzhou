.PHONY: project3

project3:
	docker build -t project3 .
	python Wrangling_Project3.py
	Rscript -e "library(rmarkdown); rmarkdown::render('../results/bios611_project3.Rmd', 'html_document')" 
