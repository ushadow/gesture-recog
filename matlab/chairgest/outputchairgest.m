function outputchairgest(data, result, algo, name)
outputDir = result.param.dir;
filename = [algo '_' result.param.dataType '.txt'];
fid = fopen(fullfile(outputDir, filename), 'w');
fprintf(fid, '#Algorithm\t%s\t%s', algo, name);
end