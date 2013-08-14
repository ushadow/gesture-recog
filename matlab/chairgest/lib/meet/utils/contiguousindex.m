function runs = contiguousindex(indexVect)

indexVect = indexVect(:);
shiftVect = [indexVect(2 : end); indexVect(end)];
diffVect = shiftVect - indexVect;

transitions = find(diffVect ~= 1);
runEnd = indexVect(transitions);
runStart = [indexVect(1); indexVect(transitions(1 : end - 1) + 1)];
runs = [runStart runEnd];
end