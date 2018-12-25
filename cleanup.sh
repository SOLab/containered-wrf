#!/bin/bash
HOME=/home/wrf
set -e
cd ${HOME}/WPS
rm -f geo_em.*
rm -f FILE*
rm -f GRIBFILE.*
rm -f met_em.*
cd ${HOME}/WRFV3/run
rm -f met_em.*
rm -f wrfbdy_*
rm -f wrfinput_*
