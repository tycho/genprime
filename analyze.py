#!/usr/bin/python

from matplotlib.ticker import NullLocator, MultipleLocator, LogLocator, FormatStrFormatter
from scipy import polyval, polyfit, optimize, stats
from numpy import log10, sqrt, average, median, std
import pylab
import fileinput
import re

powerlaw = lambda x, amp, index: amp * (x ** index)

def PwrReg(xvals, yvals):
	logx = log10(xvals)
	logy = log10(yvals)

	fitfunc = lambda p, x: p[0] + p[1] * x
	errfunc = lambda p, x, y, err: (y - fitfunc(p, x)) / err

	pinit = [1.0, -1.0]
	out = optimize.leastsq(errfunc, pinit,
		args=(logx, logy, 1.0), full_output=1)

	pfinal = out[0]
	covar = out[1]

	index = pfinal[1]
	amp = 10**pfinal[0]

	return (amp, index)
	
def OneVarStats(vals):
	min = vals[0]
	max = vals[-1]
	mean = average(vals)
	med = median(vals)
	variance = 0
	for i in vals:
		variance += (i - mean) ** 2
	variance /= (len(vals) - 1)
	deviation = sqrt(variance)
	tval = stats.t.ppf(0.975, len(vals) - 1)
	sem = (deviation / sqrt(1)) * tval
	error = ((sem / mean) * 100)
	return {'min':min, 'max':max, 'mean':mean, 'median':med, 'variance':variance, 'stddev':deviation, 't':tval, 'sem':sem, 'error':error}

class Processor():
	def __init__(self):
		self.a = 0
		self.b = 0
		self.mhz = 0
		self.name = ""
	def plot(self,ax,primes):
		ax.plot(primes, map(self.timeForPrimes, primes), '--')
	def ppsForPrimes(self, primes):
		return primes / self.timeForPrimes(primes)
	def timeForPrimes(self, primes):
		return powerlaw(primes, 10**self.a, self.b)
	def equivalentToMhz(self, primes, time):
		selfpps = primes / self.timeForPrimes(primes)
		otherpps = primes / time
		#print (selfpps, otherpps)
		return otherpps / selfpps * self.mhz

class TestRun():
	def __init__(self):
		self.primes = list()
		self.time = list()
	def spit_col(self, ax):
		ax.plot(self.primes,self.time,'o-')
		(a, b) = PwrReg(self.primes, self.time)
		print "A and B =", (log10(a), b)
		plaw = lambda p: powerlaw(p, a, b)
		#ax.plot(self.primes, powerlaw(self.primes, a, b), '-')

procs = list()
runs = list()
run = None

proc = Processor()
proc.name = "Intel Core i7 (Arrandale)"
proc.mhz = 2660
proc.a = -7.8824473644561923
proc.b = 1.3694918109561547
procs.append(proc)

proc = Processor()
proc.name = "Intel Core i7 (Arrandale) (Without Cache)"
proc.mhz = 2660
proc.a = -8.3220702315715069
proc.b = 1.5191803139899496
procs.append(proc)

proc = Processor()
proc.name = "Intel Core 2 Duo (Penryn)"
proc.mhz = 2922
proc.a = -7.8711678067794812
proc.b = 1.3625158951193272
procs.append(proc)

proc = Processor()
proc.name = "Intel Core 2 Duo (Penryn) (Without Cache)"
proc.mhz = 2922
proc.a = -8.2406610113134509
proc.b = 1.501553090325551
procs.append(proc)

proc = Processor()
proc.name = "Intel Core Duo (Yonah)"
proc.mhz = 1662
proc.a = -7.0088271233575892
proc.b = 1.3527178411076743
procs.append(proc)

for line in fileinput.input():
	re_x = re.compile(r'^\[C\] Found[ ]+([0-9]+) primes in[ ]+([0-9]+[.][0-9]+)')
	l = re_x.match(line)
	if (l):
		g = l.groups()
		if not run or (run.primes and run.primes[-1] > int(g[0])):
			run = TestRun()
			runs.append(run)
		if (float(g[1]) < 0.001):
			continue
		run.primes.append(float(g[0]))
		run.time.append(float(g[1]))

ax = pylab.subplot(111)
#pylab.yscale('log')
#pylab.xscale('log')
for proc in procs:
	proc.plot(ax, runs[0].primes)

for i in runs:
	for proc in procs:
		mhzlist = list()
		for (p, t) in zip(i.primes, i.time):
			mhz = proc.equivalentToMhz(p, t)
			mhzlist.append(mhz)
		mhzlist.sort()
		stat = OneVarStats(mhzlist)
		#print mhzlist
		#print stat
		print "average time equivalent to %1.2f MHz (+/- %1.3f%%) %s" % (stat['mean'], stat['error'], proc.name)
	print ""

for i in runs:
	i.spit_col(ax)

pylab.show()
