function [parents, local_start, local_end, lsc] = candidate_cut_graph( num, debug )
%[parents, local_start, local_end, lsc] = candidate_cut_graph( num, debug )
%   Create a graph for a candidate cut model considering all possible
%   groupings of segments 1-1, 1-2, 1-3, ... 2-2, 2-3, ... 3-3, etc.
% Input:
% num --            The number of segments to be grouped considered.
% Returns:
% parents --        A cell array of dim (num, num+1) containing 
%                   the indices of parents in the graph (the last column
%                   indicates how to exit the graph). The indices are
%                   represented as a matrix (2, np), where np is the number
%                   of parents and the lines are i anf j indices.
% local_start --    Boudary condition: first column of the local score matrix
% local_end --      Boudary condition: last column of the local score matrix
% lsc --            For debug purpose a random score matrix

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

if nargin<2, debug=0; end
if nargout>3, debug=1; end

parents=cell(num, num+1);
k=1;
for j=1:num, 
    parents{1, j}=[0; 1]; % By convention we call the root node [0 1]
    if debug
        lsc(1, j)=randn;
    end
end
for i=2:num
    for j=i:num
        parents{i, j}=[ 1:i-1; (i-1)*ones(1, i-1)];
        if debug
            lsc(i, j)=randn;
        end
    end
end

% Last column
parents{end, end} = [ 1:num; num*ones(1, num)];

nc=20;
if debug 
    col=jet(nc);
    figure;
    imagesc(lsc); colormap(gray); axis image; axis xy
    hold on
    for i=1:num
        for j=i:num
            text(j-.2, i-.2, sprintf('%d - %d', i, j), 'FontSize', 16, 'Color', [0 0 1], 'FontWeight', 'bold');
            if i>1
                par=parents{i, j};
                c=col(round(rand*(nc-1)+1),:);
                for k=1:size(par,2)
                    ii=par(1, k); 
                    jj=par(2, k);
                    plot([j, jj], [i ii], 'Color', c, 'LineWidth', 2);
                    plot([j, jj], [i ii], 'Color', c, 'LineWidth', 2);
                    plot(j, i, '.', 'Color', c, 'MarkerSize', 40);
                end
            end  
        end
    end
    title('Links to parent nodes', 'FontWeight', 'bold', 'FontSize', 14);
end

local_start=-eps*ones(num,1);
local_start(1)=0;

local_end=-Inf*ones(num,1);
local_end(end)=0;


end

