a49 = read_raw_depth('vassilis_hard59.bin', 49);
a50 = read_raw_depth('vassilis_hard59.bin', 50);
a51 = read_raw_depth('vassilis_hard59.bin', 51);
figure(1); imshow(a50, [])

diff1 = abs(a49 - a50);
diff2 = abs(a50 - a51);
motion = min(diff1, diff2);
motion(a49 == 0) = 0;
motion(a50 == 0) = 0;
motion(a51 == 0) = 0;
figure(3); imshow(motion, []);

