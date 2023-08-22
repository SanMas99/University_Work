import numpy as np
from skimage.io import imread, imsave, imshow
from skimage.transform import resize
from matplotlib import pyplot as plt
import skimage.exposure
import skimage.filters
from math import sqrt
from skimage import feature
#Sanad Masannat
#1626221
#CMPUT 206 Assignment2


def padPhoto(photo):
  paddedPhoto=np.zeros([photo.shape[0]+2,photo.shape[1]+2])#This will generate an empty array that will store the padded image
  paddedHeight=paddedPhoto.shape[0]#Gets the number of rows & colums in the padded image
  paddedWidth=paddedPhoto.shape[1]
  for i in range(1,paddedHeight-1):
    for j in range(1,paddedWidth-1):
      paddedPhoto[i][j]=photo[i-1][j-1]
  #This part will fill in the columns in padding except for the 4 courners
  for i in range(1,paddedHeight-1):
    paddedPhoto[i][0]=paddedPhoto[i][1]#Will copy the pixel value from the pixel to its right 
    paddedPhoto[i][paddedWidth-1]=paddedPhoto[i][paddedWidth-2]#Copies pixel value from the left
  #This section is similar to above except it deals with the rows in the padding
  for i in range(1,paddedWidth-1):
    paddedPhoto[0][i]=paddedPhoto[1][i]#Will copy the pixel value from the pixel below it
    paddedPhoto[paddedHeight-1][i]=paddedPhoto[paddedHeight-2][i]#Copies pixel value from the above pixel
  #These following 4 lines will fill in the borders using the pixel data nearest to them
  paddedPhoto[0][0]=paddedPhoto[1][0]
  paddedPhoto[0][paddedWidth-1]=paddedPhoto[1][paddedWidth-1]
  paddedPhoto[paddedHeight-1][0]=paddedPhoto[paddedWidth-2][0]
  paddedPhoto[paddedHeight-1][paddedWidth-1]=paddedPhoto[paddedHeight-2][paddedWidth-1]
  return paddedPhoto


def Convolution(paddedPhoto,filter):
  filteredPhoto=np.zeros([paddedPhoto.shape[0]-2,paddedPhoto.shape[1]-2])#Creates an empty image of size of the original image
  for i in range(1,paddedPhoto.shape[0]-2):#Starts from the 1st row/colum and goes to the second last row/column
    for j in range(1,paddedPhoto.shape[1]-2):
      filteredPhoto[i][j]=np.tensordot(filter,paddedPhoto[i-1:i+2,j-1:j+2])#Calculates the new value of the pixel and stores it into the output image
  return filteredPhoto

  
def part1():
 
  photo=skimage.io.imread('moon.png', as_gray=True)
  height = photo.shape[0]#Gets the number of rows & colums in the image
  width = photo.shape[1]
  paddedPhoto=padPhoto(photo)

  filter=-np.ones((3,3))
  filter[1,1]=8#This is the laplactian filter
  laplacePhoto=Convolution(paddedPhoto,filter)
  filter=np.zeros((3,3))
  filter[1,1]=1#Filter 2 of [0,0,0][0,1,0][0,0,0]
  filter2Photo=Convolution(paddedPhoto,filter)
  filter[1,1]=0
  filter[1,2]=1
  filter3Photo=Convolution(paddedPhoto,filter)#Filter 3 of [0,0,0][0,0,1][0,0,0]
  filter=np.ones((3,3))/9#gives the average filter
  filter4=Convolution(paddedPhoto,filter)
  filter4=photo-filter4
  filter4=photo+filter4


  f, subPlot = plt.subplots(1,5,figsize=(10,10))
  subPlot[0].set_title("Original Image")
  subPlot[0].imshow(photo,'gray')
  subPlot[1].set_title("Laplace")
  subPlot[1].imshow(laplacePhoto,'gray')
  subPlot[2].set_title("Second Filter")
  subPlot[2].imshow(filter2Photo,'gray')
  subPlot[3].set_title("Third Filter")
  subPlot[3].imshow(filter3Photo,'gray')
  subPlot[4].set_title("Fourth Filter")
  subPlot[4].imshow(filter4,'gray')

def part2():
  photo=skimage.io.imread('noisy.jpg',as_gray=True)
  gaussianPhoto=skimage.filters.gaussian(photo)#Applies a gaussian filter to the photo
  medianPhoto=skimage.filters.median(photo)#Applies a median filter to the photo

  f, subPlot = plt.subplots(1,3,figsize=(20,20))
  subPlot[0].set_title("Noisy Photo")
  subPlot[0].imshow(photo,'gray')
  subPlot[1].set_title("Gaussian Filter")
  subPlot[1].imshow(gaussianPhoto,'gray')
  subPlot[2].set_title("Median Filter")
  subPlot[2].imshow(medianPhoto,'gray')
  #The Median Filter works bettter as the iage looks cleaner and there is less noise

