dirname = 'H:\yingyin\chairgest-saliencexsens4';
data = prepdatachairgest(dirname, 'gtSensorType', 'Xsens', 'subsampleFactor', 1);
combinedData = {combinedata(data)};
savevariable(fullfile(dirname, 'data.mat'), 'data', combinedData);
%split = getsessionsplit(dirname, 'Kinect');
split = getusersplit(data, 3);
hyperParam = hyperparamchairgest(combinedData{1}.param, 'dataFile', 'data', ...
  'nM', 6);
jobParam = jobparam;
runexperimentbatch(combinedData, split, hyperParam, jobParam);
%outputchairgest(dsKinectXsens{1}, job247_output, 'hmm-nM-6-247-1session1user', 'yingyin', gesturelabel)