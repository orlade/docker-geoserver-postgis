#!/bin/bash

python $GEOSERVER_HOME/docker/setup.py \
    && echo "Starting GeoServer..." \
    && $GEOSERVER_HOME/bin/startup.sh
