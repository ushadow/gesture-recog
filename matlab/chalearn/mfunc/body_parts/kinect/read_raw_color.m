function result = read_raw_color(filename, frame)

% function result = read_raw_color(filename, frame)

rows = 480;
cols = 640;

fid = fopen(filename);
offset=rows*cols*3*(frame-1);
fseek(fid, offset, 'bof');
raw_color = fread(fid, [cols*rows*3], 'uint8');
fclose(fid);

result = zeros(rows,cols,3,'uint8');

red = raw_color(1:3:(3*rows*cols));
green = raw_color(2:3:(3*rows*cols));
blue = raw_color(3:3:(3*rows*cols));

red = reshape(red, cols, rows);
red = red';
green = reshape(green, cols, rows);
green = green';
blue = reshape(blue, cols, rows);
blue = blue';

result(:,:,1) = red;
result(:,:,2) = green;
result(:,:,3) = blue;

