% Script to read annotations of Pat and compate to computed head position

% Isabelle Guyon -- isabelle@clopinet.com -- February 2012

% Load Pat annotations
annodir='/Users/isabelle/Documents/Projects/DARPA/ManualAnnotations/skeleton_annotation_no_visualize_tool';
load([annodir '/labels.mat']);

filenames = {};
[filenames{1:length(labels),1}] = deal(labels.dataset_name);
filenames=unique(filenames);

%skeleton_annotation is an array whose lines are:
%Frame ID		Body part ID		Uncertain flag		Left		Top		Width		Height
%Body part ID: The body part ID as follows;
%				1 : Right hand
%				2 : Left hand
%				3 : Face
%				4 : Right shoulder
%				5 : Left shoulder
%				6 : Right elbow
%				7 : Left elbow
% Frame ID: pointer into the labels structure
% labels(frame_id).dataset_name ---- e.g. devel01
% labels(frame_id).videos       ---- movie number xxx of K_xxx.avi
% llabels(frame_id).frame       ---- frame number in the movie

droot='/Users/isabelle/Documents/Projects/DARPA/';
datadir=[droot 'DistributedChallengeData'];

debug=1;

old_frame_id=0;
col='rgbymck';
i=0;
overlap=zeros(length(labels), 1);
quality=zeros(length(labels), 1);

for k=1:length(skeleton_annotation)
    
    frame_id=skeleton_annotation(k, 1);
    
    %if isempty(find(bad_list==frame_id)), continue; end

    if frame_id~=old_frame_id 
        i=i+1;
        old_frame_id=frame_id;

        data_name=labels(frame_id).dataset_name;
        movie_num=labels(frame_id).videos;
        frame_num=labels(frame_id).frame;
        title0=[num2str(i) ' -- ' data_name ' K_' num2str(movie_num) ' fr=' num2str(frame_num)];

        % Load the movie and select the frame
        M=get_movie([datadir '/' data_name], movie_num);

        % Compute head box for first frame
        % We find the head in the first frame. Using the last makes no
        % difference on average.
        fr=1; % first frame
        [~, ~, ~, head_box, q]=annotate(M, fr);
        % The quality of detection in the first frame does not necessarily
        % reflect the quality of detection of the head in the desired from
        quality(frame_id)=check_head(M, head_box, frame_num);

        if debug
            IM=M(frame_num).cdata;
            figure('Name', title0);
            imagesc(IM);
            hold on
            rectangle('Position', head_box, 'EdgeColor', 'b', 'Linewidth', 2);  % Computer generated
        end
    end
        
    % Pat's annotations
    body_part=skeleton_annotation(k, 2);
    uncertainty=skeleton_annotation(k, 3);
    box0=skeleton_annotation(k, 4:end);
    box0(1)=box0(1)-40;
    box0(2)=box0(2)-40;
    x=box0(1);
    y=box0(2);
    w=box0(3);
    h=box0(4);
    if debug
        if w==0 || h==0
            plot(x, y, [col(body_part) '+'], 'MarkerSize', 10, 'LineWidth', 2); 
        else 
            rectangle('Position', box0, 'EdgeColor', col(body_part), 'Curvature', [uncertainty uncertainty]); 
        end
    end   
    
    if body_part==3
        % Compute the head box overlap
        overlap(frame_id)=intersect_rect(head_box, box0);
        fprintf([title0 ' --- overlap=' num2str(overlap(frame_id)) ' - quality=' num2str(quality(frame_id))]);
        if overlap(frame_id)<0.5
            fprintf(' <#####\n');
        else
            fprintf('\n');
        end
    end
end

[p, n]=hist(overlap, 20);
figure; bar(n, p);
title(sprintf('Average overlap %5.2f', mean(overlap)));

% Compute ROC curve when we vary a threshold on quality
truth=ones(size(overlap));
truth(overlap<0.2)=-1;
roc(quality, truth);

if 1==2

% Path where to find data and code

codedir=[droot 'Software/Recognizer/'];
addpath(codedir);

this_dir=pwd;
gdc_dir='/Users/isabelle/Documents/Projects/DARPA/GDC';
cd(gdc_dir);
set_path;
cd(this_dir);

set_names={'devel', 'valid'};

for i=1:length(set_names)
    set_name=set_names{i};
    if strcmp(set_name, 'devel')
        bmax=480;
    else
        bmax=20;
    end
    for batch_num=1:bmax
        if batch_num<=20
            datadir=[droot 'DistributedChallengeData'];
        else
            datadir=[droot 'Lossless_compressed_sata/new_devel_dir'];
        end
        batch_dir=sprintf('%s/%s%02d/', datadir, set_name, batch_num); 

        for movie_num=1:47
            [~, ~, ~, head_box, quality]=annotate(batch_dir, movie_num);
        end

    end
end

end