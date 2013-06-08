function [resu, model]=train(model, data)
%[data, model]=train(model, data)
% Template matching recognizer training method.
% Inputs:
% model     -- A recognizer object.
% data      -- A structure created by databatch.
%
% Returns:
% model     -- The trained model.
% resu      -- A new data structure containing the results.

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

if model.verbosity>0, fprintf('\n==TR> Training %s... ', class(model)); end

% Save the training examples (templates)
Ntr=length(data);
X=get_X(data, 1);
Nfeat=size(X, 2);
T=zeros(Ntr, Nfeat);
T(1,:)=X;
for k=2:Ntr
    T(k,:)=get_X(data, k);
end

% Reorder the templates so we don't have to worry
y=get_Y(data, 'all');
[s, idx]=sort([y{:}]);
model.X=T(idx,:);

% Eventually  test the model
if model.test_on_training_data
    resu=test(model, data);
else
    resu=result(data); % Just make a copy
end

if model.verbosity>0, fprintf('\n==TR> Done training %s...\n', class(model)); end


