function I = getnfoldindex(nsample, ntest, nfold, seed)
% I = get_nfold_indices( num_samples, nfold )
% Generates nfold indices by random permutation
%
% Input:
%  - num_samples: total number of samples
%  - nfold: desired fold
%  - seed: random seed for randperm (default 0)
%
% Output:
% - I: 2-by-nfold cell array. Each column contain indices for a set of 
%      2-splits.

if ~exist('seed','var'), seed = 0; end

RandStream.setGlobalStream(RandStream('mt19937ar','seed',seed));
randNDX = randperm(nsample - ntest);
foldSize = floor((nsample - ntest) / nfold);

I = cell(2, nfold);
for i=1:nfold
    I{2, i} = randNDX((i - 1) * foldSize + 1 : i * foldSize);
    I{1, i} = setdiff(randNDX, I{2, i});
    I{3, i} = nsample - ntest + 1 : nsample;
end

end

