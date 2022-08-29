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
df = pd.read_csv("C:/Users/Elizabeth/Desktop/TDP/driver_imgs_list.csv") #Route of .csv filename

features = df["img"]
labels = df["classname"]

path="C:/Users/Elizabeth/Desktop/TDP/train" #Path of train dataset
folder_names=os.listdir(path)
folder_names

for i,folder in enumerate( folder_names):
    print(folder,"contains",len(os.listdir(path+"/"+folder)))

def read_gray():
    base="../input/state-farm-distracted-driver-detection/imgs/train" #Path of the image dataset
    image_data=[]
    label_data=[]
    for i in range(len (features)):
        img = cv2.resize(cv2.imread(base+"/"+labels[i]+"/"+ features[i], cv2.IMREAD_GRAYSCALE),(64,64))
        image_data.append(img)
        label_data.append(labels[i])
    return image_data, label_data


def read_color():    
    path="../input/state-farm-distracted-driver-detection/imgs/train"#Path of the image dataset
    image_data=[]
    label_data=[]
    for i in range(len (features)):
        img=cv2.imread(path+"/"+labels[i]+"/"+ features[i],cv2.IMREAD_COLOR)
        img = cv2.resize(cv2.cvtColor(img, cv2.COLOR_BGR2RGB) ,(64,64))
        image_data.append(img)
        label_data.append(labels[i])
    return image_data,label_data

#To move the images to the training, validation and testing
def split(image_data,label_data):
    train_images, images_validation_test, train_labels, labels_validation_test = train_test_split(
        image_data, label_data, test_size=0.2, random_state=42, stratify=labels)
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
    train_images = train_images.reshape((train_images.shape[0], -1))
    train_images = train_images.astype('float32') / 255

    validation_images = validation_images.reshape((validation_images.shape[0], -1))
    validation_images = validation_images.astype('float32') / 255

    test_images = test_images.reshape((test_images.shape[0],-1))
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
#Values for testing and training purposes
image_data, label_data=read_gray()
train_images,train_labels,validation_images,validation_labels,test_images,test_labels=split(image_data,label_data)
train_images,validation_images,test_images=feature_preprocessing(train_images,validation_images,test_images)
train_labels,validation_labels,test_labels=label_preprocessing(train_labels,validation_labels,test_labels)