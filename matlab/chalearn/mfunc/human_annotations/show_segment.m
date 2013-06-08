function show_segment(segment_dir, data_dir)
% show_segment(segment_dir, data_dir)
% Function to display the temporal segmentation.
% segment_dir -- a directory containing the temporal segmentation (devel 01-20)
% data_dir    --   a directory containing data batches devel01, ... devel20

% Isabelle Guyon -- isabelle@clopinet.com -- February 2012

% Each Matlab file in segment_dir contains two cell arrays of length 47
% (number of movies):
% saved_annotation  -- Each element is a matrix (n,2) where n is the number
% of gestures in the movie. Each line corresponds to the frame number of
% the beginning and end of the gesture.
% truth_labels      -- Each element is a vector of labels. Normally the
% number of labels is equal to n, except in some cases in which the user
% did not perform all the assigned gestures.

n=-2;
p=-1;
e=0;
h0=figure('Name', 'CGD2011 data annotation browser');
batch_num=1;
movie_num=0;

idx=n;

N=47; % number of movies per batch
M=20; % number of batches

while 1
    switch idx
    case n
        movie_num=movie_num+1;
        if movie_num>N, 
            movie_num=1; 
            batch_num=batch_num+1;
            if batch_num>M
                batch_num=1;
            end
        end
    case p
        movie_num=movie_num-1;
        if movie_num<1, 
            movie_num=1; 
            batch_num=batch_num-1;
            if batch_num<1
                batch_num=M;
                movie_num=N;
            end
        end
    case e
        break
    otherwise
        movie_num=idx;
        if movie_num>N, 
            movie_num=N; 
        end
    end
    
    data_name=sprintf('devel%02d', batch_num);
    
    title0=[data_name ' K_' num2str(movie_num) ' -- labels: '];
    
    % Load the movie and compute the average motion
    Movie=get_movie([data_dir '/' data_name], movie_num);
    L=motion(Movie);
    
    hold off
    plot(L);
    hold on
    
    % Load the temporal segmentation
    load([segment_dir '/' data_name]);
    tempo_seg=saved_annotation{movie_num};
    labels=truth_labels{movie_num};
    for k=1:length(labels)
        title0=[title0 num2str(labels(k)) ' ']
    end
    
    mini=min(L);
    maxi=max(L);
    middle=(maxi+mini)/2;
    T=size(tempo_seg,1);
    if length(labels)>T
        labels=labels(1:T);
    end
    if length(labels)<T
        for i=length(labels)+1:T
            labels(i)=0;
        end
    end
    for k=1:T
        plot([tempo_seg(k, 1) tempo_seg(k, 1)], [mini maxi],  'g', 'LineWidth' , 2);
        plot([tempo_seg(k, 2) tempo_seg(k, 2)], [mini maxi], 'r', 'LineWidth' , 2);
        plot([tempo_seg(k, 1) tempo_seg(k, 2)], [middle middle], 'b', 'LineWidth' , 2);
        text((tempo_seg(k, 1)+tempo_seg(k, 2))/2, middle+(maxi-mini)/4, num2str(labels(k)), 'FontSize', 20, 'FontWeight', 'bold')
    end
    
    set(h0, 'Name', title0);
    xlabel('Time');
    ylabel('Motion in lower part');
    
    idx = input('movie# or [movie#, batch#] or n, p or e (for next, previous, exit)? ');
    if isempty(idx), idx=n; end
    if length(idx)>1
        batch_num=idx(2);
        idx=idx(1);
    end
    
end

end