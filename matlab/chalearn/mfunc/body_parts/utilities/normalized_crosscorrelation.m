function result = normalized_crosscorrelation(v1, v2)

v1a = v1 - mean(v1);
v2a = v2 - mean(v2);

v1b = v1a / sqrt(sum(v1a .* v1a));
v2b = v2a / sqrt(sum(v2a .* v2a));

result = sum(v1b .* v2b);
