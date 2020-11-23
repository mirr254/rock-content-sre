#!/bin/bash
set -ex

mkdir -p plugins
for download_url in $(cat plugins.txt)
do
    curl -Ls $download_url -o plugin.zip
    unzip -oq plugin.zip -d plugins/
    rm -f plugin.zip
done
