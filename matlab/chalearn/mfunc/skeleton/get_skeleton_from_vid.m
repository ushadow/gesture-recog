function [skeleton_annotation] = get_skeleton_from_vid(V0, fghigh_params,parse_params_Buffy3and4andPascal,pm2segms_params)
% [skeleton_annotation_pred] = get_skeleton_from_video(V0,
% fghigh_params,parse_params_Buffy3and4andPascal,pm2segms_params)
% 
% Function to extract skeleton annotations for a given video V0 using the
% pose estimation code from  Marcin Eichner, Manuel J. Mar�n-Jim�nez,
% Andrew Zisserman, and Vittorio Ferrari. The code is publicly available
% from
% http://www.vision.ee.ethz.ch/~calvin/articulated_human_pose_estimation_code/
%
% V0: is the video that will be labeled with body parts
% the rest of inputs are parameters obtained from the code (file env.mat)
%
% skeleton_annotation:  the coordinates for the skeleton and bounding boxes
%                       around the skeleton. It is a matrix of size 
%                       (number of frames * 6, 10). Rows corresponds to the
%                       information of a body part in a particular fram one
%                       annotation point and columns are properties as
%                       follows:  

%                       Frame No. | Body part ID | X | Y | Width | Height |x1 | y1 | x2| y2|

%                       Where body parts are represented as follows: 
%                           Body part ID: 	1. Torso
%                                           2. Right upper arm 
%                                           3. Left upper arm 
%                                           4. Right lower arm
%                                           5. Left lower arm 
%                                           6. Head
%
%                       | X | Y | Width | Height |:	Are the x, y width and height for the bounding box containing the body part. 
%                       | x1 | y1 | x2| y2|:		Are the x1,y1, x2,y2 coordinates for the sticks associated with the skeleton. 		
%
% Note: If you are running this under Mac, you will have to install mmread
%
% Isabelle Guyon -- isabelle@clopinet.com -- February 2012
col='rgbymck';

skeleton_annotation=[];
h = figure;
set(gcf, 'Name', 'Skeleton annotations with the ETHs code');
for i=1:length(V0),
        IM=V0(i).cdata;
        imwrite(imresize(IM,2),['tempimg.jpeg'],'JPEG');
        % % % % % Get the bounding boox for the head using Isabelle's code
        [icoord, jcoord, kcoord, head_box, quality]=annotate(V0, i, 1, 0);
        % % % % % % Heuristic estimation of the bounding box for the body
        esbb=([max(round(head_box(1)-head_box(3).*1.5),1),...
            max(round(head_box(2))-(round(head_box(4).*0.3)),1),...
            head_box(3).*3.5,head_box(4).*2.5]);
        bb=round(esbb.*2);       
        if exist([pwd '/segms_ubf/tempimg.jpeg']),
            system(['del ' pwd '\segms_ubf\tempimg.jpeg']);
        end
        % % % % % Run the pose estimation code with recommended parameters
        [T2 sticks_imgcoor] = PoseEstimStillImage(pwd, ...
            '', ['tempimg.jpeg'], 0, 'ubf', bb', fghigh_params, ...
            parse_params_Buffy3and4andPascal, [], pm2segms_params,true);
        % % % % % Get bounding boxes for each body part
        for jj=1:size(T2.PM.segm,3)
            binseg=(T2.PM.segm(:,:,jj)>0);
            [rows,cols]=find(binseg);
            T2.mbb(:,jj)=[min(cols),min(rows),max(cols)-min(cols),max(rows)-min(rows)]';                
        end
        T2.sticks_bbs= round(convertSticksToImgCoor(T2.mbb,[size(T2.PM.a,2) size(T2.PM.a,1)], T2.PM.bb)./2);
        % % % % % % % Get stick coordinates, they are scaled by a half
        % % % % % % % because we re-sized the image before
        sticks_imgcoor=round(sticks_imgcoor./2);    
            
        teval3=[T2.sticks_bbs];   %%% bounding box coordinates
        teval4 = sticks_imgcoor;  %%% skeleton coordinates
                        
        skeleton_annotation=[skeleton_annotation;[i.*ones(size(teval3,2),1),(1:size(teval3,2))',teval3',teval4']];        
        
        imdisplay(IM, h);  hold on;
        %%%%%%% Show the annotations obtained with the pose estimation code       
        annot_idx=find(skeleton_annotation(:, 1)==i);
        for j=1:length(annot_idx)
            k=annot_idx(j);
            body_part=skeleton_annotation(k, 2);
            box0=skeleton_annotation(k, 3:6);
            rectangle('Position', box0, 'EdgeColor', col(body_part));                        
            box1=skeleton_annotation(k, 7:10);
                    line([box1(1),box1(3)],[box1(2),box1(4)],'Linewidth',3,'Color',col(body_part));
        end   
end
