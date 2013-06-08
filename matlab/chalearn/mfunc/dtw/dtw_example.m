function [auto_tempo_segment, MOTION_te, recognized_labels]=dtw_example(Ktr, train_labels, K0, with_rest_position)
%[auto_tempo_segment, MOTION_te, recognized_labels]=dtw_example(Ktr, train_labels, K0, with_rest_position)
% Example of temporal segmentation and recognition using Dynamic Time Warping.
% Inputs:
% Ktr --                A cell array containing training examples of movies
% train_labels --       Training labels
% K0 --                 A test movie,
% with_rest_position -- A 0/1 flab indicating whether the model should
% include a rest position.
% Returns:
% auto_tempo_segment -- Automatic temporal segmentation: a matrix nx2 where
% n it the number of cuts. auto_tempo_segment(k, 1) is the frame number of
% the kth gesture start; auto_tempo_segment(k, 2) is the frame number of
% the kth gesture end.
% MOTION_te --          A data representation of the test video 
% with frames in lines that can be used for display purpose.
% features in columm.
% recognized_labels --  Recognized labels.

% Isabelle Guyon -- isabelle@clopinet.com -- June 2012

% Number of features in the motion data representation
motion_num=9;

% PREPROCESSING TRAINING DATA
n=length(Ktr);
L=zeros(n,1);
MOTION_tr=[];
for k=1:n
    % Note: this is similar to motion_histograms, just coarser
    motion_tr=motion(Ktr{k}, motion_num);
    if with_rest_position
        motion_tr=trim(motion_tr); % remove still frames at beginning and end
    end
    L(k)=size(motion_tr,1); % This is the length of each example video
    MOTION_tr=[MOTION_tr; motion_tr];
end           
if with_rest_position
    % Add the zero motion as transition model
    MOTION_tr=[MOTION_tr; zeros(1, size(MOTION_tr,2))];
end

% Motion representation for the test example
MOTION_te=motion(K0, motion_num);

% COMPUTATION OF LOCAL SCORES (using Euclidean distance)
% We make frame-by-frame comparisons between
% all training examples and the test video
local_scores=euclid_simil(MOTION_tr, MOTION_te);

% FORWARD HMM MODEL
% We create a "model" with the training data.
% Note that we use as parameters onle the length of the
% training gestures. We add or not an extra model for the rest
% position.
[parents, local_start, local_end] = simple_forward_model( L , with_rest_position);

% Computation of the best elastic match
debug=1; % Show the matching path
[~, ~, ~, cut, label_idx]=viterbi(local_scores, parents, local_start, local_end, debug);
ylabel('Training examples', 'FontSize', 14, 'FontWeight', 'bold');
set(gcf, 'Name', 'DYNAMIC TIME WARPING (DTW) TEMPORAL SEGMENTATION');

% Cleanup labels and create a list of begining and end of gestures.
% Remove 0 labels and eventual transition model labels 
transition_model_label=length(L)+1;
idxg=find(label_idx~=transition_model_label & label_idx>0);
label_idx=label_idx(idxg);
auto_tempo_segment=[cut(1:end-1)'+1, cut(2:end)'];
auto_tempo_segment=auto_tempo_segment(idxg,:);

recognized_labels=train_labels(label_idx);

end

