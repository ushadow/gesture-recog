function CPD = update_ess(CPD, fmarginal, evidence, ~, ~, ~)
% fmarginal: the marginal on self's family which includes self's parents
% and self.
% evidence: 2D cell array for one sequence. Each cell contains two vectors.
                        
% Figure out the node numbers associated with the parent. The node number
% is unrolled in time, i.e. i + (t - 1) * ss.
dom = fmarginal.domain;
self = dom(end);

CPD.nsamples = CPD.nsamples + 1;
[ss dpsz] = size(CPD.mean); % ss = self size for the continuous features.
n = size(CPD.hand, 1); % n = size of the hand depth image.

w = fmarginal.T(:);
CPD.Wsum = CPD.Wsum + w;
y = evidence{self};
y1 = y{1}; % First part of the observation with continuous values.
y2 = y{2}; % Depth image.
Cy1y1 = y1 * y1';
WY1 = repmat(w(:)', ss, 1); % WY(y, i) = w(i)
WY1Y1 = repmat(reshape(WY1, [ss 1 dpsz]), [1 ss 1]); % WYY((y, y', i) = w(i)
CPD.WY1sum = CPD.WY1sum + y1(:) * w(:)'; % w(:)' is a row matrix.
CPD.WY1Y1sum = CPD.WY1Y1sum + ...
               WY1Y1 .* repmat(reshape(Cy1y1, [ss ss 1]), [1 1 dpsz]);

CPD.WY2sum = CPD.WY2sum + y2(:) * w(:)';
end