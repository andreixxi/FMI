#!/usr/bin/env python
# coding: utf-8

# In[3]:


import numpy as np
from scipy.io import wavfile
import os
import matplotlib.pyplot as plt
from scipy.fft import fft
import scipy.fftpack
from skimage import util
import random
import scipy.fftpack
from sklearn.svm import SVC
from pydub import AudioSegment
from sklearn.model_selection import cross_val_score
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.naive_bayes import MultinomialNB
from sklearn.linear_model import Perceptron 
from sklearn.neural_network import MLPClassifier
from sklearn.neighbors import KNeighborsClassifier
import sklearn.preprocessing as preprocessing
from sklearn.linear_model import LinearRegression


# In[ ]:


#lab function
def normalize(train_data, test_data, type=None):
    if type is None:
        return train_data, test_data
    elif type == 'standard':
         # .fit - calculeaza mean si std, .transform -> (x - mean) / std
        scaler = preprocessing.StandardScaler()
        scaler.fit(train_data)
        return scaler.transform(train_data), scaler.transform(test_data)
    elif type == 'min-max':
        # .fit - calculeaza min si max, .transform -> (x - min) / (max - min)
        scaler = preprocessing.MinMaxScaler()
        scaler.fit(train_data)
        return scaler.transform(train_data), scaler.transform(test_data)
    elif type == 'l1' or type == 'l2':
        scaler = preprocessing.Normalizer(type)
        scaler.fit(train_data)
        return scaler.transform(train_data), scaler.transform(test_data)


# In[1]:


# read data
# initialise a list for each set: train, validation, test in which i append the files' names + their corresponding labels
# the dictionary with names + labels is used to sort the data so i have the labels sorted when reading the .wav files
# afterward i convert the lists to numpy arrays so i can use them as parameters for my model


# train
train_labels = []
name_train = []
train_data_dict = {}

with open ('train.txt', 'r') as fin:
    for line in fin:
        line = line.split(',')
        train_data_dict[line[0]] = int(line[1]) # nume : label

for key in sorted(train_data_dict.keys()):
    name_train.append(key) # nume
    train_labels.append(train_data_dict[key]) #label
    
train_labels = np.asarray(train_labels)
print('len(name_train)=', len(name_train))
print('len(train_labels)=', len(train_labels))


# test
test_labels = []
name_test = []
test_data_dict = {}
with open('test.txt', 'r') as fin:
    for line in fin:
        line = line.strip() # sterge '\n'
        test_data_dict[line] = 'unk' # nume : unk

for key in sorted(test_data_dict.keys()):
    name_test.append(key) # nume
    test_labels.append(test_data_dict[key]) #label    
    
test_labels = np.asarray(test_labels)
print('len(name_test)=', len(name_test))
print('len(test_labels)', len(test_labels))


# validation
validation_labels = []
name_validation = []
validation_data_dict = {}
with open('validation.txt', 'r') as fin:
    for line in fin:
        line = line.split(',')
        validation_data_dict[line[0]] = int(line[1]) # nume : label
        
for key in sorted(validation_data_dict.keys()):
    name_validation.append(key) # nume
    validation_labels.append(validation_data_dict[key]) #label
    
validation_labels = np.asarray(validation_labels)
name_validation = np.asarray(name_validation)
print('len(name_validation)=', len(name_validation))
print('len(validation_labels)=', len(validation_labels))



# get the files 
train_files = os.listdir('train/train/')
test_files = os.listdir('test/test/')
validation_files = os.listdir('validation/validation/')



# for each file in the sets i get the sample rate and data by using wavfile.read. then i perform fft (from scipy.fft) on data
# i make a list with the ffts of the data (complex values) and then convert it to a numpy array


## fft
train_files = os.listdir('train/train/')
train_data = []
for file in train_files:
    rate, data = wavfile.read('train/train/' + file) # reading wave file.
    fft_out = fft(data)  # perform the FFT by calling fft() with data
    train_data.append(fft_out)
train_data = np.asarray(train_data)

test_files = os.listdir('test/test/')
test_data = []
for file in test_files:
    rate, data = wavfile.read('test/test/' + file) # reading wave file.
    fft_out = fft(data)  # perform the FFT by calling fft() with data
    test_data.append(fft_out)
test_data = np.asarray(test_data)

validation_files = os.listdir('validation/validation/')
validation_data = []
for file in validation_files:
    rate, data = wavfile.read('validation/validation/' + file) # reading wave file.
    fft_out = fft(data)  # perform the FFT by calling fft() with data
    validation_data.append(fft_out)
validation_data = np.asarray(validation_data)



