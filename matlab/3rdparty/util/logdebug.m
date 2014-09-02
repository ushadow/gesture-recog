function logdebug(funcName, valName, val)
if ischar(funcName) && ischar(valName)
  disp([funcName ': ' valName '=']);
  disp(val);
else
  disp('The first two arguments have to be string.');
end
end
  