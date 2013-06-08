function pot = convert_to_pot(CPD, pot_type, domain, evidence)
% CONVERT_TO_POT Converts a Gaussian CPD to one or more potentials.
% pot = convert_to_pot(CPD, pot_type, domain, evidence)

sz = CPD.sizes;
ns = zeros(1, max(domain));
ns(domain) = sz;

odom = domain(~isemptycell(evidence(domain)));

switch pot_type
  case 'd', % discrete
    T = convert_to_table(CPD, domain, evidence);
    ns(odom) = 1;
    pot = dpot(domain, ns(domain), T);

  otherwise,
    error(['unrecognized pot_type' pot_type]);
end
    