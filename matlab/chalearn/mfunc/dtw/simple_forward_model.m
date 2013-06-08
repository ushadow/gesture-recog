function [parents, local_start, local_end] = simple_forward_model( L, N, debug )
%[parents, local_start, local_end] = simple_forward_model( L, N, debug )
%   Create the graph of a simple hmm forward model
% Input:
% L --              A vector containing the length of the individual sub-models
% N --              Optionally the length of a transition model through
% which one must always go between models (resting position).
% Returns:
% parents --        A cell array containing vectors of indices of the parents
%                   of a node
% local_start --    Boudary condition: first column of the local score matrix
% local_end --      Boudary condition: last column of the local score matrix

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

if nargin<3, debug=0; end
if nargin<2 || isempty(N), N=0; end

% Number of models
if N~=0
    L(end+1)=N;
end
Ntr=length(L);

% Positions of the last nodes
last_node=zeros(1, Ntr);
last_node(1)=L(1);
for k=2:Ntr
    last_node(k)= last_node(k-1)+L(k);
end

% Array of parents
parents=cell(sum(L),1);
k=1;
for i=1:Ntr
    if N==0
        % The parents of the first node are the last nodes of the other
        % models, and itself.
        parents{k}=unique([ k last_node]);
    else
        if i~=Ntr
        % The parents of the first node are the last node of the transition
        % model and itself.
            parents{k}=[ k last_node(end)];
        else
        % Except for the transition model, for which the parents of the
        % first node are the last nodes of all the other models.
            parents{k}=[ k last_node(1:end-1)];
        end
    end
    
    k=k+1;
    for j=2:L(i)
        if j==2
            parents{k}=[k, k-1];
        else
            parents{k}=[k, k-1, k-2];
        end
        k=k+1;
    end
end

if debug
	for k=1:length(parents), fprintf('%d: ', k); fprintf('%d ', parents{k}), fprintf('\n'); end
end

local_start=[];
local_end=[];
for k=1:Ntr
    %b=-eps*ones(L(k),1); 
    b=-Inf*ones(L(k),1); % Force start in nodes with 0 score.
    e=-Inf*ones(L(k),1);
    b(1)=0;
    e(end)=0;
    local_start=[local_start; b];
    local_end=[local_end; e];
end

end

