function viewspeed(X, frame, param)
WSIZE = 15;

nFrames = size(X, 2);
pos = X(1 : 3, :);
speed = computespeed(pos, frame);

smoothedPos = smoothts(pos, 'b', round(WSIZE / param.kinectSampleRate));
smoothedSpeed = computespeed(smoothedPos, frame);
plot(1 : nFrames, speed, 1 : nFrames, smoothedSpeed, 'r');
axis([1 nFrames 0 0.1]);
end