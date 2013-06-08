function M=rescale_movie(M, n, m, flip) 
%M=rescale_movie(M, n, m, flip) 
% Rescale a movie by a factor that makes it that is preserves its aspect
% ratio and fits in the [n x m] rectangle.
% If flip == 1, take also the mirror image

% Isabelle Guyon -- isabelle@clopinet.com -- June 2011

if nargin<4, flip=0; end

if isa(M, 'struct')

    [m0, n0, t]=size(M(1).cdata);

    factor=min(n/n0, m/m0);

    if factor ~=1
        for k=1:length(M)
            M(k).cdata=imresize(M(k).cdata, factor);
        end
    else
        %fprintf('no rescaling\n');
    end

    if flip
        fprintf('mirror image\n');
        for k=1:length(M)
            M(k).cdata=flipdim(M(k).cdata, 2);
        end
    end

else

    [m0, n0]=size(M{1});

    factor=min(n/n0, m/m0);

    if factor ~=1
        for k=1:length(M)
            M{k}=imresize(M{k}, factor);
        end
    else
        fprintf('no rescaling\n');
    end

    if flip
        fprintf('mirror image\n');
        for k=1:length(M)
            M{k}=flipdim(M{k}, 2);
        end
    end
        
end



end

