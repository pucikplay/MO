#!/bin/sh
for i in $(seq 1 $1)
do
    echo data\;param N := $i\;end\; > data.dat
    glpsol -m model.mod -d data.dat
done