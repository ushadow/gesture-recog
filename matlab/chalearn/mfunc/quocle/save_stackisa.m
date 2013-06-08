function save_stackisa(params, center_all, km_obj, train_label_all, test_label_all, MM_train, MM_test, ...
train_indices,test_indices,all_train_files,all_test_files,all_train_labels,all_test_labels)

%%-------------SAVE ------------
date = datestr(now,29);

fprintf('-----saving at SAVEPATH ....%s  %s------\n', params.savepath, date);

mkdir([params.savepath, date])

labels_filename = sprintf('svm_ready_%s', params.testid);

if exist('all_train_labels', 'var')
  save([params.savepath, date,'/',labels_filename],'center_all', 'km_obj','train_label_all', 'test_label_all', 'MM_train','MM_test','train_indices','test_indices','all_train_files','all_test_files','all_train_labels','all_test_labels', 'params', '-v7.3')
else
  save([params.savepath, date,'/',labels_filename],'center_all', 'km_obj','train_label_all', 'test_label_all', 'MM_train','MM_test','train_indices','test_indices','all_train_files','all_test_files', 'params', '-v7.3')
end

end