# the models needs real values so i convert the complex numbers(from fft) by using their absolute value: 
# power = math.sqrt(R*R + C*C) 
# the list is turned into a numpy array again 
fft_train_data = []
for array in train_data:
    values = []
    for complex_no in array:
        real, imag = complex_no.real, complex_no.imag
        value = math.sqrt(real * real + imag * imag) # power = math.sqrt(R*R + C*C)
        values.append(value)
    fft_train_data.append(values)
fft_train_data = np.asarray(fft_train_data)


fft_test_data = []
for array in test_data:
    values = []
    for complex_no in array:
        real, imag = complex_no.real, complex_no.imag
        value = math.sqrt(real * real + imag * imag) # power = math.sqrt(R*R + C*C)
        values.append(value)
    fft_test_data.append(values)
fft_test_data = np.asarray(fft_test_data)


fft_validation_data = []
for array in validation_data:
    values = []
    for complex_no in array:
        real, imag = complex_no.real, complex_no.imag
        value = math.sqrt(real * real + imag * imag) # power = math.sqrt(R*R + C*C)
        values.append(value)
    fft_validation_data.append(values)
fft_validation_data = np.asarray(fft_validation_data)


# method 1
# on the RAW data
# the train_data was WITHOUT applying fft, like this (i did not put it here in order to shorten the code): 
# the same for test and validation
# rate, data = wavfile.read('train/train/' + file)
# train_data.append(data)


# svc c = 1
model = SVC(C=1.0, kernel='linear')
model.fit(train_data, train_labels)
test_preds = model.predict(test_data)
model.score(validation_data, validation_labels)
with open('submission.csv', 'w') as fout:
    fout.write('name,label\n')
    for i in range(len(name_test)):
        name = name_test[i]
        label = test_preds[i]
        fout.write(name + ',' + str(label) + '\n')

valid_preds = model.predict(validation_data)
print(confusion_matrix(validation_labels, valid_preds)) # y_true, y_pred
print(classification_report(validation_labels, valid_preds)) # validation_labels = valid labels


# svc c = 10
model = SVC(C = 10, kernel = 'linear')
model.fit(train_data, train_labels)
test_preds = model.predict(test_data)
model.score(validation_data, validation_labels)
valid_preds = model.predict(validation_data)
print(confusion_matrix(validation_labels, valid_preds))
print(classification_report(validation_labels, valid_preds))      
with open('submission_svc_c=10.csv', 'w') as fout:
    fout.write('name,label\n')
    for i in range(len(name_test)):
        name = name_test[i]
        label = test_preds[i]
        fout.write(name + ',' + str(label) + '\n')
        
        
# kernel poly
model = SVC(C = 0.5, kernel = 'poly', gamma = 'scale')
model.fit(train_data, train_labels)
test_preds = model.predict(test_data)
model.score(validation_data, validation_labels)
valid_preds = model.predict(validation_data)
print(confusion_matrix(validation_labels, valid_preds)) # y_true, y_pred
print(classification_report(validation_labels, valid_preds))      
with open('submission_svc_c_poly_gamma.csv', 'w') as fout:
    fout.write('name,label\n')
    for i in range(len(name_test)):
        name = name_test[i]
        label = test_preds[i]
        fout.write(name + ',' + str(label) + '\n')
        
        
        
# svc kernel rbf
model = SVC(C = 3, kernel = 'rbf')
model.fit(train_data, train_labels)
test_preds = model.predict(test_data)
model.score(validation_data, validation_labels)
valid_preds = model.predict(validation_data)
print(confusion_matrix(validation_labels, valid_preds)) # y_true, y_pred
print(classification_report(validation_labels, valid_preds)) 
with open('submission_svc_rbf.csv', 'w') as fout:
    fout.write('name,label\n')
    for i in range(len(name_test)):
        name = name_test[i]
        label = test_preds[i]
        fout.write(name + ',' + str(label) + '\n')
        
        
        
        
# on the fft data
# svc c=1
model = SVC(C=1.0, kernel='linear')
model.fit(fft_train_data, train_labels)
test_preds = model.predict(fft_test_data)
model.score(fft_validation_data, validation_labels)
valid_preds = model.predict(fft_validation_data) 
print(classification_report(validation_labels, valid_preds)) 
print(confusion_matrix(validation_labels, valid_preds)) # y_true, y_pred
with open('submission_fft.csv', 'w') as fout:
    fout.write('name,label\n')
    for i in range(len(name_test)):
        name = name_test[i]
        label = test_preds[i]
        fout.write(name + ',' + str(label) + '\n')
