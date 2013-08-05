function testData = createtestdata(data)
% ARGS
% data  - struct of data

dataRange = 1 : 50;
testData.Y = data.Y(dataRange);
testData.X = data.X(dataRange);
testData.frame = data.frame(dataRange);
testData.file = data.file(dataRange);
testData.param = data.param;
testData.split = {1 : dataRange(end) - 1; dataRange(end); []};
end