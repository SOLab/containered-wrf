FROM ubuntu:16.04
MAINTAINER Ekaterina Balashova <nerpa87@yandex.ru>

ENV DEBIAN_FRONTEND noninteractive
RUN \
    apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:ubuntugis/ppa \
    && apt-get update \
    && apt-get install -y --allow-unauthenticated \
        gfortran \
        gfortran-5-multilib \
        csh \
        build-essential \
        libcloog-ppl1 \
        m4 \
        wget \
        ncl-ncarg \
        libgrib2c-dev \
        libjpeg-dev \
        libudunits2-dev \
        python \
        python-pip \
        python-tk \
        python-matplotlib \
        python-matplotlib-data \
        python-imaging \
        python-numpy \
        python-scipy \
        python-systemd \
        libsystemd-dev \
        curl \
        imagemagick \
        libjpeg-dev \
        libopenjpeg-dev \
        libopenjpeg5 \
        libg2-dev \
        libg20 \
        libjasper-dev \
        libjasper1 \
        libx11-6 \
        libxaw7 \
        libmagickwand-dev \
        git \
        vim \
        autotools-dev \
        autoconf \
        libproj9 \
		libproj-dev \
        proj-bin \
        python-gdal \
        libgdal-dev \
        gdal-bin \
    && rm -rf /var/lib/apt/lists/*

ENV PREFIX /home/wrf
WORKDIR /home/wrf
ENV DEBIAN_FRONTEND noninteractive
ENV CC gcc
ENV CPP /lib/cpp -P
ENV CXX g++
ENV FC gfortran
ENV FCFLAGS -m64
ENV F77 gfortran
ENV FFLAGS -m64
ENV NETCDF $PREFIX
ENV NETCDFPATH $PREFIX
ENV WRF_CONFIGURE_OPTION 33 #GNU shared memory/openmp
ENV WRF_EM_CORE 1
ENV WRF_NMM_CORE 0
ENV LD_LIBRARY_PATH_WRF $PREFIX/lib/
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH_WRF
ENV NCARG_ROOT=$PREFIX
ENV JASPERLIB=$PREFIX/lib
ENV JASPERINC=$PREFIX/include
ENV GRADS=$PREFIX/grads-2.0.2.oga.2/Contents
ENV GRADDIR=$GRADS/Resources/SupportData
ENV GASCRP=$GRADS/Resources/Scripts
ENV ARW_CONFIGURE_OPTION 3
ENV PYTHONPATH $PREFIX/lib/python2.7/site-packages
ENV PATH $PATH:$PREFIX/bin:$NCARG_ROOT/bin:$GRADS:$GRADS/gribmap:$PREFIX/cnvgrib-1.4.1:$PREFIX/WPS:$PREFIX/WRFV3/test/em_real:$PREFIX/WRFV3/main:$PREFIX/WRFV3/run:$PREFIX/WPS:$PREFIX/ARWpost:$PREFIX
RUN mkdir -p /home/wrf && \
    mkdir -p $PYTHONPATH && \
    useradd wrf -d /home/wrf && \
    chown -R wrf:wrf /home/wrf
RUN ulimit -s unlimited
COPY requirements.yml $PREFIX
RUN pip install --upgrade pip pip
RUN pip install --upgrade pip setuptools
RUN pip install -r requirements.yml --ignore-installed 
COPY build.sh $PREFIX
USER wrf
RUN ./build.sh install_all_deps
RUN mkdir -p /home/wrf/data
RUN ./build.sh install_wrf
RUN ./build.sh install_wps
RUN mv $PREFIX/WPS/namelist.wps $PREFIX/WPS/namelist.orig
COPY --chown=wrf config_samples/namelist.wps $PREFIX/WPS/
RUN mv $PREFIX/WRFV3/run/namelist.input $PREFIX/WRFV3/run/namelist.input.orig
COPY --chown=wrf config_samples/namelist.input $PREFIX/WRFV3/run/
WORKDIR /home/wrf/WPS
# for gfs input files
RUN ln -s ./ungrib/Variable_Tables/Vtable.GFS Vtable
WORKDIR /home/wrf
# script for running container with test data
COPY --chown=wrf run_testdata.sh .
COPY --chown=wrf cleanup.sh .
ENV OMP_NUM_THREADS=32
ENV OMP_STACKSIZE=128M
ENV TZ=Europe/Moscow
RUN echo "alias ll='ls -l'" >> ~/.bashrc
CMD ["bash"]
VOLUME /home/wrf/data
VOLUME /home/wrf/geog
USER root
RUN groupadd -g 1111 wrfusers
RUN usermod wrf -g wrfusers
USER wrf
RUN mkdir -p /home/wrf/out
RUN chown wrf:wrfusers /home/wrf/out
VOLUME /home/wrf/out
ENV OUTDIR=/home/wrf/out
USER wrf
