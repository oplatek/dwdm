#!/bin/bash 
#java weka.filters.unsupervised.attribute.StringToWordVector -i android-platform-bugs.arff -o android-plat-bugs-Vectors.arff
java weka.filters.unsupervised.attribute.StringToWordVector -i $1 -o $2 
