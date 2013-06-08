function show_alignment(num)

data_dir='/Users/isabelle/Documents/Projects/DARPA/Data/DistributedChallengeData';
batch=alignment_labels(num).dataset_name;
movie=alignment_labels(num).videos;
frame=alignment_labels(num).frame;

M=read_movie([data_dir '/' batch '/M_' sprintf('%d.avi', movie)]);
K=read_movie([data_dir '/' batch '/K_' sprintf('%d.avi', movie)]);

FM=M(frame).cdata;
FK=K(frame).cdata;

BODY_SEGMENT = detect_body_segment(FK);
for k=1:3
    I=FM(:,:,k);
    I(BODY_SEGMENT==0)=0;
    OVERLAID_IMAGES(:,:,k)=I;
end
imdisplay(OVERLAID_IMAGES);

% Transform image to fit window
tx=alignment_annotation(num).translate_x;
ty=alignment_annotation(num).translate_y;
sx=alignment_annotation(num).scale_x;
sy=alignment_annotation(num).scale_y;

[p, n, d]=size(FM);
SM=imresize(FM, [round(sy*p), round(sx*n)]);

[p, n, d]=size(SM);
for k=1:3
    I0=SM(:,:,k);
    I=zeros(p, n);
    idxi=[1:p]+round(ty);
    idxj=[1:n]-round(tx);
    ig=find(idxi>0 & idxi<p);
    jg=find(idxj>0 & idxj<n);
    I(ig, jg)=I0(idxi(ig), idxj(jg));
    I(BODY_SEGMENT==0)=0;
    TRANSLATED_IMAGE(:,:,k)=I;
end
imdisplay(TRANSLATED_IMAGE);