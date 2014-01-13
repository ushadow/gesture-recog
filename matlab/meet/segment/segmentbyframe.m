function seg = segmentbyframe(~, frame, ~, ~)
% RETURNS
% seg   - a cell array of n x 2 matrices. Each row of the matrix is the 
%     start and end index of a motion segment.

MIN_REST_FRAME_LEN = 50;
MIN_MOVE_FRAME_LEN = 50;
nSeqs =size(frame, 2);
seg = cell(1, nSeqs);
for i = 1 : nSeqs
  frame1 = frame{i};
  frameDiff = zeros(size(frame1));
  frameDiff(2 : end) = frame1(2 : end) - frame1(1 : end - 1);
  largeDiffNdx = find(frameDiff > MIN_REST_FRAME_LEN);
  seg{i} = [];
  startNdx = 1;
  largeDiffNdx(end + 1) = length(frame1) + 1; %#ok<AGROW>
  for j = 1 : length(largeDiffNdx)
    endNdx = largeDiffNdx(j) - 1;
    startFrame = frame1(startNdx);
    endFrame = frame1(endNdx);
    if (endFrame - startFrame + 1 > MIN_MOVE_FRAME_LEN)
      seg{i}(end + 1, :) = [startNdx endNdx];
    end
    startNdx = endNdx + 1;
  end
end
end