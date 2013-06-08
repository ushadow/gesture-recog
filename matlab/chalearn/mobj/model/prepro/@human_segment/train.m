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

% LOAD THE TEMPORAL SEGMENTATION (Human)
% We have the temporal segmentation for all the movie frames of devel01-20
s=load([this.datadir '/' data.dataname]);
% Each Matlab file in segment_dir contains two cell arrays of length 47
% (number of movies):
% saved_annotation  -- Each element is a matrix (n,2) where n is the number
% of gestures in the movie. Each line corresponds to the frame number of
% the beginning and end of the gesture.
% truth_labels      -- Each element is a vector of labels. Normally the
% number of labels is equal to n, except if the user
% did not perform all the assigned gestures.

this.cuts=s.saved_annotation;

% We cheat: we compute a hash code for all examples
subidx=data.subidx;
invidx=data.invidx;
data.subidx=1:data.data_size;
data.invidx=1:data.data_size;
this.hash=zeros(data.data_size, 1);
for k=1:data.data_size
    this.hash(k)=compute_hash(get_X(data, k));
end
data.subidx=subidx;
data.invidx=invidx;

% Eventually test the model
if this.test_on_training_data
    resu=test(this, data);
else
    resu=result(data); % Just make a copy
end

if this.verbosity>0, fprintf('\n==TR> Done training %s for movie type %s...\n', class(this), this.movie_type); end


