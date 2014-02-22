function viewautoseg(data, index)
%% VIEWAUTOSEG view automatic segmentation of training data.
% 
% ARGS
% X - a sequence

figure;

X = data.X{index};
Y = data.Y{index};
frame = data.frame{index};
param = data.param;

nFrames = size(X, 2);
pos = X(1 : 3, :);
speed = computespeed(pos, frame);

plot(1 : nFrames, speed, 1 : nFrames, X(2, :), 'r');

ngestures = param.vocabularySize;
gestureLabel = gesturelabel();
colormap(bipolar(ngestures));
image('XData', [1, nFrames], 'YData', [0.1, 0.08], 'CData', Y);
h = colorbar;
set(h, 'YTick', 1 : ngestures);
set(h, 'YTickLabel', gestureLabel, 'FontSize', 12);

axis([1 nFrames -0.6 0.1]);
legend('smoothed speed', 'y coordinate');
end