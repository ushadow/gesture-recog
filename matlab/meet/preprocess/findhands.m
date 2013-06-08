function hand = findhands(depthVideo)

nframe = length(depthVideo);
hand = cell(1, nframe);
firstFrame = depthVideo(1).cdata;
h = figure;
for i = 1 : nframe
  frame = depthVideo(i).cdata;
  hand1 = detect_hand(frame, firstFrame);
  hand{i} = hand1;
  imdisplay(frame, h, 'BODY PART ANNOTATIONS (automatic)'); hold on
  if ~isempty(hand1.bounding_box)
    box = hand1.bounding_box;
    rect = [box.left, box.top, box.right - box.left, box.bottom - box.top];
    rectangle('Position', rect, 'EdgeColor', 'g', 'Linewidth', 2);
  end
end