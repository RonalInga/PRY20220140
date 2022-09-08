import os
import cv2
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from tensorflow.keras import optimizers
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from tensorflow.keras.utils import to_categorical
from tensorflow.keras import models
from tensorflow.keras import layers
from keras.applications.vgg16 import VGG16

# Getting .csv file
# df = pd.read_csv("C:/Users/Elizabeth/Desktop/TDP/driver_imgs_list.csv") #Route of .csv filename
df = pd.read_csv("C:/Users/jackc/Documents/Machine Learning/Kaggle competitions/02 Car driven/driver_imgs_list.csv") #Route of .csv filename

features = df["img"]
labels = df["classname"]
DIM = 28

# path="C:/Users/Elizabeth/Desktop/TDP/train" #Path of train dataset
path="C:/Users/jackc/Documents/Machine Learning/Kaggle competitions/02 Car driven/imgs/train" #Path of train dataset
folder_names=os.listdir(path)
img_train = len(features)
# img_train = 200
img_shape = (DIM, DIM)

# for i,folder in enumerate( folder_names):
#     print(folder,"contains",len(os.listdir(path+"/"+folder)))

def read_gray():
    image_data=[]
    label_data=[]
    cnt_imgs = {"c0": 0, "c1": 0, "c2": 0, "c3": 0, "c4": 0, "c5": 0, "c6": 0, "c7": 0, "c8": 0, "c9": 0}
    for i in range(img_train):
        if cnt_imgs[labels[i]] < 2300:
            cnt_imgs[labels[i]] += 1
            img = cv2.resize(cv2.imread(path+"/"+labels[i]+"/"+ features[i], cv2.IMREAD_GRAYSCALE), img_shape)
            image_data.append(img)
            label_data.append(labels[i])

    for i in range(img_train):
        if cnt_imgs[labels[i]] < 2300:
            cnt_imgs[labels[i]] += 1
            img = cv2.resize(cv2.imread(path+"/"+labels[i]+"/"+ features[i], cv2.IMREAD_GRAYSCALE), img_shape)
            image_data.append(img)
            label_data.append(labels[i])
            print('Reading', i, 'images of category', labels[i])

    for cat, val in cnt_imgs.items():
        print(cat, val)
    
    return image_data, label_data

def read_single_gray(path, args):
    img = cv2.imread(path, cv2.IMREAD_GRAYSCALE)

    img_proc = cv2.resize(img, img_shape) 
    img_proc = img_proc.reshape((DIM, DIM, 1))
    img_proc = np.full((args.batch_size, DIM, DIM, 1), img_proc)
    #batch_size
    img_proc = img_proc.astype('float32') / 255

    return img, img_proc

def read_color():    
    image_data=[]
    label_data=[]
    for i in range(img_train):
        img=cv2.imread(path+"/"+labels[i]+"/"+ features[i],cv2.IMREAD_COLOR)
        img = cv2.resize(cv2.cvtColor(img, cv2.COLOR_BGR2RGB), img_shape)
        image_data.append(img)
        label_data.append(labels[i])
    return image_data,label_data

#To move the images to the training, validation and testing
def split(image_data,label_data):
    train_images, images_validation_test, train_labels, labels_validation_test = train_test_split(
        image_data, label_data, test_size=0.20, random_state=42, stratify=label_data)
    validation_images, test_images, validation_labels, test_labels = train_test_split(
        images_validation_test, labels_validation_test, test_size=0.5,random_state=42,stratify=labels_validation_test)
    train_images=np.asarray(train_images)
    validation_images=np.asarray(validation_images)
    test_images=np.asarray(test_images)
    
    train_labels=np.asarray(train_labels)
    validation_labels=np.asarray(validation_labels)
    test_labels=np.asarray(test_labels)
    return train_images,train_labels,validation_images,validation_labels,test_images,test_labels

#Images purposes
def feature_preprocessing(train_images,validation_images,test_images):
    train_images = train_images.reshape((-1, DIM, DIM, 1))
    train_images = train_images.astype('float32') / 255

    validation_images = validation_images.reshape((-1, DIM, DIM, 1))
    validation_images = validation_images.astype('float32') / 255

    test_images = test_images.reshape((-1, DIM, DIM, 1))
    test_images = test_images.astype('float32') / 255
    return train_images,validation_images,test_images

#Label purposes
def label_preprocessing(train_labels,validation_labels,test_labels):   
    label_encoder = LabelEncoder()
    vec = label_encoder.fit_transform(train_labels)
    train_labels = to_categorical(vec)
    vec = label_encoder.fit_transform(validation_labels)
    validation_labels = to_categorical(vec)
    vec = label_encoder.fit_transform(test_labels)
    test_labels = to_categorical(vec)
    return train_labels,validation_labels,test_labels

# main important features
class_dict = {
    0 : "safe driving",
    1 : "texting - right",
    2 : "talking on the phone - right",
    3 : "texting - left",
    4 : "talking on the phone - left",
    5 : "operating the radio",
    6 : "drinking",
    7 : "reaching behind",
    8 : "hair and makeup",
    9 : "talking to passenger"
}

def get_name(index):
    return class_dict[index]
