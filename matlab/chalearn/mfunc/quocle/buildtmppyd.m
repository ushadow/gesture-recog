function X = buildtmppyd(label, indices, num_movies, num_centroids, pydheight, MM_norm)

% Note this function is only used in the package to do bag-of-words, i.e.
% pydheight = 1; temporal structure of the video is not explored

% function to build svm (Mtrain/Mtest) data in a temporal pyramid
% labels: the cluster to which data points belong
% indices: list of cells, each contain .start, .end marking starting and
% ending sub_samples for distinct data samples (e.g. indices of first and last sift descriptors for images)
% num_movies: total number of images/movies/other data sample
% num_centroids: number of clusters
% pydheight: height of pyramid [1 for single layer (normal setting); 2 for whole + half; 3 for whole+ half +
% div by 4, h for whole+half+...+blksize:2^(h-1); and so on]

blk_dim = num_centroids;
num_blocks = 2^pydheight-1;
X = zeros(num_movies, blk_dim*num_blocks);

for i=1:num_movies   
    ds_sections = indices{i}.ds_sections;
    for ds = 1:length(ds_sections)
        for h = 1:pydheight        
        des_blk_size = (ds_sections(ds).end-ds_sections(ds).start+1)/(2^(h-1));
        
            starts = round((0:2^(h-1)-1)*des_blk_size)+ds_sections(ds).start;
            tails = round((1:2^(h-1))*des_blk_size)+ds_sections(ds).start-1;
            
            for idx = 1:2^(h-1)
            
                blk = idx+2^(h-1)-1;
                blkzero = (blk-1)*blk_dim;
                
                for j = starts(idx):tails(idx)
                    if exist('MM_norm', 'var')
                        X(i, blkzero+label(j))= X(i, blkzero+label(j)) + MM_norm(j);
                    else
                        X(i, blkzero+label(j))= X(i, blkzero+label(j)) + 1;
                    end
                end
            end        
        end
    end
end

end