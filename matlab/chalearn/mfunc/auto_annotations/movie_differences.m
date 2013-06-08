function DM = movie_differences(M)
%DM = movie_differences(M)
% Compute the mean and the difference of movie's consecutive frames

% Isabelle Guyon -- isabelle@clopinet.com -- Dec. 2011-Jan 2012

for k=2:length(M)
    % takes only the positive value... (integer arithmetic)
    DM(k-1).cdata = M(k).cdata-M(k-1).cdata;
    DM(k-1).colormap=M(k-1).colormap;  
end
DM(length(M)).cdata=M(end-1).cdata-M(end).cdata;
DM(length(M)).colormap=M(end-1).colormap;

end

