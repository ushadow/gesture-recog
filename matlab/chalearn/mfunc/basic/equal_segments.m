function cuts = equal_segments( pattern, len )
%cuts = equal_segments( pattern, len )
% Dumb segmentation routine that cuts a pattern into equal segments.
% pattern -- a movie or a feature representation, patterns/frames in lines,
% and features in columns.
% len -- approximate length of a segment

% Isabelle Guyon -- June 2012 -- isabelle@clopinet.com

if nargin<2, len=10; end

if isfield(pattern, 'K')
    L=length(pattern.K);
elseif isfield(pattern, 'cdata')
    L=length(pattern);
else
    L=size(pattern, 1);
end
    
N=min(max(1, round(L/len)), 5);    % Number of gestures
step=L/N;                          % Average duration of a gesture
cuts=zeros(N, 2);
b=1; e=round(step);
cuts(1,:)=[b, e];
for i=2:N
    b=e+1;
    e=round(min(e+step, L));
    cuts(i,:)=[b, e];
end
if e<L
    cuts(i,:)=[b, L];
end


if 1==2 % old bogus code (that actually worked better :=))
    N=min(max(1, round(L/len)), 5);    % Number of gestures
    step=round(L/N);                   % Average duration of a gesture
    cuts=zeros(N, 2);
    b=1; e=step;
    cuts(1,:)=[b, e-1];
    for i=2:N
        b=e+1;
        e=min(e+step, L);
        cuts(i,:)=[b, e-1];
    end
end

end

