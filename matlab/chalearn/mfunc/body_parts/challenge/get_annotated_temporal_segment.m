function [annotated class_labels] = get_annotated_temporal_segment(dataset_name, sequence)
    load( sprintf('H:/Work/Gesture Challenge/Data/annotation/start_end_frames/%s.mat', dataset_name));
    annotated = saved_annotation{sequence};
    class_labels = truth_labels{sequence};
end