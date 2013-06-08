function code = compute_hash( movie )
%code = compute_hash( movie )

% Isabelle Guyon -- isabelle@clopinet.com -- June 2012

L=length(movie.K);
H=round(L/2);
c1=L;
c2=mean(movie.M(H).cdata(:)-movie.M(1).cdata(:));
c3=mean(movie.K(end).cdata(:)-movie.K(H).cdata(:));

code=sqrt(c1)+c2+c3^2;

end

