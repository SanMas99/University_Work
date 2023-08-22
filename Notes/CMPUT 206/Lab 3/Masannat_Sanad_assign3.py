from math import floor
from matplotlib import pyplot as plt
from scipy import spatial
from skimage import exposure
from skimage import io, color, img_as_float
from skimage.color import rgb2gray,gray2rgb
from skimage.exposure import rescale_intensity
from skimage.feature import match_descriptors, corner_harris, corner_peaks, ORB, plot_matches
from skimage.measure import ransac
from skimage.transform import ProjectiveTransform
from skimage.transform import warp
from sklearn.cluster import KMeans
import math
import numpy as np
import os
import skimage
import torch
import torch.nn.functional as F
#Sanad Masannat 1626221 CMPUT206 Assignment 3
def makeIG(img,h,w):
  IG = np.copy(img) # copy the image into each channel
  for row in range(0,h,4): # loop step is 4 since our mask size is 4.
    for col in range(0,w,4): # loop step is 4 since our mask size is 4.
    #the bottom performs the operations as shown in the GreenMP 
      IG[row,col+1]=(int(img[row,col])+int(img[row,col+2]))/2
      IG[row,col+3]=(int(img[row+1,col+3])+int(img[row,col+2]))/2
      IG[row+1,col]=(int(img[row,col])+int(img[row+2,col+2]))/2
      IG[row+1,col+2]=(int(img[row,col+2])+int(img[row+1,col+3])+int(img[row+2,col+2])+int(img[row+1,col+1]))/4
      IG[row+2,col+1]=(int(img[row+1,col+1])+int(img[row+2,col+2])+int(img[row+3,col+1])+int(img[row+2,col]))/4
      IG[row+2,col+3]=(int(img[row+1,col+3])+int(img[row+3,col+3]))/2
      IG[row+3,col]= (int(img[row+2,col])+int(img[row+3,col+1]))/2
      IG[row+3,col+2]= (int(img[row+3,col+3])+int(img[row+3,col+1]))/2
  return IG
def makeIR(img,h,w):
  IR = np.copy(img)
  for row in range(0,h,4): # loop step is 4 since our mask size is 4.
    for col in range(0,w,4): # loop step is 4 since our mask size is 4
        #the bottom performs the operations as shown in the RedBMP 
      IR[row,col]=int(IR[row,col+1])
      IR[row,col+2]=(int(IR[row,col+1])+int(IR[row,col+3]))/2
      IR[row+1,col+1]=(int(IR[row,col+1])+int(IR[row,col+2]))/2
      IR[row+1,col]=IR[row+1,col+1]
      IR[row+1,col+2]=(int(IR[row,col+1])+int(IR[row,col+3])+int(IR[row+2,col+1])+int(IR[row+2,col+3]))/4
      IR[row+1,col+3]=(int(IR[row,col+3]+int(IR[row+2,col+3])))/2
      IR[row+2,col]=int(IR[row+1,col+1])
      IR[row+2,col+2]=(int(IR[row+2,col+1])+int(IR[row+2,col+3]))/2
      IR[row+3,col+1]=IR[row+2,col+1]
      IR[row+3,col]=IR[row+3,col]
      IR[row+3,col+2]=IR[row+2,col+2]
      IR[row+3,col+3]=IR[row+2,col+3]     
  return IR
def makeIB(img,h,w): 
  IB = np.copy(img)
  for row in range(0,h,4): # loop step is 4 since our mask size is 4.
    for col in range(0,w,4): # loop step is 4 since our mask size is 4
        #the bottom performs the operations and shown in the BlueBMP 
      IB[row,col]=IB[row+1,col]
      IB[row,col+2]=IB[row+1,col+2]
      IB[row+1,col+3]=IB[row+1,col+2]
      IB[row,col+3]=IB[row+1,col+3]
      IB[row+1,col+1]=(int(IB[row+1,col])+int(IB[row+1,col+2]))/2
      IB[row,col+1]=IB[row+1,col+1]
      IB[row+2,col]=(int(IB[row+3,col])+int(IB[row+1,col]))/2
      IB[row+2,col+1]=(int(IB[row+1,col])+int(IB[row+1,col+2])+int(IB[row+3,col])+int(IB[row+3,col+2]))/4
      IB[row+2,col+2]=(int(IB[row+3,col+2])+int(IB[row+1,col+2]))/2
      IB[row+2,col+3]=IB[row+2,col+2]
      IB[row+3,col+1]=(int(IB[row+3,col])+int(IB[row+3,col+2]))/2
      IB[row+3,col+3]=IB[row+3,col+2]
  return IB

 
  # Finds the closest colour in the palette using kd-tree.
