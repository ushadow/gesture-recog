function H=display_annot(IM, annot, H, ttl, offset)
% H=display_annot(IM, annot, H, ttl, offset)
% Function to display annotations.
% IM    -- an image
% annot -- a matrix whose columns are:
% Body_part_ID	Uncertainty	Left    Top	Width	Height
% Body_part_ID: The body part ID as follows;
%				1 : Right hand
%				2 : Left hand
%				3 : Face
%				4 : Right shoulder
%				5 : Left shoulder
%				6 : Right elbow
%				7 : Left elbow
% Uncertainty: a value between 0 and 1 indicating how well we know the
% position
% [Left Top Width Height]: bounding box of body part

% IMPORTANT: There is a border of 40 around the image, all the annotation
% coordinates are offset by [40, 40].


if nargin<3, H=figure; else figure(H); end
if nargin<4, 
    ttl=inputname(1);
    ttl(ttl=='_')=' ';
end
if nargin<5, offset=0; end

col='rgbymck';
    
% Plunge the image into a frame
[n p m]=size(IM);
IMM=zeros(n+80,p+80,3, 'uint8');
IMM(:,:,2)=255;
IMM(:,:,3)=255;
IMM(41:size(IM,1)+40,41:size(IM,2)+40,:)=IM;
imagesc(IMM);
title(ttl);
hold on
axis off

for k=1:size(annot,1)
    body_part=annot(k, 1);
    uncertainty=annot(k, 2);
    box0=annot(k, 3:end);
    box0(1)=box0(1)+offset;
    box0(2)=box0(2)+offset;
    x=box0(1);
    y=box0(2);
    w=box0(3);
    h=box0(4);

    if w==0 || h==0
        plot(x, y, [col(body_part) '+'], 'MarkerSize', 10, 'LineWidth', 2); 
    else 
        rectangle('Position', box0, 'EdgeColor', col(body_part), 'Curvature', [uncertainty uncertainty], 'LineWidth', 2); 
    end
end   


end