% cost per pair for dynamic time warping
% return euclidean distance
function cost = get_cost(p1, p2)
    diff = p1 - p2;
    diff = diff .* diff;
    cost = sqrt(sum(diff));
end