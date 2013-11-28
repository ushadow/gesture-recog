function label = mostlikelilabel(ll)
%%
% ARGS
% ll  - cell array of log likelihoods. Each cell is a sequence.
%
% RETURNS
% label   - cell array of most likely labels.

label = cellfun(@(x) maxindex(x), ll, 'UniformOutput', false);
end

function index = maxindex(ll)
[~, index] = max(ll);
end