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
RUN echo "c.NotebookApp.password = u'sha1:442f120757ec:7d936ce2841c7b8976f41e041babe726f1490343'" >> /home/dev/.jupyter/jupyter_notebook_config.py
RUN mkdir /home/dev/notebooks

#Installing R and R packages
RUN sudo apt -y update
RUN sudo DEBIAN_FRONTEND=noninteractive apt install -y tzdata
RUN sudo apt -y install gnupg gnupg1 gnupg2
RUN sudo apt-get install -y software-properties-common
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'
RUN sudo apt -y update && sudo apt -y install r-base
RUN sudo chmod 777 /usr/local/lib/R/site-library
RUN R -e "install.packages(c('simmer'),dependencies=TRUE,repos='http://cran.rstudio.com/')"
RUN sudo apt-get update && sudo apt-get install -y \
    libxml2-dev
RUN sudo apt-get update && \
  sudo apt-get install -y libcurl4-openssl-dev libssl-dev libssh2-1-dev libxml2-dev && \
  R -e "install.packages(c('devtools', 'testthat', 'roxygen2'))"
RUN Rscript -e "install.packages(c(\"devtools\", \"testthat\", \"roxygen2\"), repos = c(\"http://irkernel.github.io/\", \"http://cran.rstudio.com\"))"
RUN sudo apt -y install git
RUN R -e "devtools::install_github('IRkernel/IRkernel')"
RUN R -e "IRkernel::installspec()"

CMD ["jupyter", "lab", "--allow-root", "--notebook-dir=/home/dev/notebooks", "--ip='*'", "--port=8888", "--no-browser"]


