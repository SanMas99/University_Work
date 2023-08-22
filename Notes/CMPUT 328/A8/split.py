import os, shutil, random, cv2
from PIL import Image
import torch
import numpy as np

current_dir=os.getcwd()
#print("Hi :", current_dir)

train_set  = np.load(current_dir+"/train_X.npy")
train_seg_set = np.load(current_dir+"/train_seg.npy")

valid_set  = np.load(current_dir+"/valid_X.npy")
valid_seg_set = np.load(current_dir+"/valid_seg.npy")

print("train")


n_images = train_set.shape[0]

for img_id in range(n_images):
    src_img = train_set[img_id, ...].squeeze().reshape((64, 64, 3)).astype(np.uint8)
    im = Image.fromarray(src_img)
    f_name= current_dir+"/unet-multi-seg/data/train/imgs/"+str(img_id)+ ".jpg"
    im.save(f_name)

n_images = train_seg_set.shape[0]

for img_id in range(n_images):
    src_img = train_seg_set[img_id, ...].squeeze().reshape((64, 64)).astype(np.uint8)
    im = Image.fromarray(src_img)
    f_name= current_dir+"/unet-multi-seg/data/train/masks/"+str(img_id)+ ".jpg"
    im.save(f_name)

n_images = valid_set.shape[0]
print("valid")
for img_id in range(n_images):
    src_img = valid_set[img_id, ...].squeeze().reshape((64, 64, 3)).astype(np.uint8)
    im = Image.fromarray(src_img)
    f_name= current_dir+"/unet-multi-seg/data/valid/imgs/"+str(img_id)+ ".jpg"
    im.save(f_name)

n_images = valid_seg_set.shape[0]

for img_id in range(n_images):
    src_img = valid_seg_set[img_id, ...].squeeze().reshape((64, 64)).astype(np.uint8)
    im = Image.fromarray(src_img)
    f_name= current_dir+"/unet-multi-seg/data/validmasks/"+str(img_id)+ ".jpg"
    im.save(f_name)
print("Done!")