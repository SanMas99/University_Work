import numpy as np
from skimage.io import imread, imsave, imshow
from skimage.transform import resize
from matplotlib import pyplot as plt
import skimage.exposure
from math import sqrt
#Sanad Masannat
#1626221
#CMPUT 206 Winter 2021
def part1_histogram_compute():
    photo=skimage.io.imread('test.jpg', as_gray=True)#Reads in image
    photo=(photo*255).astype(np.uint8)#Converts the photo from a float to integer
    pixelList=np.zeros((256),np.uint32)#Initalizes a numpy array


    height = photo.shape[0]#Gets the number of rows in image
    width = photo.shape[1]#Gets number of columns in image
    for i in range(height):#Loops through all pixels
      for j in range (width):
        binIndex=(photo[i,j])
        pixelList[binIndex]+=1#Increments the count of that specific pixel found from image

    plt.plot(pixelList)#Plots the histogram created from my data
    plt.title("My Histogram")
    plt.show()

    histogram2,bin_edges = np.histogram(photo, 256,range=[0,256])#Using numpy, we get the histogram data, we also store the bin_edges to not cause a 2-d array
    plt.plot(histogram2)
    plt.title("Numpy Histogram")
    plt.show()

    hist3,bins=skimage.exposure.histogram(photo, nbins=256,source_range="dtype")#Using skimage, we compute the histogram data and plot it below
    plt.plot(hist3)
    plt.title("Skimage Histogram")
    plt.show()


def part2_histogram_equalization():

    photo=skimage.io.imread('test.jpg', as_gray=True)#Reads in image as grayscale
    photo=(photo*255).astype(np.uint8)
    pixelList=np.zeros((256),np.uint32)#Initializes numpy array to calculate histogram


    height = photo.shape[0]#Gets the number of rows in image
    width = photo.shape[1]#Gets number of columns in image
    for i in range(height):#Loops through all pixels
      for j in range (width):
        binIndex=(photo[i,j])
        pixelList[binIndex]+=1

    plt.plot(pixelList)#Plots the histogram created from my data
    plt.title("My Histogram")
    plt.show()
    imshow(photo)

    cumulativeFreq=np.zeros((256),np.float32)#Initalizes a cumulative histogram frequency

    for i in range(0,len(pixelList)):
      for j in range(0,i):
        cumulativeFreq[i]+=pixelList[j]#Calculates cumulative freq
      cumulativeFreq[i]/=(float(height*width))#Converts cumulative freq into a probabilty value between 0-1 by dividing it by the number of pixels


    for i in range(0,len(cumulativeFreq)):
      cumulativeFreq[i]*=255#Multiplies by the number of gray levels
      cumulativeFreq[i]=int(cumulativeFreq[i])#Creates a map from original image to new equalized histogram

    newPic=np.zeros((height,width),np.uint8)#Initializes new image

    for i in range(height):
      for j in range(width):
        binIndex=(photo[i,j])#Gets pixel value from original image
        newPic[i,j]=cumulativeFreq[binIndex]#An looks for that value in cumulative frequency table at the map(cumulativeFreq array)
    #Below lines initalize a new empty array and will calculate the new histogram of equalized image and plots it while showing the new image
    pixelList2=np.zeros((256),np.uint32) 

    for i in range(height):
      for j in range (width):
        binIndex=(newPic[i,j])
        pixelList2[binIndex]+=1
        
    plt.figure()
    plt.plot(pixelList2)#Plots the histogram created from equalized image data
    plt.title("Histogram after Equalization")
    plt.show()
    imshow(newPic)



