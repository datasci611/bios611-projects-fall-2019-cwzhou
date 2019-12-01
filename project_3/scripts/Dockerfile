FROM rocker/verse:3.5.1
RUN Rscript -e "install.packages('kableExtra')"
RUN Rscript -e "install.packages('ggplot2')"
RUN Rscript -e "install.packages('dplyr')"
RUN Rscript -e "install.packages('knitr')"

FROM continuumio/anaconda3
RUN conda install -c conda-forge statsmodels
RUN pip install pandas==0.25.0 --user
RUN pip install datetime --user
RUN pip install numpy --user
RUN pip install DataFrame --user
