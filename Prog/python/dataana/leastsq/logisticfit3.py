#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: lintao


import numpy as np
import matplotlib.pyplot as plt
import scipy.optimize

def sigmoid(p,x):
    x0,k=p
    y = 1 / (1 + np.exp(-k*(x-x0)))
    return y

def residuals(p,x,y):
    return y - sigmoid(p,x)

def resize(arr,lower=0.0,upper=1.0):
    arr=arr.copy()
    if lower>upper: lower,upper=upper,lower
    arr -= arr.min()
    arr *= (upper-lower)/arr.max()
    arr += lower
    return arr

def magic_main(x, title, outputfile):
    n, bins, patches = plt.hist(x, 60, cumulative=True, normed=True,
            histtype='step')
    #print n     # y
    #print len(n)     # y
    #print bins  # x
    #print len(bins)  # x
    bincenters = 0.5*(bins[1:]+bins[:-1])
    #print bincenters
    #print len(bincenters)

    #print patches


    p_guess=(np.median(bincenters),0.02)
    p, cov, infodict, mesg, ier = scipy.optimize.leastsq(
        residuals,p_guess,args=(bincenters,n),full_output=1)  

    x0,k=p
    print x0, k

    plog = sigmoid(p, bincenters)
    #plt.plot(bincenters,n, '+', bincenters, plog, '-*')
    plt.plot(bincenters, plog, '-*')

    #plt.show()
    plt.title(title)
    plt.savefig(outputfile)

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description='Logistic fit.')
    parser.add_argument("--file", default="stationxs12.txt", help="file name")
    parser.add_argument("--col", default=1, type=int, help='column')
    args = parser.parse_args()
    filename = args.file
    col = args.col
    data = np.loadtxt(filename)
    x = data[:, col]
    title = "%s: %d" %(filename, col)
    outputfile = "%s-%d.png"%(filename, col)
    magic_main(x, title, outputfile)

