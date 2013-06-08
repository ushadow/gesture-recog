function [X, n]=average_movie(M, subtract_first_frame)
%[X, n]=average_movie(M, subtract_first_frame)
%   Average a Matlab movie to create a template X.
%   Also returns the length of the movie.

if nargin<2, subtract_first_frame=0; end

	n=length(M);
    X0=mean(double(M(1).cdata), 3); 
    
    % Average all  frames
    X=X0;
    for j=2:n
        x=double(M(j).cdata);
        X=X+mean(x, 3);
    end
    X=X/n;

	% Subtract the first frame
    if subtract_first_frame
        X=X-X0;
    end
    
end

