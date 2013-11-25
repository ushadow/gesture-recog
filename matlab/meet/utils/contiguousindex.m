function runs = contiguousindex(indexVect)
%% CONTIGUOUSINDEX finds runs of continuous indices. 
%
% An example of continuous indices is: 1 2 3 4

indexVect = indexVect(:);
shiftVect = [indexVect(2 : end); indexVect(end)];
diffVect = shiftVect - indexVect;

transitions = find(diffVect ~= 1);
runEnd = indexVect(transitions);
runStart = [indexVect(1); indexVect(transitions(1 : end - 1) + 1)];
runs = [runStart runEnd];
end