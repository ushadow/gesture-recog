function extractfeature(dirname, outputDir)
exeDir = 'C:\Users\yingyin\workspace\tabletop\ChairGest_DataVisualizer\Preprocess\bin\Release';
preprocessExe = fullfile(exeDir, 'Preprocess.exe');
command = sprintf('%s -i=%s -o=%s -p=1-17', preprocessExe, dirname, outputDir);
system(command);
end