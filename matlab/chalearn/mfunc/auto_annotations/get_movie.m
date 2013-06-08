function M=get_movie(batch_dir, movie_num, use_kinect, reduce_resolution, debug)
% M=get_movie(batch_num, movie_num, use_kinect, reduce_resolution, debug)
% batch_dir         - batch directory
% movie_num         - movie number in a bacth (1-47)
% use_kinect        - flag to choose kinect or RGB (kinect by default)
% reduce_resolution - flag to down-sample (none by default)
% debug             - flag to show intermediate steps

% Isabelle Guyon -- isabelle@clopinet.com -- February 2012

if nargin<1
    batch_dir='';           % directory of a movie back containing M_xxx.avi and K_xxx.avi
end
if nargin<2
    movie_num=1;            % number xxx of the movie (1:47)
end
if nargin<3
    use_kinect=1;           % if use_kinect, read K otherwise read M
end
if nargin<4
    reduce_resolution=0;    % downsize the images
end
if nargin<5
    debug=1;                % view some intermediate steps
end         


% Load the movie in depth or RGB format
if use_kinect
    % Use the Kinect image
    movie_file=[batch_dir '/K_' num2str(movie_num) '.avi'];
else
    % Use RGB
    movie_file=[batch_dir '/M_' num2str(movie_num) '.avi'];
end

if ~exist(movie_file, 'file')
    M=[];
    return
end

[M, fps]=read_movie(movie_file);

if debug>1, play_movie(M, fps); end

% Reduce the resolution (frame by frame)
% this can speed up processing quite a bit
if reduce_resolution
    factor=0.25;
    for k=1:length(M)
        M(k).cdata=imresize(M(k).cdata, factor);
    end
    if debug>1, play_movie(M, fps); end
end

end