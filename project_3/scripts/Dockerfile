FROM rocker/verse:3.5.1
RUN R -e "install.packages('kableExtra', repos = 'http://cran.us.r-project.org')"

FROM continuumio/anaconda3
RUN conda install -c conda-forge statsmodels
