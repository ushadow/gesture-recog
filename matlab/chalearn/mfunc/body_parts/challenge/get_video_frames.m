function [result fps] =  get_video_frames(filename)

  obj = mmreader(filename);
  frames = read(obj);
  number_of_frames = size(frames, 4);
  result = cell(number_of_frames, 1);
  for i = 1:number_of_frames
    result{i} = frames(:,:,1,i);
    result{i}(result{i} <= 5) = 0;
  end
  fps = obj.FrameRate;
end