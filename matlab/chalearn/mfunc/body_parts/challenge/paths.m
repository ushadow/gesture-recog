restoredefaultpath;
clear all;
clear java;

run ../../local/directories;
[matlab_base, simple, temp] = fileparts(code_directory);
[code_base, simple, temp] = fileparts(matlab_base);

addpath(sprintf('%s/challenge', code_directory));
addpath(sprintf('%s/local', matlab_base));
addpath(sprintf('%s/detection', code_directory));
addpath(sprintf('%s/utilities', code_directory));
addpath(sprintf('%s/kinect', code_directory));
%addpath(sprintf('%s/strings', code_directory));

% here I am just storing all the dataset names, for quick access.

% all_dataset_names = {
% '2011_09_08_kinect/I_A_ChineseNumbers_2011_09_07_12_01';
% '2011_09_08_kinect/I_A_MusicNotes_2011_09_07_10_46';
% '2011_09_08_kinect/I_A_TaxiSouthAfrica_2011_09_07_13_24';
% '2011_07_24_data/Jerome_Noriot_ChineseNumbers_2011_05_29_01_28';
% '2011_07_24_data/Jerome_Noriot_DivingSignals1_2011_05_29_02_10';
% '2011_07_24_data/Jerome_Noriot_DivingSignals2_2011_05_13_21_02';
% '2011_07_24_data/Jerome_Noriot_DivingSignals3_2011_05_14_00_34';
% '2011_07_24_data/Jerome_Noriot_DivingSignals4_2011_05_29_00_55';
% '2011_07_24_data/Jerome_Noriot_HelicopterSignals_2011_05_18_23_09';
% '2011_07_24_data/Jerome_Noriot_ItalianGestures_2011_05_24_01_34';
% '2011_07_24_data/Jerome_Noriot_Mudra1_2011_05_10_02_16';
% '2011_07_24_data/Jerome_Noriot_Mudra2_2011_05_24_02_14';
% '2011_07_24_data/Jerome_Noriot_MusicNotes_2011_05_24_00_59';
% '2011_07_24_data/Jerome_Noriot_RefereeVolleyballSignals1_2011_05_26_23_34';
% '2011_07_24_data/Jerome_Noriot_RefereeVolleyballSignals2_2011_05_27_00_11';
% '2011_07_24_data/Jerome_Noriot_SurgeonSignals_2011_05_27_00_48';
% '2011_07_24_data/Jerome_Noriot_TaxiSouthAfrica_2011_05_27_01_22';
% '2011_07_24_data/Jerome_Noriot_TractorOperationSignals_2011_05_27_01_33';
% }


