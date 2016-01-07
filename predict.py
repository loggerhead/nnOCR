#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import glob
import subprocess
import config
import numpy as np
from scipy.io import loadmat as load
from PIL import Image

mat = load(config.thetas_path)
theta1 = np.asmatrix(mat['Theta1'].transpose())
theta2 = np.asmatrix(mat['Theta2'].transpose())
num_labels = np.size(theta2, 1)

def size(matrix):
    return [np.size(matrix, 0), np.size(matrix, 1)]

def sigmoid(z):
    return 1.0 / (1.0 + np.exp(-z))

def imread(imgpath):
    img = Image.open(imgpath)
    img = img.convert('L', palette=Image.ADAPTIVE, colors=2)
    return np.array(img) > 128

def split_to_chars(imgpath, saveto):
    try:
        try:
            map(os.remove, glob.glob(os.path.join(saveto, '*.bmp')))
            os.makedirs(saveto)
        except:
            pass
        p = subprocess.Popen("octave", stdin=subprocess.PIPE)
        p.communicate("cutImage('%s', '%s')" % (imgpath, saveto))
    except:
        print 'split image failed'
        return False
    return True;

def name_to_point(imgname):
    imgname = imgname.rsplit('.', 1)[0]
    point = map(float, imgname.split('_')[-2:])
    point.reverse()
    return tuple(point)

def mean_gap(points):
    acc = 0.0
    prev = points[0]

    for p in points:
        acc += p[0] - prev[0]
        prev = p

    return acc / (len(points)-1)

def predict_from_matrix(x):
    m = np.size(x, 0)
    ones = np.ones(m)
    add_ones = lambda matrix: np.asmatrix(np.insert(matrix, 0, ones, 1))

    h1 = sigmoid(add_ones(x) * theta1)
    h2 = sigmoid(add_ones(h1) * theta2)
    # NOTICE: python index start at 0, but octave start as 1
    return h2.argmax(1)

def predict_from_image(imgpath):
    x = np.asmatrix(imread(imgpath).flatten(1))
    ascii_num = predict_from_matrix(x) + ord('0')

    if ascii_num > 255:
        return ''
    else:
        return chr(ascii_num)

def predict(filepath):
    try:
        saveto = os.path.basename(filepath).split('.')[0]
        saveto = os.path.join(config.upload_folder, saveto)
    except:
        return ''

    if split_to_chars(filepath, saveto):
        imgnames = filter(lambda name: name.endswith('.bmp'), os.listdir(saveto))
        predicts = {}

        for imgname in imgnames:
            imgpath = os.path.join(saveto, imgname)
            point = name_to_point(imgname)
            predicts[point] = predict_from_image(imgpath)

        keys = sorted(predicts.keys())
        prev = keys[0]
        mgap = mean_gap(keys)
        predict = ''

        for k in keys:
            if k[0] - prev[0] > 1.2 * mgap:
                predict += ' '
            predict += predicts[k]
            prev = k

        return predict
    else:
        return ''


if __name__ == '__main__':
    import sys
    if len(sys.argv) < 2:
        print 'Usage: %s image_path' % (sys.argv[0])
    else:
        imgpath = sys.argv[1]
        print predict(imgpath)