function [resu, model]=train(model, data)
%[data, model]=train(model, data)
% DTW recognizer training method.
% Inputs:
% model     -- A recognizer object.
% data      -- A structure created by databatch.
%
% Returns:
% model     -- The trained model.
% resu      -- A new data structure containing the results.

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

if model.verbosity>0, fprintf('\n==TR> Training %s for movie type %s... ', class(model), model.movie_type); end

if isa(data, 'result'),
    do_not_preprocess=1;
else
    do_not_preprocess=0;
end

Ntr=length(data);
L=zeros(Ntr, 1);

% Reorder the templates so we don't have to worry
y=get_Y(data, 'all');
[s, idx]=sort([y{:}]);
model.Y=1:length(y);

% Preprocess data, and trim the training examples
rest_position=[];
for i=1:Ntr
    k=idx(i);
    if do_not_preprocess
        T=get_X(data, k);
    else
        goto(data, k);
        if strcmp(model.movie_type, 'K')
            M=data.current_movie.K;
        else
            M=data.current_movie.M;
        end
        T = model.preprocessing(M, model.prepro_param);
    end
    rest_position(i,:)=T(1,:);
    T = trim(T);
    model.X=[model.X; T];    
    model.L(i)=size(T,1);
end
% Add the rest position
model.X=[model.X; mean(rest_position)];

% Create the connectivity graph, with a transition model
[model.parents, model.local_start, model.local_end]=simple_forward_model(model.L, 1);

% Eventually  test the model
if model.test_on_training_data
    resu=test(model, data);
else
    resu=result(data); % Just make a copy
end

if model.verbosity>0, fprintf('\n==TR> Done training %s for movie type %s...\n', class(model), model.movie_type); end


