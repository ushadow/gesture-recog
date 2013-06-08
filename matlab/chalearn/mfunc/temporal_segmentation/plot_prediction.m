function h = plot_prediction(pr, tr, motion_score)

    if (numel(tr) == 0)
       return; 
    end

    h = figure;
    clf(h);
    
    no_frames = length(motion_score);
    
    truth = zeros(size(tr,1) + 2, 2);
    truth(1, :) = [0, 1];
    truth(2:size(truth, 1)-1, :) = tr;
    truth(size(truth, 1), :) = [no_frames  , 0];

    for i=2:size(truth, 1)
         x = [truth(i-1,2) truth(i-1,2):truth(i,1) truth(i,1)];
         y = ones(1, length(x)) * 0.5;
         y(1) = 0;
         y(length(y)) = 0;
         fill(x,y, [222/255 233/255 1]);
         hold on;
  
    end
    
%     if (nargin == 3)
        plot(1:no_frames,motion_score, 'k');
        hold on;
%     end
    
    value = ones(no_frames, 1) * 0.25;
    for i=1:size(pr,1)
       value(pr(i,1):pr(i,2)) = Inf;
    end

    plot(1:no_frames, value, 'b');
end