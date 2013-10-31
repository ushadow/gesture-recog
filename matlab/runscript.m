%dirname = 'G:\stand';
%data = prepdata(dirname);
%combinedData = {combinedata(data)};
%savevariable(fullfile(dirname, 'data.mat'), 'data', combinedData);
%split = getalltrainsplit(combinedData{1});
%jobParam = jobparam;
hyperParam = hyperparam(combinedData{1}.param, 'dataFile', 'data');
R = runexperiment(hyperParam, split, 1, 1, 0, combinedData{1});
%runexperimentbatch(combinedData, split, hyperParam, jobParam);
%outputchairgest(dsKinectXsens{1}, job247_output, 'hmm-nM-6-247-1session1user', 'yingyin', gesturelabel)