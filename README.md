# rdccosmo/containered-wrf

This project aims to dockerize the [WRF (Weather Research and Forecast Model)](http://www.wrf-model.org/index.php).
It follows the instructions from this [tutorial](http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php).

WRF has version 3.9.1.1, build with OpenMP support (shared memory)
Setting are set up for using GFS input files and ARW dynamics

To build:
docker build -t wrf3.9.1.1:0 .

To run:
docker run -v YOUR_GFS_FILES_DIR:/home/wrf/data -v YOUR_GEOG_DIR:/home/wrf/geog -v YOUR_OUT_DIR:/home/wrf/out -it wrf3.9.1.1:0 bash
