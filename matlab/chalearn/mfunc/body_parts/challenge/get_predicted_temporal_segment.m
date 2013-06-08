function pr = get_predicted_temporal_segment(dataset_name, sequence)
    load( sprintf('D:/Plabuu/Work/Gesture Challenge/annotation/start_end_frames/%s.mat', dataset_name), 'predicted');
    pr = predicted{sequence};
end