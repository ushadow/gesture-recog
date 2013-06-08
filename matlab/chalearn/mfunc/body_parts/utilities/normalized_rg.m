function result = normalized_rg(img)

result = double(img);
gray = sum(result, 3);

result(:,:,1) = result(:,:,1) ./ gray;
result(:,:,2) = result(:,:,3) ./ gray;
result(:,:,3) = result(:,:,3) ./ gray;
result(isnan(result)) = 0;

