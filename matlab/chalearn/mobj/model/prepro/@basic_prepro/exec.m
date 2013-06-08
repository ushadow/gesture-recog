function [preprocessed_pattern, preprocessed_cuts] = exec(this, pattern, cuts)
%[preprocessed_pattern, preprocessed_cuts] = exec(this, pattern, cuts)
% Make execute the preprocessing for a single pattern.
% Inputs:
% this --           A preprocessing object.
% pattern --        A pattern obtained with get_X(data). In this example, the
%                   pattern is a movie.
% cuts --           Optionally give movie temporal segmentation into gestures.
% Returns:
% preprocessed_pattern -- The result of preprocessing.
% preprocessed_cuts    -- Optionally, the pattern temporal segmentation.

% Isabelle Guyon -- May 2012 -- isabelle@clopinet.com

if nargin<3, cuts=[]; end

if this.verbosity>1, fprintf('\n==TE> Executing %s for movie type %s... ', class(this), this.movie_type); end

% This method eventually needs to test for the type of data that it is fed 
% (movie, cell_array, matrix).

if isfield(pattern, 'K')
    if strcmp(this.movie_type, 'K')
        pattern=pattern.K;
    else
        pattern=pattern.M;
    end
end
    
% If there is no temporal segmentation provided, 
% performs a trivial segmentation based on movie length
if isempty(cuts)
    cuts=equal_segments(pattern, model.len);
end

N=size(cuts,1);     % Number of gestures
preprocessed_cuts=[1:N;1:N]';

% Averages the values between cut boundaries to create a fixed length
% pattern
if isfield(pattern, 'cdata')
    X=average_movie(pattern(cuts(1,1):cuts(1,2)));
    n=prod(size(X));
    preprocessed_pattern=zeros(N, n);
    preprocessed_pattern(1,:)=X(:);
    for k=2:N
        X=average_movie(pattern(cuts(k,1):cuts(k,2)));
        preprocessed_pattern(k,:)=X(:);
    end
elseif isnumeric(pattern)
    % If the input is a matrix, computes a fixed-length representation
    % using the cuts by averaging the features.
    [p, n]=size(pattern);
    preprocessed_pattern=zeros(N, n);
    for k=1:N
        preprocessed_pattern(k,:)=mean(pattern(cuts(k,1):cuts(k,2),:));
    end  
else
    % don't know what to do
    preprocessed_pattern=pattern;
end

if this.verbosity>1, fprintf('\n==TE> Executing %s for movie type %s... ', class(this), this.movie_type); end
