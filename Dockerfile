FROM r-base

## Set up locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


## Create an user
ENV HOME /home/myrutils
RUN useradd --create-home --home-dir $HOME myrutils \
    && chown -R myrutils:myrutils $HOME

WORKDIR myrutils

## Check if myrutils is buildable
RUN R CMD build --no-manual --no-build-vignettes
