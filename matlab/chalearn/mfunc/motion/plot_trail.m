function h=plot_trail(trail, h)
%h=plot_trail(trail, h)

% Isabelle Guyon -- isabelle@clopinet.com -- April 2012

if nargin<2, h=figure; else figure(h); end

 
mu=mean(trail); 

plot(trail); 
hold on; 
plot([0 length(trail)], [mu, mu], 'r--'); 

ttl=inputname(1);
ttl(ttl=='_')=' ';
title(ttl); 


end

