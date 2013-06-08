function [preprocessed_pattern, preprocessed_cuts] = exec(this, pattern, cuts)
%[preprocessed_pattern, preprocessed_cuts] = exec(this, pattern, cuts)
% Executes the preprocessing for a single pattern.
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
        pattern=pattern.K';
    else
        pattern=pattern.M';
    end
elseif isfield(pattern, 'cdata')
    pattern=pattern';
end

% When the input is a movie and we compute the motion trail
if isfield(pattern, 'cdata')
    preprocessed_pattern=motion_histograms(pattern, this.scale);
else
    % don't know what to do
    preprocessed_pattern=pattern;
end

%Don't touch temporal segmentation
preprocessed_cuts=cuts;

if this.verbosity>1, fprintf('\n==TE> Executing %s for movie type %s... ', class(this), this.movie_type); end