scores = cross_val_score(model, fft_validation_data, validation_labels, cv=5)
print("accuracy: {} (+/- {})".format(scores.mean(), scores.std() * 2))        
        
    
# svc c = 10    
model = SVC(C=10, kernel='linear')
model.fit(fft_train_data, train_labels)
test_preds = model.predict(fft_test_data)
model.score(fft_validation_data, validation_labels) 
valid_preds = model.predict(fft_validation_data) 
print(confusion_matrix(validation_labels, valid_preds))
print(classification_report(validation_labels, valid_preds)) 
with open('submission_fft_c=10.csv', 'w') as fout:
    fout.write('name,label\n')
    for i in range(len(name_test)):
        name = name_test[i]
        label = test_preds[i]
        fout.write(name + ',' + str(label) + '\n')


# NB
model = MultinomialNB() # are partial_fit
model.fit(fft_train_data, train_labels)
test_preds = model.predict(fft_test_data)
model.score(fft_validation_data, validation_labels) 
valid_preds = model.predict(fft_validation_data) 
print(confusion_matrix(validation_labels, valid_preds))
print(classification_report(validation_labels, valid_preds)) 
scores = cross_val_score(model, fft_validation_data, validation_labels, cv=20) 
print(scores)
print("accuracy: {} (+/- {})".format(scores.mean(), scores.std() * 2))
with open('submission_fft_naivebayes.csv', 'w') as fout:
    fout.write('name,label\n')
    for i in range(len(name_test)):
        name = name_test[i]
        label = test_preds[i]
        fout.write(name + ',' + str(label) + '\n')
        
        
        
# NB alpha = 5
model = MultinomialNB(alpha = 5)
model.fit(fft_train_data, train_labels)
test_preds = model.predict(fft_test_data)
model.score(fft_validation_data, validation_labels) 
valid_preds = model.predict(fft_validation_data) 
print(confusion_matrix(validation_labels, valid_preds))
print(classification_report(validation_labels, valid_preds)) 
with open('submission_fft_nb_alpha5.csv', 'w') as fout:
    fout.write('name,label\n')
    for i in range(len(name_test)):
        name = name_test[i]
        label = test_preds[i]
        fout.write(name + ',' + str(label) + '\n')
        

# KNN
knn = KNeighborsClassifier(5, metric = 'l1') # 5 neighbours 
knn.fit(fft_train_data, train_labels)
test_preds = knn.predict(fft_test_data)
knn.score(fft_validation_data, validation_labels) 
valid_preds = knn.predict(fft_validation_data) 
print(confusion_matrix(validation_labels, valid_preds))
print(classification_report(validation_labels, valid_preds)) 
with open('submission_fft_knn.csv', 'w') as fout:
    fout.write('name,label\n')
    for i in range(len(name_test)):
        name = name_test[i]
        label = test_preds[i]
        fout.write(name + ',' + str(label) + '\n')
        
        
# regression with normalized data .. AWFUL RESULTS with this method.... 
linear_regression_model = LinearRegression()
fft_train_data, _ = normalize(fft_train_data, fft_train_data, 'standard')
fft_test_data, _ = normalize(fft_test_data, fft_test_data, 'standard')
fft_validation_data, _ = normalize(fft_validation_data, fft_validation_data, 'standard')
linear_regression_model.fit(fft_train_data, train_labels)
test_preds = linear_regression_model.predict(fft_test_data)
linear_regression_model.score(fft_validation_data, validation_labels)




# method 2
# on the fft data
# i concatenate the train and validation data and then i use train_test_split with a low percentage for train
data = np.concatenate((fft_train_data, fft_validation_data))
labels = np.concatenate((train_labels, validation_labels))

# DIFFERENT train_size for models (always < 0.4), but to keep it short i kept only this line: 
X_train, X_test, y_train, y_test = train_test_split(data, labels, train_size=0.3) #X date, y labels
print(X_train.shape)
print(X_test.shape)



# svm.svc c = 1000
model = SVC(C = 1000 , kernel = 'linear')
model.fit(X_train, y_train) # train the model
model.score(X_test, y_test) # get the accuracy 
test_preds = model.predict(fft_test_data) # get the labels for test data

# write the test name + label for submission
with open('submission_30-70.csv', 'w') as fout:
    fout.write('name,label\n')
    for i in range(len(name_test)):
        name = name_test[i]
        label = test_preds[i]
        fout.write(name + ',' + str(label) + '\n')
        
valid_preds = model.predict(X_test) #valid data  
print(classification_report(y_test, valid_preds)) # y_teset = valid labels
print(confusion_matrix(y_test, valid_preds)) # y_true, y_pred

#  computing the score 5 consecutive times (with different splits each time):
scores = cross_val_score(model, X_test, y_test, cv=5)
print("accuracy: {} (+/- {})".format(scores.mean(), scores.std() * 2))




