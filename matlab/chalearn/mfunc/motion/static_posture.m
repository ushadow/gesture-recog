function out_frame = static_posture( frame, previous, next, original, debug )
%out_frame = static_posture( frame, previous, next, original )
% Identifies the pixels that are not moving but different from the original
% frame
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

frame=double(frame);
previous=double(previous);
next=double(next);
original=double(original);

% Difference to previous posture, positive part
DdiffB=previous-frame;
DdiffB(DdiffB<0)=0;
moving_frame=DdiffB;


% Difference to next posture, positive part
if ~isempty(next)
    DdiffC=next-frame;
    DdiffC(DdiffC<0)=0;
    moving_frame=max(moving_frame, DdiffC);
end

% Difference to original posture, positive part
DdiffA=original-frame;
DdiffA(DdiffA<0)=0;

out_frame=DdiffA-moving_frame;
out_frame(out_frame<0)=0;


if debug
    imdisplay(out_frame);
end

end

