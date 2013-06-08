function [mov, fps]=read_movie(filename)
%[mov, fps]=read_movie(filename)

mov=[];
fps=[];

% We need the abosolute path
absfilename=[pwd '/' filename];
if exist(absfilename, 'file')
    filename=absfilename;
end

if ~exist(filename, 'file');
    error('File %s does not exist!', filename);
end

warning off
try
    
        M=mmread(filename);
        mov=M.frames;
        fps=M.nrFramesTotal/M.totalDuration;
    
catch
        
    try
       % Construct a multimedia reader object associated with file 'xylophone.mpg' with
       % user tag set to 'myreader1'.
       readerobj = mmreader(filename);
 
       % Read in all video frames.
       vidFrames = read(readerobj);
 
       % Get the number of frames.
       numFrames =  size(vidFrames, 4);
 
       % Create a MATLAB movie struct from the video frames.
       for k = 1 : numFrames
             mov(k).cdata = vidFrames(:,:,:,k);
             mov(k).colormap = [];
       end
       
       % Frame rate
        fps=readerobj.FrameRate;
    catch
        error('*** mmreader does not work for you, try to install mmread ***');
    end
        
end
warning on