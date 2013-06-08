%==========================================================================
% DYNAMIC TIME WARPING recognizer/temporal segmenter object             
%==========================================================================
% a=dtw_recog(hyper) 
%
% This is an object performing Dynamic Time Warping, modeled after
% recog_template. Note that is is more like an hmm with fixed weights 
% (a forward model self loop, transition and skip) than dtw.
% Each "model" is one of the training examples. The are stacked in the
% order of their labels. We add a transition model to the rest state.
% You can optionally pass it a preprocessing function and a similarity
% function between pairs of frames. 
% By default the data representation is coarse motion histograms.
% By default, the similarity measure is -(Euclidean_dist)^2.
%
% Note: DTW can also be used as preprocessing when the flag use_as_prepro
% is equal to 1. In that case, the result includes the preprocessed data
% representation and the new cuts, not the results of recognition.
% DTW can also be used as temporal segmentation engine only if the flag
% use_as_segmenter is equal to 1. In that case, the original data
% representation is returned in the results together with the cuts.
%
% Usage:
% my_dtw=dtw_recog; % uses default functions
% my_dtw=dtw_recog('preprocessing=@myprepro'); % uses your myprepro preprocessing
% function when operating directly on a databatch.
% You can also chain dtw with a preprocessing object:
% my_dtw=chain({prepro_template, dtw_recog);
% In that case, the "internal" preprocessing is not performed.
% my_dtw=dtw_recog('similarity=@mysimil'); % uses your mysimil similarity function
% my_dtw=dtw_recog({'preprocessing=@myprepro', 'similarity=@mysimil'}); % uses both
% D=databatch(datadir);
% Dtr=subset(D, 1:D.vocabulary_size);
% Dte=subset(D, D.vocabulary_size+1:length(D));
% [tr_resu, my_dtw]=train(my_dtw, Dtr);
% te_resu=test(mymodel, Dte);

%Isabelle Guyon -- isabelle@clopinet.com -- May 2012

classdef dtw_recog
	properties (SetAccess = public)
        preprocessing=@motion; % Handle to a function
        % The preprocessing now is used only if the data passed is a
        % databatch. If it is a result from a preprocessing, no further
        % preprocessing is applied.
        prepro_param=9;           % Eventual preprocessing parameter
        similarity=@any_simil;
        simil_param='euclid2';    % Eventual similarity measure parameter
        parents={};               % Cell array containing the list of "parent nodes" at the previous time step
        local_start=[];           % Boundary condition vector of length n
        local_end=[];             % Boundary condition vector of length n
        X=[];                     % Training data matrix (features in columns) of dim (num_frames, n)
                                  % All the training examples are concatenated.
        Y=[];                     % The labels (dim tr_num)
        L=[];                     % The number of frames of each training example (dim tr_num)                         
        movie_type='K';           % A choice of 'M' for the RGB image or 'K' for the depth image
        use_as_prepro=0;          % Set to 1 to use as preprocessing
        use_as_segmenter=0;       % Set to 1 to use as temporal segmenter
        verbosity=0;              % Flag to turn on verbose mode for debug
        test_on_training_data=0;  % Flag to turn on training data testing
    end
    methods
        %%%%%%%%%%%%%%%%%%%
        %%% CONSTRUCTOR %%%
        %%%%%%%%%%%%%%%%%%%
        function a = dtw_recog(hyper) 
            % Evaluate hyper-parameters entered with the syntax of the
            % Spider http://www.kyb.mpg.de/bs/people/spider/
            eval_hyper;
        end  
        
        function show(this, h)
            %show(this, h)
            if ~isempty(this.X)
                % Show the training data
                h=figure; hold on
                subplot(2,1,1);
                imdisplay(this.X', h, 'TRAINING DATA'); axis normal; colorbar off
                subplot(2,1,2);
                tempo_segment(1,1)=1; tempo_segment(1,2)=this.L(1);
                for k=2:length(this.L)
                    tempo_segment(k,1)=tempo_segment(k-1,2)+1;
                    tempo_segment(k,2)=tempo_segment(k-1,2)+this.L(k);
                end
                display_segment(mean(this.X, 2), tempo_segment, this.Y, h); title('TRAINING LABELS');
            end
        end % show
        
    end %methods
end %classdef
  

 

 
 





