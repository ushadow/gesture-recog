This is work in progress.
main2.m: processes data to compute the head boxes

The principle routine of interest is:
[~, ~, ~, head_box, quality]=annotate(M);
where M is a Kinect depth movie.

Other routines of interest are:
save_annot_as_csv: convert the annotations to csv format
compare_annot: compare manual annotation and automatic annotations.
