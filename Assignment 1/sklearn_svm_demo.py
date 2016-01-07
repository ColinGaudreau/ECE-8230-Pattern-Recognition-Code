'''
These are utility functions written for the sklearn demo that I
did as part of the ECE 8230 (Pattern Recognition) course for 
Assignment 1.
'''
import struct
import numpy as np
import pdb
import gzip
from sklearn.svm import LinearSVC, SVC
import os.path
import requests

def load_data(images, labels, number_desired=float('inf'), reshape=True):
	'''
	This function reads the data files that you can download from 
	http://yann.lecun.com/exdb/mnist/.
	'''
	loaded_images = None
	loaded_labels = None

	# read image file
	with gzip.open(images, 'rb') as imfile:
		imfile.read(4) # magin number at start
		num_im = struct.unpack('>i', imfile.read(4))[0] # read number of images
		num_row = struct.unpack('>i', imfile.read(4))[0] # read number of rows
		num_col = struct.unpack('>i', imfile.read(4))[0] # read number of columns

		number_desired = min(number_desired, num_im)
		loaded_images = np.empty(shape=(0,num_row,num_col), dtype=int)
		frmt = 'B' * number_desired*num_row*num_col
		# Read all the desired bytes and store them in a numpy.ndarray
		loaded_images = np.reshape(np.array(struct.unpack('>' + frmt, imfile.read(number_desired*num_row*num_col))), (number_desired,num_row,num_col))

		print '\nFinished loading images'

		imfile.close()

	# read label file
	with gzip.open(labels, 'rb') as lbfile:
		lbfile.read(4) # magic number
		num_labels = struct.unpack('>i', lbfile.read(4))[0]
		number_desired = min(number_desired, num_labels) 
		frmt = 'B' * number_desired
		loaded_labels = np.array(struct.unpack('>' + frmt, lbfile.read(number_desired)))

		print '\nFinished loading labels'

		lbfile.close()

	# make sure label and image have same length
	if loaded_images is not None and loaded_labels is not None:
		final_count = min(loaded_images.shape[0], loaded_labels.shape[0])
		return loaded_images[:final_count], loaded_labels[:final_count]

def reshape_image_data(im):
	'''
	Using pixels as features, so have to reshape it so that the nxm image is instead just a 1x(n*m)
	feature vector (this is just quick and dirty).
	'''
	return np.reshape(im, (im.shape[0], im.shape[1]*im.shape[2]))

def get_mnist_data(files):
	BASE_URL = 'http://yann.lecun.com/exdb/mnist/'
	for filename in files:
		if not os.path.isfile(files[filename]):
			with open(files[filename], 'wb') as f:
				r = requests.get(BASE_URL + files[filename], stream=True)
				shutil.copyfileobj(r.raw, f)
				f.close()


MNIST_FILES = {
	'training_images': 'train-images-idx3-ubyte.gz',
	'training_labels': 'train-labels-idx1-ubyte.gz',
	'test_images': 't10k-images-idx3-ubyte.gz',
	'test_labels': 't10k-labels-idx1-ubyte.gz',
}

get_mnist_data(MNIST_FILES)

print 'Fetching training data'
train_data, train_labels = load_data('train-images-idx3-ubyte.gz', 'train-labels-idx1-ubyte.gz',5000)
train_data = reshape_image_data(train_data)

# Choose type of Kernel
# clf = LinearSVC() # choose this for linear
# clf = SVC(kernel='rbf') # radial basis, takes a LOONNNNNNNGGGGGGGG time and sucks
clf = SVC(kernel='poly', degree=2) # poly

print 'Training data...'
clf.fit(train_data, train_labels)

del train_data, train_labels

print 'Fetching test data'
test_data, test_labels = load_data('t10k-images-idx3-ubyte.gz', 't10k-labels-idx1-ubyte.gz')

test_data = reshape_image_data(test_data)

print 'Calculating score...'
print clf.score(test_data, test_labels)

import cv2
try:
	import cv2
	im = cv2.imread('two.jpg', cv2.CV_LOAD_IMAGE_GRAYSCALE)
	im = np.reshape(im, (1,im.shape[0]*im.shape[1]))
	print 'Prediction for my hand writing (2):'
	print clf.predict(im)
except:
	print 'OpenCV python wrapper not in python path, so couldn\'t do demo with my handwriting'
