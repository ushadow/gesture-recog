function [m, C, hand] = obs_CPD_params_given_dps(CPD, domain, evidence)
% OBS_CPD_PARAMS_GIVEN_DPS Extracts parameters given evidence on all
% discrete parents.
% [m, C, hand] = obs_CPD_params_given_dps(CPD, domain, evidence)

ps = domain(1 : end - 1);
dps = ps(CPD.dps);
if isempty(dps)
  m = CPD.mean;
  C = CPD.cov;
  hand = CPD.hand;
else
  odom = domain(~isemptycell(evidence(domain)));
  dops = myintersect(dps, odom);
  dpvals = cat(1, evidence{dops});
  if length(dops) == length(dps) % All discrete parents are observed.
    dpsizes = CPD.sizes(CPD.dps);
    dpval = subv2ind(dpsizes, dpvals(:)');
    m = CPD.mean(:, dpval);
    C = CPD.cov(:, :, dpval);
    hand = CPD.hand(:, dpval);
  else % Some of the discrete parents are not observed.
    map = find_equiv_posns(dops, dps);
    index = mk_multi_index(length(dps), map, dpvals);
    m = CPD.mean(:, index{:});
    C = CPD.cov(:, :, index{:});
    hand = CPD.hand(:, index{:});
  end
end
    