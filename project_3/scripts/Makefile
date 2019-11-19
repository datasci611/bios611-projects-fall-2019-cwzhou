.PHONY: project3
projec3: Dockerfile
	docker build -t mf2g -f Dockerfile . && touch $@
	python Wrangling_Project3.ipynb
	Rscript Data_Analysis_Project3.R
