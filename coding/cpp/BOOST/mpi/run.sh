#!/bin/bash

mpic++ commu.cc -lboost_mpi

mpirun -np 4 a.out
