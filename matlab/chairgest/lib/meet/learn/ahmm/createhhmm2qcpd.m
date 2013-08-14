function cpd = createhhmm2qcpd(bnet, self, cpdStruct)
% ARGS
% self  - the index of the node in the bnet.

cpd = hhmm2Q_CPD(bnet, self, 'startprob', cpdStruct.startprob, ...
                 'transprob', cpdStruct.transprob); 
cpd = set_fields(cpd, 'Fself_ndx', cpdStruct.Fself_ndx, ...
      'Fbelow_ndx', cpdStruct.Fbelow_ndx, 'Qps_ndx', cpdStruct.Qps_ndx, ...
      'Qpsizes', cpdStruct.Qpsizes); 
end