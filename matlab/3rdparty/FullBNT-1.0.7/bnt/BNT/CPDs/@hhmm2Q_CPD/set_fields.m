function CPD = set_fields(CPD, varargin)
% SET_PARAMS Set the parameters (fields) for a tabular_CPD object
% CPD = set_params(CPD, name/value pairs)
%
% The following optional arguments can be specified in the form of name/value pairs:
%
% CPT, prior, clamped, counts
%
% e.g., CPD = set_params(CPD, 'CPT', 'rnd')

args = varargin;
nargs = length(args);
for i=1 : 2 : nargs
  switch args{i},
   case 'Fself_ndx', 
    CPD.Fself_ndx = args{i + 1};
   case 'Fbelow_ndx',       
    CPD.Fbelow_ndx = args{i + 1};
   case 'Qps_ndx',      
    CPD.Qps_ndx = args{i + 1};  
   case 'Qpsizes',
    CPD.Qpsizes = args{i + 1};
   otherwise,  
    error(['invalid argument name ' args{i}]);       
  end
end


