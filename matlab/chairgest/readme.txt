How to run
==========

1) Start MATLAB and change the directory to the main source folder:
"chairgest-code". The "chairgestmain.m" file should be in the current directory. 
The program has been tested with MATLAB R2013a.

2) In the Command Window type:

chairgestmain(raw_data_base_folder)

where `raw_data_base_folder` is a string of the absolute path to RAW data folder
for all the users. For example: 'C:\Users\username\chairgest2013'.

3) The program takes approximately 3.5 hours to finish (Intel Core2 Quad @ 2.83GHz) 
and will output a txt file "hmm_Converted_1.txt" in the main source folder.

4) For evaluation, the Converted data folder should be used. The output file
indicates that the Datatype is Converted and the MainSensor is Xsens. 

Developement environment
========================

The program has been tested on both 64 bit and 32 bit Windowns 7 with 
MATLAB R2013a. On a machine with Intel Core2 Quad @ 2.83GHz and 3GB RAM, it takes
about 20min to finish 1 session, so the estimated time to process 10 sessions is 3.5hr.
On a machine with 32 cores, it takes 2.5hr to process 10 sessions.

Development result
==================

The result based on the development data is in the "dev-result" folder. It is based
on the model trained on all the development data and tested on all the development
data. "hmm-dev_Converted_1.txt" is the gesture recognition output of our
program, and "dev-score.txt" is the final score from the provided performance
evalucation program.
