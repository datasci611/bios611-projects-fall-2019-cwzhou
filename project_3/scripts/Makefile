build-image: Dockerfile
	docker build -t mf2g -f Dockerfile . && touch $@
export_dataframe.csv:
	docker run -d --rm -v "$(pwd):$(pwd)" -w "$(pwd)" jupyter/datascience-notebook && touch $@
	python Wrangling_Project3.py $@
