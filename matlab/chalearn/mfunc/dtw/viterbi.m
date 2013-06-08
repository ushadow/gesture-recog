function [best_score, global_scores, best_path, cut, label]=viterbi(local_scores, parents, local_start, local_end, debug)
%[best_score, global_scores, best_path, cut, label]=viterbi(local_scores, parents, local_start, local_end, debug)
% Run the Viterbi algorithm.
% All transition scores are 1.
% Inputs:
% local_scores --   A matrix (n, p) of scores representing e.g. similarities between the elements of
%                   two sequences. The models/reference sequence elements are in columns and 
%                   the sequence to be matched is in line. The local_scores
%                   matrix may represent something else, e.g. scores for
%                   various candidate cuts.
% parents --        A cell array of dim n of lists of parent nodes in the model,
%                   or a cell array (n, p+1). If a cell array of dim n is
%                   given, the same connections are repeated along the
%                   second dimension.
% local_start --    A vector of dim n. Local scores at the beginning. 
%                   For forward models, usually a bunch of -eps with
%                   0 only where the individual models start.
% local_end --      A vector of dim n. Local scores at the end. 
%                   For forward models, usually a bunch of -Inf with
%                   0 only where the individual models end.
%
% Returns:
% best_score --     Best sum of local scores (best sequence match)
% global_scores --  Matrix (n, p) of partial global scores computed by
%                   dynamic programming according to the Viterbi algorithm.
%                   global_scores(i, j) = local_scores(i, j) + max(global_score(parents(i, k), j-1));
%                   where k=j, if parents i 2d of k=1 if parents is a vector.
% best_path --      The best path obtained by back tracking, a vector of
%                   dimension n (to account for the boundary conditions)
% cut --            The position of the cuts (model jumps of candidate cuts).
% label --          The model IDs of the cut chuncks.
% 
% If parents, local_start, and local_end are not given, perform something
% analogous at DTW (i.e. assumes the scores represent the matching of 2
% sequences, start at one end and end at the other.

% Isabelle Guyon -- isabelle@clopinet.com -- May 2012

% The default values allow you to run DTW between 2 sequences by supplying
% a matrix of similarities between pairs if frames in the sequences.
[n, p]=size(local_scores);
if nargin<2 || isempty(parents), 
    parents=cell(n, 1);
    parents{1}= 1;
    parents{2}= [1 2];
    for k=3:n
        parents{k} = [k, k-1, k-2];
    end
end
if nargin<3 || isempty(local_start), 
    local_start=-eps*ones(n, 1); % Soft initialization; use -Inf to force starting in given nodes with 0 local_start score
    local_start(1)=0;
end
if nargin<4 || isempty(local_end), 
    local_end=-Inf*ones(n, 1);
    local_end(end)=0;
end
if nargin<5,
    debug=0;
end

[nn, pp]=size(parents);
if nn~=n, error('Graph size does not match score matrix'); end
if pp>1,
    if pp~=p+1, error('Graph size does not match score matrix'); end
end

% Initialization
global_scores=zeros(n, p);
back_pointers=cell(n, p);

forbidden_start=find(local_start==-Inf);
if pp>1 || isempty(forbidden_start)
    % Soft initialization
    for i=1:n
        par=parents{i, 1};
        if ~isempty(par)
            [global_scores(i, 1), bp] = max(local_start(max(1, par(1, :))));
            back_pointers{i, 1} = par(:, bp);
            global_scores(i, 1) = global_scores(i, 1) + local_scores(i, 1);
        end
    end
else
    % Force to start in one of the start nodes
    mini=min(0, min(local_scores(:)))-eps;
    model_start=find(local_start==0);
    local_start(forbidden_start)=mini;
    [back_pointers{model_start, 1}] = deal(0);
    global_scores(:,1)=local_scores(:,1)+local_start;
end

% Forward propagate
for j=2:p
    % Choose the parent column (always the same if parents is a vector)
    if pp>1, k=j; else k=1; end
    for i=1:n
        par=parents{i, k}; 
        if ~isempty(par)
            % Find the scores of the parents
            if pp>1 
                if prod(par)>0
                    gs=global_scores((par(2,:)-1)*n+par(1,:));
                else
                    gs=0; % the parent is the root node
                end
            else
                gs=global_scores(par, j-1);
            end
            % Retain the largest and keep track of the parent ID
            [global_scores(i, j), bp] = max(gs);
            back_pointers{i, j} = par(:,bp);
            % Add the local score
            global_scores(i, j) = global_scores(i, j) + local_scores(i, j);
        end
    end
end

% Last column
global_end=-Inf*ones(n,1);
final_pointer=cell(n,1);
% Choose the parent column (always the same if parents is a vector)
if pp>1, k=p+1; else k=1; end
for i=1:n
    par=parents{i, k};
    if ~isempty(par)
        % Find the scores of the parents
        if pp>1
            if prod(par)>0
                gs=global_scores((par(2,:)-1)*n+par(1,:));
            else
                gs=0; % the parent is the root node
            end
        else
            gs=global_scores(par, end);
        end
        [global_end(i), fp] = max(gs);   
        final_pointer{i} = par(:, fp);
        global_end(i) = global_end(i) + local_end(i);
    end
end

% Avoid ties
global_end=global_end+eps*global_scores(:,end);

% Find the best global score
[best_score, idx] = max(global_end);

% Back track
best_path=zeros(2, p+2);
best_path(:,end) = [idx; p+1];
if pp>1
    best_path(:,end-1) = final_pointer{idx};
else
    best_path(:,end-1) = [final_pointer{idx}; p];
end
for k=p:-1:1
    bp=best_path(:, k+1);
    if pp>1
        if prod(bp)>0
            best_path(:,k) = back_pointers{bp(1), bp(2)};
        else
            best_path(:,k) = [0;1]; % Root node
        end
    else
        best_path(:,k) = [back_pointers{bp(1), bp(2)}; k-1];
    end
end

% Determine the sequence of cuts and labels
if pp>1
    cut=[];
    idxg=find(best_path(1,:)>0 & best_path(2,:)<p+1);
    best_path0=best_path(:,idxg);
    cut=[ 0, best_path0(2,1:end)];
    for k=1:length(best_path0)
        label{k}=sprintf('%d-%d ', best_path0(1,k), best_path0(2,k));
    end
else 
    model_start=find(local_start==0);
    %lbl=find(model_start==best_path(1,2));
    lbl=find(model_start==best_path(1,1));
    if ~isempty(lbl)
        label(1)=lbl;
    else
        label(1)=0;
    end
    cut(1)=0;
    i=2;
    for k=1:p % k=2:p
        if best_path(1,k+1)~=best_path(1,k)
            %bp=[bp best_path(1,k+1)];
            mdl=find(model_start==best_path(1,k+1));
            if ~isempty(mdl)
                label(i)=mdl;
                cut(i)=k-1;
                i=i+1;
            end
        end
    end
    cut(i)=p;
    label=label';
end

% Remove the start and end nodes from the path
if debug < 2
    if pp>1
        best_path=best_path0;
    else
        best_path=best_path(:,2:end-1);
    end
end

% Show the result
if debug % && n<=30 && p<=30
    if n<=30 && p<=30
        msz=40;
    else
        msz=10;
    end
        
    imdisplay(global_scores); hold on
    for i=1:n
        for j=1:p
            bp=back_pointers{i, j};
            if debug >1 % show all the back pointers
                for k=1:size(bp, 2)
                    if pp>1
                        bpj=bp(2,k);
                    else
                        bpj=j-1;
                    end
                    plot([j bpj], [i bp(1, k)], 'r-', 'LineWidth', 2);
                    plot(j, i, 'r.', 'MarkerSize', msz);
                end
            end
            if pp>1 & ~isempty(bp)
                text(j-.2, i-.2, sprintf('%d - %d', i, j), 'FontSize', 16, 'Color', [0 0 1], 'FontWeight', 'bold');
            end
        end
    end
    plot(best_path(2,:), best_path(1,:), 'g-', 'LineWidth', 2);
    plot(best_path(2,:), best_path(1,:), 'go', 'MarkerSize', msz/2, 'LineWidth', 2);
    if ~isempty(label)
        if isnumeric(label)
            xlabel(['BEST PATH LABELS: ' num2str(label(:)')], 'FontWeight', 'bold', 'FontSize', 16);
        else
            xlabel(['BEST PATH LABELS: ' label{:}], 'FontWeight', 'bold', 'FontSize', 16);
        end
    end
      
    axis xy
    title(['BEST PATH CUTS: ' num2str(cut)], 'FontWeight', 'bold', 'FontSize', 16);
end




end