def part3_histogram_comparing():
    coEfficient=0
    day=skimage.io.imread('day.jpg', as_gray=True)#Loads in day image and night image below
    night=skimage.io.imread('night.jpg', as_gray=True)
    histogramDay,bin_edges = np.histogram(day, 256,range=[0,1])#Computes both of the histograms
    histogramNight,bin_edges = np.histogram(night, 256,range=[0,1])
    heightDay = day.shape[0]
    widthDay = day.shape[1]
    noOfPixelsDay=heightDay*widthDay#Calculates the number of pixels in the image by getting the number of rowss and columns in previous 2 lines. Repeated for night and day
    heightNight = night.shape[0]
    widthDay = night.shape[1]
    noOfPixelsNight=heightNight*widthDay
    for i in range(0,len(histogramDay)):#Loops through both histograms, doesnt matter which histogram is chosen as both are same size
      coEfficient+=sqrt(histogramDay[i]/noOfPixelsDay)*sqrt(histogramNight[i]/noOfPixelsNight)#This is the formula. The sum from i to length of histogram, of Sqrt(P(x)*Q(x))
    print("Bhattacharyya Coefficient: ", coEfficient)

def histEqualization (photo):#Psses loaded photo as a parameter
    histogram,bins=(np.histogram(photo, 256,range=[0,256]))
    height=photo.shape[0]
    width=photo.shape[0]
    photo=(photo*255).astype(np.uint8)
    cfd=np.zeros((256),np.float32)
    newPhoto=np.zeros([height,width],np.uint8)
    for i in range(0,256):
        for j in range(0,i):
            cfd[i]+=histogram[j]
        cfd[i]/=(float(height*width))
    for i in range(0,256):
        cfd[i]=int(cfd[i]*255)#Multiplies by the number of gray levels
    for i in range(height):
        for j in range(width):
            binIndex=photo[i,j]
            newPhoto[i,j]=cfd[binIndex]
    hist2,bins=(np.histogram(newPhoto, 256,range=[0,256]))
    return newPhoto,cfd,hist2

def part4_histogram_matching():

    newNight,cfdDay,histNewDay=histEqualization(day) #Calls a function(above) to equalize an image, and will return its cumulative freq, its histogram and the new equalized image     
    newNight,cfdNight,histNewNight=histEqualization(night)#The reason for making it a function is that the code will be repeated twice, to prevent clutter, a function was made

    indexList=np.zeros((256),np.uint32)
    for i in range(256):#This is an array which holds each pixel value in corresponding element(i.e pixel 1 at position 0, 2 at 1 etc.)
      indexList[i]=i
    mapArray=np.zeros((256),np.uint32)#Initalizes Mapping arrat to be used

    for i in range(256):
      mapArray[i]=np.interp(cfdDay[i],cfdNight,indexList)# This allows us to find out what the pixel value in the source image will map to

    for i in range(heightDay):
      for j in range(widthDay):
        index=day[i,j]
        newDay[i,j]=mapArray[index]#This will put the mapped pixel in the correct place based on the original image

    plt.figure()
    #Sets up a sub plot for 3 images, creates an array 
    f, subPlot = plt.subplots(1,3,figsize=(20,20)) 

    # Prints out the 3 images
    subPlot[0].imshow(day,'gray')#makes sure the image is in greyscale
    subPlot[1].imshow(night,'gray')
    subPlot[2].imshow(newDay,'gray')

    dayC=skimage.io.imread('day.jpg')#Loads in colour images of the day and night image
    nightC=skimage.io.imread('night.jpg')
    newDayC=np.zeros([dayC.shape[0],dayC.shape[1],3],np.uint8)#Initializes a new colour photo for post-histogram matching
    for i in range(dayC.shape[0]):
      for j in range(day.shape[1]):
        for k in range(3):#Loops through the three different channels of Red, Blue and Green
          index=dayC[i,j,k]
          newDayC[i,j,k]=mapArray[index]#Using the map array from the above greysclae image, maps the pixel to a different pixel intensity

    f, subPlot = plt.subplots(1,3,figsize=(20,20)) #This sets up a subplot and makes the size bigger

    # Prints out the 3 images
    subPlot[0].imshow(dayC)
    subPlot[1].imshow(nightC)
    subPlot[2].imshow(newDayC)

if __name__ == '__main__':
    part1_histogram_compute()
    part2_histogram_equalization()
    part3_histogram_comparing()
    part4_histogram_matching()
