function display_accuracy_statistics (dataset, predicted_labels, ground_truth)

% function display_accuracy_statistics (predicted_labels, ground_truth)

test_size = numel (predicted_labels);
total_gestures = 0;
total_insertions = 0;
total_deletions = 0;
total_substitutions = 0;
total_recognized = 0;

for test_index = 1: test_size
  current_labels =  predicted_labels {test_index};
  current_truth = ground_truth {test_index};
  current_size = numel (current_truth);
  total_gestures = total_gestures + current_size;
  [insertions, deletions, substitutions, recognized] = compare_labels (current_labels, current_truth);
  total_insertions = total_insertions + insertions;
  total_deletions = total_deletions + deletions;
  total_substitutions = total_substitutions + substitutions;
  total_recognized = total_recognized + recognized;
  
  disp(sprintf('test_sequence %d', test_index));
  disp(sprintf('correctly recognized %d out of %d gestures', recognized, current_size));
  disp(sprintf('%d insertions, %d deletions, %d substitutions', insertions, deletions, substitutions));
  disp(sprintf('error rate: %f\n\n', (insertions+deletions+substitutions) / current_size));
end

error_rate = (total_insertions+total_deletions+total_substitutions) / total_gestures;
disp(sprintf('cumulative statistics of %d sequences', test_size));
disp(sprintf('correctly recognized %d out of %d gestures', total_recognized, total_gestures));
disp(sprintf('%d insertions, %d deletions, %d substitutions', total_insertions, total_deletions, total_substitutions));
disp(sprintf('error rate: %f\n\n', error_rate));

output_line = sprintf('%s\t %d\t %d\t %d\t %d\t %d', dataset.name, [total_gestures, total_recognized, total_insertions, total_deletions, total_substitutions]);
disp(output_line);
fid = fopen('result.txt', 'a');
fprintf(fid, '%s\n', output_line);
fclose(fid);

%disp(dataset.name);
%disp(sprintf('%d, ', [total_gestures; total_recognized; total_insertions; total_deletions; total_substitutions; error_rate]));
