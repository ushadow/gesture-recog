% Examples of usage of the Viterbi algorithm

debug=1;

% 1) Match 2 sequences

x1=sin(1:.5:2*pi);
x2=cos(1:.5:2*pi);
local_scores=euclid_simil(x1, x2);
local_scores=euclid_simil(x1', x2');
viterbi(local_scores,[],[],[], debug);

% 2) Uses 3 templates and match a sequence where they are out of order

x={};
r=randperm(10);
L=r(1:3);
x{1}=rand(r(1),1);
x{2}=rand(r(2),1);
x{3}=rand(r(3),1);
rp=randperm(3);
X=[x{1}; x{2}; x{3}];
Y=[x{rp(1)}; x{rp(2)}; x{rp(3)}];
local_scores=euclid_simil(X, Y);
[parents, local_start, local_end] = simple_forward_model( L, [], debug );
[best_score, global_scores, best_path, resu, cut]=viterbi(local_scores, parents, local_start, local_end, debug);

% 3) Same thing but introduce an transition model
xtr=rand;
X=[x{1}; x{2}; x{3}; xtr];
Y=[xtr; x{rp(1)}; xtr; xtr; x{rp(2)};xtr;  x{rp(3)}; xtr;  xtr];
local_scores=euclid_simil(X, Y);
[parents, local_start, local_end] = simple_forward_model( L, 1, debug );
[best_score, global_scores, best_path, resu, cut]=viterbi(local_scores, parents, local_start, local_end, debug);

% 4) Create an abitrary candidate cut graph
[parents, local_start, local_end, lsc] = candidate_cut_graph( 5);
[best_score, global_scores, best_path, resu]=viterbi(lsc, parents, local_start, local_end, debug);
