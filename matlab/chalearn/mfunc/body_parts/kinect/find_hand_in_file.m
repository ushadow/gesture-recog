function result = find_hand_in_file(filename, frame_number, side)

% function result = find_hand_in_file(filename, frame_number, size)

%previous2 = read_raw_depth(filename, frame_number-10);
previous1 = read_raw_depth(filename, frame_number-10);
current = read_raw_depth(filename, frame_number);
next1 = read_raw_depth(filename, frame_number+10);
%next2 = read_raw_depth(filename, frame_number+10);

person = find_person(current);
median_depth = median(current(person))
max_depth = max(current(person))

diff1 = abs(previous1-current);
diff2 = abs(next1-current);
%diff3 = abs(previous2-current);
%diff4 = abs(next2-current);
diff = max(diff1, diff2);
%diff = max(diff2, diff3);
%diff = max(diff3, diff4);

%diff(previous == 0) = 0;
diff(current == 0) = 0;
%diff(next == 0) = 0;
diff(current > max_depth) = 0;

roi = (diff > 1);
scores = current .* roi;
scores(roi) = scores(roi) - median_depth;
scores = scores .* diff;
scores(previous1 == 0) = 0;
scores(next1 == 0) = 0;

f = ones(side, 1);
f1 = imfilter(scores, f, 'same');
f2 = imfilter(f1, f', 'same');

min_value = min(min(f2));
[is, js] = find(f2 == min_value);
size(is)
result = [is(1), js(1)];

