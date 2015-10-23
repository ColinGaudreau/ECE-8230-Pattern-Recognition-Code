'''
These are utility functions written for the sklearn demo that I
did as part of the ECE 8230 (Pattern Recognition) course for 
Assignment 1.
'''
import struct
import numpy as np
import pdb
import sys
import time
from sklearn.svm import LinearSVC, SVC

def load_data(images, labels, number_desired=float('inf'), reshape=True):
	'''
	This function reads the data files that you can download from 
	http://yann.lecun.com/exdb/mnist/.
	'''
	loaded_images = None
	loaded_labels = None

	# read image file
	with open(images, 'rb') as imfile:
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
	with open(labels, 'rb') as lbfile:
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


print 'Fetching training data'
train_data, train_labels = load_data('train-images-idx3-ubyte', 'train-labels-idx1-ubyte', 6000)

train_data = reshape_image_data(train_data)

# Choose type of Kernel
# clf = LinearSVC() # choose this for linear
# clf = SVC(kernel='rbf') # radial basis, takes a LOONNNNNNNGGGGGGGG time
clf = SVC(kernel='poly', degree=2) # poly

print 'Training data...'
clf.fit(train_data, train_labels)

del train_data, train_labels

print 'Fetching test data'
test_data, test_labels = load_data('t10k-images-idx3-ubyte', 't10k-labels-idx1-ubyte')

test_data = reshape_image_data(test_data)

print 'Calculating score...'
print clf.score(test_data, test_labels)