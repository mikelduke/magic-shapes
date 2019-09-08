#!/bin/bash

./bin/clean.sh

./bin/assemble.sh

echo "Making .love dist"

cd temp
zip -9 -r magicshapes.love .
cp magicshapes.love ../dist

echo 'done'
