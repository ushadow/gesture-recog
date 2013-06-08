function [ prediction, stat ] = svr_test( labels, seqs, model )
% [prediction, stat] = svr_test( labels, seqs, model )
%
% Input: 
%   -labels      : n-by-m matrix, n test instances with m features. 
%   -seqs        : n-by-1 vector, test labels (type should be double)
% 
% Output:
%   - prediction : n-by-1 vector, prediction result
%   - stat       : struct
%     - time_test
%     - mean_squared_error
%     - squared_correlation_coefficient

assert( size(labels,1) == size(seqs,1) );
tid = tic;
[prediction, b] = svmpredict(labels,seqs,model);
stat.time = toc(tid);
stat.mean_squared_error = b(2);
stat.squared_correlation_coefficient = b(3);
