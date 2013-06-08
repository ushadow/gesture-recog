function [feat, pos] = get_stip(stipfname, rep)
%feat = get_stip(stipfname, rep)
% rep: choice of representation:
% 1) pos = [y x t]
% 2) hog
% 3) hof
% 4) pos+hog
% 5) hog+hof
% 6) all

if nargin<2, rep=4, end

[pos, val, dscr]=readstips_text(stipfname); 
    coord=pos;
    hof=dscr(:,1:72);
    hog=dscr(:,73:90);
    switch rep
        case 1
            feat= coord; 
        case 2
            feat= hog;            
        case 3
            feat= hof;
        case 4
            feat= [coord, hog];            
        case 5
            feat= [coord, hof];
        case 6
            feat= [coord, hog, hof];
    end

    
end

