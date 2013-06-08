function [Xall, MM, indices, data_file_names, lbss] = compute_raw_features_s2isa_hj(network, params, data_file_names, size_idx, batchz, MTY, tridx, trfg)

% data_file_names : list of files
% XALL: descriptors for all video clips
% MM  : saliency measure of the descriptors
% indices: track start and end of each clip; also contains ds_sections,
% which tracks sections containing descriptors from differenct dense
% sampling offsets
lbss=[];
indices = cell(1);

fovea = network.isa{params.feature.num_layers}.fovea;

ss=dir([params.avipath{size_idx},'devel*']);
dc=1;
for i=1:length(tridx),
    s2=dir([params.avipath{size_idx} ss(tridx(i)).name '\' MTY '*.avi']);    
    
%     if trfg==1,
%         XD=importdata([params.avipath{size_idx} ss(tridx(i)).name '\'  ss(tridx(i)).name '_train.csv']);
%         lbss=[XD.data];
%     elseif trfg==0,
%         XD=importdata([params.avipath{size_idx} ss(tridx(i)).name '\'  ss(tridx(i)).name '_test.csv']);
%         lbss=[XD.data];
%     else
%         XD1=importdata([params.avipath{size_idx} ss(tridx(i)).name '\'  ss(tridx(i)).name '_train.csv']);
%         XD2=importdata([params.avipath{size_idx} ss(tridx(i)).name '\'  ss(tridx(i)).name '_test.csv']);
%         lbss=[XD1.data;XD2.data];
%     end

    for j=1:length(s2),
        data_file_names{dc}=   [ss(tridx(i)).name '\' s2(j).name];
        dc=dc+1;
    end
end

% for i=1:
    
m = length(data_file_names);
Xall = 0;
switch params.feature.type
    case 'sisa'
        Xall = zeros(3000000, params.num_features, 'single');
end

MM = zeros(3000000, 1, 'single');

Xall_fill = 1;
% total_time = 0;
for i=1:m
%   tic
    
    M = loadclip_3dm([params.avipath{size_idx}, char(data_file_names(i))], fovea.spatial_size, 0, 0); 
    
    [X_clip, motionmeasure, ds_sections] = transact_dense_samp(M, network, params);
    
    %% code to filter out the features with more motion elements, by l1 norm of
    %% activations
            
    indices{i}.start = Xall_fill;

    for ds = 1:length(ds_sections)
       ds_sections(ds).start = ds_sections(ds).start + indices{i}.start - 1 ;
       ds_sections(ds).end = ds_sections(ds).end + indices{i}.start - 1 ;
    end
    
    Xall(Xall_fill:Xall_fill+size(X_clip,1)-1,:) = X_clip;
    
    MM(Xall_fill:Xall_fill+size(X_clip,1)-1,:) = motionmeasure;
    
    Xall_fill = Xall_fill + size(X_clip,1);    
    
    indices{i}.end = Xall_fill-1;

    indices{i}.ds_sections = ds_sections;
    
%   elapsed_time = toc;
%   total_time = total_time + elapsed_time;
%   average_time = total_time / i;
%   fprintf('number of features %d\n', size(X_clip, 1));
%   fprintf('elapsed = %f (seconds)\n', elapsed_time);
%   fprintf('ETA = %f (minutes)\n', average_time * (m-i) / 60);
  
    % print clip index
    fprintf('%d ', i);
    if mod(m, 20) == 0
        fprintf('\n');
    end    
end

Xall = Xall(1:Xall_fill-1,:);

MM = MM(1:Xall_fill-1);

end