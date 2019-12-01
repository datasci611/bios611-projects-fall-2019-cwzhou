FROM rocker/verse:latest
RUN Rscript -e "install.packages('ggplot2')"

FROM continuumio/anaconda3
RUN conda install -c conda-forge statsmodels
RUN pip install datetime --user
RUN pip install DataFrame --user
