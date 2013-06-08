function [labels, cuts] = exec(model, pat, cuts)
%[labels, cuts] = exec(model, pat, cuts)
% Make predictions with a dtw method.
% Inputs:
% pat  --    A pattern (movie or feature representation)
% cuts --    Temporal segmentatation.
% Returns:
% newpat and newcuts, the result of recognition and segmentation.

% Isabelle Guyon -- May 2012 -- isabelle@clopinet.com

if nargin<3, cuts=[]; end

if isfield(pat, 'K')
	new_pat=pat.(model.movie_type);
else
    new_pat=pat;
end

% Eventually preprocess the movie
if isfield(new_pat, 'cdata'),
    new_pat=model.preprocessing(new_pat, model.prepro_param);
end

% Create the local scores
local_scores=model.similarity(model.X, new_pat, model.simil_param);

% Run the Viterbi algorithm
[~, ~, ~, tsegment, labels]=viterbi(local_scores, model.parents, model.local_start, model.local_end);
            
% Remove the transition model label from the labels and determine the cuts
transition_model_label=length(model.Y)+1;
idxg=find(labels~=transition_model_label & labels>0);
labels=labels(idxg);
tempo_segment=[tsegment(1:end-1)'+1, tsegment(2:end)'];
cuts=tempo_segment(idxg,:);


if model.use_as_prepro
    labels=new_pat;
elseif model.use_as_segmenter 
    labels=pat;
end


