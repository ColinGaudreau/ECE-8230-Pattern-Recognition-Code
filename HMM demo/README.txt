This is a very rough demo for single word recognition using HMM.

This uses the AN4 database of voice recordings.  Note that only 5 words are used, so there are two bash scripts which move the necessary recordings to the desired location for training.

1. Place the “get_test.sh” and “get_training.sh” in the “etc” directory of the AN4 directory.

2. Run these, and input the file path to where the “data” (for training) and “test” (for testing) directories are located (this must be in the same directory as the “.m” files.

You will also need a few MATLAB toolboxes (may eventually add my own implementation HMM).