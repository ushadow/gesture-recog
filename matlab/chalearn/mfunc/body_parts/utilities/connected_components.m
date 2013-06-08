function [labels, sorted_labels, areas] = connected_components(binary, four_or_eight)

% function [labels, sorted_labels, areas] = connected_components(binary)
%
% returns a boolean image where non-zero pixels represent
% the k-th largest connected component of the input image

if (nargin == 1)
  four_or_eight = 4;
end

% connected component analysis
[labels, number] = bwlabel(binary, four_or_eight);
[rows, cols] = size(binary);

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
    
% we pass counters as argument because we want to find max areas,
% not min areas.
[areas, sorted_labels] = sort(counters, 'descend');    
