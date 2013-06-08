function show_annot(annot_file, data_dir, offset)
% show_annot(annot_file, data_dir, offset)
% Function to display annotations.
% annot_file -- a Matlab matrix containing a structure "labels" and a matrix
% "skeleton_annotation"
% data_dir --   a directory containing data batches devel01, ... valid01, ...
% offset: a number by which to translate the coordinates x and y

% Note: If you are running this under Mac, you will have to install mmread

% Isabelle Guyon -- isabelle@clopinet.com -- February 2012

% annot_file points to a Matlab .mat file containing a labels structure
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

% IMPORTANT: There is a border of 40 around the image, all the annotation
% coordinates are offset by [40, 40].


if nargin<3
    offset=0;
end

load(annot_file); % Load the annotations

col='rgbymck';

n=1;
p=-1;
e=0;
h0=figure('Name', 'CGD2011 data annotation brwoser');
num=0;
idx=n;

N=length(labels);

while 1
    switch idx
    case n
        num=num+1;
        if num>N, num=1; end
    case p
        num=max(1,num-1);
    case e
        break
    otherwise
        num=idx;
        if num>N, num=1; end
    end
    
    % Show the image
    clf
    
    data_name=labels(num).dataset_name;
    movie_num=labels(num).videos;
    frame_num=labels(num).frame;
    
    title0=[num2str(num) ' -- ' data_name ' K_' num2str(movie_num) ' fr=' num2str(frame_num)];
    
    % Load the movie and visualize the frame
    M=get_movie([data_dir '/' data_name], movie_num);
    
    if ~isempty(M)
        hold off
        % Plunge the movie into a frame
        IM=M(frame_num).cdata;
        [n p m]=size(IM);
        IMM=zeros(n+80,p+80,3, 'uint8');
        IMM(:,:,2)=255;
        IMM(:,:,3)=255;
        IMM(41:size(IM,1)+40,41:size(IM,2)+40,:)=IM;
        imagesc(IMM);
        set(h0, 'Name', title0);
        hold on
        axis off

        % Select the annotations
        annot_idx=find(skeleton_annotation(:, 1)==num);

        for j=1:length(annot_idx)
            k=annot_idx(j);
            body_part=skeleton_annotation(k, 2);
            uncertainty=skeleton_annotation(k, 3);
            box0=skeleton_annotation(k, 4:end);
            box0(1)=box0(1)+offset;
            box0(2)=box0(2)+offset;
            x=box0(1);
            y=box0(2);
            w=box0(3);
            h=box0(4);

            if w==0 || h==0
                plot(x, y, [col(body_part) '+'], 'MarkerSize', 10, 'LineWidth', 2); 
            else 
                rectangle('Position', box0, 'EdgeColor', col(body_part), 'Curvature', [uncertainty uncertainty]); 
            end
        end   
    end
    
    idx = input('Data number (or n for next, p for previous, e exit)? ');
    if isempty(idx), idx=n; end
    
end

end