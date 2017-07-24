#!/usr/bin/env sh
# This script downloads the hed model

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR

echo "Downloading..."


http://172.23.168.6:7000/vision/trained_nets/hed/hed.weights


URL="http://172.23.168.6:7000"
wget $URL"/vision/trained_nets/yolo/yolo.weights"
wget $URL"/vision/trained_nets/yolo/yolo.net"

echo "Done."
