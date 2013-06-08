function H=head_template(M, head_box)
%H=head_template(M, head_box)

% Isabelle Guyon -- isabelle@clopinet.com -- Jan 2012

borderi=5;
borderj=10;

[maxi, maxj, T]=size(M(1).cdata);

rngi = max(1, head_box(2)-borderi) : min(head_box(2)+head_box(4)+borderi, maxi) ;
rngj = max(1, head_box(1)-borderj) : min(head_box(1)+head_box(3)+borderj, maxj);

H=double(M(1).cdata(rngi, rngj, 1));
H=H-mean(H(:));


