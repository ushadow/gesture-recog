function accuracy = evalsegmentation(data, nRest)

split = data.split;
restNDX = 13;
nfolds = size(split, 2);
result = zeros(1, nfolds);
for i  = 1 : nfolds
Ytrain = data.Y(split{1, i});
Xtrain = data.X(split{1, i});
model = trainsegment(Ytrain, Xtrain, restNDX, nRest);

Ytest = data.Y(split{2, i});
Xtest = data.X(split{2, i});
seg = testsegment(Xtest, model);

Ytest = cell2mat(Ytest);
Ytest = Ytest(1, :) == restNDX;
seg = cell2mat(seg);
result(i) = length(find(Ytest == seg)) / length(seg);
end
accuracy = mean(result);
end