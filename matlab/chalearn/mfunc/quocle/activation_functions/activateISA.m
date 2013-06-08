function act_p = activateISA(input, network_isa, pa_layer)
% t1 = tic;
if nargin<3
   pa_layer.type = 'lhthresh';
   pa_layer.lowthresh = 0.1;
   pa_layer.highthresh = 1;
end

act_p = zeros(size(network_isa.H, 1), size(input, 2), 'single');

batch_size = 5000; 
count = 0;

while(count~=size(input,2))
    batchend = min(count + batch_size, size(input,2));                
    
    act_w = activateNN(input(:, count+1:batchend), network_isa.W, single(0), @sq_vec, pa_layer);    
    
    act_p(:, count+1:batchend) = activateNN(act_w, network_isa.H, single(1e-4), @sqrt_vec, pa_layer);
    
    count = batchend;   
end
% dt = toc(t1);
% fprintf('\ntime taken: %f; size input %d\n', dt, size(input, 2));
end