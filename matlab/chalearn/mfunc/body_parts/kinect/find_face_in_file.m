function result = find_face_in_file(filename)

% function result = find_face_in_file(filename)
%
% it takes as argument a filename
% finds the face by considering several frames

first = read_raw_depth(filename, 1);
[rows, cols] = size(first);
average_person = zeros(rows, cols);

number_of_random_frames = 20;
random_frames = round(rand(1,number_of_random_frames) * 400) + 100;
for (frame = random_frames)
    depth = read_raw_depth(filename, frame);
    person = find_person(depth);
    average_person = average_person + person;
end
   
person = (average_person > (number_of_random_frames / 2));
projections = sum(person, 2);

% find top row of face
top_row = -1;
for i=1:rows
    if (projections(i) > 0) 
        top_row = i;
        break;
    end
end
        
% find width of face
max_width_row = -1;
min_width_row = -1;
max_width = -1;
min_after_max = -1;
for i=(top_row+5):rows
    width = projections(i);
    if (width > max_width)
        max_width = width;
        min_after_max = max_width;
        max_width_row = i;
    end
    if (width < min_after_max)
        min_after_max = width;
        min_width_row = i;
        if (min_after_max < max_width * 0.7)
            break;
        end
    end
end

% find neck
min_width = min_after_max;
neck_row = -1;
for i=min_width_row:rows
    width = projections(i);
    if (width < min_width)
        min_width = width;
        neck_row = i;
    end
    if (width > max_width)
        break;
    end
end

result = [top_row, neck_row];

% find left column
left_col = -1;
for i = 1:rows
    if (person(max_width_row, i) > 0)
        left_col = i;
        break;
    end
end

% find right column
right_col = -1;
for i = left_col:rows
    if (person(max_width_row, i) == 0)
        right_col = i;
        break;
    end
end

result = [top_row, neck_row, left_col, right_col];
