function [resu, prepro] = test(model, data)
%[resu, prepro] = test(model, data)
% Make predictions with a dtw method.
% Inputs:
% model --  A recog_template object.
% data --   A data structure.
% Returns:
% resu --   The result structure. WARNING: this follows the convention of
% Spider http://www.kyb.mpg.de/bs/people/spider/ *** The result is in resu.X!!!! ***
% resu.Y are the target values.
% prepro -- The intermediate preprocessing results (held in a similar
% result stucture).
% If use_as_prepro=1, resu=prepro.

% Isabelle Guyon -- May 2012 -- isabelle@clopinet.com

if model.verbosity>0, fprintf('\n==TE> Testing %s for movie type %s... ', class(model), model.movie_type); end

if isa(data, 'result'),
    do_not_preprocess=1;
else
    do_not_preprocess=0;
end

if model.use_as_segmenter
    resu=data;
else
    resu=result(data);
end
if nargin>1
    prepro=result(data);
end

Ntr=length(model.Y);
Nte=length(data);

% Loop over the samples 
for k=1:Nte
    if model.verbosity>0,
        if ~mod(k, round(Nte/10))
            fprintf('%d%% ', round(k/Nte*100));
        end
    end
    
    % Preprocess the movie
    M=get_X(data, k);
    if do_not_preprocess
        Xte=M;
    else
        Xte=model.preprocessing(M.(model.movie_type), model.prepro_param);
    end
    
    % Create the local scores
    local_scores=model.similarity(model.X, Xte, model.simil_param);
    
    % Run the Viterbi algorithm
    [~, ~, ~, cuts, labels]=viterbi(local_scores, model.parents, model.local_start, model.local_end);
            
    % Remove the transition model label from the labels and determine the cuts
    transition_model_label=length(model.Y)+1;
    idxg=find(labels~=transition_model_label & labels>0);
    labels=labels(idxg);
    tempo_segment=[cuts(1:end-1)'+1, cuts(2:end)'];
    tempo_segment=tempo_segment(idxg,:);
    
    % Set the results
    if ~model.use_as_segmenter
        if model.use_as_prepro
            set_X(resu, k, Xte);
        else
            set_X(resu, k, labels);
        end
    end
    set_cuts(resu, k, tempo_segment);
    
    % Save the preprocessing
    if nargout>1
        set_X(prepro, k, Xte);
        set_cuts(prepro, k, tempo_segment);
    end
end

if model.verbosity>0, fprintf('\n==TE> Done testing %s for movie type %s... ', class(model), model.movie_type); end
