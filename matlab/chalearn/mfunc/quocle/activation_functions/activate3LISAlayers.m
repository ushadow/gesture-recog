function [res, act_l2_pool, act_l1_pool, l1_motion] = activate3LISAlayers(network, data, batch_size, pool_type, postact)
%tstart = tic;

nr_samples = size(data, 2);
nr_done = 0;
counter = 1;

%% initialize result
res = zeros(network.isa{3}.num_features, nr_samples);
l1_motion = zeros(1, nr_samples);

%!!!!hard code for pool_type 1: unless need to change dimensions
act_l1_pool = zeros(network.isa{3}.num_features, nr_samples);
act_l2_pool = zeros(network.isa{3}.num_features, nr_samples);

while(nr_done<nr_samples)
    %tstart_batch = tic;
    nr_to_calc = min(nr_samples-nr_done, batch_size);
    
    data_batch = data(:, (nr_done+1):(nr_done+nr_to_calc));
    
    %----------wrapper-------------    
    %% activate in batches
    
    [act_l2_list, act_l2_pool_batch, act_l1_pool_batch, l1_motion_batch] = transactConvISA2layers(network, data_batch, pool_type, postact);
    
    res(:,nr_done+1:nr_done+nr_to_calc)= activateISA(act_l2_list, network.isa{3}, postact.layer3);   
    l1_motion(1, nr_done+1:nr_done+nr_to_calc) = l1_motion_batch;

    
    %% l1 l2 pooled activations
    act_l1_pool(:,nr_done+1:nr_done+nr_to_calc) = act_l1_pool_batch;
    act_l2_pool(:,nr_done+1:nr_done+nr_to_calc) = act_l2_pool_batch;
    
    %----------wrapper-------------

    nr_done  = nr_done + nr_to_calc;
    
    counter = counter +1;
%    fprintf('batch elapsed time: %f\n', toc(tstart_batch));
end

%fprintf('activation elapsed time: %f\n',toc(tstart));
end
