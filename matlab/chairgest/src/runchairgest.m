dirname = 'D:\chairgest-kinectxsens';
data = prepdatachairgest(dirname, 'gtSensorType', 'Xsens', 'subsampleFactor', 1);
combinedData = {combinedata(data)};
savevariable(fullfile(dirname, 'data.mat'), 'data', combinedData);
sessionSplit = getsessionsplit(dirname, 'Kinect');
hyperParam = hyperparam(combinedData{1}.param, 'dataFile', 'data');
jobParam = jobparam;
runexperimentbatch(combinedData, sessionSplit, hyperParam, jobParam);
%outputchairgest(dsKinectXsens{1}, job247_output, 'hmm-nM-6-247-1session1user', 'yingyin', gesturelabel)