function [BOF_tr, centers, t] = train_STIP_BOF( data_nm, n_tr, cnum, rep )
%[BOF_tr, centers, t] = train_STIP_BOF( data_nm, n_tr, cnum, rep )
% Bag of STIP features
% Inputs:
% data_nm: base data of the data (no movie number)
% n_tr --  number of training examples
% cnum --  number of clusters (also num of BOF features)
% rep --   choice of representation:
% 1) pos
% 2) hog
% 3) hof
% 4) pos+hog
% 5) hog+hof
% 6) all
% Returns:
% BOF_tr --     bag of STIP features (number of training patt x cnun)
% centers --    cluster centers
% t --          average training pattern duration

% Number of clusters
if nargin<3, cnum=30; end
if nargin<4, rep=4; end

fprintf('Computing bag of STIP features, a bit slow...');
% LOAD TRAINING DATA (precomputed STIP features)

FEAT_tr=[]; feat_tr={};

for k=1:n_tr
    [feat_tr{k}, pos_tr{k}]=get_stip([data_nm num2str(k) '.txt'], rep); 
    FEAT_tr=[FEAT_tr; feat_tr{k}];
end

% Get average pattern duration
t=zeros(n_tr,1);
for k=1:n_tr
    P=pos_tr{k};
    t(k)=max(P(:,3));
end
t=mean(t);

% K-means clustering of descriptors FEAT_tr
[centers, cluster_labels, mimdist]=kmeans(FEAT_tr, cnum);

BOF_tr=zeros(n_tr, cnum);
for k=1:n_tr
    % Assignment of dscr_tr features of training ex to cluster centers
    %dist=eucliddist(centers, dscr_tr{k});
    dist=eucliddist(centers, feat_tr{k});
    [sdist, lbl]=min(dist);

    % Bag Of Features representation (BOF) of training examples
    H=histc(lbl, 1:cnum)+eps;
    BOF_tr(k, :)=H/sqrt(H*H');
end

fprintf(' done\n');

end

