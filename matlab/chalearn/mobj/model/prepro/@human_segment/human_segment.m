%==========================================================================
% HUMAN_SEGMENT Preprocessing object             
%==========================================================================
% a=human_segment(hyper) 
%
% This segmentation method splits the movie or time dependent feature
% representation into segments that were manually determined by an operator. 
%
%
% This is an object similar to a Spider object
% http://www.kyb.mpg.de/bs/people/spider/
%
% All preprocessing objects (called prepro) must have at least 3 methods: train, test, and exec
% [resu, trained_prepro]=train(prepro, databatch)
% resu = test(prepro, databatch)
% preprocessed_representation = exec(prepro, movie)
%
% IMPORTANT: This object can be used to retrieve and apply saved
% segmentation values, BUT, it works only when applied to a databatch.
% So, as part of a chain, apply if FIRST.

%Isabelle Guyon -- isabelle@clopinet.com -- June 2012

classdef human_segment
	properties (SetAccess = public)
        % Here other hyperparameters of the preprocessing 
        % and trainable parameters can be declared
        datadir ='Examples/tempo_segment/'; % Directory where to find the human segmentation
        %datadir ='/Users/isabelle/Documents/Projects/DARPA/Data/Annotations/Tempo_segment/tempo_segment';
        cuts={}; % a cell array containing the human temporal segmentation matrices
        % for the whole dataset of p examples (trainign + test)
        % Each matrix corresponds to one sample in the dataset "trained" on
        % and has N lines (cuts) and 2 columns (start and end of gesture).
        hash=[]; % a matrix p lines and f columns of hash codes for the p examples
        % this allows retrieving by "cheating" the human segmentation by
        % matching the hash codes of the images. hash(k,1)=frame_num,
        % hash(k,2)=ave(RGBframe(1/2end)-RBGframe(1)),
        % hash(k,2)=ave(Kframe(end)-Kframe(1/2end)).
        verbosity=0;            % Flag to turn on verbose mode for debug
        test_on_training_data=0;% Flag to turn on training data
    end
    methods
        %%%%%%%%%%%%%%%%%%%
        %%% CONSTRUCTOR %%%
        %%%%%%%%%%%%%%%%%%%
        function a = human_segment(hyper) 
            % Evaluate hyper-parameters entered with the syntax of the
            % Spider http://www.kyb.mpg.de/bs/people/spider/
            eval_hyper;
        end  
        
    end %methods
end %classdef
  

 

 
 





