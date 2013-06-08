function testid = maketestid(params, network)

datetime = datestr(now,30);

if params.feature.num_layers == 1
  testid = sprintf('%s_Nlay%d_ca%d_nm%d_cen%d_nkms%d_1v_%s_ds%d%d%d_unb%d_fm%d_%s.mat', network.isa{1}.bases_id, params.feature.num_layers, params.feature.catlayers, params.num_movies, params.num_centroids, params.num_km_samples, params.avipath{1}(end-6: end-1), params.testds_sp_strides_per_cfovea_x, params.testds_sp_strides_per_cfovea_y, params.testds_tp_strides_per_cfovea, params.usenormbin, params.filtermotion, datetime);
elseif params.feature.num_layers == 2
  testid = sprintf('%s_Nlay%d_ca%d_nm%d_cen%d_nkms%d_1v_%s_ds%d%d%d_unb%d_fm%d_%s.mat', network.isa{2}.bases_id, params.feature.num_layers, params.feature.catlayers, params.num_movies, params.num_centroids, params.num_km_samples, params.avipath{1}(end-6: end-1), params.testds_sp_strides_per_cfovea_x, params.testds_sp_strides_per_cfovea_y, params.testds_tp_strides_per_cfovea, params.usenormbin, params.filtermotion, datetime);
end

end