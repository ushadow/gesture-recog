function result = find_hand(frames, frame_number, size)

% function result = find_hand(filename, frame_number, size)

%previous2 = read_raw_depth(filename, frame_number-10);
previous_number = max(1, frame_number - 3);
next_number = min(numel(frames), frame_number + 3);

previous = frames{previous_number};
current = frames{frame_number};
next = frames{next_number};

person = find_person(current);
median_depth = median(current(person))
max_depth = max(current(person))

diff1 = abs(previous-current);
diff2 = abs(next-current);
diff = max(diff1, diff2);

diff(current == 0) = 0;
diff(current > max_depth) = 0;

roi = (diff > 1);
scores = current .* roi;
scores(roi) = scores(roi) - median_depth;
scores = scores .* diff;
scores(previous == 0) = 0;
scores(next == 0) = 0;

f = ones(size, 1);
f1 = imfilter(scores, f, 'same');
f2 = imfilter(f1, f', 'same');

min_value = min(min(f2));
[is, js] = find(f2 == min_value);
%size(is)
result = [is(1), js(1)];

