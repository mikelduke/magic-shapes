#!/bin/bash

./bin/clean.sh

echo "Making .love dist"

mkdir -p dist
mkdir -p temp

cp -rf *.* temp/
mkdir temp/assets
cp -rf assets/ temp/assets

zip -9 -r dist/magic-shapes.love ./temp
rm -rf temp

echo 'done'
