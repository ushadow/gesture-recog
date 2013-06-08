function result = read_raw_depth(filename, frame)

% function result = read_raw_depth(filename, frame)

rows = 480;
cols = 640;

fid = fopen(filename);
offset=rows*cols*2*(frame-1);
fseek(fid, offset, 'bof');
result = fread(fid, [cols,rows], 'uint16');
fclose(fid);

result(result == 2047) = 0;
result = result';

    

