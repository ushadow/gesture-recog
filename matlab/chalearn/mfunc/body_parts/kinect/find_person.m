function result = find_person(frame)

depth_threshold = 10;
component_threshold = 5;

segmentation = depth_segmentation(frame, depth_threshold);

[labels, number] = bwlabel(segmentation, 4);
[rows, cols] = size(segmentation);

% create an array of counters, one for each connected component.
counters = zeros(1,number);
for row = 1:rows
    for col = 1:cols
        % for each i ~= 0, we count the number of pixels equal to i in the labels
        % matrix
        % first, we create a component image, that is 1 for pixels belonging to
        % the i-th connected component, and 0 everywhere else.

        label = labels(row, col);
        if (label ~= 0)
            counters(label) = counters(label) + 1;
        end
    end
end
    
% find the id of the largest component
% we pass -counters as argument because we want to find max areas,
% not min areas.
[areas, ids] = sort(-counters);    

depths = zeros(1, component_threshold);
for i=1:component_threshold
    component = (labels == (ids(i)));
    pixels = frame(component);
    depths(i) = mean(pixels(i));
end
    
[value, index] = min(depths);
result = (labels == ids(index));