# naive bayes
model = MultinomialNB()
model.fit(X_train, y_train)
print(model.score(X_test, y_test))
test_preds = model.predict(fft_test_data)

with open('submission_20-80_NB.csv', 'w') as fout:
    fout.write('name,label\n')
    for i in range(len(name_test)):
        name = name_test[i]
        label = test_preds[i]
        fout.write(name + ',' + str(label) + '\n')
        
valid_preds = model.predict(X_test) #valid data  
print(classification_report(y_test, valid_preds)) # y_teset = valid labels
print(confusion_matrix(y_test, valid_preds)) # y_true, y_pred
scores = cross_val_score(model, X_test, y_test, cv=5)
print("accuracy: {} (+/- {})".format(scores.mean(), scores.std() * 2))



# perceptron
model = Perceptron(penalty = 'l1')
model.fit(X_train, y_train)
print(model.score(X_test, y_test))
test_preds = model.predict(fft_test_data)

with open('submission_30-80_perceptron.csv', 'w') as fout:
    fout.write('name,label\n')
    for i in range(len(name_test)):
        name = name_test[i]
        label = test_preds[i]
        fout.write(name + ',' + str(label) + '\n')
        
valid_preds = model.predict(X_test) #valid data  
print(classification_report(y_test, valid_preds)) # y_teset = valid labels
print(confusion_matrix(y_test, valid_preds))


# mlpclassifier; bad results on my approach 
model = MLPClassifier()
model.fit(X_train, y_train)
print(model.score(X_test, y_test))
test_preds = model.predict(fft_test_data)

# scriere fisier pt submit
with open('submission_25-75_MLPClassifier.csv', 'w') as fout:
    fout.write('name,label\n')
    for i in range(len(name_test)):
        name = name_test[i]
        label = test_preds[i]
        fout.write(name + ',' + str(label) + '\n')

valid_preds = model.predict(X_test) #valid data  
print(classification_report(y_test, valid_preds)) # y_teset = valid labels
print(confusion_matrix(y_test, valid_preds)) # y_true, y_pred



# i tried to resample the data
# RESAMPLED_DATA
# Resample data to num samples using Fourier method along the given axis(0 by default).
# The resampled signal starts at the same value as x but is sampled with a spacing of len(x) / num * (spacing of x). 
# Because a Fourier method is used, the signal is assumed to be periodic.
resampled_data = signal.resample(data, 9000) # the resampled array
                                # 9k is the length of data (train+validation)
X_train, X_test, y_train, y_test = train_test_split(resampled_data, labels, train_size=0.3) #X date, y labels
model = SVC(C = 10000 , kernel = 'linear')
model.fit(X_train, y_train)
print(model.score(X_test, y_test))
test_preds = model.predict(fft_test_data)

# scriere fisier pt submit
with open('submission_30-70_resampled.csv', 'w') as fout:
    fout.write('name,label\n')
    for i in range(len(name_test)):
        name = name_test[i]
        label = test_preds[i]
        fout.write(name + ',' + str(label) + '\n')
        
valid_preds = model.predict(X_test) #valid data  
print(classification_report(y_test, valid_preds)) # y_teset = valid labels
print(confusion_matrix(y_test, valid_preds)) # y_true, y_pred








#### alte incercari 
# %%time

# """prelucrarea asta a fost proasta, modelul nu s a antrenat dupa 6 ore.."""
# la fel si pentru test si validation
# am vrut sa aplic filtre pe sunetele initiale pentru a crea artificial samples si a avea mai multe date pentru train

# # artificial samples 
# train_files = os.listdir('train/train/')
# train_data = []
# train_data_filters = []
# for file in train_files:
#     with open('train/train/' + str(file), 'r') as fin:
#         data =  AudioSegment.from_wav('train/train/' + file) # type = pydub.audio_segment.AudioSegment
#         train_data.append(data.get_array_of_samples()) # data nemodificata
        
#         length = len(data) # length of file 
#         fade_time = int(length * 0.5) # Set fade time
#         faded = data.fade_in(fade_time).fade_out(fade_time) # Fade in and out
#         train_data_filters.append(faded.get_array_of_samples()) # modified data
#                                         # o lista cu array.array
#                                         #(este ca la wavfile.read, dar difera tipul de vector).
                
    
# train_data = np.asarray(train_data)
# train_data_filters = np.asarray(train_data_filters)

# # concatenate the 2 arrays (raw data + artificial)
# train_data_filters = np.concatenate((train_data, train_data_filters), axis = 0) 
# train_data_filters.shape
# # dubleaza lungime labels TODO
# filtered_train_labels = np.concatenate((train_labels, train_labels))
# len(filtered_train_labels) , filtered_train_labels.shape


# In[ ]:


#

