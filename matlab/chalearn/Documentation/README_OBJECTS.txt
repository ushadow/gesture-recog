

            GROP: Gesture Recognition Object Package

		BETA VERSION

		June 15, 2012
    
             Copyright (c) CHALEARN, 2011-2012
     http://gesture.chalearn.org -- events@chalearn.org
                                   
 -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-

DISCLAIMER: ALL INFORMATION, SOFTWARE, DOCUMENTATION, AND DATA ARE PROVIDED "AS-IS" BY CHALEARN, A CALIFORNIA NON-FOR-PROFIT. THE CONTRIBUTORS DISCLAIM ANY EXPRESSED OR IMPLIED WARRANTIES INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR PURPOSE, AND THE WARRANTY OF NON-INFRIGEMENT OF ANY THIRD PARTY'S INTELLECTUAL PROPERTY RIGHTS. IN NO EVENT SHALL ISABELLE GUYON AND/OR OTHER CONTRIBUTORS BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF DATA, SOFTWARE, DOCUMENTS,MATERIALS, PUBLICATIONS, OR INFORMATION MADE AVAILABLE FOR THE CHALLENGE. 

 -o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-|-o-

There are only 2 types of Matlab objects in this package:
1) data
2) model

Release notes:
New in this release, 
- databatch and result objects have now a property "cuts" that stores temporal segmentation of movies into individual gestures. It is a cell array of length the number of movies. Each element is a matrix of n line and 2 columns, n being the number of cuts, and the columns representing beginning and and of a gesture.
- result objects can now hold intermediate results (new movie representations) in the property X, which is a cell array of dimension the number of movies. Each element hold a matrix of dimension (p, n), p is the number of frames and n the number of features. It is possible to also reduce the number of frames as desired, down to one frame per gesture, eventually.
- model objects can now be "chained", e.g. you can sequentially process data with a segmented, a preprocessor, and a recognizer. See for example the objects:
basic_recog (the analogous of recog_template in the previous release)
principal_motion (the same algorithm as before, but broken down into pieces)
- we provide a new algorithm: Dynamic Time Warping, which allows you to do both recognition and segmentation. It comes in several flavors:
dtw_recog: does both recognition and segmentation
dtw_prepro: runs only the preprocessor
dtw_segment: runs only the segmented.

---------------------------
	DATA OBJECTS
---------------------------
Data objects allow you to browse though data. There are two flavors of data objects holding movies or patterns with variable length feature representations:
- databatch: Hold the raw data. One reads the movies directly from disk to avoid using too much memory. 
- result: Stores either results of recognition or intermediate preprocessing results.
- [There is another kind of data object called "data" that stores fixed length data representations (not used in this release).]

All data objects have the following methods:
==> a constructor, taking as argument either a directory name or another data object (from which to copy information):
D=databatch('mydir');
R=result(D);
==> a method to create subsets of a dataset called "subset":
Dtr=subset(D, 1:D.vocabulary_size); % Uses the first few movies as training data
==> methods to set/get cuts (temporal segmentation points)
set_cuts(D, 20, [1 22; 24 45; 48 57]); % set the start and end cu points for movie number 22
my_cuts=get_cut(D, 20);
==> a method to get a pattern:
my_movie=get_X(D, 6); % get the 6th movie
my_clip=get_X(D, 20, 2); % get the 2nd gesture in the 20th movie (assumes that a temporal segmentation exists)
==> a method to get the labels/truth values:
Y=get_Y(D, 6);
==> lower level methods to move into the databatch: goto, next, prev.
==> a method to visualize the current pattern: show.
==> methods to find the number of patterns, number labels, current movie number: length, labelnum, num.

For "result" data objects only:
==> set_X and set_Y to set pattern and label values. IMPORTANT: in "result", Y always hold to truth values. X holds either the transformed data representation or the predicted labels.
==> methods to score the predicted labels: s=length_score(D) and s=leven_score(D).
==> a method to save the results: save.


---------------------------
	MODEL OBJECTS
---------------------------

Model objects are trainable models, which operate on data objects. They have at least 3 methods "train", "exec" and "test". They are of 3 kinds:
1) prepro: preprocessing. They transfer X into another representation.
	a) segment: temporal segmentation, changes only the property "cuts"
	b) only preprocessing: changes only the property "X"
	c) general preprocessing: change both "cuts" and "X"
2) recog: recognizer. They transform X into predicted labels.
3) group: a combination of several models. for the moment we provide the "chain" object that combines models sequentially by processing data one after the other.
basic_recog=chain({basic_segment, basic_prepro, template_matching});
principal_motion=chaln({dtw_segment, motion_prepro, pca_recog});

The methods train and test act on data objects (entire datasets):
[my_new_data, my_trained_model]=train(model, data);
my_new_data=test(model, data);

The method exec processes only one sample at a time:
[scores, cuts] = exec(model, pattern, cuts);
It allows us to make calculations on "chain" objects more memory efficient by never holding in memory intermediate data representations of the whole dataset.

If you want to write your own models, you can use as examples:
basic_segment
basic_prepro
template_matching



