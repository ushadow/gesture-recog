% Analyzes how a line of pixels in an image look like over time. Plots a 3D
% diagram of pixel values over frames and pixel column positions.
%
% Args:
%   filename: full path name of the file to read.
%   columnStart (optional): column index of the start of the line to 
%       analyze. Defaults to be 1.
%   columnEnd (optional): column index of the end of the line to analyze. 
%       Defaults to be the maximum width of the frame.
%   columnSampleRate (optional): plots the pixel value every column sample 
%       rate. Defaults to be every other 10 columns.
%   frameSampleRate (optional): plots the data every frame sample rate.
%       Defaults to be every other 10 frames.
function analyzeline(filename, columnStart, columnEnd, ...
                       columnSampleRate, frameSampleRate)
  depth_range = [1150 1200];
  M = dlmread(filename);
  % The first column is the frame id.
  frameid = M(:, 1);
  M(:, 1) = [];
  
  nframeCol = size(M, 2);
  
  if nargin < 2
    columnStart = 1;
  end
  
  if nargin < 3 || columnEnd > nframeCol
    columnEnd = nframeCol;
  end
  
  if nargin < 4
    columnSampleRate = 10;
  end
  
  if nargin < 5
    frameSampleRate = 10;
  end
  
  colRange = columnStart: columnSampleRate : columnEnd;
  M = M(1 : frameSampleRate : end, colRange);
  frameid = frameid(1 : frameSampleRate : end, :);
  
  [nrow, ncol] = size(M);
  fprintf('Number of frames: %d\n', nrow);
  
  
  plot3(repmat(colRange, nrow, 1), repmat(frameid, 1, ncol), M);
  axis([colRange(1) colRange(end) frameid(1) frameid(end) ... 
        depth_range(1) depth_range(2)]); 
  xlabel('Pixel column position');
  ylabel('Frame');
  zlabel('Depth');
  title('Line Analysis');
end