def nearest(palette, colour):
    dist, i = palette.query(colour)
    return palette.data[i]

# Make a kd-tree palette from the provided list of colours
def makePalette(colours):
    #print(colours)
    return spatial.KDTree(colours)

# Dynamically calculates and N-colour palette for the given image
# Uses the KMeans clustering algorithm to determine the best colours
# Returns a kd-tree palette with those colours
def findPalette(image, nColours):
  h,w,d=image.shape
  alteredImage=image.reshape(h*w,d)
  colours=np.zeros((nColours))
  kmean=KMeans(n_clusters=nColours).fit(alteredImage)
  colours=(kmean.cluster_centers_)
  return makePalette(colours)
  
  
def FloydSteinbergDitherColor(image, palette):
  for i in range(image.shape[0]-1):
    for j in range(image.shape[1]-1):
      oldpixel  = image[i][j]
      newpixel  = nearest(palette,oldpixel) # Determine the new colour for the current pixel
      image[i][j]  = newpixel 
      quant_error  = oldpixel - newpixel
      image[i+1][j] = image[i+1][j] + quant_error * 7 / 16
      image[i-1][j+1] = image[i-1][j+1] + quant_error * 3 / 16
      image[i][j+1] = image[i][j+1] + quant_error * 5 / 16
      image[i+1][j+1] = image[i+1][j+1] + quant_error * 1 / 16
  return image  


def add_alpha(image, background=-1):
    """Add an alpha layer to the image.

    The alpha layer is set to 1 for foreground
    and 0 for background.
    """
    rgb = gray2rgb(image)
    alpha = (image != background)
    return np.dstack((rgb, alpha))

# part I 
def part1():
  filename_Grayimage = 'PeppersBayerGray.bmp'
  filename_gridB = 'gridB.bmp'
  filename_gridR = 'gridR.bmp'
  filename_gridG = 'gridG.bmp'
  img = io.imread(filename_Grayimage, as_gray =True)

  h,w = img.shape

  # our final image will be a 3 dimentional image with 3 channels
  rgb = np.zeros((h,w,3),np.uint8);


  # reconstruction of the green channel IG
  IG=makeIG(img,h,w)
  # reconstruction of the Red channel IR
  IR=makeIR(img,h,w)
  # reconstruction of the blue channel IB
  IB=makeIB(img,h,w)
  # merge the channels
  rgb[:,:,0]=IR
  rgb[:,:,1]=IG
  rgb[:,:,2]=IB
  plt.imshow(rgb),plt.title('rgb')
  plt.show()

def part2():
  nColours = 8 # The number colours: change to generate a dynamic palette
  imfile = 'lena.png'
  image = io.imread(imfile)
  # Strip the alpha channel if it exists
  image = image[:,:,:3]

  # Convert the image from 8bits per channel to floats in each channel for precision
  image = img_as_float(image)
  # Dynamically generate an N colour palette for the given image
  palette = findPalette(image, nColours)
  colours = palette.data
  colours = img_as_float([colours.astype(np.ubyte)])[0]
  img = FloydSteinbergDitherColor(image, palette)
  plt.imshow(img)
  plt.show()

