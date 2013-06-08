function play_movie(mov, fps, hf, x, y, w, h, flip)
%play_movie(mov, fps, hf, x, y, w, h, flip)
% Play a movie mov at fps frames per seconds in figure hf
% mov can either be an array of movie frames (usually from getframe).
% or a file name.

% Isabelle Guyon -- isabelle@clopinet.com -- April-May 2010

if nargin<2 || isempty(fps)
    fps=12;
end
if nargin<3
    hf=figure;
else
    hf=figure(hf);
end
if nargin<4 || isempty(x),
    x=[]; y=[];
end
if nargin<6 || isempty(w),
    [h, w, c]=size(mov(1).cdata);
end
if nargin<8
    flip=0;
end

if ischar(mov)
    % get the movie from the file called mov
    [mov, fps]=read_movie(mov);
end

% Rescale the movie 
mov=rescale_movie(mov, w, h, flip);

% Resize figure based on the video's width and height
if isempty(x)
    x=100; y=100;
    P=get(hf, 'Position');
    set(hf, 'Position', [P(1) P(2) 2*x+w 2*y+h]);
end
pause(2);
 
% Playback movie once at the video's frame rate
fprintf(['Movie playback at ' num2str(fps) ' frames per seconds\n'], 'FontSize', 20);
set(hf, 'Name', ['PLAY MOVIE (fps='  num2str(fps) ')']);

% If the movie is large, we cut it in chunks to avoid memory problems
cnum=ceil(length(mov)/30);
b=1; e=min(length(mov),30);
for k=1:cnum
    if isempty(b:e)
        break
    end
    movie(hf, mov(b:e), 1, fps, [x y 0 0]);
    b=e+1;
    e=min(length(mov), b+30);
end

       
       