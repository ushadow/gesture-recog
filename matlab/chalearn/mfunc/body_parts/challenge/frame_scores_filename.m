function result = frame_scores_filename(original_filename)

[di, name, ext] = fileparts(original_filename);
result = sprintf('%s/fscores_%s.mat', di, name);

