#Dockerfile created by Carlos E. González C. at bloomcker
#Data Science environment
FROM ubuntu:18.04

#Metadata
LABEL maintainer="Carlos E. Gonzalez C. carlos@bloomcker.io"
LABEL build_date="08/30/2019"

#Updating Ubuntu
RUN apt-get update \
  && yes|apt-get upgrade

#Installing basics
RUN apt-get install -y wget bzip2 nano

#Setting-up root and dev users
Run apt-get -y install sudo
RUN adduser --disabled-password --gecos '' dev
RUN adduser dev sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER dev
WORKDIR /home/dev/
RUN chmod a+rwx /home/dev/

#Installing Anaconda
RUN wget https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh
RUN sh Anaconda3-2019.07-Linux-x86_64.sh -b
RUN rm Anaconda3-2019.07-Linux-x86_64.sh
ENV PATH /home/dev/anaconda3/bin:$PATH
RUN conda update conda
RUN conda update anaconda
RUN conda update --all

#Installing opencv
RUN sudo apt install -y libsm6 libxext6 libxrender-dev
RUN pip install opencv-python

#Installing TensorFlow
RUN pip install tensorflow==2.0.0-rc0

#Installing JupyterLab
RUN conda install -c anaconda jupyter \
  && conda install -c conda-forge jupyterlab
RUN jupyter notebook --generate-config --allow-root
RUN echo "c.NotebookApp.password = u'sha1:7570f868dbce:80cd18013d7007bf120e2f0fd168b16743bb998e'" >> /home/dev/.jupyter/jupyter_notebook_config.py
RUN mkdir /home/dev/notebooks
#ENTRYPOINT ["python3"]

#Installing R and R packages
RUN sudo apt -y update
RUN sudo DEBIAN_FRONTEND=noninteractive apt install -y tzdata
RUN sudo apt -y install gnupg gnupg1 gnupg2
RUN sudo apt-get install -y software-properties-common
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'
RUN sudo apt -y update && sudo apt -y install r-base
#RUN sudo apt install -y r-base
RUN sudo chmod 777 /usr/local/lib/R/site-library
RUN R -e "install.packages(c('simmer'),dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN sudo apt-get update && sudo apt-get install -y \
    libxml2-dev
#RUN R -e "install.packages(c('curl', 'gh','usethis', 'httr','devtools', 'packrat'))"
#RUN sudo apt-get -y build-dep libcurl4-gnutls-dev
#RUN sudo apt-get -y install libcurl4-gnutls-dev
RUN sudo apt-get update && \
  sudo apt-get install -y libcurl4-openssl-dev libssl-dev libssh2-1-dev libxml2-dev && \
  R -e "install.packages(c('devtools', 'testthat', 'roxygen2'))"
RUN Rscript -e "install.packages(c(\"devtools\", \"testthat\", \"roxygen2\"), repos = c(\"http://irkernel.github.io/\", \"http://cran.rstudio.com\"))"
RUN sudo apt -y install git
RUN R -e "devtools::install_github('IRkernel/IRkernel')"
RUN R -e "IRkernel::installspec()"
#RUN installGithub.r IRkernel/IRkernel
#RUN R -e "install.packages(c('devtools'),dependencies=TRUE,repos='http://cran.rstudio.com/')"
#RUN R -e "devtools::install_github(IRkernel/IRkernel)"
#RUN R -e "IRkernel::installspec(user=FALSE)"
#RUN conda install -c r r-irkernel
#RUN conda config --add channels r
#RUN conda install readline=6
#RUN R -e "install.packages(/'simmer/',dependencies=TRUE, repos='http://cran.rstudio.com/')"
#RUN Rscript -e "install.packages('simmer')"
#RUN R -e "install.packages('simmer.plot',dependencies=TRUE, repos='http://cran.rstudio.com/')"
#RUN R -e "install.packages('simmer.bricks',dependencies=TRUE, repos='http://cran.rstudio.com/')"
#ENTRYPOINT ["python"]
CMD ["jupyter", "lab", "--allow-root", "--notebook-dir=/home/dev/notebooks", "--ip='*'", "--port=8888", "--no-browser"]


