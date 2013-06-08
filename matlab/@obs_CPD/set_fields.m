function CPD = set_fields(CPD, varargin)

args = varargin;
nargs = length(args);
for i = 1 : 2 : nargs
  switch args{i},
    case 'mean', CPD.mean = args{i + 1};
    case 'cov', CPD.cov = args{i + 1};
    case 'cov_type', CPD.cov_type = args{i + 1};
    case 'tied_type', CPD.tied_cov = args{i + 1};
    case 'clamp_mean', CPD.clamped_mean = args{i + 1};
    case 'clamp_cov', CPD.clamped_cov = args{i + 1};
    case 'clamp', clamp = args{i + 1};
      CPD.clamped_mean = clamp;
      CPD.clamped_cov = clamp;
    otherwise,
      error(['invalid argument name ' args{i}]);
  end
end