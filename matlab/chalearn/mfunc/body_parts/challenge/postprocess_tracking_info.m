function result = postprocess_tracking_info(tracking_info, parameters)

result = tracking_info;
if (~isfield(tracking_info, 'hand_info'))
  return;
end

hand_info = tracking_info.hand_info;
right_position = hand_info.right_position;
if (numel(right_position) == 0)
  return;
end

face_info = tracking_info.face_info;
magnification_factor = parameters.magnification_param / face_info.height;

% set center of face as origin
right_normalized = right_position - [face_info.row, face_info.col, face_info.depth];

% convert depth to same units as pixels
right_normalized(3) = right_normalized(3) / magnification_factor;

% normalize length units based on size of face.
right_normalized = right_normalized / face_info.height;

result.hand_info.right_normalized = right_normalized;