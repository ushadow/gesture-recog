dirname = 'G:\salience';
data = prepdata(dirname);
combinedData = {combinedata(data)};
savevariable(fullfile(dirname, 'data.mat'), 'data', combinedData);
split = getalltrainsplit(combinedData{1});
hyperParam = hyperparam(combinedData{1}.param, 'dataFile', 'data');
jobParam = jobparam;
%runexperimentbatch(combinedData, split, hyperParam, jobParam);
%outputchairgest(dsKinectXsens{1}, job247_output, 'hmm-nM-6-247-1session1user', 'yingyin', gesturelabel)