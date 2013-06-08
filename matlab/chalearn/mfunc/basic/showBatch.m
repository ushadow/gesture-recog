function [D, R] = showBatch(batchDir, useRecog, displayMode, h)
  % Create a databatch object called "D"
  D = databatch(batchDir);

  % Create a recognizer
  if useRecog
      Dtr=subset(D, 1:D.vocabulary_size);
      recog_options={'test_on_training_data=0', 'movie_type=''K'''};
      [~, RK]=train(basic_recog(recog_options), Dtr);
      recog_options={'test_on_training_data=0', 'movie_type=''M'''};
      [~, RM]=train(basic_recog(recog_options), Dtr);
      if strcmp(displayMode, 'K')
          R=RK;
      else
          R=RM;
      end
  else
      R=[];
  end

  % Show a movie
  show(D, displayMode, h, R);
end