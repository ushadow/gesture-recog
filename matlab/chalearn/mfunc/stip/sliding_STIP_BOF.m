function [BOF, FEAT, POS] = sliding_STIP_BOF(stipfile, centers, L_tr, rep, nover )
%BOF = sliding_STIP_BOF( STIP_FEAT, POS, centers, L_tr, rep, nover )
% Get a sliding window bag of features representation
% Inputs:
% FEAT --  STIP features
% POS --   Position part of the features (necessary to recover the timing)
% centers --    centers of the BOF representation
% Ltr --        average duration of a training example
% Lte --        duration of the test sequence
% rep --        choice of representation
% nover --      overlap between windows (total length of representation =
% Returns:
% BOF --        matrix n x cnum of n meta-frames times cnum BOF features
% FEAT --       the STIP features (in case you need them)
% POS --        the positions of the STIP features

if nargin<4, rep=4; end
if nargin<5, nover=3; end

% Get the feature representation
[FEAT, POS] = get_stip(stipfile, rep);

% Get the time
T_te=POS(:,3);
L_te=max(T_te);

% Dimension the sliding window and the steps
N=round(L_te/L_tr);
wnum=1+nover*(N-1);
w=round(L_tr);
s=ceil(L_tr/nover);
beg=1;
fin=min(beg+w, L_te);

cnum=size(centers, 1);
BOF_te=zeros(wnum, cnum);
for k=1:wnum
    idx=find(T_te>=beg & T_te<fin);
    dscr=FEAT(idx,:);
    % Assignment of dscr_te features of the test sequence to cluster centers
    dist=eucliddist(centers, dscr);
    [sdist, lbl]=min(dist);
    H=histc(lbl, 1:cnum)+eps;
    BOF(k, :)=H/sqrt(H*H');
    beg=beg+s;
    fin=min(beg+s, L_te);
end


end

