function extractfeature(dirname, outputDir)
exeDir = fullfile(pwd, 'lib', 'preprocess');
preprocessExe = fullfile(exeDir, 'Preprocess.exe');
command = sprintf('%s -i=%s -o=%s -p=1-17', preprocessExe, dirname, outputDir);
system(command);
end