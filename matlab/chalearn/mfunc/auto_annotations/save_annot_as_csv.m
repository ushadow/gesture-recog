function save_annot_as_csv( annot_file, labels, skeleton_annotation )
%save_annot_as_csv( annot_file, labels, skeleton_annotation )
% Convert the annotations of Univ. Texas to csv, and write them to
% annot_file
%
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

% Isabelle Guyon -- isabelle@clopinet.com -- February 2012

fp=fopen(annot_file, 'w');

fprintf(fp, 'dataset_name,videos,frame,Body_part_ID,Uncertain_flag,Left,Top,Width,Height\n');

for k=1:length(skeleton_annotation)
    
    fprintf('%d ', k);
    frame_id=skeleton_annotation(k, 1);
    
    data_name=labels(frame_id).dataset_name;
    movie_num=labels(frame_id).videos;
    frame_num=labels(frame_id).frame;
    fprintf(fp, '%s,%d,%d', data_name, movie_num, frame_num);
    fprintf(fp, ',%7.3g', skeleton_annotation(k, 2:end));
    fprintf(fp, '\n');
end

fclose(fp);
 