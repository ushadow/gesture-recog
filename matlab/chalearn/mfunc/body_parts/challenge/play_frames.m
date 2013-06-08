function play_frames(figno, fps, frames, start, finish)

figure(figno);

tic;

for i=start:finish
  frame = frames{i};
  frame = frame(:,:, 1);
  imshow(color_code(double(frame)));
  drawnow;
  time_elapsed = toc;
  time_needed = (i-start+1) * 1 / fps;
  time_remaining = time_needed - time_elapsed;
  if (time_remaining > 0)
    pause(time_remaining);
  end
end

