import os, shutil, random, cv2
from PIL import Image
import torch
import numpy as np

current_dir=os.getcwd()
#print("Hi :", current_dir)

train_set  = np.load(current_dir+"/data/obj/train_X.npy")
train_labels_set = np.load(current_dir+"/data/obj/train_Y.npy")

valid_set  = np.load(current_dir+"/data/obj/valid_X.npy")
valid_labels_set = np.load(current_dir+"/data/obj/valid_Y.npy")


train_bboxes_set = np.load(current_dir+"/data/obj/train_bboxes.npy")
valid_bboxes_set = np.load(current_dir+"/data/obj/valid_bboxes.npy")


#print(current_dir+"\data/obj/")


n_images = train_set.shape[0]
wh= 28/64
val = " "+str(wh)


for img_id in range(n_images):
    src_img = train_set[img_id, ...].squeeze().reshape((64, 64, 3)).astype(np.uint8)
    im = Image.fromarray(src_img)
    f_name= current_dir+"/data/obj/"+str(img_id)+ "_train.jpg"
    im.save(f_name)


for i in range(n_images):
    train_bboxes = train_bboxes_set[i].tolist()
    train_labels = train_labels_set[i].tolist()
    x_cor0 = ((train_bboxes[0][1]/64)+(train_bboxes[0][3]/64))/2
    y_cor0 = ((train_bboxes[0][0]/64)+(train_bboxes[0][2])/64)/2
    x_cor1 = ((train_bboxes[1][1]/64)+(train_bboxes[1][3]/64))/2
    y_cor1 = ((train_bboxes[1][0]/64)+(train_bboxes[1][2])/64)/2
    line1=str(train_labels[0]) +" "+str(x_cor0)+" "+str(y_cor0) + val+val
    line2=str(train_labels[1]) +" "+str(x_cor1)+" "+str(y_cor1) + val+val   
    print(line1)
    print(line2)
    file_name = current_dir+"/data/obj/"+str(i)+"_train.txt"
    f = open(file_name, 'w')
    f.write(line1+"\n"+line2)
    f.close()

   
n_images = valid_set.shape[0]
wh= 28/64
val = " "+str(wh)

for img_id in range(n_images):
    src_img = valid_set[img_id, ...].squeeze().reshape((64, 64, 3)).astype(np.uint8)
    im = Image.fromarray(src_img)
    f_name= current_dir+"/data/obj/"+str(img_id)+ "_train.jpg"
    im.save(f_name)

for i in range(n_images):
    train_bboxes = valid_bboxes_set[i].tolist()
    train_labels = valid_labels_set[i].tolist()
    x_cor0 = ((train_bboxes[0][1]/64)+(train_bboxes[0][3]/64))/2
    y_cor0 = ((train_bboxes[0][0]/64)+(train_bboxes[0][2])/64)/2
    x_cor1 = ((train_bboxes[1][1]/64)+(train_bboxes[1][3]/64))/2
    y_cor1 = ((train_bboxes[1][0]/64)+(train_bboxes[1][2])/64)/2
    line1=str(train_labels[0]) +" "+str(x_cor0)+" "+str(y_cor0) + val+val
    line2=str(train_labels[1]) +" "+str(x_cor1)+" "+str(y_cor1) + val+val   
    print(line1)
    print(line2)
    file_name = current_dir+"/data/obj/"+str(i)+"_train.txt"
    f = open(file_name, 'w')
    f.write(line1+"\n"+line2)
    f.close()

# preparing the folder structure

full_data_path = 'data/obj/'
extension_allowed = '.jpg'
split_percentage = 90

images_path = 'data/images/'
if os.path.exists(images_path):
    shutil.rmtree(images_path)
os.mkdir(images_path)
    
labels_path = 'data/labels/'
if os.path.exists(labels_path):
    shutil.rmtree(labels_path)
os.mkdir(labels_path)
    
training_images_path = images_path + 'training/'
validation_images_path = images_path + 'validation/'
training_labels_path = labels_path + 'training/'
validation_labels_path = labels_path +'validation/'
    
os.mkdir(training_images_path)
os.mkdir(validation_images_path)
os.mkdir(training_labels_path)
os.mkdir(validation_labels_path)

files = []

ext_len = len(extension_allowed)

for r, d, f in os.walk(full_data_path):
    for file in f:
        if file.endswith(extension_allowed):
            strip = file[0:len(file) - ext_len]      
            files.append(strip)

random.shuffle(files)

size = len(files)                   

split = int(split_percentage * size / 100)

print("copying training data")
for i in range(split):
    strip = files[i]
                         
    image_file = strip + extension_allowed
    src_image = full_data_path + image_file
    shutil.copy(src_image, training_images_path) 
                         
    annotation_file = strip + '.txt'
    src_label = full_data_path + annotation_file
    shutil.copy(src_label, training_labels_path) 

print("copying validation data")
for i in range(split, size):
    strip = files[i]
                         
    image_file = strip + extension_allowed
    src_image = full_data_path + image_file
    shutil.copy(src_image, validation_images_path) 
                         
    annotation_file = strip + '.txt'
    src_label = full_data_path + annotation_file
    shutil.copy(src_label, validation_labels_path) 

print("finished")
