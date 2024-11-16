import sys
import random

# Check we have enough arguments
if len(sys.argv) < 3:
	print("Must specify at least two command line arguments")
	# exit the script
	sys.exit()

# How many lines do we want to sample?
try:
	n = int(sys.argv[2])
except ValueError as e:
	print("Invalid sample size specified: %s" % e )
	sys.exit()

# Now read the file
try:
	fin = open(sys.argv[1],"r")
	lines = []
	for line in fin.readlines():
		lines.append(line.strip())
	fin.close()
except IOError as e:
	print("Unable to read from file: %s" % e )
	sys.exit()

# Is the required sample size too high?
if len(lines) < n:
	print("Sample size greater is than number of lines in the file: %d > %d" % (n, len(lines)) )
	sys.exit()

# Randomly select the lines
sample = random.sample(lines, n)
for line in sample:
	print(line)