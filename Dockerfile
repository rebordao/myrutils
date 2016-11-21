FROM r-base

## Set up locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

## Install R dependencies
RUN Rscript -e "install.packages(c('testthat'))"

## Create user myrutils
ENV HOME /home/user
RUN useradd --create-home --home-dir $HOME user \
    && chown -R user:user $HOME

COPY . $HOME/myrutils
WORKDIR $HOME/myrutils

## Check if myrutils is buildable
RUN R CMD build .
RUN R CMD check --no-manual --no-build-vignettes myrutils_0.0.0.9000.tar.gz

## Install package
RUN R CMD INSTALL -l /usr/local/lib/R/site-library/ myrutils_0.0.0.9000.tar.gz

CMD ["R"]
