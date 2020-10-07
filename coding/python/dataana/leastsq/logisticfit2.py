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

# raw data
filename = "stationxs12.txt"
data = np.loadtxt(filename)
print data
print len(data)

x = data[:, 1]
print x

n, bins, patches = plt.hist(x, 60, cumulative=True, normed=True)
print n     # y
print len(n)     # y
print bins  # x
print len(bins)  # x
bincenters = 0.5*(bins[1:]+bins[:-1])
print bincenters
print len(bincenters)

print patches


p_guess=(np.median(bincenters),0.02)
p, cov, infodict, mesg, ier = scipy.optimize.leastsq(
    residuals,p_guess,args=(bincenters,n),full_output=1)  

x0,k=p
print x0, k

plog = sigmoid(p, bincenters)
plt.plot(bincenters, plog, '-')

plt.show()
