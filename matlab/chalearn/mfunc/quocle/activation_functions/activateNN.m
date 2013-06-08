function act_out = activateNN(act_in, W, bias, act_func, pa_layer)

% funciton to feed forward one layer of neural network
% act_in and act_out are column vectors
% act_func needs to handle vectors

if ~exist('pa_layer','var')
    pa_layer.type = 'none';        
end

if isfield(pa_layer, 'gpu')
   W = gsingle(W);
   bias = gsingle(bias);
end

act_out = zeros(size(W, 1), size(act_in, 2), 'single');

% batch for gpu
batch_size = 5000;
count = 0;
batchend = 0; 
while batchend~=size(act_in, 2)
    batchend = min(size(act_in, 2), count + batch_size);      
    batch = act_in(:, count+1:batchend);
    if isfield(pa_layer, 'gpu')
       batch = gsingle(batch);
    end    
    z_out = W*batch + bias;
    act_out(:, count+1:batchend) = single(act_func(z_out));
    count = batchend;
end

%% post activation processing
if strcmp(pa_layer.type, 'lhthresh')
    act_out(act_out > pa_layer.highthresh) = pa_layer.highthresh;
    act_out(act_out < pa_layer.lowthresh) = 0;
elseif strcmp(pa_layer.type, 'hthresh')
    act_out(act_out > pa_layer.highthresh) = pa_layer.highthresh;
elseif strcmp(pa_layer.type, 'lthresh')
    act_out(act_out < pa_layer.lowthresh) = 0;
end

end
