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

def sigmoid2(p,x):
    x0,k=p
    y = k * np.exp(-k*(x-x0)) / (1 + np.exp(-k*(x-x0)))**2
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
    #fig = plt.figure()
    plt.title(title)
    #print np.sum(n)
    plt.subplot(2,1,1)
    #fig.add_subplot(212)
    #return
    n, bins, patches = plt.hist(x, 22, cumulative=True, normed=True,
            histtype='bar', color='crimson')
    print np.sum(n)
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

    bincenters = np.arange(bins[0], bins[-1], 10)
    plog = sigmoid(p, bincenters)
    #plt.plot(bincenters,n, '+', bincenters, plog, '-*')
    plt.plot(bincenters, plog, '-')

    #plt.show()
    # ======
    #fig.add_subplot(211)
    plt.subplot(2,1,2)
    n, bins, patches = plt.hist(x, 22, normed=True, stacked=True)
    plog = sigmoid2(p, bincenters)
    plt.plot(bincenters, plog, '-')

    #plt.show()
    plt.savefig(outputfile)

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description='Logistic fit.')
    parser.add_argument("--file", default="stationxs12.txt", help="file name")
    parser.add_argument("--col", default=1, type=int, help='column')
    args = parser.parse_args()
    filename = args.file
    col = args.col
    print filename, col
    data = np.loadtxt(filename)
    x = data[:, col]
    title = "%s: %d" %(filename, col)
    outputfile = "%s-%d.png"%(filename, col)
    magic_main(x, title, outputfile)

