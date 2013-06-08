function M = crop_video_blk(M, spatial_size, temporal_size)
% crops video blk in multiples of given size

    [x, y, t] = size(M);
    
    M = M(1:floor(x/spatial_size)*spatial_size, 1:floor(y/spatial_size)*spatial_size, 1:floor(t/temporal_size)*temporal_size);

end