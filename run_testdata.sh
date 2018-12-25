#!/bin/bash
HOME=/home/wrf
set -e
cd ${HOME}/WPS
./link_grib.csh /home/wrf/data/*
./geogrid.exe
./ungrib.exe
./metgrid.exe
cd ${HOME}/WRFV3/run
ln -s ../../WPS/met_em.* .
./real.exe
./wrf.exe
mv ${HOME}/WRFV3/run/wrfout_* ${OUTDIR}
