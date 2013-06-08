function [pattern, cuts] = exec(this, pattern, cuts)
%[preprocessed_pattern, preprocessed_cuts] = exec(this, pattern, cuts)
% Executes the preprocessing for a single pattern.
% Inputs:
% this --           A preprocessing object.
% pattern --        A pattern obtained with get_X(data). In this example, the
%                   pattern is a movie.
% cuts --           Optionally give movie temporal segmentation into gestures.
% [we need this extra parameter for compatibility with other exec methods]
% Returns:
% pattern --        No preprocessing, the data are unchanged.
% cuts    --        Optionally, the pattern temporal segmentation.

% Isabelle Guyon -- May 2012 -- isabelle@clopinet.com

if nargin<3, cuts=[]; end

if this.verbosity>1, fprintf('\n==TE> Executing %s for movie type %s... ', class(this), this.movie_type); end

% Compute the hash code of the movie
code=compute_hash(pattern);

% Find the movie number
movie_num=find(this.hash==code);

% retrieve the human segmentation
cuts=this.cuts{movie_num};

if this.verbosity>1, fprintf('\n==TE> Executing %s for movie type %s... ', class(this), this.movie_type); end
