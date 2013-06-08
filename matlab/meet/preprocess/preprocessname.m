function preprocessName = preprocessname(preprocess)
preprocessName = cellfun(@func2str, preprocess(1 : end - 1), ...
                        'UniformOutput', false);
preprocessName = strjoin(preprocessName, '-');
end