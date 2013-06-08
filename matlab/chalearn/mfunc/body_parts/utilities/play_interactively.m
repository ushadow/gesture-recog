function result = play_interactively(sequence)

frames = numel(sequence)
i = 0;
while(1);
  i = i + 1;
  if (i > frames)
    i = 1;
    disp('back to frame 1');
  else
    disp(sprintf('frame %d', i));
  end
  
  frame = sequence(i);
  if (iscell(frame))
    imshow(frame{1}, []);
  else
    imshow(frame, []);
  end
  a = input('press <enter> to continue, 1 to stop\n');
  if (a == 1)
    break;
  end
end
