function CPD = hhmm2Q_CPD(bnet, self, varargin)
% HHMMQ_CPD Make the CPD for a Q node in a 2 level hierarchical HMM
% CPD = hhmmQ_CPD(bnet, self, ...)
%
%  Fself(t-1)   Qps
%           \    |
%            \   v
%  Qold(t-1) ->  Q(t)
%            /
%           /
%  Fbelow(t-1) 
%
%
% optional args [defaults]
%
% Fself - node number <= ss
% Fbelow  - node number  <= ss
% Qps - node numbers (all <= 2*ss) - uses 2TBN indexing
% transprob - CPT for when Fbelow=2 and Fself=1
% startprob - CPT for when Fbelow=2 and Fself=2
% If Fbelow=1, we cannot change state.

if nargin == 0
  CPD = init_fields;
  CPD = class(CPD, 'hhmm2Q_CPD', discrete_CPD(0, []));
  return;
elseif isa(bnet, 'hhmm2Q_CPD')
  CPD = bnet;
  return;
end

ss = bnet.nnodes_per_slice;
ns = bnet.node_sizes(:);

% set default arguments
Fself = [];
Fbelow = [];
Qps = [];
startprob = [];
transprob = [];
clamped = 0;

for i=1:2:length(varargin)
  switch varargin{i},
   case 'Fself', Fself = varargin{i+1};
   case 'Fbelow', Fbelow = varargin{i+1};
   case 'Qps', Qps = varargin{i+1};
   case 'transprob', transprob = varargin{i+1}; 
   case 'startprob',  startprob = varargin{i+1}; 
   case 'clamped', clamped = varargin{i + 1};
  end
end

CPD = init_fields;

ps = parents(bnet.dag, self);
old_self = self - ss;
ndsz = ns(:)';
CPD.dom_sz = [ndsz(ps) ns(self)];
CPD.Fself_ndx = find_equiv_posns(Fself, ps);
CPD.Fbelow_ndx = find_equiv_posns(Fbelow, ps);
Qps = mysetdiff(ps, [Fself Fbelow old_self]);
CPD.Qps_ndx = find_equiv_posns(Qps, ps);
CPD.old_self_ndx = find_equiv_posns(old_self, ps);

Qps = ps(CPD.Qps_ndx);
CPD.Qsz = ns(self);
CPD.Qpsizes = ns(Qps);

CPD.transprob = transprob;
CPD.startprob = startprob;

CPD = class(CPD, 'hhmm2Q_CPD', discrete_CPD(clamped, CPD.dom_sz));
end

function CPD = init_fields()
CPD.dom_sz = [];
CPD.Fself_ndx = [];
CPD.Fbelow_ndx = [];
CPD.Qps_ndx = [];
CPD.old_self_ndx = [];
CPD.Qsz = [];
CPD.Qpsizes = [];
CPD.startprob = [];
CPD.transprob = [];
CPD.start_counts = [];
CPD.trans_counts = [];
end

