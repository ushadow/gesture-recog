function res = evalsvm(data, param)
dataNdx = 3 : 4;
Ytrue = data.Y(dataNdx);
Ytrue = cellfun(@(x) mask(x), Ytrue, 'UniformOutput', false);

Ystar = cellfun(@(x) x(end, :), data.X(dataNdx), 'UniformOutput', false);
res = f1(Ytrue, Ystar, param);
end

function Y = mask(Y)
Y(1, Y(1, :) <= 4) = 4;
end