#!/usr/bin/env python
# -*- coding: utf-8 -*-

thetas_path = 'trainer/thetas.mat'
trainning_dataset_path = 'trainer/trainning_data.mat'
upload_folder = 'tmp/'
# The unit is `mb`
max_content_length = 3
allowed_extensions = ['bmp', 'jpg', 'png', 'jpeg']


import os
thetas_path = os.path.expanduser(thetas_path)
trainning_dataset_path = os.path.expanduser(trainning_dataset_path)
upload_folder = os.path.expanduser(upload_folder)
try:
    os.makedirs(upload_folder)
except:
    pass