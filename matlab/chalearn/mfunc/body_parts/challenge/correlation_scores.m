function frame_scores = correlation_scores(first, second)

% function frame_scores =_correlation_scores(first, second)
%
% returns the matrix of normalized cross correlation scores between
% each frame of the first sequence and each frame of the second sequence

first_frames = numel  (first);
second_frames = numel (second);
frame_scores =  zeros (first_frames, second_frames);

for first_index = 1: first_frames
  first_frame = first{first_index};
  first_frame = first_frame(:);
  for second_index = 1: second_frames
    second_frame = second {second_index};
    frame_scores(first_index, second_index) = normalized_crosscorrelation(first_frame, second_frame(:));
  end
end

frame_scores(isnan(frame_scores)) = 0;
