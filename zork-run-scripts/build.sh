#!/bin/sh
set -eu

make -C confusion_patched \
    CC=gcc \
    CXX=g++ \
    mdli

make -C dungeon_3_2b FC=gfortran
