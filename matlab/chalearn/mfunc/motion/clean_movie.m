function M = clean_movie( M, superclean )
%Mclean = clean_movie( M, superclean )
% Remove background and noise

if nargin<2, superclean=0; end

addtop=1;
debug=0;
for k=1:length(M)
    frame=M(k).cdata;
    M(k).cdata=bgremove(frame,debug,addtop,superclean);
end

end

