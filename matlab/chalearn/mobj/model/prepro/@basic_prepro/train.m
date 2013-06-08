function [resu, this]=train(this, data)
%[data, this]=train(this, data)
% Template preprocessing training method.
% Inputs:
% this      -- A preprocessing object.
% data      -- A structure created by one of the data objects.
%
% Returns:
% this      -- The trained preprocessing object.
% resu      -- A new data structure containing the results.
% Note: 
% - data is a databatch, which is an object oriented database of movies
% reading them directly from disk (low mwmory usage).
% - resu is a data structure that includes results of preprocessing or
% recognition as a data matrix. It consumes a lot of memory.

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

if this.verbosity>0, fprintf('\n==TR> Training %s for movie type %s... ', class(this), this.movie_type); end

% Here the preprocessing is supposed to do something

% Some code here to train parameters of the preprocessing
% Note: not all preprocessing do some training, this method could do
% "nothing"

% Here we just compute the average movie length is trainign data to
% eventually perform a trivial temporal segmentation
Ntr=length(data);
L=zeros(Ntr, 1);
for k=1:Ntr
    X=get_X(data, k);
    if isnumeric(X)
        L(k)=size(X,1);
    else
        L(k)=length(X.K);
    end
end

% Set the average gesture length
this.len=mean(L);  


% Eventually  test the this
if this.test_on_training_data
    resu=test(this, data);
else
    resu=result(data); % Just make a copy
end

if this.verbosity>0, fprintf('\n==TR> Done training %s for movie type %s...\n', class(this), this.movie_type); end


