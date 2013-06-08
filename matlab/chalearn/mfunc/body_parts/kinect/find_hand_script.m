filename = 'paul_hard04.bin';
square_size = 11;
half = floor(square_size/2);
side = 50;

for frame = 100:1:500
    a = read_raw_depth(filename, frame);
    b = find_hand(filename, frame, side);
    c = a;
    c((b(1)-half):(b(1)+half), (b(2)-half):(b(2)+half)) = 0; 
    figure(1); imshow(a, []);
    figure(2); imshow(c, []); 
    disp(frame);
end
