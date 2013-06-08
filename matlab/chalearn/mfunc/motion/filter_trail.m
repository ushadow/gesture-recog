function trail=filter_trail(trail, duration)
%trail=filter_trail(trail, duration)
% Pass the trail through a duration filter

n1=3; n2=round(duration/4);
filter_shape=[-1*ones(1,n1) ones(1,n2)];
trail=conv(trail, filter_shape, 'same');


end

