function distance = euclidean_distance(p1, p2)
    distance = sqrt( sum(  (p1 - p2)  .^ 2) );
end