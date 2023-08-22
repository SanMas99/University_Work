
import numpy as np
from skimage.io import imread, imsave, imshow
from skimage.transform import resize
from matplotlib import pyplot as plt
import skimage.exposure

photo=skimage.io.imread('test.jpg', as_gray=True)
pixelList=np.zeros((256),np.uint64)

dimensions = photo.shape
height = photo.shape[0]#Gets the number of rows in image
width = photo.shape[1]#Gets number of columns in image
for i in range(height):#Loops through all pixels
  for j in range (width):
    binIndex=(round(photo[i,j]*256))
    pixelList[binIndex]+=1

plt.plot(pixelList)#Plots the histogram created from my data
plt.title("My Histogram")
plt.show()

histogram2,bin_edges = np.histogram(photo, 256,range=[0,1])#Using numpy, we get the histogram data, we also store the bin_edges to not cause a 2-d array
plt.plot(histogram2)
plt.title("Numpy Histogram")
plt.show()

hist3,bins=skimage.exposure.histogram(photo, nbins=256,source_range='image')
plt.plot(hist3)
plt.title("Skimage Histogram")
plt.show()



