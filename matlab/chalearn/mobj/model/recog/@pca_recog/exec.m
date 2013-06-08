function [labels, cuts] = exec(model, pat, cuts)
%[labels, cuts] = exec(model, pat, cuts)
% Make predictions with a PCA method.
% Inputs:
% pat  --    A pattern (movie or feature representation)
% cuts --    Temporal segmentatation.
% Returns:
% newpat and newcuts, the result of recognition and segmentation.

% Isabelle Guyon -- May 2012 -- isabelle@clopinet.com

if nargin<3, cuts=[]; end

if isfield(pat, 'K')
    pat=pat.(model.movie_type);
end

% Eventually preprocess the movie
if isfield(pat, 'cdata'),
    pat=model.preprocessing(pat, model.prepro_param);
end
    
% Checks whether cuts exist
if isempty(cuts)
    cuts=model.segmenter(pat, model.segment_param); 
end
    
% Chop the movie in equal pieces and compute the average of the pieces
Xb=split_pattern(pat, cuts);

% Compute the reconstruction error with the different PCA models and 
% assign the label corresponding to the gesture with lowest
% reconstruction error    
N=length(Xb);
labels=zeros(1,N);    
L=length(model.T);
S=zeros(1,L);   
for i=1:N % Number of gestures
    for j=1:L
        [p,n]=size(Xb{i});
        % % % % Project the data using the PCs for this model
        X=Xb{i}-model.OCM{j}.a.mu(ones(p,1),:);
        rX=X*model.OCM{j}.a.U;            
        % % % % Reconstruct the data with the j-th model and compute
        % % % % the reconstruction error
        v=mean(Xb{i});    
        R=rX*model.OCM{j}.a.pinvU+(v(ones(size(Xb{i},1),1), :));
        rerrr=(sum((R-Xb{i}).^2,2)).^0.5;
        c=mean(rerrr);                       
        S(j)=c;            
    end               
[m, labels(i)]=min(S);    
end