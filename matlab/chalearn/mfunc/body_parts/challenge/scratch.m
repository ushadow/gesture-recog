cd c:\users\athitsos\home\code\matlab\source\challenge;
paths;

%%

%clear all;

%dn = 'Amber_Miller_TractorOperationSignals_2011_10_07_12_58';
%dn = '2011_10_22_uncompressed/Collected_data15c/Daisy_Martinez_DivingSignals4_2011_09_30_09_10';
dn = '2011_10_22_uncompressed/Collected_data16c/Jorge-Alberto_Molina_SwatHandSignals1_2011_10_03_13_36';

ds = load_dataset(dn);
K = get_depth_frames(ds, 'tr', 8);

parameters = set_parameters(K{1});
depth_frame = double(K{1});

% detect the face
first_tracking_info = initial_tracking_info(depth_frame, parameters);
current_tracking_info = first_tracking_info;
previous_tracking_info = current_tracking_info;
frame_number = 1;

%%

%frame_number = 8; current_tracking_info = first_tracking_info;
%frame_number = 30; current_tracking_info = previous_tracking_info;
frame_number = frame_number+1;
disp(sprintf('frame_number = %d', frame_number));

current = double(K{frame_number});
figure(1); imshow(current, []);
figure(2); imshow(color_code(current));
figure(3); imshow(depth_edges(current, parameters.depth_edge_low, parameters.depth_edge_high), []);
previous_tracking_info = current_tracking_info;

tic; 
[imgi, current_tracking_info] = find_hand_initial2(current, previous_tracking_info, parameters); 
toc;

center = current_tracking_info.hand_info.right_position;
figure(4); imshow(imgi, []);

if (size(center, 1) > 0)
  disp(sprintf('frame_number = %d, score value = %10.1f', frame_number, current_tracking_info.hand_info.right_score));
end

%%

tic;
ti = ti+1; depth_frames = get_depth_frames(ds, 'te', ti); 
[labels, starts, finishes] = spot_gestures(depth_frames, ds, parameters); 
[labels, starts, finishes]
ds.test.class_ids{ti}
toc;
