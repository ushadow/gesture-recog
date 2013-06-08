function M = none( V, prepro_param )
%M = none( V, prepro_param )
% No preprocessing
% Just convert the video V to a data matrix M.
% the columns are features and the lines are the frames (so time runs
% vertically), to be consistent with most data mining software in which the
% features are in columns.

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

N=prod(V(1).cdata);
P=length(V);
M=zeros(P, N);
for k=1:P
    M(k,:)=double(V(1).cdata(:));
end

end

