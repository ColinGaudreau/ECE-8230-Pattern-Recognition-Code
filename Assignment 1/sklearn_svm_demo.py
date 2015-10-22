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
from sklearn.svm import SVC

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
		for i in range(0,number_desired,1):
			img = []
			for j in range(0,num_row,1):
				row = [struct.unpack('>B', imfile.read(1))[0] for k in range(0,28,1)]
				img.append(row)
			loaded_images = np.append(loaded_images, np.array([img]), axis=0)
			if not i % 100 or i == number_desired - 1:
				sys.stdout.write("\r%.2f%%" % (float(i+1)/float(number_desired) * 100.0))
				sys.stdout.flush()

		print '\nFinished loading images'

		imfile.close()

	# read label file
	with open(labels, 'rb') as lbfile:
		lbfile.read(4) # magic number
		num_labels = struct.unpack('>i', lbfile.read(4))[0]
		number_desired = min(number_desired, num_labels) 
		loaded_labels = np.array([struct.unpack('>B', lbfile.read(1))[0] for i in range(0,number_desired,1)])

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
train_data, train_labels = load_data('train-images-idx3-ubyte', 'train-labels-idx1-ubyte')

train_data = reshape_image_data(train_data)
clf = SVC()
print 'Training data...'
clf.fit(train_data, train_labels)

del train_data, train_labels

print 'Fetching test data'
test_data, test_labels = load_data('t10k-images-idx3-ubyte', 't10k-labels-idx1')

test_data = reshape_image_data(test_data)

print 'Calculating score...'
print clf.score(test_data, test_labels)