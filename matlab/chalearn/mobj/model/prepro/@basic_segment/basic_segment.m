%==========================================================================
% BASIC_SEGMENT Preprocessing object             
%==========================================================================
% a=basic_segment(hyper) 
%
% This segmentation method splits the movie or time dependent feature
% representation into equal segments. The number of segments is determined
% by the total length divided by the average length of the training
% examples (which are single gestures).
%
% This is an object similar to a Spider object
% http://www.kyb.mpg.de/bs/people/spider/
%
% All preprocessing objects (called prepro) must have at least 3 methods: train, test, and exec
% [resu, trained_prepro]=train(prepro, databatch)
% resu = test(prepro, databatch)
% preprocessed_representation = exec(prepro, movie)

%Isabelle Guyon -- isabelle@clopinet.com -- June 2012

classdef basic_segment
	properties (SetAccess = public)
        % Here other hyperparameters of the preprocessing 
        % and trainable parameters can be declared
        len =[];                % Average pattern length
        verbosity=0;            % Flag to turn on verbose mode for debug
        test_on_training_data=0;% Flag to turn on training data
    end
    methods
        %%%%%%%%%%%%%%%%%%%
        %%% CONSTRUCTOR %%%
        %%%%%%%%%%%%%%%%%%%
        function a = basic_segment(hyper) 
            % Evaluate hyper-parameters entered with the syntax of the
            % Spider http://www.kyb.mpg.de/bs/people/spider/
            eval_hyper;
        end  
        
    end %methods
end %classdef
  

 

 
 