def part3():

  damagedPhoto=skimage.io.imread("damage_cameraman.png",as_gray=True)
  mask=skimage.io.imread("damage_mask.png",as_gray=True)
  repaired=np.zeros([damagedPhoto.shape[0],damagedPhoto.shape[1]])
  repaired=damagedPhoto#Equates the repaired image to the original damaged image
  for i in range(100):
    repaired=skimage.filters.gaussian(repaired)#Performs gaussian smoothing on the filter
    for j in range(mask.shape[0]):#Will loop through the image to see where the good pixels are in the original image
      for k in range(mask.shape[1]):
        if mask[j][k]!=0:#If the good pixels are found, copy them from the original image and store them in the repaired image
          repaired[j][k]=damagedPhoto[j][k]
  f, subPlot = plt.subplots(1,2,figsize=(10,10))
  subPlot[0].set_title("Before Inpainting")
  subPlot[0].imshow(damagedPhoto,'gray')
  subPlot[1].set_title("After Inpainting")
  subPlot[1].imshow(repaired,'gray')


def part4():
  photo=skimage.io.imread('ex2.jpg',as_gray=True)
  hSobel=skimage.filters.sobel_h(photo)#Gets the horizontal derivate from the image
  vSobel=skimage.filters.sobel_v(photo)#Gets the vertical derivate from the image
  edges=np.zeros([photo.shape[0],photo.shape[1]])

  for i in range(hSobel.shape[0]):
    for j in range(hSobel.shape[1]):
      edges[i][j]=sqrt((hSobel[i][j]*hSobel[i][j])+(vSobel[i][j]*vSobel[i][j]))
      #Formula used above is: Gradient=sqrt(HorizontalDerivate^2+VerticalDerivate^2)

  f, subPlot = plt.subplots(1,4,figsize=(20,20))
  subPlot[0].set_title("ex2 Original")
  subPlot[0].imshow(photo,'gray')
  subPlot[1].set_title("Horizontal Derivative")
  subPlot[1].imshow(hSobel,'gray')
  subPlot[2].set_title("Vertical Derivative")
  subPlot[2].imshow(vSobel,'gray')
  subPlot[3].set_title("Image Gradient")
  subPlot[3].imshow(edges,'gray')

def part5():
  photo=skimage.io.imread('ex2.jpg',as_gray=True)
  gaussianPhoto=skimage.filters.gaussian(photo)
  imshow(gaussianPhoto)#Prints the original image
  #The following 8 lines adjust the parameters of the canny function
  #The first two deal with the Low Threshhold while the next 2 deal with the HIgh Threshold
  #The last 4 lines deal with the sigma value of the canny function
  lowThresh1=skimage.feature.canny(photo,1,25)
  lowThresh2=skimage.feature.canny(photo,1,50)
  highThresh1=skimage.feature.canny(photo,1,high_threshold=150)
  highThresh2=skimage.feature.canny(photo,1,high_threshold=200)
  sigma1=skimage.feature.canny(photo,1,50,150)
  sigma2=skimage.feature.canny(photo,1.5,50,150)
  sigma3=skimage.feature.canny(photo,2,50,150)
  sigma4=skimage.feature.canny(photo,2.5,50,150)

  f, subplot= plt.subplots(1,4,True,figsize=(20,20))
  subplot[0].set_title("Low Thresh=25")
  subplot[0].imshow(lowThresh1,'gray')
  subplot[1].set_title("Low Thresh=55")
  subplot[1].imshow(lowThresh2,'gray')
  subplot[2].set_title("High Thresh=150")
  subplot[2].imshow(highThresh1,'gray')
  subplot[3].set_title("High Thresh=200")
  subplot[3].imshow(highThresh2,'gray')

  f, subplot= plt.subplots(1,4,True,figsize=(20,20))
  subplot[0].set_title("$\sigma=1$")
  subplot[0].imshow(sigma1,'gray')
  subplot[1].set_title("$\sigma=1.5$")
  subplot[1].imshow(sigma2,'gray')
  subplot[2].set_title("$\sigma=2$")
  subplot[2].imshow(sigma3,'gray')
  subplot[3].set_title("$\sigma=2.5$")
  subplot[3].imshow(sigma4,'gray')
#From what we see from the output images, the images are indeed affected by the vhanging
#Sigma and threshold values. The threshhold values cause the image changes what pixels are deemed edges
# and what pixels to discard, the higher the lower threshold, the more pixels are ignored.
# The higher the High Threshold is, the higher the threshold for what is deemed an edge pixel becomes
#Sigma is the standard deviation of the filter. As  Sigma value increases,smoothness will increase. 
if __name__ == '__main__':
  part1()
  part2()
  part3()
  part4()
  part5()
