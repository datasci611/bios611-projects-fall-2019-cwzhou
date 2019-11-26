.PHONY: project3
project3: 
	docker image build -t project3 .
	python Wrangling_Project3.py
	Rscript -e "library(rmarkdown); rmarkdown::render('bios611_project3.Rmd', 'html_document')"
