

            SAMPLE CODE FOR ROUND 2 OF THE
                 
      ONE-SHOT-LEARNING CHALEARN GESTURE CHALLENGE

		VERSION II

		June 15, 2012
    
             Copyright (c) CHALEARN, 2011-2012
     http://gesture.chalearn.org -- events@chalearn.org
                                   
 -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-

DISCLAIMER: ALL INFORMATION, SOFTWARE, DOCUMENTATION, AND DATA ARE PROVIDED "AS-IS" BY CHALEARN, A CALIFORNIA NON-FOR-PROFIT. THE CONTRIBUTORS DISCLAIM ANY EXPRESSED OR IMPLIED WARRANTIES INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR PURPOSE, AND THE WARRANTY OF NON-INFRIGEMENT OF ANY THIRD PARTY'S INTELLECTUAL PROPERTY RIGHTS. IN NO EVENT SHALL ISABELLE GUYON AND/OR OTHER CONTRIBUTORS BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF DATA, SOFTWARE, DOCUMENTS,MATERIALS, PUBLICATIONS, OR INFORMATION MADE AVAILABLE FOR THE CHALLENGE. 

 -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-

Permission is granted to the challenge participants to use the data for the one-shot-learning gesture challenge. Redistribution of the data in its original or modified form must be accompanied by this notice. The data may be use for research purpose only. Permission to use the data for commercial purpose must be requested at events@chalearn.org.

The data are found at: http://gesture.chalearn.org/data

If you want to cite the data, please use:

"ChaLearn Gesture Dataset (CGD2011), ChaLearn, California, 2011"

 -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-

DATA:

The data are organized in subdirectories "typeXX", called "baches", where type is either "devel", "valid", or final and XX is the batch number. The prefix "devel" means that the data may be used for development purpose: we provide all truth labels for such data. The prefix "valid" means that the data may be used for validation: we provide only the training labels. The prediction results may be submitted to the website of the challenge to get feed-back on performance. The prefix "final" means final evaluation data.

WARNING: The data batches final01-20 are the final evaluation batches for ROUND 1. The ROUND 2 batches are final21-40. They have NOT been distributed yet.

Each data "batch" includes the recordings of 100 gestures as RGB videos (M_x.avi) and depth videos (K_x.avi) recorded with a Kinect (TM) camera. There are 47 pairs of {M_x.avi, K_x.avi} movies, including sequences of 1 to 5 gestures. The gestures in one batch are performed by a single user. They are instances of N unique gestures from a vocabulary of 8 to 15 gestures. The training labels are in a comma separated file called typeXX_train.csv and the test labels in typeXX_test.csv, with the row ID in the first column and the labels separated by spaces in the scond column.

There is a single labeled training example of each gestures of the vocabulary of a given batch. The goal of the challenge is, for each batch, to train a system on the training examples, and to make predictions of the labels for the test examples.

VIDEO FORMAT:

The videos are formatted is a quasi-lossless compressed AVI format. The compression was performed with FFMPEG http://ffmpeg.org/, using:
ffmpeg -i original.avi -sameq compressed.avi

We also provide lossy compressed data for easier download. The compression was performed with FFMPEG using:
ffmpeg -i original.avi -qscale num compressed.avi
where num is the compression quality.

Compressed file can be read with one of many readers available for free, including SMplayer http://smplayer.org/. From Matlab, you may use mmreader or mmread.

The Kinect depth images were produced after a normalization f(x)=(x-mini)/(maxi-mini), where mini is the minimum distance to the camera and maxi the maximum distance to the camera for an entire batch, The table of normalization constants is given in the file Depth_info.txt.

mini: Minimum distance to the camera.
maxi: Maximum distance to the camera.
acc: Accuracy with which the depth is known: (0) Mediocre. (1) Good. (2) Very good. Depending on the version of our recording software.
miss: Number of missing files.

Note: All validation files and all final evaluation file (to be distributed later) have acc=2.

SUBMISSION FORMAT:

-- Results:
The predictions of the missing test labels must be returned in the same csv format as the labels are provided, all concatenated in a single file. For final testing, new batches will be provided to registered participants shortly before the end of the challenge.

-- Code:
Code may be submitted together with the results for verification purpose. We provide the function prepare_final_resu.m as an example of how we would like you to prepare code for final submission.

Detailed instructions are found at:
http://www.kaggle.com/c/gesture-challenge-2/details/SubmissionInstructions

 -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-

SAMPLE MATLAB (R) CODE:

The directory Sample_code contains Matlab code to browse through the data, run experiments, and format the results for submission.

The main point of entry is main.m. You must edit the top to make sure the code finds the functions and data needed. From the Sample_code directory, type at the Matlab prompt:
> main;

To simply browse through the data, use:
> browse;

Some of the most useful objects and functions:

@databatch: An object to load a data batch. Usage: D=databatch(dirname); browser('D');

@basic_recog: A very simple example of recognizer based on template matching. Usage: [tr_resu, mymodel] = train(basic_recog, Dtr); te_resu = test(mymodel, Dte); show(mymodel); tr_resu and te_resu are @result objects.

@result: An object to store results. Usage: save(te_resu, dirname);

We also provide a new example of recognizer almost as simple as basic_recog called principal_motion, but performing better, as a new baseline method for round 2.

New in this release:
models can be chained. See README_OBJECTS.txt

 -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-
