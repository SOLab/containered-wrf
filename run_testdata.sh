#!/bin/bash
set -e
cd ~/WPS
./link_grib.csh /home/wrf/data/*
./geogrid.exe
./ungrib.exe
./metgrid.exe
cd ~/WRFV3/run/
ln -s ../../WPS/met_em.* .
./real.exe
./wrf.exe
mv ~/WRFV3/run/wrfout_* ~/out
