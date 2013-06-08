

--- STIP implementation v1.0 --- (18-06-2008)
http://www.irisa.fr/vista/Equipe/People/Laptev/download/stip-1.0.zip

Authors:
========
This code was developed in 2006-2008 jointly at INRIA Rennes 
(http://www.irisa.fr/vista) and IDIAP (www.idiap.ch) under supervision
of Ivan Laptev and Barbara Caputo. The code is provided as-it-is without
any warranty. For questions and bug reports contact Ivan Laptev 
(ivan.laptev@inria.fr)

General:
========
The code in this directory detects Space-Time Interest Points (STIPs)
and computes corresponding local space-time descriptors. The currently
implemented detector resembles the extended space-time Harris detector
described in [Laptev IJCV'05]. The code does not implement scale selection
but detects points for a set of multiple combinations of spatial and
temporal scales. This simplification appears to produce similar 
(or better) results in applications (e.g. action recognition) while 
resulting in a considerable speed-up and close-to-video-rate run time.

The currently implemented types of descriptors are HOG (Histograms of
Oriented Gradients) and HOF (Histograms of Optical Flow) computed on 
a 3D video patch in the neighborhood of each detected STIP. The patch
is partitioned into a grid with 3x3x2 spatio-temporal blocks; 4-bin HOG
descriptors and 5-bin HOF descriptors are then computed for all blocks
and are concatenated into a 72-element and 90-element descriptors 
respectively.

Input/Output:
=============
The input can be either a video file (supported either by Windows video
codecs or ffmpeg library under Linux) or a video stream from the camera
supported by OpenCV camera interface. For a video input the frame interval
for processing can be specified. The position and descriptors of detected
STIPs will be saved in a text format. Run "./bin/stipdet --help" to get
further details.

Dependencies:
=============
OpenCV library (http://www.intel.com/technology/computing/opencv/)
On Linux OpenCV must be compiled with ffmpeg support, see e.g.:
http://www.comp.leeds.ac.uk/vision/opencv/install-lin-ffmpeg.html

Running
=======
There are two executables in ./bin directory
./bin/stipdet     : detection and saving of STIP features
./bin/stipshow    : visualization of STIP points with optional video dump
Run "./bin/stipdet --help" and "./bin/stipshow --help" to learn about the
format of command line I/O parameters.

Evaluation:
===========
This STIP version has been tested on KTH action recognition benchmark
(http://www.nada.kth.se/cvap/actions). The results are comparable to
the ones reported in [Laptev et al. CVPR 2008] and to the date (June 2008)
correspond to the best known performance on KTH dataset. We evaluated
the features using single channel Bag-of-Features SVM classification 
framework as in [Laptev et al. CVPR 2008]. Average accuracy for
action recognition on KTH dataset using different descriptors in
this package are as follows:
hog: 80.5%
hof: 90.6%
hoghof: 91.3%
(hoghof is a concatenation of hog and hof descriptors) 

Example 1 (detection):
======================

>./bin/stipdet -f ./data/walk-simple.avi -o ./data/walk-simple-stip.txt
Options summary:
  video input:     data/walk-simple.avi
  frame interval:  0-100000000
  output file:     data/walk-simple-stip.txt
  #pyr.levels:     3
  init.pyr.level:  0
  patch size fct.: 5
  descriptor type: hoghof
Fame:    20 - IPs[this: 0, total:   0] - Perf: Avg FPS=9.7
Fame:    40 - IPs[this: 6, total:  63] - Perf: Avg FPS=9.6
Fame:    60 - IPs[this: 5, total: 110] - Perf: Avg FPS=9.6
Fame:    80 - IPs[this: 1, total: 161] - Perf: Avg FPS=9.6
Fame:   100 - IPs[this: 0, total: 203] - Perf: Avg FPS=9.6
-> detected 242 points

Example 2 (visualization):
==========================

>./bin/stipshow -v ./data/walk-simple.avi -f ./data/walk-simple-stip.txt -o ./data/walk-simple-stip.avi
Input video:   data/walk-simple.avi
Input features:data/walk-simple-stip.txt
load 243 features from data/walk-simple-stip.txt
Output #0, avi, to 'data/walk-simple-stip.avi':
  Stream #0.0: Video: mpeg4, 160x120, 25.00 fps, q=2-31, 800 kb/s

Links
=====
Action recognition page and related papers using STIP features:
http://www.irisa.fr/vista/actions

