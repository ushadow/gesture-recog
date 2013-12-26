function output = addone(output)
output.prediction.Va = cellfun(@(x) addone1(x), output.prediction.Va, 'UniformOutput', false);
output.prediction.Tr = cellfun(@(x) addone1(x), output.prediction.Tr, 'UniformOutput', false);
end

function x = addone1(x)
x(x < 13) = x(x < 13) + 1;
end