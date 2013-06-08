function compare_annot(manual_label_file, auto_label_file, offset)
%compare_annot(manual_label_file1, auto_label_file, offset)
% Script to compare annotations, manual and automatic.
% Presently, just the head.
% Can be generatlized
% offset is a number added to the coordinates of auto_label_file.
% for manual annotations, the offset is always -40, -40
% Important: ALL the frames annotated in manual_label_file are assumed to
% be annotated in auto_label_file.

% Isabelle Guyon -- isabelle@clopinet.com -- February 2012

% label_file points to a Matlab .mat file containing a labels structure
% and a skeleton_annotation matrix in a format specified by Pat Jangyodsuk.
%
% labels(frame_id).dataset_name ---- e.g. devel01
% labels(frame_id).videos       ---- movie number xxx of K_xxx.avi
% labels(frame_id).frame        ---- frame number in the movie
%
% skeleton_annotation is a matrix whose columns are:
% Frame_ID	Body_part_ID	Uncertainty	Left    Top	Width	Height
% Body_part_ID: The body part ID as follows;
%				1 : Right hand
%				2 : Left hand
%				3 : Face
%				4 : Right shoulder
%				5 : Left shoulder
%				6 : Right elbow
%				7 : Left elbow
% Frame_ID: pointer into the labels structure
% Uncertainty: a value between 0 and 1 indicating how well we know the
% position
% [Left Top Width Height]: bounding box of body part


if nargin<3
    offset=0;
end

% Load the annotations
load(manual_label_file); 
manual_labels=labels;
manual_skeleton_annotation=skeleton_annotation;
load(auto_label_file); 

% Convert to lists
Data_name = {}; [Data_name{1:length(labels),1}] = deal(labels.dataset_name);
Movie_num = {}; [Movie_num{1:length(labels),1}] = deal(labels.videos); Movie_num=cell2mat(Movie_num);
Frame_num = {}; [Frame_num{1:length(labels),1}] = deal(labels.frame); Frame_num=cell2mat(Frame_num);

N=length(manual_labels);
overlap=zeros(N,1);
auto_uncertain=zeros(N,1);
uncertainty_is_meaningless=0;

for manual_frame_id=1:N

    manual_data_name=manual_labels(manual_frame_id).dataset_name;
    manual_movie_num=manual_labels(manual_frame_id).videos;
    manual_frame_num=manual_labels(manual_frame_id).frame;
    
    title0=[num2str(manual_frame_id) ' -- ' manual_data_name ' K_' num2str(manual_movie_num) ' fr=' num2str(manual_frame_num)];

    % Fetch the head annotation (head only)
    manual_idx=find(manual_skeleton_annotation(:,1)==manual_frame_id & manual_skeleton_annotation(:,2)==3);
    manual_head_box=manual_skeleton_annotation(manual_idx,4:end);
    manual_head_box(1)=manual_head_box(1)-40;
    manual_head_box(2)=manual_head_box(2)-40;

    % Fetch automatic annotations (head only)
    auto_frame_id=strmatch(manual_data_name, Data_name, 'exact');
    ii=find(Movie_num(auto_frame_id)==manual_movie_num & Frame_num(auto_frame_id)==manual_frame_num);
    if isempty(ii) % maybe not all frames are processed, check if the first one is
        ii=find(Movie_num(auto_frame_id)==manual_movie_num & Frame_num(auto_frame_id)==1);
        uncertainty_is_meaningless=1;
    end
    auto_frame_id=auto_frame_id(ii);
    auto_idx=find(skeleton_annotation(:,1)==auto_frame_id & skeleton_annotation(:,2)==3);
    auto_uncertain(manual_frame_id)=skeleton_annotation(auto_idx,3);
    auto_head_box=skeleton_annotation(auto_idx,4:end);
    auto_head_box(1)=auto_head_box(1)+offset;
    auto_head_box(2)=auto_head_box(2)+offset;

    % Compute the head box overlap
    overlap(manual_frame_id)=intersect_rect(manual_head_box, auto_head_box);
    fprintf([title0 ' --- overlap=' num2str(overlap(manual_frame_id)) ' - uncertainty=' num2str(auto_uncertain(manual_frame_id))]);
    if overlap(manual_frame_id)<0.5
        fprintf(' <#####\n');
    else
        fprintf('\n');
    end
end

[p, n]=hist(overlap, 20);
figure; bar(n, p);
title(sprintf('Average overlap %5.2f', mean(overlap)));

% Compute ROC curve when we vary a threshold on quality
if ~uncertainty_is_meaningless
    % This is meaningful only if the uncertainty was computed in the right
    % frame (hence we skip it if we use the head box of the first frame)
    truth=ones(size(overlap));
    truth(overlap<0.2)=-1;
    roc(1-auto_uncertain, truth);
end

end