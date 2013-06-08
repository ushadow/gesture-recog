function out_frame = active_motion( frame, previous, next, original, debug )
%out_frame = active_motion( frame, previous, next, original )
% Identifies the pixels currently moving most
% frame -- current frame
% previous -- previous frame
% next -- next frame
% original -- original frame
% debug -- 1 to show images

% Isabelle Guyon -- isabelle@clopinet.com -- April 2012

if nargin<2, out_frame=double(frame); return; end
if nargin<3, next=[]; end
if nargin<4, original=[]; end
if nargin<5, debug=0; end

DiffA=[];
DiffB=[];
DiffC=[];
frame=double(frame);
out_frame=frame;
previous=double(previous);
next=double(next);
original=double(original);

% Difference to original posture, positive part
if ~isempty(original)
    DdiffA=original-frame;
    DdiffA(DdiffA<0)=0;
    out_frame=min(out_frame, DdiffA);
end

% Difference to previous posture, positive part
if ~isempty(previous)
    DdiffB=previous -frame;
    DdiffB(DdiffB<0)=0;
    out_frame=min(out_frame, DdiffB);
end

% Difference to next posture, positive part
if ~isempty(next)
    DdiffC=next-frame;
    DdiffC(DdiffC<0)=0;
    out_frame=min(out_frame, DdiffC);
end

if debug
    imdisplay(out_frame);
end

end