def part3():
  image1 = io.imread('lab5_img.jpeg')
  h,w,d=image1.shape
  warpedImage=image1
  T_r=np.zeros((3,3))#Initializes Rotation Matrix
  T_s=np.zeros((3,3))#Initializes Scalar matrix
  T_r[1,0]=1#sin90 =1
  T_r[0,1]=-1#-sin90 =-1
  T_r[2,2]=1#Doesnt not transform the channel of image
  T_s[0,0]=2#As horizontal scalar is 2, we set this to 2
  T_s[1,1]=2#As vertical scalar is 2, we set this to 2
  T_s[2,2]=1
  y, x = torch.meshgrid([torch.arange(0,h).float(), torch.arange(0,w).float()])#Creates a meshgrid to apply the trnadformation
  y, x = 2.0*y/(h-1) - 1.0, 2.0*x/(w-1) - 1.0
  combined=np.dot(T_r,T_s)#Comcines the two transformations
  #Performs Transformations on x and Y co-ordinates
  changedX = (combined[0,0]*x + combined[0,1]*y + combined[0,2])
  changedY= (combined[1,0]*x + combined[1,1]*y + combined[1,2])
  #Interpolates pixxels on all three channels(Idea used from IMage Registation Notebook from professor)
  warpedImageR = F.grid_sample(torch.tensor(image1[:,:,0]).float().unsqueeze(0).unsqueeze(0),
                        torch.stack([torch.tensor(changedX),torch.tensor(changedY)],2).unsqueeze(0),
                        align_corners=False).squeeze().cpu().detach().numpy()
  warpedImageG = F.grid_sample(torch.tensor(image1[:,:,1]).float().unsqueeze(0).unsqueeze(0),
                        torch.stack([torch.tensor(changedX),torch.tensor(changedY)],2).unsqueeze(0),
                        align_corners=False).squeeze().cpu().detach().numpy()
  warpedImageB = F.grid_sample(torch.tensor(image1[:,:,2]).float().unsqueeze(0).unsqueeze(0),
                        torch.stack([torch.tensor(changedX),torch.tensor(changedY)],2).unsqueeze(0),
                        align_corners=False).squeeze().cpu().detach().numpy()
  #Merges the three channels
  warpedImage[:,:,0]=warpedImageR
  warpedImage[:,:,1]=warpedImageG
  warpedImage[:,:,2]=warpedImageB
  plt.imshow(warpedImage,cmap='gray')
  plt.show()

def part4():
  image0 = io.imread('im1.jpg', True)
  image1 = io.imread('im2.jpg', True)

  plt.imshow(image0,cmap='gray')
  plt.show()
  plt.imshow(image1,cmap='gray')
  plt.show()
  #Feature detection and matching

  # Initiate ORB detector
  orbObject=ORB(n_keypoints=1000, fast_threshold=0.08)


  # Find the keypoints and descriptors for Image 0 and 1
  orbObject.detect_and_extract(image0)
  keypoint1=orbObject.keypoints
  descriptors1=orbObject.descriptors

  orbObject.detect_and_extract(image1)
  keypoint2=orbObject.keypoints
  descriptors2=orbObject.descriptors


  # initialize Brute-Force matcher and exclude outliers. See match descriptor function.
  matches = match_descriptors(descriptors2,descriptors1,cross_check=True,max_distance=10)
      
  src=keypoint2[matches[:, 0]][:, ::-1]
  dst=keypoint1[matches[:, 1]][:, ::-1]
  # Compute homography matrix using ransac and ProjectiveTransform
  model_robust, inliers = ransac((src,dst),ProjectiveTransform, min_samples=3,residual_threshold=2, max_trials=100)
  #Warping
  #Next, we produce the panorama itself. The first step is to find the shape of the output image by considering the extents of all warped images.

  r, c = image1.shape[:2]

  # Note that transformations take coordinates in
  # (x, y) format, not (row, column), in order to be
  # consistent with most literature.
  corners = np.array([[0, 0],
                      [0, r],
                      [c, 0],
                      [c, r]])

  # Warp the image corners to their new positions.
  warped_corners = model_robust(corners)

  # Find the extents of both the reference image and
  # the warped target image.
  all_corners = np.vstack((warped_corners, corners))

  corner_min = np.min(all_corners, axis=0)
  corner_max = np.max(all_corners, axis=0)

  output_shape = (corner_max - corner_min)
  output_shape = np.ceil(output_shape[::-1])

  #The images are now warped according to the estimated transformation model.

  #A shift is added to ensure that both images are visible in their entirety. Note that warp takes the inverse mapping as input.

  offset = SimilarityTransform(translation=-corner_min)

  image0_ = warp(image0, offset.inverse,
                output_shape=output_shape)

  image1_ = warp(image1, (model_robust + offset).inverse,
                output_shape=output_shape)

  #An alpha channel is added to the warped images before merging them into a single image:




  #add alpha to the image0 and image1
  alpha1=add_alpha(image0_)
  alpha2=add_alpha(image1_)
  #merge the alpha added image
  merged = alpha2+alpha1
  alpha = merged[..., 3]
  merged /= np.maximum(alpha, 1)[..., np.newaxis]
  plt.imshow(merged)
  # The summed alpha layers give us an indication of
  # how many images were combined to make up each
  # pixel.  Divide by the number of images to get
  # an average.
if __name__ == '__main__':
  part1()
  part2()
  part3()
  part4()
