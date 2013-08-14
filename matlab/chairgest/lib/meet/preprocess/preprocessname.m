function preprocessName = preprocessname(preprocess)
if isempty(preprocess)
  preprocessName = 'feature';
else
  preprocessName = cellfun(@func2str, preprocess, 'UniformOutput', false);
  preprocessName = strjoin(preprocessName, '-');
end