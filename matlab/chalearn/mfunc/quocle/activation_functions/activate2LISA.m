function [res, act_l1_pca_reduced, act_l1_abssum] = activate2LISA(data, isa1, isa2, batch_size, postact)

% function activates 2 layers of stacked isa networks
% returns the l2 activation only 

% tstart = tic;

nr_samples = size(data, 2);
nr_done = 0;
counter = 1;

%% initialize result
res = zeros(size(isa2.H, 1), nr_samples);
act_l1_pca_reduced = zeros(size(isa2.H, 1), nr_samples);
act_l1_abssum= zeros(1, nr_samples);

while(nr_done<nr_samples)
%   tstart_batch = tic;
    nr_to_calc = min(nr_samples-nr_done, batch_size);
    
    if nr_to_calc == size(data, 2)
       data_batch = data;clear data;
    else
       data_batch = data(:, (nr_done+1):(nr_done+nr_to_calc));
    end
    %----------wrapper-------------
    %% activate in batches
    
    act_l1_list = transactConvISA(data_batch, isa1, isa2, postact.layer1);
    
    act_out = activateISA(act_l1_list, isa2, postact.layer2);
    
    res(:,nr_done+1:nr_done+nr_to_calc) = act_out;
    
    %% pca reduce l1 activations
    if isfield(postact.layer2, 'gpu')
        act_l1_pca_reduced(:,nr_done+1:nr_done+nr_to_calc) = double(gdouble(isa2.V(1:size(isa2.H,1),:))*gdouble(act_l1_list));
    else
        act_l1_pca_reduced(:,nr_done+1:nr_done+nr_to_calc) = isa2.V(1:size(isa2.H,1),:)*act_l1_list;
    end

    act_l1_abssum(:, nr_done+1:nr_done+nr_to_calc) = sum(abs(act_l1_list), 1);    
    %----------wrapper-------------

    nr_done  = nr_done + nr_to_calc;
    
    counter = counter +1;
    %fprintf('batch elapsed time: %f\n', toc(tstart_batch));
end

%fprintf('activation elapsed time: %f\n',toc(tstart));
end
