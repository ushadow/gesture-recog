function h=display_segment(motion_trail, tempo_seg, recog_labels, h)
% h=display_segment(motion_trail, tempo_seg, recog_labels, h)
% Function to display the temporal segmentation.
% motion_trail -- A function of time indicating amount of motion
% recog_labels -- a vector of n labels for the gestures.
% tempo_seg    -- a matrix [nt, 2] of begin and end segmentation points for
% all the gestures in the sequence.

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

if nargin<4, h=figure; else figure(h); end
    
[p, n]=size(motion_trail);
if p>n, motion_trail=motion_trail'; end

plot(motion_trail);
hold on

mini=min(motion_trail);
maxi=max(motion_trail);
middle=(maxi+mini)/2;
T=size(tempo_seg,1);
if length(recog_labels)>T
    labels=recog_labels(1:T);
end
if length(recog_labels)<T
    for i=length(recog_labels)+1:T
        recog_labels(i)=0;
    end
end
for k=1:T
    plot([tempo_seg(k, 1) tempo_seg(k, 1)], [mini maxi],  'g', 'LineWidth' , 2);
    plot([tempo_seg(k, 2) tempo_seg(k, 2)], [mini maxi], 'r', 'LineWidth' , 2);
    plot([tempo_seg(k, 1) tempo_seg(k, 2)], [middle middle], 'b', 'LineWidth' , 2);
    if recog_labels(k)~=0
        text((tempo_seg(k, 1)+tempo_seg(k, 2))/2, middle+(maxi-mini)/4, num2str(recog_labels(k)), 'FontSize', 20, 'FontWeight', 'bold')
    end
end

set(gca, 'XLim', [0.5 length(motion_trail)+0.5]);

title('TEMPORAL SEGMENTATION');
xlabel('Time');
ylabel('Motion trail');


end