function depthFrame = readDepthFrame(fileName);

% Read kinect generated depth frame
% fileName = 'depthFrame_01.04.59.9456706.dat';

frameWidth = 320;
frameHeight = 240;

fid = fopen(fileName);
byteArrayLength = frameWidth*frameHeight*2;
data = fread(fid, byteArrayLength, '*uint8');

% Convert kinect depth byte array to real distance values (from 800mm to
% 4500mm)
dist = zeros(byteArrayLength/2, 1);
for i=0:2:byteArrayLength-2
    dist(i/2+1) = bitor(bitshift(uint16(data((i+1)+1)), 5), bitshift(uint16(data((i+1))), -3));
end

% Conver distance values to 2D (frameWidth*frameHeight) image
depthFrame = zeros(frameHeight, frameWidth);
for i=1:frameHeight
    for j=1:frameWidth
        depthFrame(i,j) = dist((i-1)*frameWidth+j);
    end
end

