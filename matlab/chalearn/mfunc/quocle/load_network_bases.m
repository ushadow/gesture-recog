function network = load_network_bases(network, params, load_layer_weights, bases_path)

if load_layer_weights ==0
return;    
end

for i = 1:load_layer_weights
   bases_path_filename = sprintf('%s%s', bases_path, params.bases_id{i}, '.mat');
   load(bases_path_filename);

   if iscell(isanetwork)
       network.isa{i}.W = isanetwork{1}.W;       
       network.isa{i}.H = isanetwork{1}.H;
       if i~=1
           network.isa{i}.V = isanetwork{1}.V;
       end

       if (i>2)
         network.isa{i}.V_l1l2 = isanetwork{1}.V_l1l2;
       end
   else       
       network.isa{i}.W = isanetwork.W;
       network.isa{i}.H = isanetwork.H;
       if i~=1
            network.isa{i}.V = isanetwork.V;
       end
       if (i>2)
         network.isa{i}.V_l1l2 = isanetwork{1}.V_l1l2;
       end
   end
   network.isa{i}.fovea_numel = size(network.isa{i}.W, 2);   
   network.isa{i}.num_features = size(network.isa{i}.H,1);
   network.isa{i}.pca_dim = size(network.isa{i}.H,2);
   network.isa{i}.group_size = network.isa{i}.pca_dim/network.isa{i}.num_features;
end

end
